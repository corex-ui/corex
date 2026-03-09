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
      |> assign(:sort_by, :id)
      |> assign(:sort_order, :asc)
      |> sort_users()

    {:ok, socket}
  end

  def handle_event("sort", %{"sort_by" => sort_by_param}, socket) do
    sort_by = String.to_existing_atom(sort_by_param)

    socket =
      if socket.assigns.sort_by == sort_by do
        update(socket, :sort_order, fn
          :asc -> :desc
          :desc -> :asc
        end)
      else
        socket
        |> assign(:sort_by, sort_by)
        |> assign(:sort_order, :asc)
      end

    {:noreply, sort_users(socket)}
  end

  defp sort_users(socket) do
    sort_by = socket.assigns.sort_by
    sort_order = socket.assigns.sort_order

    sorted_users =
      Enum.sort_by(socket.assigns.users, &Map.get(&1, sort_by), fn a, b ->
        case sort_order do
          :asc -> a <= b
          :desc -> a >= b
        end
      end)

    assign(socket, :users, sorted_users)
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
      <div class="layout__row">
        <h1>Data Table</h1>
        <h2>Sorting Example</h2>
      </div>

      <div class="space-y-4">
        <p>This example demonstrates how to implement sorting with the `data-table` component.</p>

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
      </div>
    </Layouts.app>
    """
  end
end
