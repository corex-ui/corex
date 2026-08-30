defmodule CorexAdmin.Query do
  @moduledoc """
  Ecto query helpers for **context authors**.

  Corex Admin never runs these against a repo. Apply them to a query you have
  already scoped, then `Repo.all/1` in your context:

      def list_users(scope, %CorexAdmin.ListOpts{} = opts) do
        query =
          User
          |> where([u], u.org_id == ^scope.org.id)
          |> CorexAdmin.Query.apply(opts)

        {:ok,
         %CorexAdmin.Page{
           entries: Repo.all(CorexAdmin.Query.paginate(query, opts)),
           total: Repo.aggregate(query, :count),
           page: opts.page,
           page_size: opts.page_size
         }}
      end

  This is a helper, not a gate. A context that needs something these functions
  cannot express should build its own query and use `CorexAdmin.ListOpts`
  directly — the admin does not check that you called it.

  ## Associations

  A filter, sortable field, or searchable field with a `path:` of
  `[:author, :email]` is joined automatically as a named binding:

      filter :author_email, :text, path: [:author, :email]
      field :author_name, :text, searchable: true, path: [:author, :name]

  Only single-level paths are joined. Deeper paths, or joins that need
  conditions, belong in the context before `apply/2`.

  ## Filter shapes

  Values are dispatched by shape: lists use `in`, `%{contains: term}` uses
  `ilike`, `:empty` / `:set` test presence, `%{op: op, value: v}` uses the named
  operator, `%{relative: window}` resolves to a rolling date range, and
  `%{from, to}` / `%{min, max}` use range bounds. Anything unrecognized raises
  rather than returning an unfiltered query, because silently listing every row
  is worse than failing.
  """

  import Ecto.Query

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Query.Ref
  alias CorexAdmin.Resource.Filter

  @doc "Applies search, filters, and sort. Does not paginate."
  @spec apply(Ecto.Queryable.t(), ListOpts.t()) :: Ecto.Query.t()
  def apply(queryable, %ListOpts{} = opts) do
    queryable
    |> from()
    |> ensure_joins(opts)
    |> apply_search(opts)
    |> apply_filters(opts)
    |> apply_sort(opts)
  end

  @doc "Applies `limit`/`offset` from list opts."
  @spec paginate(Ecto.Queryable.t(), ListOpts.t()) :: Ecto.Query.t()
  def paginate(queryable, %ListOpts{page: page, page_size: page_size}) do
    offset = (page - 1) * page_size

    queryable
    |> from()
    |> limit(^page_size)
    |> offset(^offset)
  end

  @doc """
  Left-joins every association a filter, sort, or search field references.

  Called by `apply/2`; call it yourself only when you build the rest of the
  query by hand but still want the admin's paths joined.
  """
  @spec ensure_joins(Ecto.Queryable.t(), ListOpts.t()) :: Ecto.Query.t()
  def ensure_joins(queryable, %ListOpts{} = opts) do
    query = from(queryable)

    opts
    |> required_bindings()
    |> Enum.reduce(query, &join_assoc(&2, &1))
  end

  @doc "Whether an in-memory record matches a parsed filter value (for test stores)."
  @spec match_filter?(term(), atom(), term()) :: boolean()
  def match_filter?(record, field, value) when is_map(record) do
    compare(Map.get(record, field), value)
  end

  defp required_bindings(%ListOpts{} = opts) do
    filter_bindings =
      opts.filters
      |> Map.keys()
      |> Enum.map(&filter_ref(opts, &1))
      |> Enum.map(& &1.binding)

    search_bindings =
      if is_binary(opts.search) do
        opts.search_fields
        |> Enum.map(&search_ref(opts, &1))
        |> Enum.map(& &1.binding)
      else
        []
      end

    (filter_bindings ++ search_bindings)
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
  end

  defp join_assoc(query, assoc) do
    if has_named_binding?(query, assoc) do
      query
    else
      join(query, :left, [row], a in assoc(row, ^assoc), as: ^assoc)
    end
  end

  defp filter_ref(%ListOpts{} = opts, name) do
    case Map.get(opts.filter_specs, name) do
      %Filter{} = filter -> Ref.from_path(filter.path, filter.field)
      _ -> Ref.root(Map.get(opts.filter_fields, name, name))
    end
  end

  defp search_ref(%ListOpts{search_paths: paths}, name) do
    Ref.from_path(Map.get(paths, name), name)
  end

  defp apply_search(query, %ListOpts{search: search, search_fields: fields} = opts)
       when is_binary(search) and fields != [] do
    pattern = "%" <> escape_like(search) <> "%"

    dynamic =
      Enum.reduce(fields, dynamic(false), fn name, acc ->
        ref = search_ref(opts, name)
        dynamic(^acc or ^ilike_dynamic(ref, pattern))
      end)

    where(query, ^dynamic)
  end

  defp apply_search(query, _opts), do: query

  defp apply_filters(query, %ListOpts{filters: filters}) when filters == %{}, do: query

  defp apply_filters(query, %ListOpts{filters: filters} = opts) do
    Enum.reduce(filters, query, fn {name, value}, acc ->
      ref = filter_ref(opts, name)

      case custom_apply(opts, name) do
        nil -> apply_value(acc, ref, value)
        mod -> mod.apply(acc, ref, value)
      end
    end)
  end

  # A host filter module may own its own SQL; the shape dispatch is only the
  # default for the built-in types.
  defp custom_apply(%ListOpts{} = opts, name) do
    with %Filter{} = filter <- Map.get(opts.filter_specs, name),
         mod when not is_nil(mod) <- Filter.module(filter),
         true <- Code.ensure_loaded?(mod),
         true <- function_exported?(mod, :apply, 3) do
      mod
    else
      _ -> nil
    end
  end

  defp apply_value(query, ref, %{relative: window}) do
    case Filter.relative_bounds(window) do
      {from, to} -> apply_value(query, ref, %{from: from, to: to})
      :error -> query
    end
  end

  defp apply_value(query, ref, %{op: op, value: value}), do: apply_op(query, ref, op, value)

  # An operator with no value means the user picked how to compare but not what.
  defp apply_value(query, _ref, %{op: _}), do: query

  defp apply_value(query, ref, value) when is_list(value) and value != [] do
    where(query, ^dynamic(^field_dynamic(ref) in ^value))
  end

  defp apply_value(query, ref, %{contains: value}) when is_binary(value) and value != "" do
    where(query, ^ilike_dynamic(ref, "%" <> escape_like(value) <> "%"))
  end

  defp apply_value(query, ref, :empty) do
    where(query, ^dynamic(is_nil(^field_dynamic(ref)) or ^field_dynamic(ref) == ""))
  end

  defp apply_value(query, ref, :set) do
    where(query, ^dynamic(not is_nil(^field_dynamic(ref)) and ^field_dynamic(ref) != ""))
  end

  defp apply_value(query, ref, %{min: _, max: _} = range) do
    query
    |> maybe_gte(ref, Map.get(range, :min))
    |> maybe_lte(ref, Map.get(range, :max))
  end

  defp apply_value(query, ref, %{min: min}), do: maybe_gte(query, ref, min)
  defp apply_value(query, ref, %{max: max}), do: maybe_lte(query, ref, max)

  defp apply_value(query, ref, %{from: _, to: _} = range) do
    query
    |> maybe_gte(ref, lower_bound(Map.get(range, :from)))
    |> upper_bound(ref, Map.get(range, :to))
  end

  defp apply_value(query, ref, %{from: from}), do: maybe_gte(query, ref, lower_bound(from))
  defp apply_value(query, ref, %{to: to}), do: upper_bound(query, ref, to)

  defp apply_value(query, _ref, value) when value in [%{}, nil, []], do: query

  defp apply_value(query, ref, value)
       when is_binary(value) or is_number(value) or is_boolean(value) or is_atom(value) or
              is_struct(value, Date) or is_struct(value, DateTime) or
              is_struct(value, NaiveDateTime) do
    where(query, ^dynamic(^field_dynamic(ref) == ^value))
  end

  defp apply_value(_query, ref, value) do
    raise ArgumentError, """
    CorexAdmin.Query cannot apply filter #{inspect(ref.field)} with value:

        #{inspect(value)}

    Built-in shapes are lists, %{contains: _}, %{op: _, value: _}, %{from: _, to: _},
    %{min: _, max: _}, %{relative: _}, :empty, :set, and scalars.

    Implement apply/3 on a CorexAdmin.Filter module to query this shape yourself.
    """
  end

  defp apply_op(query, ref, op, value) when op in [:contains, :not_contains] do
    pattern = "%" <> escape_like(to_string(value)) <> "%"
    dynamic = ilike_dynamic(ref, pattern)

    case op do
      :contains -> where(query, ^dynamic)
      :not_contains -> where(query, ^dynamic(not (^dynamic)))
    end
  end

  defp apply_op(query, ref, :starts_with, value) do
    where(query, ^ilike_dynamic(ref, escape_like(to_string(value)) <> "%"))
  end

  defp apply_op(query, ref, :ends_with, value) do
    where(query, ^ilike_dynamic(ref, "%" <> escape_like(to_string(value))))
  end

  defp apply_op(query, ref, op, value) when op in [:equals, :eq] do
    where(query, ^dynamic(^field_dynamic(ref) == ^value))
  end

  defp apply_op(query, ref, :gte, value), do: maybe_gte(query, ref, value)
  defp apply_op(query, ref, :lte, value), do: maybe_lte(query, ref, value)

  defp apply_op(query, ref, :in, value) when is_list(value) and value != [] do
    where(query, ^dynamic(^field_dynamic(ref) in ^value))
  end

  defp apply_op(query, ref, :not_in, value) when is_list(value) and value != [] do
    where(query, ^dynamic(^field_dynamic(ref) not in ^value))
  end

  defp apply_op(query, _ref, _op, value) when value in [nil, "", []], do: query

  defp apply_op(_query, ref, op, value) do
    raise ArgumentError,
          "CorexAdmin.Query cannot apply operator #{inspect(op)} to " <>
            "#{inspect(ref.field)} with value #{inspect(value)}"
  end

  defp field_dynamic(%Ref{binding: nil, field: field}), do: dynamic([row], field(row, ^field))

  defp field_dynamic(%Ref{binding: as, field: field}) do
    dynamic([{^as, b}], field(b, ^field))
  end

  defp ilike_dynamic(%Ref{} = ref, pattern) do
    dynamic(ilike(^field_dynamic(ref), ^pattern))
  end

  defp maybe_gte(query, _ref, nil), do: query

  defp maybe_gte(query, ref, value) do
    where(query, ^dynamic(^field_dynamic(ref) >= ^value))
  end

  defp maybe_lte(query, _ref, nil), do: query

  defp maybe_lte(query, ref, value) do
    where(query, ^dynamic(^field_dynamic(ref) <= ^value))
  end

  # A date range's upper bound covers the whole day, so it compares against the
  # start of the next day rather than midnight of the day itself.
  defp upper_bound(query, _ref, nil), do: query

  defp upper_bound(query, ref, %Date{} = date) do
    next = DateTime.new!(Date.add(date, 1), ~T[00:00:00], "Etc/UTC")
    where(query, ^dynamic(^field_dynamic(ref) < ^next))
  end

  defp upper_bound(query, ref, value), do: maybe_lte(query, ref, value)

  defp lower_bound(%Date{} = date), do: DateTime.new!(date, ~T[00:00:00], "Etc/UTC")
  defp lower_bound(other), do: other

  defp apply_sort(query, %ListOpts{sort: {name, direction}} = opts) do
    ref = sort_ref(opts, name)
    order_by(query, ^[{direction, field_dynamic(ref)}])
  end

  defp apply_sort(query, _opts), do: query

  defp sort_ref(%ListOpts{search_paths: paths}, name) do
    Ref.from_path(Map.get(paths, name), name)
  end

  # -- in-memory matching (test stores) -------------------------------------

  defp compare(actual, %{relative: window}) do
    case Filter.relative_bounds(window) do
      {from, to} -> in_time_range?(actual, %{from: from, to: to})
      :error -> false
    end
  end

  defp compare(actual, %{op: op, value: value}), do: compare_op(actual, op, value)
  defp compare(_actual, %{op: _}), do: true

  defp compare(actual, %{contains: value}) when is_binary(value) do
    compare_op(actual, :contains, value)
  end

  defp compare(actual, :empty), do: actual in [nil, ""]
  defp compare(actual, :set), do: actual not in [nil, ""]

  defp compare(actual, value) when is_list(value) do
    to_string(actual) in Enum.map(value, &to_string/1)
  end

  defp compare(actual, %{min: _} = range), do: in_number_range?(actual, range)
  defp compare(actual, %{max: _} = range), do: in_number_range?(actual, range)
  defp compare(actual, %{from: _} = range), do: in_time_range?(actual, range)
  defp compare(actual, %{to: _} = range), do: in_time_range?(actual, range)

  defp compare(actual, true), do: actual in [true, "true", 1, "1"]
  defp compare(actual, false), do: actual in [false, "false", 0, "0"]
  defp compare(actual, value), do: to_string(actual) == to_string(value)

  defp compare_op(actual, :contains, value) when is_binary(value) do
    actual |> to_string() |> String.downcase() |> String.contains?(String.downcase(value))
  end

  defp compare_op(actual, :not_contains, value) when is_binary(value) do
    not compare_op(actual, :contains, value)
  end

  defp compare_op(actual, :starts_with, value) when is_binary(value) do
    actual |> to_string() |> String.downcase() |> String.starts_with?(String.downcase(value))
  end

  defp compare_op(actual, :ends_with, value) when is_binary(value) do
    actual |> to_string() |> String.downcase() |> String.ends_with?(String.downcase(value))
  end

  defp compare_op(actual, op, value) when op in [:equals, :eq] do
    to_string(actual) == to_string(value)
  end

  defp compare_op(actual, :gte, value), do: in_number_range?(actual, %{min: value})
  defp compare_op(actual, :lte, value), do: in_number_range?(actual, %{max: value})

  defp compare_op(actual, :in, value) when is_list(value) do
    to_string(actual) in Enum.map(value, &to_string/1)
  end

  defp compare_op(actual, :not_in, value) when is_list(value) do
    not compare_op(actual, :in, value)
  end

  defp compare_op(_actual, _op, _value), do: false

  defp in_number_range?(actual, range) do
    case to_number(actual) do
      nil ->
        false

      number ->
        min = Map.get(range, :min)
        max = Map.get(range, :max)
        (is_nil(min) or number >= min) and (is_nil(max) or number <= max)
    end
  end

  defp in_time_range?(nil, _range), do: false

  defp in_time_range?(actual, range) do
    from = Map.get(range, :from)
    to = Map.get(range, :to)

    (is_nil(from) or compare_bound(actual, lower_bound(from), :gte)) and
      (is_nil(to) or upper_in_range?(actual, to))
  end

  defp upper_in_range?(actual, %Date{} = to) do
    next = DateTime.new!(Date.add(to, 1), ~T[00:00:00], "Etc/UTC")
    compare_bound(actual, next, :lt)
  end

  defp upper_in_range?(actual, to), do: compare_bound(actual, to, :lte)

  defp compare_bound(%DateTime{} = actual, %Date{} = bound, op) do
    compare_dates(DateTime.to_date(actual), bound, op)
  end

  defp compare_bound(%Date{} = actual, %Date{} = bound, op), do: compare_dates(actual, bound, op)

  defp compare_bound(%DateTime{} = actual, %DateTime{} = bound, op) do
    case {DateTime.compare(actual, bound), op} do
      {:lt, :lt} -> true
      {_, :lt} -> false
      {:lt, :gte} -> false
      {_, :gte} -> true
      {:gt, :lte} -> false
      {_, :lte} -> true
    end
  end

  defp compare_bound(actual, bound, :gte), do: actual >= bound
  defp compare_bound(actual, bound, :lt), do: actual < bound
  defp compare_bound(actual, bound, :lte), do: actual <= bound

  defp compare_dates(actual, bound, op) do
    case {Date.compare(actual, bound), op} do
      {:lt, :lt} -> true
      {_, :lt} -> false
      {:lt, :gte} -> false
      {_, :gte} -> true
      {:gt, :lte} -> false
      {_, :lte} -> true
    end
  end

  defp to_number(value) when is_number(value), do: value

  defp to_number(value) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} ->
        int

      _ ->
        case Float.parse(value) do
          {float, ""} -> float
          _ -> nil
        end
    end
  end

  defp to_number(_), do: nil

  defp escape_like(term) do
    term
    |> String.replace("\\", "\\\\")
    |> String.replace("%", "\\%")
    |> String.replace("_", "\\_")
  end
end
