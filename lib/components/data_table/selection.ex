defmodule Corex.DataTable.Selection do
  import Phoenix.Component, only: [assign: 3]

  @moduledoc """
  Helpers for selectable `.data_table` usage in LiveViews.

  Use in mount to assign initial selection state, and in
  handle_event("select", ...) / handle_event("select_all", ...) to update
  selection and sync checkboxes. Keeps the LiveView minimal.

  ## Example

      def mount(_params, _session, socket) do
        socket =
          socket
          |> assign(:users, fetch_users())
          |> Corex.DataTable.Selection.assign_for_selection(:users, table_id: "users-table", row_id: &"user-\#{&1.id}")

        {:ok, socket}
      end

      def handle_event("select", params, socket) do
        {:noreply, Corex.DataTable.Selection.handle_select(socket, params, :users)}
      end

      def handle_event("select_all", params, socket) do
        {:noreply, Corex.DataTable.Selection.handle_select_all(socket, params, :users)}
      end

      def render(assigns) do
        ~H\"\"\"
        <.data_table
          id="users-table"
          rows={@users}
          row_id={&"user-\#{&1.id}"}
          selectable={true}
          selected={@selected}
          on_select="select"
          on_select_all="select_all"
        >
          <:col :let={user} label="ID">{user.id}</:col>
          <:col :let={user} label="Name">{user.name}</:col>
        </.data_table>
        \"\"\"
      end
  """

  @doc """
  Assigns selection state for the data table.

  Use in `mount/3` after assigning the rows list. Options:

  - `:table_id` – required, the data_table `id` (e.g. `"users-table"`)
  - `:row_id` – required, function from row to string id (e.g. `&"user-\#{&1.id}"`)

  Adds `:selected` (empty list), `:selection_table_id`, and `:selection_row_id`
  for use by the handlers.
  """
  def assign_for_selection(socket, _rows_assign, opts) do
    table_id = Keyword.fetch!(opts, :table_id)
    row_id = Keyword.fetch!(opts, :row_id)

    socket
    |> assign(:selected, [])
    |> assign(:selection_table_id, table_id)
    |> assign(:selection_row_id, row_id)
  end

  @doc """
  Handles the "select" event (single row checkbox) and returns the updated socket.

  Use in `handle_event("select", params, socket)` and return
  `{:noreply, Corex.DataTable.Selection.handle_select(socket, params, :users)}`.

  `params` must contain `"id"` (checkbox DOM id) and `"checked"`. `rows_assign`
  is the assign key holding the list (e.g. `:users`).
  """
  def handle_select(socket, %{"id" => checkbox_id, "checked" => checked}, rows_assign) do
    table_id = socket.assigns.selection_table_id
    row_id = String.replace(checkbox_id, "#{table_id}-select-", "")
    rows = socket.assigns[rows_assign] || []

    selected =
      if checked do
        [row_id | socket.assigns.selected] |> Enum.uniq()
      else
        List.delete(socket.assigns.selected, row_id)
      end

    all_selected = length(selected) == length(rows)

    socket
    |> assign(:selected, selected)
    |> Corex.Checkbox.set_checked("#{table_id}-select-all", all_selected)
  end

  @doc """
  Handles the "select_all" event and returns the updated socket.

  Use in `handle_event("select_all", params, socket)` and return
  `{:noreply, Corex.DataTable.Selection.handle_select_all(socket, params, :users)}`.

  `params` must contain `"checked"`. Syncs all row checkboxes via
  `Corex.Checkbox.set_checked`. `rows_assign` is the assign key holding the list.
  """
  def handle_select_all(socket, %{"checked" => checked}, rows_assign) do
    table_id = socket.assigns.selection_table_id
    row_id_fn = socket.assigns.selection_row_id
    rows = socket.assigns[rows_assign] || []

    selected =
      if checked do
        Enum.map(rows, row_id_fn)
      else
        []
      end

    socket =
      socket
      |> assign(:selected, selected)

    socket =
      Enum.reduce(rows, socket, fn row, acc ->
        Corex.Checkbox.set_checked(acc, "#{table_id}-select-#{row_id_fn.(row)}", checked)
      end)

    socket
  end
end
