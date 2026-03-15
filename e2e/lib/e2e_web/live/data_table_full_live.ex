defmodule E2eWeb.DataTableFullLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    users = [
      %{id: 1, name: "Alice", email: "alice@example.com", role: "Admin", status: "Active"},
      %{id: 2, name: "Bob", email: "bob@example.com", role: "User", status: "Inactive"},
      %{id: 3, name: "Charlie", email: "charlie@example.com", role: "User", status: "Active"},
      %{id: 4, name: "Diana", email: "diana@example.com", role: "Manager", status: "Active"},
      %{id: 5, name: "Eve", email: "eve@example.com", role: "Admin", status: "Inactive"}
    ]

    socket =
      socket
      |> assign(:users, users)
      |> Corex.DataTable.Sort.assign_for_sort(:users,
        default_sort_by: :id,
        default_sort_order: :asc
      )
      |> Corex.DataTable.Selection.assign_for_selection(:users,
        table_id: "users-table",
        row_id: &"user-#{&1.id}"
      )

    {:ok, socket}
  end

  def handle_event("sort", params, socket) do
    {:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}
  end

  def handle_event("select", params, socket) do
    {:noreply, Corex.DataTable.Selection.handle_select(socket, params, :users)}
  end

  def handle_event("select_all", params, socket) do
    {:noreply, Corex.DataTable.Selection.handle_select_all(socket, params, :users)}
  end

  def handle_event("check_selected", _params, socket) do
    message =
      if socket.assigns.selected == [] do
        "No rows selected"
      else
        "Selected IDs: " <> Enum.join(socket.assigns.selected, ", ")
      end

    {:noreply,
     Corex.Toast.push_toast(
       socket,
       "layout-toast",
       "Selection",
       message,
       :info,
       5000
     )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Data Table</:title>
        <:subtitle>Full Example (Sorting & Selection)</:subtitle>
      </.layout_heading>

        <p>
          This example uses `Corex.DataTable.Sort` and `Corex.DataTable.Selection` for sorting and selection.
        </p>

        <div>
          <.action phx-click="check_selected" class="button button--sm">Check selected</.action>
        </div>

        <.data_table
          id="users-table"
          class="data-table"
          rows={@users}
          row_id={&"user-#{&1.id}"}
          sort_by={@sort_by}
          sort_order={@sort_order}
          on_sort="sort"
          selectable={true}
          selected={@selected}
          on_select="select"
          on_select_all="select_all"
          checkbox_class="checkbox"
        >
          <:checkbox_indicator>
            <.heroicon name="hero-check" class="data-checked" />
          </:checkbox_indicator>
          <:sort_icon :let={%{direction: direction}}>
            <.heroicon name={
              case direction do
                :asc -> "hero-chevron-up"
                :desc -> "hero-chevron-down"
                :none -> "hero-chevron-up-down"
              end
            } />
          </:sort_icon>
          <:col :let={user} label="ID" name={:id}>{user.id}</:col>
          <:col :let={user} label="Name" name={:name}>{user.name}</:col>
          <:col :let={user} label="Email" name={:email}>{user.email}</:col>
          <:col :let={user} label="Role" name={:role}>{user.role}</:col>
          <:col :let={user} label="Status" name={:status}>{user.status}</:col>
          <:action :let={user}>
            <.action class="button button--sm" aria-label={"Edit #{user.name}"}>
              <.heroicon name="hero-pencil-square" />
            </.action>
          </:action>
        </.data_table>
    </Layouts.app>
    """
  end
end
