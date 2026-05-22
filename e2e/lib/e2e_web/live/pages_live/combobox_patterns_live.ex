defmodule E2eWeb.ComboboxPatternsLive do
  use E2eWeb, :live_view

  import Ecto.Query
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Place
  alias E2e.Place.Airport
  alias E2e.Repo

  @airport_page_size 120
  @search_limit 80

  @grouped_iata ~W(LHR LGW STN JFK LGA EWR CDG ORY IST SAW)

  @controlled_items [
    %{label: "France", value: "fra"},
    %{label: "Belgium", value: "bel"},
    %{label: "Germany", value: "deu"},
    %{label: "Netherlands", value: "nld"},
    %{label: "Switzerland", value: "che"},
    %{label: "Austria", value: "aut"}
  ]

  def mount(_params, _session, socket) do
    airports = Place.list_airports_first(@airport_page_size, 0) |> Enum.map(&format_airport/1)
    grouped = load_airports_grouped_from_db()
    grouped_all = grouped

    {:ok,
     socket
     |> assign(:airports, airports)
     |> assign(:airports_grouped, grouped)
     |> assign(:airports_grouped_all, grouped_all)
     |> assign(:combobox_controlled_value, ["deu"])
     |> assign(:combobox_controlled_items, Corex.List.new(@controlled_items))}
  end

  def handle_event("search_airports", %{"reason" => "clear-trigger"}, socket) do
    airports = Place.list_airports_first(@airport_page_size, 0) |> Enum.map(&format_airport/1)
    {:noreply, assign(socket, :airports, airports)}
  end

  def handle_event("search_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports", %{"value" => value}, socket) when is_binary(value) do
    airports =
      if byte_size(value) < 1 do
        Place.list_airports_first(@airport_page_size, 0) |> Enum.map(&format_airport/1)
      else
        Place.search_airports(value, @search_limit, 0) |> Enum.map(&format_airport/1)
      end

    {:noreply, assign(socket, :airports, airports)}
  end

  def handle_event("search_airports", _params, socket), do: {:noreply, socket}

  def handle_event("search_airports_grouped", %{"reason" => "clear-trigger"}, socket) do
    full = socket.assigns.airports_grouped_all
    {:noreply, assign(socket, :airports_grouped, full)}
  end

  def handle_event("search_airports_grouped", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports_grouped", %{"value" => value}, socket)
      when is_binary(value) do
    full = socket.assigns.airports_grouped_all

    list =
      if byte_size(value) < 1 do
        full
      else
        q = String.downcase(value)
        Enum.filter(full, fn row -> String.contains?(String.downcase(row.label), q) end)
      end

    {:noreply, assign(socket, :airports_grouped, list)}
  end

  def handle_event("search_airports_grouped", _params, socket), do: {:noreply, socket}

  def handle_event("combobox_patterns_controlled_value", %{"value" => value}, socket) do
    v = value |> List.wrap() |> Enum.map(&to_string/1)
    {:noreply, assign(socket, :combobox_controlled_value, v)}
  end

  defp load_airports_grouped_from_db do
    from(a in Airport,
      where: a.iata_code in ^@grouped_iata,
      order_by: [asc: a.city_name, asc: a.name]
    )
    |> Repo.all()
    |> Enum.map(fn a ->
      city = a.city_name || " - "
      %{value: a.iata_code, label: ~t"#{a.name} (#{a.iata_code})", group: city}
    end)
  end

  defp format_airport(a) do
    %{value: a.iata_code, label: ~t"#{a.name} (#{a.iata_code})"}
  end

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
        id="combobox-patterns-page"
        title={~t"Combobox · Patterns"}
        subtitle={~t"Server-driven filtering and controlled value."}
      >
        <.demo_section
          id="combobox-patterns-server-filter-doc"
          title={~t"Server Side Filtering"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: patterns_server_filter_heex()},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: patterns_server_filter_elixir()
            }
          ]}
        >
          <:preview>
            <.combobox
              id="combobox-patterns-server-filter-field"
              class="combobox"
              placeholder={~t"Search…"}
              items={Corex.List.new(@airports)}
              filter={false}
              on_input_value_change="search_airports"
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-patterns-server-filter-grouped-doc"
          title={~t"Server Side Filtering Grouped"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: patterns_server_filter_grouped_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: patterns_server_filter_grouped_elixir()
            }
          ]}
        >
          <:preview>
            <.combobox
              id="combobox-patterns-server-filter-grouped-field"
              class="combobox"
              placeholder={~t"Search…"}
              items={Corex.List.new(@airports_grouped)}
              filter={false}
              on_input_value_change="search_airports_grouped"
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-patterns-controlled-doc"
          title={~t"Controlled (value)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: patterns_controlled_heex()},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: patterns_controlled_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 max-w-md">
              <.combobox
                id="combobox-patterns-controlled-field"
                class="combobox"
                placeholder={~t"Select a country…"}
                items={@combobox_controlled_items}
                controlled
                value={@combobox_controlled_value}
                on_value_change="combobox_patterns_controlled_value"
              >
                <:empty>No results</:empty>
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
                <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
                <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
              </.combobox>
              <p class="text-sm text-ink-muted font-mono" id="combobox-patterns-controlled-state">
                value: {inspect(@combobox_controlled_value)}
              </p>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp patterns_server_filter_heex do
    ~S"""
    <.combobox
      id="airport-combobox"
      class="combobox"
      placeholder={~t"Search…"}
      items={@items}
      filter={false}
      on_input_value_change="filter_airports"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
    </.combobox>
    """
  end

  defp patterns_server_filter_elixir do
    ~S"""
    defmodule MyAppWeb.AirportComboboxLive do
      use MyAppWeb, :live_view

      defp all_rows do
        [
          %{value: "LHR", label: ~t"London Heathrow (LHR)"},
          %{value: "CDG", label: ~t"Paris Charles de Gaulle (CDG)"},
          %{value: "JFK", label: ~t"New York John F. Kennedy (JFK)"}
        ]
      end

      def mount(_params, _session, socket) do
        {:ok, assign(socket, :items, Corex.List.new(all_rows()))}
      end

      def handle_event("filter_airports", %{"reason" => "clear-trigger"}, socket) do
        {:noreply, assign(socket, :items, Corex.List.new(all_rows()))}
      end

      def handle_event("filter_airports", %{"reason" => "item-select"}, socket), do: {:noreply, socket}

      def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
        q = value |> String.trim() |> String.downcase()

        rows =
          if q == "" do
            all_rows()
          else
            Enum.filter(all_rows(), fn r -> String.contains?(String.downcase(r.label), q) end)
          end

        {:noreply, assign(socket, :items, Corex.List.new(rows))}
      end

      def handle_event("filter_airports", _, socket), do: {:noreply, socket}

      def render(assigns) do
        ~H|
        <.combobox
          id="airport-combobox"
          class="combobox"
          placeholder={~t"Search…"}
          items={@items}
          filter={false}
          on_input_value_change="filter_airports"
        >
          <:empty>No results</:empty>
          <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
          <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
        </.combobox>
        |
      end
    end
    """
  end

  defp patterns_server_filter_grouped_heex do
    ~S"""
    <.combobox
      id="airport-combobox-grouped"
      class="combobox"
      placeholder={~t"Search…"}
      items={@items}
      filter={false}
      on_input_value_change="filter_airports_grouped"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
    </.combobox>
    """
  end

  defp patterns_server_filter_grouped_elixir do
    ~S"""
    defmodule MyAppWeb.AirportComboboxGroupedLive do
      use MyAppWeb, :live_view

      defp all_rows do
        [
          %{value: "LHR", label: ~t"London Heathrow (LHR)", group: "London"},
          %{value: "LGW", label: ~t"London Gatwick (LGW)", group: "London"},
          %{value: "STN", label: ~t"London Stansted (STN)", group: "London"},
          %{value: "JFK", label: ~t"New York John F. Kennedy (JFK)", group: "New York"},
          %{value: "LGA", label: ~t"New York LaGuardia (LGA)", group: "New York"},
          %{value: "EWR", label: ~t"Newark Liberty (EWR)", group: "New York"},
          %{value: "CDG", label: ~t"Paris Charles de Gaulle (CDG)", group: "Paris"},
          %{value: "ORY", label: ~t"Paris Orly (ORY)", group: "Paris"},
          %{value: "IST", label: ~t"Istanbul Airport (IST)", group: "Istanbul"},
          %{value: "SAW", label: ~t"Istanbul Sabiha Gökçen (SAW)", group: "Istanbul"}
        ]
      end

      def mount(_params, _session, socket) do
        {:ok, assign(socket, :items, Corex.List.new(all_rows()))}
      end

      def handle_event("filter_airports_grouped", %{"reason" => "clear-trigger"}, socket) do
        {:noreply, assign(socket, :items, Corex.List.new(all_rows()))}
      end

      def handle_event("filter_airports_grouped", %{"reason" => "item-select"}, socket), do: {:noreply, socket}

      def handle_event("filter_airports_grouped", %{"value" => value}, socket) when is_binary(value) do
        q = value |> String.trim() |> String.downcase()

        rows =
          if q == "" do
            all_rows()
          else
            Enum.filter(all_rows(), fn r -> String.contains?(String.downcase(r.label), q) end)
          end

        {:noreply, assign(socket, :items, Corex.List.new(rows))}
      end

      def handle_event("filter_airports_grouped", _, socket), do: {:noreply, socket}

      def render(assigns) do
        ~H|
        <.combobox
          id="airport-combobox-grouped"
          class="combobox"
          placeholder={~t"Search…"}
          items={@items}
          filter={false}
          on_input_value_change="filter_airports_grouped"
        >
          <:empty>No results</:empty>
          <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
          <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
        </.combobox>
        |
      end
    end
    """
  end

  defp patterns_controlled_heex do
    ~S"""
    <.combobox
      id="combobox-patterns-controlled-field"
      class="combobox"
      placeholder={~t"Select a country…"}
      items={@combobox_controlled_items}
      controlled
      value={@combobox_controlled_value}
      on_value_change="combobox_patterns_controlled_value"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.combobox>
    """
  end

  defp patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      items = Corex.List.new([
        %{label: ~t"Belgium", value: "bel"},
        %{label: ~t"Germany", value: "deu"}
      ])

      {:ok,
       socket
       |> assign(:combobox_controlled_value, ["deu"])
       |> assign(:combobox_controlled_items, items)}
    end

    def handle_event("combobox_patterns_controlled_value", %{"value" => value}, socket) do
      v = value |> List.wrap() |> Enum.map(&to_string/1)
      {:noreply, assign(socket, :combobox_controlled_value, v)}
    end
    """
  end
end
