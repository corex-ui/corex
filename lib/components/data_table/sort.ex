defmodule Corex.DataTable.Sort do
  import Phoenix.Component, only: [assign: 3]

  @moduledoc """
  Helpers for sortable `.data_table` usage in LiveViews.

  Use in mount to assign initial sort state and sorted rows, and in
  handle_event("sort", ...) to update sort and re-sort the rows assign.
  Keeps the LiveView minimal: no manual sort_by/sort_order or sort logic.

  ## Example

      def mount(_params, _session, socket) do
        socket =
          socket
          |> assign(:users, fetch_users())
          |> Corex.DataTable.Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

        {:ok, socket}
      end

      def handle_event("sort", params, socket) do
        {:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}
      end

      def render(assigns) do
        ~H\"\"\"
        <.data_table
          id="users-table"
          rows={@users}
          sort_by={@sort_by}
          sort_order={@sort_order}
          on_sort="sort"
        >
          <:col :let={user} label="ID" name={:id}>{user.id}</:col>
          <:col :let={user} label="Name" name={:name}>{user.name}</:col>
        </.data_table>
        \"\"\"
      end
  """

  @doc """
  Assigns sort state and sorts the given rows assign for initial render.

  Use in `mount/3` after assigning the list. Options:

  - `:default_sort_by` – atom, column to sort by (e.g. `:id`)
  - `:default_sort_order` – `:asc` or `:desc`, default `:asc`

  The socket must already have an assign at `rows_assign` (e.g. `:users`)
  with a list of maps. Adds or updates `:sort_by`, `:sort_order`, and
  replaces the rows assign with the sorted list.
  """
  def assign_for_sort(socket, rows_assign, opts \\ []) do
    sort_by = Keyword.get(opts, :default_sort_by)
    sort_order = Keyword.get(opts, :default_sort_order, :asc)
    rows = socket.assigns[rows_assign] || []

    socket
    |> assign(:sort_by, sort_by)
    |> assign(:sort_order, sort_order)
    |> assign(rows_assign, sort_rows(rows, sort_by, sort_order))
  end

  @doc """
  Handles the "sort" event and returns the updated socket.

  Use in `handle_event("sort", params, socket)` and return
  `{:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}`.

  `params` must contain `"sort_by"` (string, e.g. `"id"`). It is converted
  to an atom. `rows_assign` is the assign key holding the list (e.g. `:users`).
  """
  def handle_sort(socket, %{"sort_by" => sort_by_param}, rows_assign) do
    sort_by = String.to_existing_atom(sort_by_param)
    current_sort_by = socket.assigns.sort_by
    current_sort_order = socket.assigns.sort_order

    {sort_by, sort_order} =
      if current_sort_by == sort_by do
        {sort_by, toggle_sort_order(current_sort_order)}
      else
        {sort_by, :asc}
      end

    rows = socket.assigns[rows_assign] || []

    socket
    |> assign(:sort_by, sort_by)
    |> assign(:sort_order, sort_order)
    |> assign(rows_assign, sort_rows(rows, sort_by, sort_order))
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp sort_rows(rows, nil, _sort_order), do: rows

  defp sort_rows(rows, sort_by, sort_order) do
    Enum.sort_by(rows, &Map.get(&1, sort_by), fn a, b ->
      case sort_order do
        :asc -> a <= b
        :desc -> a >= b
      end
    end)
  end
end
