defmodule E2eWeb.ComboboxFetch do
  use E2eWeb, :live_view

  alias E2e.Place

  def mount(_params, _session, socket) do
    raw = Place.list_airports_first(20, 0)
    {:ok,
     socket
     |> assign(:airports, format_airports(raw))
     |> assign(:raw_airports, raw)
     |> assign(:loading, false)
     |> assign(:offset, 20)
     |> assign(:search_term, nil)}
  end

  def handle_event("search_airports", %{"value" => value}, socket) when byte_size(value) < 2 do
    raw = Place.list_airports_first(20, 0)
    {:noreply,
     socket
     |> assign(:airports, format_airports(raw))
     |> assign(:raw_airports, raw)
     |> assign(:offset, 20)
     |> assign(:search_term, nil)}
  end

  def handle_event("search_airports", %{"value" => value}, socket) do
    raw = Place.search_airports(value, 20, 0)
    raw = if raw == [], do: Place.list_airports_first(20, 0), else: raw
    {:noreply,
     socket
     |> assign(:airports, format_airports(raw))
     |> assign(:raw_airports, raw)
     |> assign(:offset, 20)
     |> assign(:search_term, value)
     |> assign(:loading, false)}
  end

  defp format_airports(airports) do
    sorted =
      Enum.sort_by(airports, fn a ->
        {(a.city_name || "Other"), a.name}
      end)

    city_counts =
      sorted
      |> Enum.group_by(&(&1.city_name || "Other"))
      |> Map.new(fn {city, list} -> {city, length(list)} end)

    Enum.map(sorted, fn airport ->
      city = airport.city_name || "Other"
      group = if city_counts[city] > 1, do: city, else: nil

      %{
        id: airport.iata_code,
        label: "#{airport.name} (#{airport.iata_code})",
        group: group
      }
    end)
  end


  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Combobox</h1>
        <h2>Server-side Fetch</h2>
      </div>

      <h3>Airport Search</h3>
      <.combobox
        id="airport-combobox"
        class="combobox"
        placeholder="Search airports..."
        collection={@airports}
        on_input_value_change="search_airports"
      >
        <:empty>No results</:empty>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
        <.icon name="hero-backspace" />
      </:clear_trigger>
      </.combobox>
    </Layouts.app>
    """
  end
end
