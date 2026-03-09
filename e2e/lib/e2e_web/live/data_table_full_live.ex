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
      |> assign(:sort_by, :id)
      |> assign(:sort_order, :asc)
      |> assign(:selected, [])
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

  def handle_event("select", %{"id" => checkbox_id, "checked" => checked}, socket) do
    # Extract the ID from "users-table-select-user-1", "users-table-select-user-2", etc.
    id_str = String.replace(checkbox_id, "users-table-select-user-", "")
    id = String.to_integer(id_str)

    selected =
      if checked do
        # We need to make sure we store the exact same format that is passed to row_id
        # In render, row_id is &"user-#{&1.id}", so we must store "user-1", "user-2", etc.
        ["user-#{id}" | socket.assigns.selected] |> Enum.uniq()
      else
        List.delete(socket.assigns.selected, "user-#{id}")
      end

    all_selected = length(selected) == length(socket.assigns.users)

    socket =
      socket
      |> assign(:selected, selected)
      |> Corex.Checkbox.set_checked("users-table-select-all", all_selected)

    {:noreply, socket}
  end

  def handle_event("select_all", %{"checked" => checked}, socket) do
    selected =
      if checked do
        Enum.map(socket.assigns.users, &"user-#{&1.id}")
      else
        []
      end

    socket = assign(socket, :selected, selected)

    # Push check/uncheck to all individual row checkboxes
    socket =
      Enum.reduce(socket.assigns.users, socket, fn user, acc ->
        Corex.Checkbox.set_checked(acc, "users-table-select-user-#{user.id}", checked)
      end)

    {:noreply, socket}
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
        <h2>Full Example (Sorting & Selection)</h2>
      </div>

      <div class="space-y-4">
        <p>
          This example demonstrates how to implement both sorting and row selection with the `data-table` component.
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
