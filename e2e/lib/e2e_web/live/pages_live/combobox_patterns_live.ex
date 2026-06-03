defmodule E2eWeb.ComboboxPatternsLive do
  use E2eWeb, :live_view

  import Ecto.Query
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Place
  alias E2e.Place.Airport
  alias E2e.Repo

  @airport_page_size 40
  @search_limit 80

  @grouped_iata ~W(LHR LGW STN JFK LGA EWR CDG ORY IST SAW)

  def mount(_params, _session, socket) do
    airports = Place.list_airports_first(@airport_page_size, 0) |> Enum.map(&format_airport/1)

    {:ok,
     socket
     |> assign(:airports, airports)
     |> assign(:airports_grouped, load_airports_grouped_from_db())}
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
    {:noreply, assign(socket, :airports_grouped, load_airports_grouped_from_db())}
  end

  def handle_event("search_airports_grouped", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports_grouped", %{"value" => value}, socket)
      when is_binary(value) do
    list =
      if byte_size(value) < 1 do
        load_airports_grouped_from_db()
      else
        q = String.downcase(value)

        load_airports_grouped_from_db()
        |> Enum.filter(fn row -> String.contains?(String.downcase(row.label), q) end)
      end

    {:noreply, assign(socket, :airports_grouped, list)}
  end

  def handle_event("search_airports_grouped", _params, socket), do: {:noreply, socket}

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
        subtitle={~t"Server-driven filtering."}
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
              placeholder={~t"Search…"}
              items={Corex.List.new(@airports)}
              filter={false}
              on_input_value_change="search_airports"
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
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
              placeholder={~t"Search…"}
              items={Corex.List.new(@airports_grouped)}
              filter={false}
              on_input_value_change="search_airports_grouped"
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
            </.combobox>
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
end
