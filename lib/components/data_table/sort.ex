defmodule Corex.DataTable.Sort do
  import Phoenix.Component, only: [assign: 3]

  @moduledoc """
  Helpers for sortable [`data_table/1`](Corex.DataTable.html#data_table/1) usage in LiveViews.

  Use with [`Corex.DataTable`](Corex.DataTable.html): set `sort_by`, `sort_order`, `on_sort`, and
  a `name` on each sortable column (see the **Sortable** pattern in
  [`data_table/1`](Corex.DataTable.html#data_table/1) docs). In the LiveView, call
  `assign_for_sort/3` in `mount/3`, then `handle_sort/3` from the `on_sort` event handler.

  ## Example

      def mount(_params, _session, socket) do
        socket =
          socket
          |> assign(:users, fetch_users())
          |> Corex.DataTable.Sort.assign_for_sort(:users,
            default_sort_by: :id,
            default_sort_order: :asc,
            sort_columns: [:id, :name]
          )

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
  Assigns sort state and sorts the rows for a [`data_table/1`](Corex.DataTable.html#data_table/1) instance.

  Use in `mount/3` after assigning the list. Options:

  - `:default_sort_by` – atom; column `name` on [`data_table/1`](Corex.DataTable.html#data_table/1) (e.g. `:id`)
  - `:default_sort_order` – `:asc` or `:desc`, default `:asc`
  - `:sort_columns` – list of atoms the client may sort by (e.g. `[:id, :name]`). When set,
    [`handle_sort/3`](#handle_sort/3) ignores unknown or disallowed `"sort_by"` values instead of
    raising. Always set this in production LiveViews.

  The socket must already have an assign at `rows_assign` (e.g. `:users`) with the same list
  passed as `rows` to [`data_table/1`](Corex.DataTable.html#data_table/1). Adds `:sort_by`,
  `:sort_order`, `:sort_columns`, and replaces the rows assign with the sorted list.
  """
  def assign_for_sort(socket, rows_assign, opts \\ []) do
    sort_by = Keyword.get(opts, :default_sort_by)
    sort_order = Keyword.get(opts, :default_sort_order, :asc)
    sort_columns = Keyword.get(opts, :sort_columns)
    rows = socket.assigns[rows_assign] || []

    socket
    |> assign(:sort_by, sort_by)
    |> assign(:sort_order, sort_order)
    |> assign(:sort_columns, sort_columns)
    |> assign(rows_assign, sort_rows(rows, sort_by, sort_order))
  end

  @doc """
  Handles the `on_sort` event from [`data_table/1`](Corex.DataTable.html#data_table/1) and returns the updated socket.

  Use in `handle_event("sort", params, socket)` (same name as `on_sort`) and return
  `{:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}`.

  `params` must contain `"sort_by"` (string, e.g. `"id"`). When `:sort_columns` was set via
  [`assign_for_sort/3`](#assign_for_sort/3), only those columns are accepted; other values are
  ignored and the socket is returned unchanged. Unknown atoms never crash the LiveView process.
  `rows_assign` is the assign key passed to [`data_table/1`](Corex.DataTable.html#data_table/1) as `rows`.
  """
  def handle_sort(socket, %{"sort_by" => sort_by_param}, rows_assign) do
    case parse_sort_by(sort_by_param, socket.assigns[:sort_columns]) do
      {:ok, sort_by} -> apply_sort(socket, sort_by, rows_assign)
      :error -> socket
    end
  end

  defp apply_sort(socket, sort_by, rows_assign) do
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

  defp parse_sort_by(param, columns) when is_list(columns) do
    with {:ok, sort_by} <- safe_existing_atom(param), true <- sort_by in columns do
      {:ok, sort_by}
    else
      _ -> :error
    end
  end

  defp parse_sort_by(param, _columns), do: safe_existing_atom(param)

  defp safe_existing_atom(param) when is_binary(param) do
    {:ok, String.to_existing_atom(param)}
  rescue
    ArgumentError -> :error
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
