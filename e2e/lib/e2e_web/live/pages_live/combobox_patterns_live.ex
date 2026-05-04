defmodule E2eWeb.ComboboxPatternsLive do
  use E2eWeb, :live_view

  import Ecto.Query
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Place
  alias E2e.Place.City
  alias E2e.Repo

  @controlled_items [
    %{label: "France", id: "fra"},
    %{label: "Belgium", id: "bel"},
    %{label: "Germany", id: "deu"},
    %{label: "Netherlands", id: "nld"},
    %{label: "Switzerland", id: "che"},
    %{label: "Austria", id: "aut"}
  ]

  def mount(_params, _session, socket) do
    airports = Place.list_airports_first(40, 0) |> Enum.map(&format_airport/1)

    cities =
      from(c in City, order_by: [asc: c.name], limit: 40)
      |> Repo.all()
      |> Enum.map(&format_city/1)

    {:ok,
     socket
     |> assign(:airports, airports)
     |> assign(:cities, cities)
     |> assign(:combobox_controlled_value, ["deu"])
     |> assign(:combobox_controlled_items, Corex.List.new(@controlled_items))}
  end

  def handle_event("search_airports", %{"reason" => "clear-trigger"}, socket) do
    airports = Place.list_airports_first(40, 0) |> Enum.map(&format_airport/1)
    {:noreply, assign(socket, :airports, airports)}
  end

  def handle_event("search_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports", %{"value" => value}, socket) when is_binary(value) do
    airports =
      if byte_size(value) < 1 do
        Place.list_airports_first(40, 0) |> Enum.map(&format_airport/1)
      else
        Place.search_airports(value, 50, 0) |> Enum.map(&format_airport/1)
      end

    {:noreply, assign(socket, :airports, airports)}
  end

  def handle_event("search_airports", _params, socket), do: {:noreply, socket}

  def handle_event("search_cities", %{"reason" => "clear-trigger"}, socket) do
    cities =
      from(c in City, order_by: [asc: c.name], limit: 40)
      |> Repo.all()
      |> Enum.map(&format_city/1)

    {:noreply, assign(socket, :cities, cities)}
  end

  def handle_event("search_cities", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_cities", %{"value" => value}, socket) when is_binary(value) do
    cities =
      if byte_size(value) < 1 do
        from(c in City, order_by: [asc: c.name], limit: 40)
        |> Repo.all()
        |> Enum.map(&format_city/1)
      else
        Place.search_cities(value, 50, 0) |> Enum.map(&format_city/1)
      end

    {:noreply, assign(socket, :cities, cities)}
  end

  def handle_event("search_cities", _params, socket), do: {:noreply, socket}

  def handle_event("combobox_patterns_controlled_value", %{"value" => value}, socket) do
    v = value |> List.wrap() |> Enum.map(&to_string/1)
    {:noreply, assign(socket, :combobox_controlled_value, v)}
  end

  defp format_airport(a) do
    %{id: a.iata_code, label: "#{a.name} (#{a.iata_code})"}
  end

  defp format_city(c) do
    code = c.iata_code || c.id
    %{id: c.id, label: "#{c.name} (#{code})"}
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
        id="combobox-patterns-page"
        title="Combobox · Patterns"
        subtitle="Server-backed search with E2e.Place airports and cities."
      >
        <.demo_section
          id="combobox-patterns-airports-doc"
          title="Airports (search_airports/3)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: patterns_airports_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_airports_elixir()}
          ]}
        >
          <:preview>
            <.combobox
              id="combobox-patterns-airports-field"
              class="combobox"
              placeholder="Search airports…"
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
          id="combobox-patterns-cities-doc"
          title="Cities (search_cities/3)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: patterns_cities_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_cities_elixir()}
          ]}
        >
          <:preview>
            <.combobox
              id="combobox-patterns-cities-field"
              class="combobox"
              placeholder="Search cities…"
              items={Corex.List.new(@cities)}
              filter={false}
              on_input_value_change="search_cities"
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-patterns-controlled-doc"
          title="Controlled (value)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: patterns_controlled_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_controlled_elixir()}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 max-w-md w-full">
              <.combobox
                id="combobox-patterns-controlled-field"
                class="combobox"
                placeholder="Select a country…"
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

  defp patterns_airports_heex do
    ~S"""
    <.combobox
      id="combobox-patterns-airports-field"
      class="combobox"
      placeholder="Search airports…"
      items={@airports}
      filter={false}
      on_input_value_change="search_airports"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
    </.combobox>
    """
  end

  defp patterns_airports_elixir do
    ~S"""
    def handle_event("search_airports", %{"value" => value, "reason" => "input-change"}, socket)
        when byte_size(value) < 1 do
      airports = Place.list_airports_first(40, 0) |> Enum.map(&format_airport/1)
      {:noreply, assign(socket, :airports, airports)}
    end

    def handle_event("search_airports", %{"value" => value, "reason" => "input-change"}, socket) do
      list = Place.search_airports(value, 50, 0) |> Enum.map(&format_airport/1)
      {:noreply, assign(socket, :airports, list)}
    end
    """
  end

  defp patterns_cities_heex do
    ~S"""
    <.combobox
      id="combobox-patterns-cities-field"
      class="combobox"
      placeholder="Search cities…"
      items={@cities}
      filter={false}
      on_input_value_change="search_cities"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
    </.combobox>
    """
  end

  defp patterns_cities_elixir do
    ~S"""
    def handle_event("search_cities", %{"value" => value, "reason" => "input-change"}, socket)
        when byte_size(value) < 1 do
      cities = from(c in City, order_by: [asc: c.name], limit: 40) |> Repo.all() |> Enum.map(&format_city/1)
      {:noreply, assign(socket, :cities, cities)}
    end

    def handle_event("search_cities", %{"value" => value, "reason" => "input-change"}, socket) do
      list = Place.search_cities(value, 50, 0) |> Enum.map(&format_city/1)
      {:noreply, assign(socket, :cities, list)}
    end
    """
  end

  defp patterns_controlled_heex do
    ~S"""
    <.combobox
      id="combobox-patterns-controlled-field"
      class="combobox"
      placeholder="Select a country…"
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
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"}
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
