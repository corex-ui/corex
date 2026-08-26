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
  `in`, `%{from, to}` / `%{min, max}` use inclusive/exclusive bounds, everything
  else uses equality.
  """

  import Ecto.Query

  alias CorexAdmin.ListOpts

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

  defp apply_filters(query, %ListOpts{filters: filters}) do
    Enum.reduce(filters, query, fn {field, value}, acc ->
      apply_one_filter(acc, field, value)
    end)
  end

  defp apply_one_filter(query, field, value) when is_list(value) and value != [] do
    where(query, [row], field(row, ^field) in ^value)
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

  defp maybe_gte(query, _field, nil), do: query
  defp maybe_gte(query, field, value), do: where(query, [row], field(row, ^field) >= ^value)

  defp maybe_lte(query, _field, nil), do: query
  defp maybe_lte(query, field, value), do: where(query, [row], field(row, ^field) <= ^value)

  defp maybe_lt(query, _field, nil), do: query
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

  defp exclusive_upper_bound(other), do: other

  defp apply_sort(query, %ListOpts{sort: {field, :asc}}) do
    order_by(query, [row], asc: field(row, ^field))
  end

  defp apply_sort(query, %ListOpts{sort: {field, :desc}}) do
    order_by(query, [row], desc: field(row, ^field))
  end

  defp apply_sort(query, _opts), do: query

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

  defp escape_like(term) do
    term
    |> String.replace("\\", "\\\\")
    |> String.replace("%", "\\%")
    |> String.replace("_", "\\_")
  end
end
