defmodule E2eWeb.ComboboxForm do
  use E2eWeb, :live_view

  alias Corex.Toast
  alias E2e.Form.Combobox
  alias E2e.Place

  @max_items 60

  @impl true
  def mount(_params, _session, socket) do
    combobox = %Combobox{}
    raw = Place.list_popular_airports_by_continent()

    {:ok,
     socket
     |> assign(:combobox, combobox)
     |> assign(:form, to_form(Combobox.change_combobox(combobox), as: :combobox))
     |> assign(:airports, format_popular_airports(raw))
     |> assign(:raw_airports, Enum.map(raw, fn {a, _} -> a end))
     |> assign(:search_term, nil)
     |> assign(:value, [])}
  end

  @impl true
  def handle_event("validate", %{"combobox" => params}, socket) do
    airport =
      case socket.assigns[:value] do
        v when is_list(v) and v != [] -> List.first(v)
        _ -> params["airport"] || ""
      end

    params = Map.put(params, "airport", airport)

    changeset =
      socket.assigns.combobox
      |> Combobox.change_combobox(params)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset, as: :combobox))
     |> assign(:combobox, Ecto.Changeset.apply_changes(changeset))}
  end

  @impl true
  def handle_event("save", %{"combobox" => params}, socket) do
    case Combobox.change_combobox(socket.assigns.combobox, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        combobox = Ecto.Changeset.apply_changes(changeset)
        params = %{"name" => combobox.name, "airport" => combobox.airport}
        saved_form = to_form(Combobox.change_combobox(combobox, params), as: :combobox)

        {:noreply,
         socket
         |> Toast.push_toast(
           "Saved",
           "Name: #{combobox.name}, Airport: #{combobox.airport}",
           :success
         )
         |> assign(:combobox, combobox)
         |> assign(:form, saved_form)
         |> assign(:value, if(combobox.airport != "", do: [combobox.airport], else: []))}

      %Ecto.Changeset{} = changeset ->
        changeset = Map.put(changeset, :action, :validate)
        {:noreply, assign(socket, form: to_form(changeset, as: :combobox))}
    end
  end

  def handle_event("search_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports", %{"reason" => "clear-trigger"}, socket) do
    raw = Place.list_popular_airports_by_continent()

    {:noreply,
     socket
     |> assign(:airports, format_popular_airports(raw))
     |> assign(:raw_airports, Enum.map(raw, fn {a, _} -> a end))
     |> assign(:search_term, nil)
     |> assign(:value, [])}
  end

  def handle_event("search_airports", %{"value" => value, "reason" => "input-change"}, socket)
      when byte_size(value) < 1 do
    raw = Place.list_popular_airports_by_continent()

    {:noreply,
     socket
     |> assign(:airports, format_popular_airports(raw))
     |> assign(:raw_airports, Enum.map(raw, fn {a, _} -> a end))
     |> assign(:search_term, nil)}
  end

  def handle_event("search_airports", %{"value" => value, "reason" => "input-change"}, socket) do
    raw = Place.search_airports(value, @max_items, 0)

    {:noreply,
     socket
     |> assign(:airports, format_airports(raw))
     |> assign(:raw_airports, raw)
     |> assign(:search_term, value)}
  end

  def handle_event("search_airports", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("airport_selected", %{"value" => value}, socket) do
    {:noreply,
     socket
     |> assign(:value, value)}
  end

  defp format_popular_airports(airports_with_continent) do
    Enum.map(airports_with_continent, fn {airport, continent} ->
      %{
        id: airport.iata_code,
        label: "#{airport.name} (#{airport.iata_code})",
        group: continent
      }
    end)
  end

  defp format_airports(airports) do
    sorted =
      Enum.sort_by(airports, fn a ->
        {a.city_name || "Other", a.name}
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

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Combobox</h1>
        <h2>Form with validation</h2>
      </div>

      <.header>
        Combobox form
        <:subtitle>Phoenix form with Ecto validation, database fetching and server side fitlering combobox.</:subtitle>
      </.header>

      <.form
        for={@form}
        id={get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
        class="flex flex-col gap-4 max-w-md"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <.combobox
          field={@form[:airport]}
          id="airport-combobox"
          class="combobox"
          placeholder="Search airports..."
          collection={@airports}
          filter={false}
          on_input_value_change="search_airports"
        >
          <:label>Airport</:label>
          <:empty>No results</:empty>
          <:trigger>
            <.icon name="hero-chevron-down" />
          </:trigger>
          <:clear_trigger>
            <.icon name="hero-backspace" />
          </:clear_trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.combobox>

        <.button type="submit" class="button button--accent">
          Save
        </.button>
      </.form>
    </Layouts.app>
    """
  end
end
