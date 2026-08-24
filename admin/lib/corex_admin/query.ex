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
  which is already allowlisted.
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
      where(acc, [row], field(row, ^field) == ^value)
    end)
  end

  defp apply_sort(query, %ListOpts{sort: {field, :asc}}) do
    order_by(query, [row], asc: field(row, ^field))
  end

  defp apply_sort(query, %ListOpts{sort: {field, :desc}}) do
    order_by(query, [row], desc: field(row, ^field))
  end

  defp apply_sort(query, _opts), do: query

  defp escape_like(term) do
    term
    |> String.replace("\\", "\\\\")
    |> String.replace("%", "\\%")
    |> String.replace("_", "\\_")
  end
end
