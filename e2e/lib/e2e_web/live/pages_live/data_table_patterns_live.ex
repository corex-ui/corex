defmodule E2eWeb.DataTablePatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Place
  alias E2eWeb.DataTablePatternState, as: PState

  @pattern_db_page_size 5

  @user_sort_columns [:id, :name, :email, :role, :status]
  @db_sort_columns [:name, :iata_code, :iata_country_code]

  @categories ~W(Fruit Vegetable Misc)
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
    {db_rows, db_total} =
      Place.list_cities_table(
        page: 1,
        page_size: @pattern_db_page_size,
        order_by: :name,
        order_dir: :asc
      )

    {:ok,
     socket
     |> stream(:pattern_stream, @stream_initial)
     |> assign(:pattern_stream_next_id, 4)
     |> assign(:pattern_stream_categories, @categories)
     |> assign(:pattern_user_rows, @list_users)
     |> assign(:pattern_sort_rows, PState.sort_rows(@list_users, :id, :asc))
     |> assign(:pattern_sort_by, :id)
     |> assign(:pattern_sort_order, :asc)
     |> assign(:pattern_select_selected, [])
     |> assign(:pattern_full_rows, PState.sort_rows(@list_users, :id, :asc))
     |> assign(:pattern_full_sort_by, :id)
     |> assign(:pattern_full_sort_order, :asc)
     |> assign(:pattern_full_selected, [])
     |> assign(:pattern_db_rows, db_rows)
     |> assign(:pattern_db_page, 1)
     |> assign(:pattern_db_page_size, @pattern_db_page_size)
     |> assign(:pattern_db_sort_by, :name)
     |> assign(:pattern_db_sort_order, :asc)
     |> assign(:pattern_db_sort_columns, @db_sort_columns)
     |> assign(:pattern_db_total, db_total)
     |> assign(:pattern_row_clicked, nil)
     |> assign(:pattern_row_click_rows, [
       %{id: 1, name: ~t"Alice", role: "Admin", email: "alice@example.com"},
       %{id: 2, name: ~t"Bob", role: "User", email: "bob@example.com"},
       %{id: 3, name: ~t"Charlie", role: "Editor", email: "charlie@example.com"}
     ])}
  end

  @impl true
  def handle_event("pattern_stream_add", _params, socket) do
    id = to_string(socket.assigns.pattern_stream_next_id)

    item = %{
      id: id,
      name: ~t"name-#{System.unique_integer([:positive])}",
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
       sort_order: :pattern_sort_order,
       sort_columns: @user_sort_columns
     )}
  end

  def handle_event("pattern_select", %{"id" => _, "checked" => _} = p, socket) do
    {:noreply,
     PState.handle_select_ns(socket, p,
       rows: :pattern_user_rows,
       selected: :pattern_select_selected,
       table_id: "pattern-select-table"
     )}
  end

  def handle_event("pattern_select_all", %{"checked" => _} = p, socket) do
    {:noreply,
     PState.handle_select_all_ns(socket, p,
       rows: :pattern_user_rows,
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
     Corex.Toast.create(
       socket,
       "layout-toast",
       "Selection",
       message,
       :info,
       duration: 5000
     )}
  end

  def handle_event("pattern_full_sort", %{"sort_by" => _} = p, socket) do
    {:noreply,
     PState.handle_sort_ns(socket, p,
       rows: :pattern_full_rows,
       sort_by: :pattern_full_sort_by,
       sort_order: :pattern_full_sort_order,
       sort_columns: @user_sort_columns
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

  def handle_event("pattern_db_sort", %{"sort_by" => sort_by_param}, socket) do
    case Corex.DataTable.Sort.parse_sort_by(
           sort_by_param,
           socket.assigns.pattern_db_sort_columns
         ) do
      {:ok, sort_by} ->
        current_by = socket.assigns.pattern_db_sort_by
        current_order = socket.assigns.pattern_db_sort_order

        {sort_by, sort_order} =
          if current_by == sort_by do
            {sort_by, toggle_order(current_order)}
          else
            {sort_by, :asc}
          end

        {rows, total} =
          Place.list_cities_table(
            page: 1,
            page_size: socket.assigns.pattern_db_page_size,
            order_by: sort_by,
            order_dir: sort_order
          )

        {:noreply,
         socket
         |> assign(:pattern_db_rows, rows)
         |> assign(:pattern_db_page, 1)
         |> assign(:pattern_db_sort_by, sort_by)
         |> assign(:pattern_db_sort_order, sort_order)
         |> assign(:pattern_db_total, total)}

      :error ->
        {:noreply, socket}
    end
  end

  def handle_event("pattern_db_page", %{"page" => page}, socket) do
    page = parse_page(page)

    {rows, total} =
      Place.list_cities_table(
        page: page,
        page_size: socket.assigns.pattern_db_page_size,
        order_by: socket.assigns.pattern_db_sort_by,
        order_dir: socket.assigns.pattern_db_sort_order
      )

    {:noreply,
     socket
     |> assign(:pattern_db_rows, rows)
     |> assign(:pattern_db_page, page)
     |> assign(:pattern_db_total, total)}
  end

  def handle_event("pattern_full_check", _params, socket) do
    message =
      if socket.assigns.pattern_full_selected == [] do
        "No rows selected"
      else
        "Selected IDs: " <> Enum.join(socket.assigns.pattern_full_selected, ", ")
      end

    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "Selection",
       message,
       :info,
       duration: 5000
     )}
  end

  def handle_event("row_click", %{"id" => id, "name" => name}, socket) do
    {:noreply, assign(socket, :pattern_row_clicked, "#{name} (##{id})")}
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
        path={@path}
        id="data-table-patterns-page"
        title="Data Table · Pattern"
        subtitle="Stream, in-memory sort, selection, a database-backed table with pagination, and a combined table on one page."
        heading_class="layout-heading"
      >
        <.demo_section
          id="data-table-patterns-row-click"
          title="Row click"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.DataTableDemo.patterns_row_click_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: E2eWeb.Demos.DataTableDemo.patterns_row_click_elixir()
            }
          ]}
        >
          <:preview>
            <p :if={@pattern_row_clicked}>Row clicked: {@pattern_row_clicked}</p>
            <p :if={is_nil(@pattern_row_clicked)}>Click a row (not the action button).</p>
            <.data_table
              id="pattern-row-click-table"
              class="data-table max-w-none"
              rows={@pattern_row_click_rows}
              row_click={fn row -> JS.push("row_click", value: %{id: row.id, name: row.name}) end}
            >
              <:col :let={row} label="ID">{row.id}</:col>
              <:col :let={row} label="Name">{row.name}</:col>
              <:action :let={row}>
                <.action class="button ui-size-sm" aria-label={"Edit #{row.name}"}>
                  <.heroicon name="hero-pencil-square" />
                </.action>
              </:action>
            </.data_table>
          </:preview>
        </.demo_section>

        <.demo_section
          id="data-table-patterns-stream"
          title={~t"Stream"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: E2eWeb.Demos.DataTableDemo.patterns_stream_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: E2eWeb.Demos.DataTableDemo.patterns_stream_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <div class="flex gap-2 flex-wrap">
                <.action phx-click="pattern_stream_add" class="button ui-size-sm ui-accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="pattern_stream_reset" class="button ui-size-sm">
                  <.heroicon name="hero-arrow-path" /> Reset
                </.action>
              </div>
              <.data_table
                id="pattern-stream-table"
                class="data-table max-w-none"
                rows={@streams.pattern_stream}
              >
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
                    class="button ui-size-sm ui-alert"
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
          title={~t"Sort"}
          code_tabs={E2eWeb.Demos.DataTableDemo.patterns_sort_code_tabs()}
        >
          <:preview>
            <.data_table
              id="pattern-sort-table"
              class="data-table max-w-none"
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
          title={~t"Select"}
          code_tabs={E2eWeb.Demos.DataTableDemo.patterns_select_code_tabs()}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full">
              <.action phx-click="pattern_check_selected" class="button ui-size-sm">
                Check selected
              </.action>
              <.data_table
                id="pattern-select-table"
                class="data-table max-w-none"
                rows={@pattern_user_rows}
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
          title={~t"Full (action, sort, select)"}
          code_tabs={E2eWeb.Demos.DataTableDemo.patterns_full_code_tabs()}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full">
              <.action phx-click="pattern_full_check" class="button ui-size-sm">
                Check selected
              </.action>
              <.data_table
                id="pattern-full-table"
                class="data-table max-w-none"
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
                  <.action class="button ui-size-sm" aria-label={"Edit #{u.name}"}>
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

        <.demo_section
          id="data-table-patterns-database"
          title={~t"With database"}
          code_tabs={E2eWeb.Demos.DataTableDemo.patterns_database_code_tabs()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.data_table
                id="pattern-db-table"
                class="data-table max-w-none"
                rows={@pattern_db_rows}
                row_id={&"db-#{&1.id}"}
                sort_by={@pattern_db_sort_by}
                sort_order={@pattern_db_sort_order}
                on_sort="pattern_db_sort"
              >
                <:sort_icon :let={%{direction: direction}}>
                  <.heroicon name={sort_icon_name(direction)} />
                </:sort_icon>
                <:col :let={city} label="Name" name={:name}>{city.name}</:col>
                <:col :let={city} label="IATA" name={:iata_code}>{city.iata_code}</:col>
                <:col :let={city} label="Country" name={:iata_country_code}>
                  {city.iata_country_code}
                </:col>
                <:empty>
                  <p id="pattern-db-empty">No cities</p>
                </:empty>
              </.data_table>
              <.pagination
                id="pattern-db-pagination"
                class="pagination max-w-none mx-auto"
                count={@pattern_db_total}
                page={@pattern_db_page}
                page_size={@pattern_db_page_size}
                controlled
                on_page_change="pattern_db_page"
              >
                <:prev><.heroicon name="hero-chevron-left" /></:prev>
                <:next><.heroicon name="hero-chevron-right" /></:next>
                <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
              </.pagination>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp sort_icon_name(:asc), do: "hero-chevron-up"
  defp sort_icon_name(:desc), do: "hero-chevron-down"
  defp sort_icon_name(:none), do: "hero-chevron-up-down"

  defp toggle_order(:asc), do: :desc
  defp toggle_order(:desc), do: :asc

  defp parse_page(page) when is_integer(page) and page > 0, do: page

  defp parse_page(page) when is_binary(page) do
    case Integer.parse(page) do
      {n, _} when n > 0 -> n
      _ -> 1
    end
  end

  defp parse_page(_), do: 1
end
