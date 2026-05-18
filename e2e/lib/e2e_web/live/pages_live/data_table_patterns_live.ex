defmodule E2eWeb.DataTablePatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Place
  alias E2eWeb.DataTablePatternState, as: PState

  @pattern_db_page_size 5

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
     |> assign(:pattern_sort_rows, sort_rows)
     |> assign(:pattern_sort_by, :id)
     |> assign(:pattern_sort_order, :asc)
     |> assign(:pattern_select_rows, @list_users)
     |> assign(:pattern_select_selected, [])
     |> assign(:pattern_full_rows, full_rows)
     |> assign(:pattern_full_sort_by, :id)
     |> assign(:pattern_full_sort_order, :asc)
     |> assign(:pattern_full_selected, [])
     |> assign(:pattern_db_rows, db_rows)
     |> assign(:pattern_db_page, 1)
     |> assign(:pattern_db_page_size, @pattern_db_page_size)
     |> assign(:pattern_db_sort_by, :name)
     |> assign(:pattern_db_sort_order, :asc)
     |> assign(:pattern_db_total, db_total)
     |> assign(:pattern_flop_rows, [])
     |> assign(:pattern_flop_meta, nil)
     |> assign(:pattern_flop_sort_by, :name)
     |> assign(:pattern_flop_sort_order, :asc)
     |> assign(:pattern_flop_params, %{})}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    flop_params = take_flop_params(params)

    case Place.list_cities_flop(flop_params) do
      {:ok, {rows, meta}} ->
        {:noreply,
         socket
         |> assign(:pattern_flop_rows, rows)
         |> assign(:pattern_flop_meta, meta)
         |> assign(:pattern_flop_params, flop_params)
         |> assign_flop_sort(meta)}

      {:error, _meta} ->
        case Place.list_cities_flop(%{}) do
          {:ok, {rows, meta}} ->
            {:noreply,
             socket
             |> assign(:pattern_flop_rows, rows)
             |> assign(:pattern_flop_meta, meta)
             |> assign(:pattern_flop_params, %{})
             |> assign_flop_sort(meta)}

          {:error, _} ->
            {:noreply, socket}
        end
    end
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

  def handle_event("pattern_db_sort", %{"sort_by" => sort_by_param}, socket) do
    sort_by = String.to_existing_atom(sort_by_param)
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

  def handle_event("pattern_flop_sort", %{"sort_by" => sort_by_param}, socket) do
    sort_by = String.to_existing_atom(sort_by_param)
    current_by = socket.assigns.pattern_flop_sort_by
    current_order = socket.assigns.pattern_flop_sort_order

    {sort_by, sort_order} =
      if current_by == sort_by do
        {sort_by, toggle_order(current_order)}
      else
        {sort_by, :asc}
      end

    params =
      socket.assigns.pattern_flop_params
      |> Map.merge(flop_sort_params(sort_by, sort_order, socket.assigns.pattern_flop_meta))

    {:noreply, push_patch(socket, to: patterns_flop_url(socket, params))}
  end

  def handle_event("pattern_flop_page", %{"page" => page}, socket) do
    params = Map.put(socket.assigns.pattern_flop_params, "page", to_string(parse_page(page)))

    {:noreply, push_patch(socket, to: patterns_flop_url(socket, params))}
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
        subtitle="Stream, in-memory sort, selection, database-backed tables (manual Ecto and Flop), and a combined table on one page."
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
            <div class="flex flex-col gap-4 w-full">
              <div class="flex gap-2 flex-wrap">
                <.action phx-click="pattern_stream_add" class="button button--sm button--accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="pattern_stream_reset" class="button button--sm">
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
            <div class="flex flex-col gap-3 w-full">
              <.action phx-click="pattern_check_selected" class="button button--sm">
                Check selected
              </.action>
              <.data_table
                id="pattern-select-table"
                class="data-table max-w-none"
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
            <div class="flex flex-col gap-3 w-full">
              <.action phx-click="pattern_full_check" class="button button--sm">
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

        <.demo_section
          id="data-table-patterns-database"
          title="With database"
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

        <.demo_section
          id="data-table-patterns-flop"
          title="With Flop"
          code_tabs={E2eWeb.Demos.DataTableDemo.patterns_flop_code_tabs()}
        >
          <:preview>
            <div class="flex flex-col gap-4 w-full">
              <.data_table
                id="pattern-flop-table"
                class="data-table max-w-none"
                rows={@pattern_flop_rows}
                row_id={&"flop-#{&1.id}"}
                sort_by={@pattern_flop_sort_by}
                sort_order={@pattern_flop_sort_order}
                on_sort="pattern_flop_sort"
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
                  <p id="pattern-flop-empty">No cities</p>
                </:empty>
              </.data_table>
              <.pagination
                :if={@pattern_flop_meta}
                id="pattern-flop-pagination"
                class="pagination max-w-none mx-auto"
                count={@pattern_flop_meta.total_count}
                page={@pattern_flop_meta.current_page}
                page_size={@pattern_flop_meta.page_size}
                controlled
                on_page_change="pattern_flop_page"
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

  defp take_flop_params(params) do
    params
    |> Map.take(["page", "page_size", "order_by", "order_directions"])
    |> Enum.reject(fn {_k, v} -> v in [nil, ""] end)
    |> Map.new()
  end

  defp assign_flop_sort(socket, %Flop.Meta{flop: flop}) do
    sort_by = flop.order_by |> List.wrap() |> List.first(:name)
    sort_order = flop.order_directions |> List.wrap() |> List.first(:asc)

    socket
    |> assign(:pattern_flop_sort_by, sort_by)
    |> assign(:pattern_flop_sort_order, sort_order)
  end

  defp flop_sort_params(sort_by, sort_order, %Flop.Meta{flop: flop}) do
    %{
      "order_by" => [Atom.to_string(sort_by)],
      "order_directions" => [Atom.to_string(sort_order)],
      "page" => "1",
      "page_size" => to_string(flop.page_size || @pattern_db_page_size)
    }
  end

  defp flop_sort_params(sort_by, sort_order, nil) do
    %{
      "order_by" => [Atom.to_string(sort_by)],
      "order_directions" => [Atom.to_string(sort_order)],
      "page" => "1",
      "page_size" => to_string(@pattern_db_page_size)
    }
  end

  defp patterns_flop_url(socket, params) do
    query = flop_encode_query(params)
    base = E2eWeb.Path.with_current_locale(socket.assigns.path)

    if query == "" do
      base
    else
      base <> "?" <> query
    end
  end

  defp flop_encode_query(params) do
    params
    |> Enum.flat_map(&flop_query_pair/1)
    |> URI.encode_query()
  end

  defp flop_query_pair({"order_by", values}) when is_list(values) do
    Enum.map(values, &{"order_by[]", &1})
  end

  defp flop_query_pair({"order_directions", values}) when is_list(values) do
    Enum.map(values, &{"order_directions[]", &1})
  end

  defp flop_query_pair({key, value}) when is_binary(value), do: [{key, value}]
  defp flop_query_pair({key, value}) when is_integer(value), do: [{key, Integer.to_string(value)}]
  defp flop_query_pair({key, value}) when is_atom(value), do: [{key, Atom.to_string(value)}]
  defp flop_query_pair(_), do: []
end
