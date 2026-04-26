defmodule E2eWeb.Demos.DataTableDemo do
  use E2eWeb, :html

  @anatomy_rows [
    %{id: 1, name: "Alice", role: "Admin", email: "alice@example.com"},
    %{id: 2, name: "Bob", role: "User", email: "bob@example.com"},
    %{id: 3, name: "Charlie", role: "Editor", email: "charlie@example.com"}
  ]

  def anatomy_minimal_code do
    ~S"""
    <.data_table
      id="data-table-anatomy-minimal"
      class="data-table"
      rows={@rows}
    >
      <:col :let={row} label="ID">{row.id}</:col>
      <:col :let={row} label="Name">{row.name}</:col>
      <:col :let={row} label="Role">{row.role}</:col>
      <:col :let={row} label="Email">{row.email}</:col>
    </.data_table>
    """
  end

  def anatomy_minimal_example(assigns) do
    assigns = assign(assigns, :rows, @anatomy_rows)

    ~H"""
    <.data_table
      id="data-table-anatomy-minimal"
      class="data-table"
      rows={@rows}
    >
      <:col :let={row} label="ID">{row.id}</:col>
      <:col :let={row} label="Name">{row.name}</:col>
      <:col :let={row} label="Role">{row.role}</:col>
      <:col :let={row} label="Email">{row.email}</:col>
    </.data_table>
    """
  end

  def anatomy_with_action_code do
    ~S"""
    <.data_table
      id="data-table-anatomy-with-action"
      class="data-table"
      rows={@rows}
    >
      <:col :let={row} label="ID">{row.id}</:col>
      <:col :let={row} label="Name">{row.name}</:col>
      <:col :let={row} label="Role">{row.role}</:col>
      <:col :let={row} label="Email">{row.email}</:col>
      <:action :let={row}>
        <.action class="button button--sm" aria-label={"Edit #{row.name}"}>
          <.heroicon name="hero-pencil-square" />
        </.action>
      </:action>
    </.data_table>
    """
  end

  def anatomy_with_action_example(assigns) do
    assigns = assign(assigns, :rows, @anatomy_rows)

    ~H"""
    <.data_table
      id="data-table-anatomy-with-action"
      class="data-table"
      rows={@rows}
    >
      <:col :let={row} label="ID">{row.id}</:col>
      <:col :let={row} label="Name">{row.name}</:col>
      <:col :let={row} label="Role">{row.role}</:col>
      <:col :let={row} label="Email">{row.email}</:col>
      <:action :let={row}>
        <.action class="button button--sm" aria-label={"Edit #{row.name}"}>
          <.heroicon name="hero-pencil-square" />
        </.action>
      </:action>
    </.data_table>
    """
  end

  def anatomy_empty_code do
    ~S"""
    <.data_table
      id="data-table-anatomy-empty"
      class="data-table"
      rows={[]}
    >
      <:col :let={row} label="ID">{row.id}</:col>
      <:col :let={row} label="Name">{row.name}</:col>
      <:empty>
        <p id="data-table-anatomy-empty-msg">No rows</p>
      </:empty>
    </.data_table>
    """
  end

  def anatomy_empty_example(assigns) do
    ~H"""
    <.data_table
      id="data-table-anatomy-empty"
      class="data-table"
      rows={[]}
    >
      <:col :let={row} label="ID">{row.id}</:col>
      <:col :let={row} label="Name">{row.name}</:col>
      <:empty>
        <p id="data-table-anatomy-empty-msg">No rows</p>
      </:empty>
    </.data_table>
    """
  end

  def patterns_stream_heex do
    ~S"""
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
    """
  end

  def patterns_stream_elixir do
    ~S"""
    @stream_items [
      %{id: "1", name: "Apple", category: "Fruit"},
      %{id: "2", name: "Banana", category: "Fruit"}
    ]

    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> stream(:pattern_stream, @stream_items)
       |> assign(:pattern_stream_next_id, 3)}
    end

    def handle_event("pattern_stream_add", _params, socket) do
      id = to_string(socket.assigns.pattern_stream_next_id)
      item = %{id: id, name: "New", category: "Misc"}
      {:noreply,
       socket
       |> stream_insert(:pattern_stream, item)
       |> assign(:pattern_stream_next_id, socket.assigns.pattern_stream_next_id + 1)}
    end

    def handle_event("pattern_stream_delete", %{"dom_id" => dom_id}, socket) do
      {:noreply, stream_delete_by_dom_id(socket, :pattern_stream, dom_id)}
    end
    """
  end

  def patterns_sort_heex do
    ~S"""
    <.data_table
      id="pattern-sort-table"
      class="data-table"
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
      <:col :let={row} label="ID" name={:id}>{row.id}</:col>
      <:col :let={row} label="Name" name={:name}>{row.name}</:col>
    </.data_table>
    """
  end

  def patterns_sort_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      rows = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
      sorted = E2eWeb.DataTablePatternState.sort_rows(rows, :id, :asc)

      {:ok,
       socket
       |> assign(:pattern_sort_rows, sorted)
       |> assign(:pattern_sort_by, :id)
       |> assign(:pattern_sort_order, :asc)}
    end

    def handle_event("pattern_sort", %{"sort_by" => _} = params, socket) do
      {:noreply,
       E2eWeb.DataTablePatternState.handle_sort_ns(socket, params,
         rows: :pattern_sort_rows,
         sort_by: :pattern_sort_by,
         sort_order: :pattern_sort_order
       )}
    end
    """
  end

  def patterns_select_heex do
    ~S"""
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
      <:col :let={row} label="ID" name={:id}>{row.id}</:col>
      <:col :let={row} label="Name" name={:name}>{row.name}</:col>
    </.data_table>
    """
  end

  def patterns_select_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :pattern_select_selected, []) |> assign(:pattern_select_rows, fetch_rows())}
    end

    def handle_event("pattern_select", params, socket) do
      {:noreply,
       E2eWeb.DataTablePatternState.handle_select_ns(socket, params,
         rows: :pattern_select_rows,
         selected: :pattern_select_selected,
         table_id: "pattern-select-table"
       )}
    end

    def handle_event("pattern_select_all", params, socket) do
      {:noreply,
       E2eWeb.DataTablePatternState.handle_select_all_ns(socket, params,
         rows: :pattern_select_rows,
         selected: :pattern_select_selected,
         table_id: "pattern-select-table",
         row_id: &"pselect-#{&1.id}"
       )}
    end
    """
  end

  def patterns_full_heex do
    ~S"""
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
      <:col :let={row} label="ID" name={:id}>{row.id}</:col>
      <:col :let={row} label="Name" name={:name}>{row.name}</:col>
      <:action :let={row}>
        <.action class="button button--sm" aria-label={"Edit #{row.name}"}>
          <.heroicon name="hero-pencil-square" />
        </.action>
      </:action>
      <:empty>
        <p id="pattern-full-empty">No rows</p>
      </:empty>
    </.data_table>
    """
  end

  def patterns_full_elixir do
    ~S"""
    def handle_event("pattern_full_sort", %{"sort_by" => _} = p, socket) do
      {:noreply,
       E2eWeb.DataTablePatternState.handle_sort_ns(socket, p,
         rows: :pattern_full_rows,
         sort_by: :pattern_full_sort_by,
         sort_order: :pattern_full_sort_order
       )}
    end

    def handle_event("pattern_full_select", params, socket) do
      {:noreply,
       E2eWeb.DataTablePatternState.handle_select_ns(socket, params,
         rows: :pattern_full_rows,
         selected: :pattern_full_selected,
         table_id: "pattern-full-table"
       )}
    end

    def handle_event("pattern_full_select_all", params, socket) do
      {:noreply,
       E2eWeb.DataTablePatternState.handle_select_all_ns(socket, params,
         rows: :pattern_full_rows,
         selected: :pattern_full_selected,
         table_id: "pattern-full-table",
         row_id: &"pfull-#{&1.id}"
       )}
    end
    """
  end
end
