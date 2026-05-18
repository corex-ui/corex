defmodule E2eWeb.DataTableStyleLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.DataTablePatternState, as: PState

  @list_users [
    %{id: 1, name: "Alice", email: "alice@example.com", role: "Admin", status: "Active"},
    %{id: 2, name: "Bob", email: "bob@example.com", role: "User", status: "Inactive"},
    %{id: 3, name: "Charlie", email: "charlie@example.com", role: "User", status: "Active"},
    %{id: 4, name: "Diana", email: "diana@example.com", role: "Manager", status: "Active"},
    %{id: 5, name: "Eve", email: "eve@example.com", role: "Admin", status: "Inactive"}
  ]

  @color_variants [
    {"", "data-table-styling-color-default"},
    {"data-table--accent", "data-table-styling-color-accent"},
    {"data-table--brand", "data-table-styling-color-brand"},
    {"data-table--alert", "data-table-styling-color-alert"},
    {"data-table--success", "data-table-styling-color-success"},
    {"data-table--info", "data-table-styling-color-info"}
  ]

  @size_variants [
    {"data-table--sm", "data-table-styling-size-sm"},
    {"data-table--md", "data-table-styling-size-md"},
    {"data-table--lg", "data-table-styling-size-lg"},
    {"data-table--xl", "data-table-styling-size-xl"}
  ]

  @width_variants [
    {"max-w-2xs", "data-table-styling-max-w-2xs"},
    {"max-w-md", "data-table-styling-max-w-md"},
    {"max-w-xl", "data-table-styling-max-w-xl"},
    {"max-w-2xl", "data-table-styling-max-w-2xl"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    rows = PState.sort_rows(@list_users, :id, :asc)

    {:ok,
     socket
     |> assign(:style_rows, rows)
     |> assign(:style_sort_by, :id)
     |> assign(:style_sort_order, :asc)
     |> assign(:style_selected, [])
     |> assign(:color_variants, @color_variants)
     |> assign(:size_variants, @size_variants)
     |> assign(:width_variants, @width_variants)}
  end

  @impl true
  def handle_event("style_sort", params, socket) do
    {:noreply,
     PState.handle_sort_ns(socket, params,
       rows: :style_rows,
       sort_by: :style_sort_by,
       sort_order: :style_sort_order
     )}
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
       row_id: &"style-#{&1.id}"
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        id="data-table-styling-page"
        title="Data Table · Style"
        subtitle="Semantic ink on column headers, size scale on headers and cells, and host max-width utilities. Tables include sort, selection, and actions."
        heading_class="layout-heading"
      >
        <.demo_section
          id="data-table-styling-color"
          title="Color"
          code={E2eWeb.Demos.DataTableDemo.styling_color_code()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.style_table
                :for={{modifier, id} <- @color_variants}
                id={id}
                class={"data-table max-w-none #{modifier}"}
                rows={@style_rows}
                sort_by={@style_sort_by}
                sort_order={@style_sort_order}
                selected={@style_selected}
              />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-styling-size"
          title="Size"
          code={E2eWeb.Demos.DataTableDemo.styling_size_code()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.style_table
                :for={{modifier, id} <- @size_variants}
                id={id}
                class={"data-table max-w-none #{modifier}"}
                rows={@style_rows}
                sort_by={@style_sort_by}
                sort_order={@style_sort_order}
                selected={@style_selected}
              />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-styling-max-width"
          title="Max width"
          code={E2eWeb.Demos.DataTableDemo.styling_max_width_code()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.style_table
                :for={{width, id} <- @width_variants}
                id={id}
                class={"data-table #{width}"}
                rows={@style_rows}
                sort_by={@style_sort_by}
                sort_order={@style_sort_order}
                selected={@style_selected}
              />
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
  attr :sort_by, :atom, required: true
  attr :sort_order, :atom, required: true
  attr :selected, :list, required: true

  defp style_table(assigns) do
    ~H"""
    <.data_table
      id={@id}
      class={@class}
      rows={@rows}
      row_id={&"style-#{&1.id}"}
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
        <.action class="button button--sm" aria-label={"Edit #{u.name}"}>
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
