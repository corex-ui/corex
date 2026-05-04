defmodule E2eWeb.DataTablePatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.DataTablePatternState, as: PState

  @categories ~w(Fruit Vegetable Misc)
  @stream_initial [
    %{id: "1", name: "Apple", category: "Fruit"},
    %{id: "2", name: "Banana", category: "Fruit"},
    %{id: "3", name: "Carrot", category: "Vegetable"}
  ]

  @list_users [
    %{id: 1, name: "Alice", email: "alice@example.com", role: "Admin", status: "Active"},
    %{id: 2, name: "Bob", email: "bob@example.com", role: "User", status: "Inactive"},
    %{id: 3, name: "Charlie", email: "charlie@example.com", role: "User", status: "Active"},
    %{id: 4, name: "Diana", email: "diana@example.com", role: "Manager", status: "Active"},
    %{id: 5, name: "Eve", email: "eve@example.com", role: "Admin", status: "Inactive"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    sort_rows = PState.sort_rows(@list_users, :id, :asc)
    full_rows = PState.sort_rows(@list_users, :id, :asc)

    {:ok,
     socket
     |> stream(:pattern_stream, @stream_initial)
     |> assign(:pattern_stream_next_id, 4)
     |> assign(:pattern_stream_categories, @categories)
     |> assign(:pattern_sort_rows, sort_rows)
     |> assign(:pattern_sort_by, :id)
     |> assign(:pattern_sort_order, :asc)
     |> assign(:pattern_select_rows, @list_users)
     |> assign(:pattern_select_selected, [])
     |> assign(:pattern_full_rows, full_rows)
     |> assign(:pattern_full_sort_by, :id)
     |> assign(:pattern_full_sort_order, :asc)
     |> assign(:pattern_full_selected, [])}
  end

  @impl true
  def handle_event("pattern_stream_add", _params, socket) do
    id = to_string(socket.assigns.pattern_stream_next_id)

    item = %{
      id: id,
      name: "name-#{System.unique_integer([:positive])}",
      category: Enum.random(socket.assigns.pattern_stream_categories)
    }

    {:noreply,
     socket
     |> stream_insert(:pattern_stream, item)
     |> assign(:pattern_stream_next_id, socket.assigns.pattern_stream_next_id + 1)}
  end

  def handle_event("pattern_stream_reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:pattern_stream, @stream_initial, reset: true)
     |> assign(:pattern_stream_next_id, 4)}
  end

  def handle_event("pattern_stream_delete", %{"dom_id" => dom_id}, socket) do
    {:noreply, stream_delete_by_dom_id(socket, :pattern_stream, dom_id)}
  end

  def handle_event("pattern_sort", %{"sort_by" => _} = p, socket) do
    {:noreply,
     PState.handle_sort_ns(socket, p,
       rows: :pattern_sort_rows,
       sort_by: :pattern_sort_by,
       sort_order: :pattern_sort_order
     )}
  end

  def handle_event("pattern_select", %{"id" => _, "checked" => _} = p, socket) do
    {:noreply,
     PState.handle_select_ns(socket, p,
       rows: :pattern_select_rows,
       selected: :pattern_select_selected,
       table_id: "pattern-select-table"
     )}
  end

  def handle_event("pattern_select_all", %{"checked" => _} = p, socket) do
    {:noreply,
     PState.handle_select_all_ns(socket, p,
       rows: :pattern_select_rows,
       selected: :pattern_select_selected,
       table_id: "pattern-select-table",
       row_id: &"pselect-#{&1.id}"
     )}
  end

  def handle_event("pattern_check_selected", _params, socket) do
    message =
      if socket.assigns.pattern_select_selected == [] do
        "No rows selected"
      else
        "Selected IDs: " <> Enum.join(socket.assigns.pattern_select_selected, ", ")
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

  def handle_event("pattern_full_sort", %{"sort_by" => _} = p, socket) do
    {:noreply,
     PState.handle_sort_ns(socket, p,
       rows: :pattern_full_rows,
       sort_by: :pattern_full_sort_by,
       sort_order: :pattern_full_sort_order
     )}
  end

  def handle_event("pattern_full_select", %{"id" => _, "checked" => _} = p, socket) do
    {:noreply,
     PState.handle_select_ns(socket, p,
       rows: :pattern_full_rows,
       selected: :pattern_full_selected,
       table_id: "pattern-full-table"
     )}
  end

  def handle_event("pattern_full_select_all", %{"checked" => _} = p, socket) do
    {:noreply,
     PState.handle_select_all_ns(socket, p,
       rows: :pattern_full_rows,
       selected: :pattern_full_selected,
       table_id: "pattern-full-table",
       row_id: &"pfull-#{&1.id}"
     )}
  end

  def handle_event("pattern_full_check", _params, socket) do
    message =
      if socket.assigns.pattern_full_selected == [] do
        "No rows selected"
      else
        "Selected IDs: " <> Enum.join(socket.assigns.pattern_full_selected, ", ")
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

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="data-table-patterns-page"
        title="Data Table · Pattern"
        subtitle="Stream rows, server-side sort, row selection, and a combined table on one page (namespaced assigns and events per section)."
        heading_class="layout-heading"
      >
        <.demo_section
          id="data-table-patterns-stream"
          title="Stream"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.DataTableDemo.patterns_stream_heex()
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: E2eWeb.Demos.DataTableDemo.patterns_stream_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full max-w-3xl">
              <div class="flex gap-2 flex-wrap">
                <.action phx-click="pattern_stream_add" class="button button--sm button--accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="pattern_stream_reset" class="button button--sm">
                  <.heroicon name="hero-arrow-path" /> Reset
                </.action>
              </div>
              <.data_table id="pattern-stream-table" class="data-table" rows={@streams.pattern_stream}>
                <:col :let={{_id, row}} label="ID">{row.id}</:col>
                <:col :let={{_id, row}} label="Name">{row.name}</:col>
                <:col :let={{_id, row}} label="Category">{row.category}</:col>
                <:empty>
                  <p id="pattern-stream-empty">No items</p>
                </:empty>
                <:action :let={{dom_id, row}}>
                  <.action
                    phx-click="pattern_stream_delete"
                    phx-value-dom_id={dom_id}
                    class="button button--sm button--alert"
                    aria-label={"Delete #{row.name}"}
                  >
                    <.heroicon name="hero-trash" />
                  </.action>
                </:action>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-patterns-sort"
          title="Sort"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.DataTableDemo.patterns_sort_heex()
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: E2eWeb.Demos.DataTableDemo.patterns_sort_elixir()
            }
          ]}
        >
          <:preview>
            <.data_table
              id="pattern-sort-table"
              class="data-table max-w-4xl"
              rows={@pattern_sort_rows}
              sort_by={@pattern_sort_by}
              sort_order={@pattern_sort_order}
              on_sort="pattern_sort"
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
              <:col :let={u} label="ID" name={:id}>{u.id}</:col>
              <:col :let={u} label="Name" name={:name}>{u.name}</:col>
              <:col :let={u} label="Email" name={:email}>{u.email}</:col>
              <:col :let={u} label="Role" name={:role}>{u.role}</:col>
              <:col :let={u} label="Status" name={:status}>{u.status}</:col>
            </.data_table>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-patterns-select"
          title="Select"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.DataTableDemo.patterns_select_heex()
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: E2eWeb.Demos.DataTableDemo.patterns_select_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-4xl">
              <.action phx-click="pattern_check_selected" class="button button--sm">
                Check selected
              </.action>
              <.data_table
                id="pattern-select-table"
                class="data-table"
                rows={@pattern_select_rows}
                row_id={&"pselect-#{&1.id}"}
                selectable
                selected={@pattern_select_selected}
                on_select="pattern_select"
                on_select_all="pattern_select_all"
                checkbox_class="checkbox"
              >
                <:checkbox_indicator>
                  <.heroicon name="hero-check" />
                </:checkbox_indicator>
                <:col :let={u} label="ID" name={:id}>{u.id}</:col>
                <:col :let={u} label="Name" name={:name}>{u.name}</:col>
                <:col :let={u} label="Email" name={:email}>{u.email}</:col>
                <:col :let={u} label="Role" name={:role}>{u.role}</:col>
                <:col :let={u} label="Status" name={:status}>{u.status}</:col>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-patterns-full"
          title="Full (action, sort, select)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.DataTableDemo.patterns_full_heex()
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: E2eWeb.Demos.DataTableDemo.patterns_full_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-4xl">
              <.action phx-click="pattern_full_check" class="button button--sm">
                Check selected
              </.action>
              <.data_table
                id="pattern-full-table"
                class="data-table"
                rows={@pattern_full_rows}
                row_id={&"pfull-#{&1.id}"}
                sort_by={@pattern_full_sort_by}
                sort_order={@pattern_full_sort_order}
                on_sort="pattern_full_sort"
                selectable
                selected={@pattern_full_selected}
                on_select="pattern_full_select"
                on_select_all="pattern_full_select_all"
                checkbox_class="checkbox"
              >
                <:checkbox_indicator>
                  <.heroicon name="hero-check" />
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
                <:col :let={u} label="ID" name={:id}>{u.id}</:col>
                <:col :let={u} label="Name" name={:name}>{u.name}</:col>
                <:col :let={u} label="Email" name={:email}>{u.email}</:col>
                <:col :let={u} label="Role" name={:role}>{u.role}</:col>
                <:col :let={u} label="Status" name={:status}>{u.status}</:col>
                <:action :let={u}>
                  <.action class="button button--sm" aria-label={"Edit #{u.name}"}>
                    <.heroicon name="hero-pencil-square" />
                  </.action>
                </:action>
                <:empty>
                  <p id="pattern-full-empty">No rows</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
