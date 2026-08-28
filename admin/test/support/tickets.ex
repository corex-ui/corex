defmodule CorexAdmin.Test.Tickets do
  @moduledoc false

  alias CorexAdmin.{ListOpts, Page, Query}
  alias CorexAdmin.Test.{Store, Ticket}

  def list_tickets(scope, %ListOpts{} = opts) do
    query =
      Ticket
      |> scoped(scope)
      |> Query.apply(opts)

    entries =
      Store.all()
      |> Enum.filter(&(&1.demo_id == scope.demo_id))
      |> apply_search(opts)
      |> apply_filters(opts)
      |> apply_sort(opts)

    total = length(entries)
    offset = (opts.page - 1) * opts.page_size
    page_entries = Enum.slice(entries, offset, opts.page_size)

    _ = query

    {:ok, %Page{entries: page_entries, total: total, page: opts.page, page_size: opts.page_size}}
  end

  def get_ticket!(scope, id) do
    id = parse_id(id)

    Enum.find(Store.all(), &(&1.id == id and &1.demo_id == scope.demo_id)) ||
      raise Ecto.NoResultsError, queryable: Ticket
  end

  def create_ticket(scope, attrs) do
    attrs =
      attrs
      |> Map.new(fn {k, v} -> {to_string(k), v} end)
      |> Map.put("demo_id", scope.demo_id)

    changeset = Ticket.changeset(%Ticket{}, attrs)

    if changeset.valid? do
      {:ok, Store.insert(attrs)}
    else
      {:error, changeset}
    end
  end

  def update_ticket(scope, %Ticket{} = ticket, attrs) do
    _ = scope
    changeset = Ticket.changeset(ticket, attrs)

    if changeset.valid? do
      {:ok, Store.replace(Ecto.Changeset.apply_changes(changeset))}
    else
      {:error, changeset}
    end
  end

  def delete_ticket(scope, %Ticket{} = ticket) do
    _ = scope
    {:ok, Store.delete(ticket)}
  end

  def change_ticket(scope, %Ticket{} = ticket, attrs \\ %{}) do
    _ = scope
    Ticket.changeset(ticket, attrs)
  end

  def seed(scope, attrs), do: create_ticket(scope, attrs) |> elem(1)

  defp scoped(query, scope) do
    import Ecto.Query
    where(query, [t], t.demo_id == ^scope.demo_id)
  end

  defp apply_search(entries, %ListOpts{search: nil}), do: entries

  defp apply_search(entries, %ListOpts{search: q, search_fields: fields}) do
    q = String.downcase(q)

    Enum.filter(entries, fn ticket ->
      Enum.any?(fields, fn field ->
        ticket |> Map.get(field) |> to_string() |> String.downcase() |> String.contains?(q)
      end)
    end)
  end

  defp apply_filters(entries, %ListOpts{filters: filters}) when filters == %{}, do: entries

  defp apply_filters(entries, %ListOpts{filters: filters} = opts) do
    fields = opts.filter_fields || %{}

    Enum.reduce(filters, entries, fn {name, value}, acc ->
      field = Map.get(fields, name, name)
      Enum.filter(acc, &Query.match_filter?(&1, field, value))
    end)
  end

  defp apply_sort(entries, %ListOpts{sort: {field, dir}}) do
    Enum.sort_by(entries, &Map.get(&1, field), sorter(dir))
  end

  defp apply_sort(entries, _), do: Enum.reverse(entries)

  defp sorter(:desc), do: :desc
  defp sorter(_), do: :asc

  defp parse_id(id) when is_integer(id), do: id

  defp parse_id(id) when is_binary(id) do
    case Integer.parse(id) do
      {int, ""} -> int
      _ -> -1
    end
  end
end
