defmodule E2eWeb.DataTableSortingLive do
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

    {:ok, socket}
  end

  def handle_event("sort", params, socket) do
    {:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}
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
        <:subtitle>Sorting Example</:subtitle>
      </.layout_heading>

        <p>This example uses `Corex.DataTable.Sort` helpers so the LiveView stays minimal.</p>

        <.data_table
          id="users-table"
          class="data-table"
          rows={@users}
          sort_by={@sort_by}
          sort_order={@sort_order}
          on_sort="sort"
        >
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
        </.data_table>
    </Layouts.app>
    """
  end
end
