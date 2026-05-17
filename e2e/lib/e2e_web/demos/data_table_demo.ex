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
      class="data-table max-w-none"
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
      class="data-table max-w-none"
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
      class="data-table max-w-none"
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
      class="data-table max-w-none"
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
      class="data-table max-w-none"
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
      class="data-table max-w-none"
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
    <.data_table id="pattern-stream-table" class="data-table max-w-none" rows={@streams.pattern_stream}>
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

  def patterns_database_heex do
    ~S"""
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
      <:col :let={city} label="Country" name={:iata_country_code}>{city.iata_country_code}</:col>
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
    </.pagination>
    """
  end

  def patterns_database_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {rows, total} =
        MyApp.Place.list_cities_table(page: 1, page_size: 5, order_by: :name, order_dir: :asc)

      {:ok,
       socket
       |> assign(:pattern_db_rows, rows)
       |> assign(:pattern_db_page, 1)
       |> assign(:pattern_db_page_size, 5)
       |> assign(:pattern_db_sort_by, :name)
       |> assign(:pattern_db_sort_order, :asc)
       |> assign(:pattern_db_total, total)}
    end

    def handle_event("pattern_db_sort", %{"sort_by" => sort_by}, socket) do
      sort_by = String.to_existing_atom(sort_by)
      order = if socket.assigns.pattern_db_sort_by == sort_by, do: toggle(socket.assigns.pattern_db_sort_order), else: :asc

      {rows, total} =
        MyApp.Place.list_cities_table(
          page: 1,
          page_size: socket.assigns.pattern_db_page_size,
          order_by: sort_by,
          order_dir: order
        )

      {:noreply,
       socket
       |> assign(:pattern_db_rows, rows)
       |> assign(:pattern_db_page, 1)
       |> assign(:pattern_db_sort_by, sort_by)
       |> assign(:pattern_db_sort_order, order)
       |> assign(:pattern_db_total, total)}
    end

    def handle_event("pattern_db_page", %{"page" => page}, socket) do
      page = String.to_integer(page)

      {rows, total} =
        MyApp.Place.list_cities_table(
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
    """
  end

  def patterns_flop_heex do
    ~S"""
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
      <:col :let={city} label="Country" name={:iata_country_code}>{city.iata_country_code}</:col>
    </.data_table>

    <.pagination
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
    </.pagination>
    """
  end

  def patterns_place_migration do
    """
    defmodule MyApp.Repo.Migrations.CreateCities do
      use Ecto.Migration

      def change do
        create table(:cities, primary_key: false) do
          add :id, :string, primary_key: true
          add :iata_code, :string
          add :iata_country_code, :string
          add :name, :string
          add :airports, :jsonb, default: "[]"
        end
      end
    end

    defmodule MyApp.Repo.Migrations.CreateAirports do
      use Ecto.Migration

      def change do
        create table(:airports, primary_key: false) do
          add :id, :string, primary_key: true
          add :name, :string
          add :iata_code, :string
          add :city_name, :string
          add :iata_city_code, :string
          add :iata_country_code, :string
          add :icao_code, :string
          add :latitude, :float
          add :longitude, :float
          add :time_zone, :string
          add :city, :jsonb
        end
      end
    end
    """
  end

  def patterns_place_schema_database do
    """
    defmodule MyApp.Place.City do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, :string, autogenerate: false}

      schema "cities" do
        field :name, :string
        field :iata_code, :string
        field :iata_country_code, :string
      end

      def changeset(city, attrs) do
        city
        |> cast(attrs, [:id, :name, :iata_code, :iata_country_code])
        |> validate_required([:name, :iata_code, :iata_country_code])
      end
    end
    """
  end

  def patterns_place_schema_flop do
    """
    defmodule MyApp.Place.City do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, :string, autogenerate: false}

      @derive {
        Flop.Schema,
        filterable: [],
        sortable: [:name, :iata_code, :iata_country_code]
      }

      schema "cities" do
        field :name, :string
        field :iata_code, :string
        field :iata_country_code, :string
      end

      def changeset(city, attrs) do
        city
        |> cast(attrs, [:id, :name, :iata_code, :iata_country_code])
        |> validate_required([:name, :iata_code, :iata_country_code])
      end
    end
    """
  end

  def patterns_database_context do
    """
    defmodule MyApp.Place do
      import Ecto.Query, warn: false
      alias MyApp.Repo
      alias MyApp.Place.City

      @sortable [:name, :iata_code, :iata_country_code]

      def list_cities_table(opts \\\\ []) do
        page = Keyword.get(opts, :page, 1)
        page_size = Keyword.get(opts, :page_size, 5)
        order_by = Keyword.get(opts, :order_by, :name)
        order_dir = Keyword.get(opts, :order_dir, :asc)

        order_by = if order_by in @sortable, do: order_by, else: :name
        order_dir = if order_dir in [:asc, :desc], do: order_dir, else: :asc

        ordered = from(c in City, order_by: [{^order_dir, field(c, ^order_by)}])
        total_count = Repo.aggregate(ordered, :count)
        offset = max(page - 1, 0) * page_size

        rows =
          ordered
          |> limit(^page_size)
          |> offset(^offset)
          |> Repo.all()

        {rows, total_count}
      end
    end
    """
  end

  def patterns_flop_context do
    """
    defmodule MyApp.Place do
      alias MyApp.Place.City

      def list_cities_flop(params \\\\ %{}) do
        Flop.validate_and_run(City, params, for: City, default_limit: 5)
      end
    end
    """
  end

  def patterns_flop_config do
    """
    # mix.exs
    defp deps do
      [
        {:flop, "~> 0.26"}
      ]
    end

    # config/config.exs
    config :flop, repo: MyApp.Repo
    """
  end

  def patterns_place_data_seed do
    """
    alias MyApp.Place

    for {id, name, code, country} <- [
          {"par", "Paris", "PAR", "FR"},
          {"lon", "London", "LON", "GB"},
          {"ber", "Berlin", "BER", "DE"},
          {"mad", "Madrid", "MAD", "ES"},
          {"rom", "Rome", "ROM", "IT"},
          {"ams", "Amsterdam", "AMS", "NL"},
          {"vie", "Vienna", "VIE", "AT"},
          {"lis", "Lisbon", "LIS", "PT"},
          {"dub", "Dublin", "DUB", "IE"},
          {"bru", "Brussels", "BRU", "BE"},
          {"zrh", "Zurich", "ZRH", "CH"},
          {"osl", "Oslo", "OSL", "NO"},
          {"cph", "Copenhagen", "CPH", "DK"},
          {"ath", "Athens", "ATH", "GR"}
        ] do
      Place.create_city(%{
        id: id,
        name: name,
        iata_code: code,
        iata_country_code: country
      })
    end
    """
  end

  def patterns_flop_liveview do
    """
    defmodule MyAppWeb.CityTableLive do
      use MyAppWeb, :live_view

      alias MyApp.Place

      @page_size 5

      @impl true
      def mount(_params, _session, socket) do
        {:ok,
         socket
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

        {:noreply, push_patch(socket, to: flop_patch_url(socket, params))}
      end

      def handle_event("pattern_flop_page", %{"page" => page}, socket) do
        params = Map.put(socket.assigns.pattern_flop_params, "page", to_string(parse_page(page)))
        {:noreply, push_patch(socket, to: flop_patch_url(socket, params))}
      end

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
          "page_size" => to_string(flop.page_size || @page_size)
        }
      end

      defp flop_sort_params(sort_by, sort_order, nil) do
        %{
          "order_by" => [Atom.to_string(sort_by)],
          "order_directions" => [Atom.to_string(sort_order)],
          "page" => "1",
          "page_size" => to_string(@page_size)
        }
      end

      defp flop_patch_url(socket, params) do
        base = MyAppWeb.Path.with_current_locale(socket.assigns.path)
        query = flop_encode_query(params)
        if query == "", do: base, else: base <> "?" <> query
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
      defp flop_query_pair(_), do: []

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
    """
  end

  def patterns_database_data do
    [
      patterns_place_migration(),
      patterns_place_schema_database(),
      patterns_database_context(),
      patterns_place_data_seed()
    ]
    |> Enum.join("\n\n")
  end

  def patterns_flop_data do
    [
      patterns_flop_config(),
      patterns_place_migration(),
      patterns_place_schema_flop(),
      patterns_flop_context(),
      patterns_place_data_seed()
    ]
    |> Enum.join("\n\n")
  end

  def patterns_database_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: patterns_database_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_database_elixir()},
      %{value: "data", label: "Data", language: :elixir, code: patterns_database_data()}
    ]
  end

  def patterns_flop_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: patterns_flop_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_flop_liveview()},
      %{value: "data", label: "Data", language: :elixir, code: patterns_flop_data()}
    ]
  end
end
