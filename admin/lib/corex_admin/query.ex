defmodule CorexAdmin.Query do
  @moduledoc """
  Ecto query helpers for **context authors**.

  Corex Admin never runs these against a repo. Apply them to a query you already
  scoped, then `Repo.all/1` / `Repo.aggregate/3` in your context.

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

  Search uses parameterized `ilike`. Sort/filter fields come from `ListOpts`,
  which is already allowlisted. Filter values are dispatched by shape: lists use
  `in`, `%{contains: term}` and `%{op: :contains, value: term}` use `ilike`,
  `:empty` / `:set` test presence, `%{op: :not_in, value: list}` uses `not in`,
  `%{op: :starts_with | :ends_with | :not_contains, value: term}` use `ilike`
  variants, `%{op: :eq | :gte | :lte, value: n}` compare numbers,
  `%{relative: window}` resolves to a rolling date range, `%{from, to}` /
  `%{min, max}` use inclusive/exclusive bounds, everything else uses equality.
  """

  import Ecto.Query

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Resource.Filter

  @doc "Applies search, filters, and sort. Does not paginate."
  @spec apply(Ecto.Queryable.t(), ListOpts.t()) :: Ecto.Query.t()
  def apply(queryable, %ListOpts{} = opts) do
    queryable
    |> from()
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

  @doc "Whether an in-memory record matches a parsed filter value (for test stores)."
  @spec match_filter?(term(), atom(), term()) :: boolean()
  def match_filter?(record, field, value) when is_map(record) do
    compare_value(Map.get(record, field), value)
  end

  defp apply_search(query, %ListOpts{search: search, search_fields: fields})
       when is_binary(search) and fields != [] do
    pattern = "%" <> escape_like(search) <> "%"

    dynamic =
      Enum.reduce(fields, dynamic(false), fn field, acc ->
        dynamic([row], ^acc or ilike(field(row, ^field), ^pattern))
      end)

    where(query, ^dynamic)
  end

  defp apply_search(query, _opts), do: query

  defp apply_filters(query, %ListOpts{filters: filters}) when filters == %{}, do: query

  defp apply_filters(query, %ListOpts{filters: filters} = opts) do
    fields = opts.filter_fields || %{}

    Enum.reduce(filters, query, fn {name, value}, acc ->
      field = Map.get(fields, name, name)
      apply_one_filter(acc, field, value)
    end)
  end

  defp apply_one_filter(query, field, %{relative: window}) do
    case Filter.relative_bounds(window) do
      {from, to} -> apply_one_filter(query, field, %{from: from, to: to})
      :error -> query
    end
  end

  defp apply_one_filter(query, field, %{op: op, value: value}) do
    apply_op_filter(query, field, op, value)
  end

  defp apply_one_filter(query, _field, %{op: _}), do: query

  defp apply_one_filter(query, field, value) when is_list(value) and value != [] do
    where(query, [row], field(row, ^field) in ^value)
  end

  defp apply_one_filter(query, field, %{contains: value}) when is_binary(value) and value != "" do
    pattern = "%" <> escape_like(value) <> "%"
    where(query, [row], ilike(field(row, ^field), ^pattern))
  end

  defp apply_one_filter(query, field, :empty) do
    where(query, [row], is_nil(field(row, ^field)) or field(row, ^field) == "")
  end

  defp apply_one_filter(query, field, :set) do
    where(query, [row], not is_nil(field(row, ^field)) and field(row, ^field) != "")
  end

  defp apply_one_filter(query, field, %{min: _, max: _} = range) do
    query
    |> maybe_gte(field, Map.get(range, :min))
    |> maybe_lte(field, Map.get(range, :max))
  end

  defp apply_one_filter(query, field, %{min: min}) do
    maybe_gte(query, field, min)
  end

  defp apply_one_filter(query, field, %{max: max}) do
    maybe_lte(query, field, max)
  end

  defp apply_one_filter(query, field, %{from: _, to: _} = range) do
    query
    |> maybe_gte(field, lower_bound(Map.get(range, :from)))
    |> apply_upper_bound(field, Map.get(range, :to))
  end

  defp apply_one_filter(query, field, %{from: from}) do
    maybe_gte(query, field, lower_bound(from))
  end

  defp apply_one_filter(query, field, %{to: to}) do
    apply_upper_bound(query, field, to)
  end

  defp apply_one_filter(query, _field, value) when value in [%{}, nil, []], do: query

  defp apply_one_filter(query, field, value) do
    where(query, [row], field(row, ^field) == ^value)
  end

  defp apply_op_filter(query, field, op, value) when op in [:contains, :not_contains] do
    pattern = "%" <> escape_like(to_string(value)) <> "%"

    case op do
      :contains -> where(query, [row], ilike(field(row, ^field), ^pattern))
      :not_contains -> where(query, [row], not ilike(field(row, ^field), ^pattern))
    end
  end

  defp apply_op_filter(query, field, :starts_with, value) do
    pattern = escape_like(to_string(value)) <> "%"
    where(query, [row], ilike(field(row, ^field), ^pattern))
  end

  defp apply_op_filter(query, field, :ends_with, value) do
    pattern = "%" <> escape_like(to_string(value))
    where(query, [row], ilike(field(row, ^field), ^pattern))
  end

  defp apply_op_filter(query, field, op, value) when op in [:equals, :eq] do
    where(query, [row], field(row, ^field) == ^value)
  end

  defp apply_op_filter(query, field, :gte, value), do: maybe_gte(query, field, value)
  defp apply_op_filter(query, field, :lte, value), do: maybe_lte(query, field, value)

  defp apply_op_filter(query, field, :in, value) when is_list(value) and value != [] do
    where(query, [row], field(row, ^field) in ^value)
  end

  defp apply_op_filter(query, field, :not_in, value) when is_list(value) and value != [] do
    where(query, [row], field(row, ^field) not in ^value)
  end

  defp apply_op_filter(query, _field, _op, _value), do: query

  defp maybe_gte(query, _field, nil), do: query
  defp maybe_gte(query, field, value), do: where(query, [row], field(row, ^field) >= ^value)

  defp maybe_lte(query, _field, nil), do: query
  defp maybe_lte(query, field, value), do: where(query, [row], field(row, ^field) <= ^value)

  defp maybe_lt(query, field, value), do: where(query, [row], field(row, ^field) < ^value)

  # Dates are inclusive calendar days: >= from 00:00 and < to+1 day.
  # DateTime ranges are inclusive on both ends.
  defp apply_upper_bound(query, _field, nil), do: query

  defp apply_upper_bound(query, field, %Date{} = date),
    do: maybe_lt(query, field, exclusive_upper_bound(date))

  defp apply_upper_bound(query, field, value), do: maybe_lte(query, field, value)

  defp lower_bound(%Date{} = date), do: DateTime.new!(date, ~T[00:00:00], "Etc/UTC")
  defp lower_bound(%DateTime{} = dt), do: dt
  defp lower_bound(%NaiveDateTime{} = dt), do: dt
  defp lower_bound(other), do: other

  defp exclusive_upper_bound(%Date{} = date) do
    DateTime.new!(Date.add(date, 1), ~T[00:00:00], "Etc/UTC")
  end

  defp apply_sort(query, %ListOpts{sort: {field, :asc}}) do
    order_by(query, [row], asc: field(row, ^field))
  end

  defp apply_sort(query, %ListOpts{sort: {field, :desc}}) do
    order_by(query, [row], desc: field(row, ^field))
  end

  defp apply_sort(query, _opts), do: query

  defp compare_value(actual, %{relative: window}) do
    case Filter.relative_bounds(window) do
      {from, to} -> timestamp_in_range?(actual, %{from: from, to: to})
      :error -> false
    end
  end

  defp compare_value(actual, %{op: op, value: value}), do: compare_op(actual, op, value)
  defp compare_value(_actual, %{op: _}), do: true

  defp compare_value(actual, %{contains: value}) when is_binary(value) do
    compare_op(actual, :contains, value)
  end

  defp compare_value(actual, :empty), do: blank_value?(actual)
  defp compare_value(actual, :set), do: not blank_value?(actual)

  defp compare_value(actual, value) when is_list(value) do
    to_string(actual) in Enum.map(value, &to_string/1)
  end

  defp compare_value(actual, %{min: _, max: _} = range) do
    number_in_range?(actual, range)
  end

  defp compare_value(actual, %{min: _} = range), do: number_in_range?(actual, range)
  defp compare_value(actual, %{max: _} = range), do: number_in_range?(actual, range)

  defp compare_value(actual, %{from: _, to: _} = range), do: timestamp_in_range?(actual, range)
  defp compare_value(actual, %{from: _} = range), do: timestamp_in_range?(actual, range)
  defp compare_value(actual, %{to: _} = range), do: timestamp_in_range?(actual, range)

  defp compare_value(actual, true), do: actual in [true, "true", 1, "1"]
  defp compare_value(actual, false), do: actual in [false, "false", 0, "0"]
  defp compare_value(actual, value), do: to_string(actual) == to_string(value)

  defp compare_op(actual, :contains, value) when is_binary(value) do
    actual
    |> to_string()
    |> String.downcase()
    |> String.contains?(String.downcase(value))
  end

  defp compare_op(actual, :not_contains, value) when is_binary(value) do
    not compare_op(actual, :contains, value)
  end

  defp compare_op(actual, :starts_with, value) when is_binary(value) do
    actual
    |> to_string()
    |> String.downcase()
    |> String.starts_with?(String.downcase(value))
  end

  defp compare_op(actual, :ends_with, value) when is_binary(value) do
    actual
    |> to_string()
    |> String.downcase()
    |> String.ends_with?(String.downcase(value))
  end

  defp compare_op(actual, op, value) when op in [:equals, :eq] do
    to_string(actual) == to_string(value)
  end

  defp compare_op(actual, :gte, value), do: number_in_range?(actual, %{min: value})
  defp compare_op(actual, :lte, value), do: number_in_range?(actual, %{max: value})

  defp compare_op(actual, :in, value) when is_list(value) do
    to_string(actual) in Enum.map(value, &to_string/1)
  end

  defp compare_op(actual, :not_in, value) when is_list(value) do
    not compare_op(actual, :in, value)
  end

  defp compare_op(_actual, _op, _value), do: false

  defp number_in_range?(actual, range) do
    case to_number(actual) do
      nil ->
        false

      number ->
        min = Map.get(range, :min)
        max = Map.get(range, :max)
        (is_nil(min) or number >= min) and (is_nil(max) or number <= max)
    end
  end

  defp timestamp_in_range?(nil, _range), do: false

  defp timestamp_in_range?(actual, range) do
    from = Map.get(range, :from)
    to = Map.get(range, :to)

    (is_nil(from) or compare_bound(actual, lower_bound(from), :gte)) and
      (is_nil(to) or upper_in_range?(actual, to))
  end

  defp upper_in_range?(actual, %Date{} = to),
    do: compare_bound(actual, exclusive_upper_bound(to), :lt)

  defp upper_in_range?(actual, to), do: compare_bound(actual, to, :lte)

  defp compare_bound(%DateTime{} = actual, %Date{} = bound, :gte) do
    Date.compare(DateTime.to_date(actual), bound) != :lt
  end

  defp compare_bound(%DateTime{} = actual, %Date{} = bound, :lt) do
    Date.compare(DateTime.to_date(actual), bound) == :lt
  end

  defp compare_bound(%Date{} = actual, %Date{} = bound, :gte),
    do: Date.compare(actual, bound) != :lt

  defp compare_bound(%Date{} = actual, %Date{} = bound, :lt),
    do: Date.compare(actual, bound) == :lt

  defp compare_bound(%DateTime{} = actual, %DateTime{} = bound, :gte),
    do: DateTime.compare(actual, bound) != :lt

  defp compare_bound(%DateTime{} = actual, %DateTime{} = bound, :lt),
    do: DateTime.compare(actual, bound) == :lt

  defp compare_bound(%DateTime{} = actual, %DateTime{} = bound, :lte),
    do: DateTime.compare(actual, bound) != :gt

  defp compare_bound(%Date{} = actual, %Date{} = bound, :lte),
    do: Date.compare(actual, bound) != :gt

  defp compare_bound(actual, bound, :gte), do: actual >= bound
  defp compare_bound(actual, bound, :lt), do: actual < bound
  defp compare_bound(actual, bound, :lte), do: actual <= bound

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

  defp blank_value?(value), do: value in [nil, ""]

  defp escape_like(term) do
    term
    |> String.replace("\\", "\\\\")
    |> String.replace("%", "\\%")
    |> String.replace("_", "\\_")
  end
end
