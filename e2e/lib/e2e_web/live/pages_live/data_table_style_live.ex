defmodule E2eWeb.DataTableStyleLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.DataTablePatternState, as: PState
  alias E2eWeb.DemoScales

  @style_sort_columns [:id, :name, :role, :status]

  @list_users [
    %{id: 1, name: "Alice", email: "alice@example.com", role: "Admin", status: "Active"},
    %{id: 2, name: "Bob", email: "bob@example.com", role: "User", status: "Inactive"},
    %{id: 3, name: "Charlie", email: "charlie@example.com", role: "User", status: "Active"},
    %{id: 4, name: "Diana", email: "diana@example.com", role: "Manager", status: "Active"},
    %{id: 5, name: "Eve", email: "eve@example.com", role: "Admin", status: "Inactive"}
  ]

  @color_variants [
    {"", "data-table-styling-color-default"},
    {"ui-accent", "data-table-styling-color-accent"},
    {"ui-brand", "data-table-styling-color-brand"},
    {"ui-alert", "data-table-styling-color-alert"},
    {"ui-success", "data-table-styling-color-success"},
    {"ui-info", "data-table-styling-color-info"}
  ]

  @size_variants [
    {"ui-size-sm", "data-table-styling-size-sm"},
    {"ui-size-md", "data-table-styling-size-md"},
    {"ui-size-lg", "data-table-styling-size-lg"},
    {"ui-size-xl", "data-table-styling-size-xl"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:style_rows, @list_users)
     |> assign(:data_table_sort, %{})
     |> assign(:sort_columns, @style_sort_columns)
     |> assign(:style_selected, [])
     |> assign(:color_variants, @color_variants)
     |> assign(:size_variants, @size_variants)
     |> assign(:max_width_variants, DemoScales.max_width_variants("data-table"))}
  end

  @impl true
  def handle_event("style_sort", params, socket) do
    {:noreply,
     Corex.DataTable.Sort.handle_sort_for(socket, params, sort_columns: @style_sort_columns)}
  end

  def handle_event("style_select", %{"id" => checkbox_id} = params, socket) do
    case String.split(checkbox_id, "-select-", parts: 2) do
      [table_id, _row_key] ->
        {:noreply,
         PState.handle_select_ns(socket, params,
           rows: :style_rows,
           selected: :style_selected,
           table_id: table_id
         )}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("style_select_all", %{"id" => checkbox_id} = params, socket) do
    table_id = String.replace_suffix(checkbox_id, "-select-all", "")

    {:noreply,
     PState.handle_select_all_ns(socket, params,
       rows: :style_rows,
       selected: :style_selected,
       table_id: table_id,
       row_id: &"#{table_id}-#{&1.id}"
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="data-table-styling-page"
        title="Data Table · Style"
        subtitle="Semantic ink on column headers and selection checkboxes, size scale on headers, cells, and checkboxes, and host max-width utilities. Tables include sort, selection, and actions."
        heading_class="layout-heading"
      >
        <.demo_section
          id="data-table-styling-color"
          title="Color"
          code_tabs={E2eWeb.Demos.DataTableDemo.styling_color_code_tabs()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.style_table
                :for={{modifier, id} <- @color_variants}
                id={id}
                class={"data-table max-w-none #{modifier}"}
                rows={@style_rows}
                data_table_sort={@data_table_sort}
                selected={@style_selected}
              />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-styling-size"
          title="Size"
          code_tabs={E2eWeb.Demos.DataTableDemo.styling_size_code_tabs()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.style_table
                :for={{modifier, id} <- @size_variants}
                id={id}
                class={"data-table max-w-none #{modifier}"}
                rows={@style_rows}
                data_table_sort={@data_table_sort}
                selected={@style_selected}
              />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-styling-max-width"
          title="Max width"
          code_tabs={E2eWeb.Demos.DataTableDemo.styling_max_width_code_tabs()}
        >
          <:preview>
            <div {DemoScales.preview_scroll_attrs()}>
              <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
                <p class="typo ui-size-sm font-medium">{variant.label}</p>
                <.style_table
                  id={"data-table-styling-max-w-#{variant.id}"}
                  class={DemoScales.join_modifiers("data-table", variant.modifier)}
                  rows={@style_rows}
                  data_table_sort={@data_table_sort}
                  selected={@style_selected}
                />
              </div>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  attr :id, :string, required: true
  attr :class, :string, required: true
  attr :rows, :list, required: true
  attr :data_table_sort, :map, required: true
  attr :selected, :list, required: true

  defp style_table(assigns) do
    state =
      Corex.DataTable.Sort.sort_state(assigns, assigns.id, %{sort_by: :id, sort_order: :asc})

    assigns =
      assigns
      |> assign(:sort_by, state.sort_by)
      |> assign(:sort_order, state.sort_order)
      |> assign(:sorted_rows, Corex.DataTable.Sort.sorted_rows(assigns.rows, state))

    ~H"""
    <.data_table
      id={@id}
      class={@class}
      rows={@sorted_rows}
      row_id={&"#{@id}-#{&1.id}"}
      sort_by={@sort_by}
      sort_order={@sort_order}
      on_sort="style_sort"
      selectable
      selected={@selected}
      on_select="style_select"
      on_select_all="style_select_all"
      checkbox_class="checkbox"
    >
      <:checkbox_indicator>
        <.heroicon name="hero-check" />
      </:checkbox_indicator>
      <:sort_icon :let={%{direction: direction}}>
        <.heroicon name={sort_icon_name(direction)} />
      </:sort_icon>
      <:col :let={u} label="ID" name={:id}>{u.id}</:col>
      <:col :let={u} label="Name" name={:name}>{u.name}</:col>
      <:col :let={u} label="Role" name={:role}>{u.role}</:col>
      <:col :let={u} label="Status" name={:status}>{u.status}</:col>
      <:action :let={u}>
        <.action class="button ui-size-sm" aria-label={"Edit #{u.name}"}>
          <.heroicon name="hero-pencil-square" />
        </.action>
      </:action>
    </.data_table>
    """
  end

  defp sort_icon_name(:asc), do: "hero-chevron-up"
  defp sort_icon_name(:desc), do: "hero-chevron-down"
  defp sort_icon_name(:none), do: "hero-chevron-up-down"
end
