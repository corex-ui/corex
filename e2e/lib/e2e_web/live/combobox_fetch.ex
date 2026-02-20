defmodule E2eWeb.ComboboxFetch do
  use E2eWeb, :live_view

  @items [
    %{id: "fra", label: "France"},
    %{id: "deu", label: "Germany"},
    %{id: "gbr", label: "United Kingdom"},
    %{id: "esp", label: "Spain"},
    %{id: "ita", label: "Italy"},
    %{id: "bel", label: "Belgium"},
    %{id: "nld", label: "Netherlands"},
    %{id: "che", label: "Switzerland"},
    %{id: "aut", label: "Austria"},
    %{id: "jpn", label: "Japan"},
    %{id: "chn", label: "China"},
    %{id: "kor", label: "South Korea"},
    %{id: "tha", label: "Thailand"},
    %{id: "usa", label: "USA"},
    %{id: "can", label: "Canada"},
    %{id: "mex", label: "Mexico"},
    %{id: "aus", label: "Australia"},
    %{id: "nzl", label: "New Zealand"},
    %{id: "are", label: "UAE"},
    %{id: "tur", label: "Turkey"}
  ]

  @popular [
    %{id: "fra", label: "France", group: "Popular in Europe"},
    %{id: "deu", label: "Germany", group: "Popular in Europe"},
    %{id: "jpn", label: "Japan", group: "Popular in Asia"},
    %{id: "chn", label: "China", group: "Popular in Asia"},
    %{id: "usa", label: "USA", group: "Popular in North America"},
    %{id: "can", label: "Canada", group: "Popular in North America"},
    %{id: "aus", label: "Australia", group: "Popular in Oceania"},
    %{id: "nzl", label: "New Zealand", group: "Popular in Oceania"},
    %{id: "are", label: "UAE", group: "Popular in Middle East"},
    %{id: "tur", label: "Turkey", group: "Popular in Middle East"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:items, @popular)
     |> assign(:search_term, nil)}
  end

  def handle_event("search", %{"reason" => "clear-trigger"}, socket) do
    {:noreply,
     socket
     |> assign(:items, @popular)
     |> assign(:search_term, nil)}
  end

  def handle_event("search", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search", %{"value" => value, "reason" => "input-change"}, socket)
      when byte_size(value) < 1 do
    {:noreply,
     socket
     |> assign(:items, @popular)
     |> assign(:search_term, nil)}
  end

  def handle_event("search", %{"value" => value, "reason" => "input-change"}, socket) do
    term = String.downcase(value)

    filtered =
      @items
      |> Enum.filter(fn item ->
        String.contains?(String.downcase(item.label), term)
      end)

    {:noreply,
     socket
     |> assign(:items, filtered)
     |> assign(:search_term, value)}
  end

  def handle_event("search", _params, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Combobox</h1>
        <h2>Server-side Filtering</h2>
      </div>

      <.header>
        Server-side filtering
        <:subtitle>
          Use on_input_value_change to filter on the server. Useful for large item lists.
          <p>Can be used with a database query to filter the items or a local list.</p>
        </:subtitle>
      </.header>

      <.combobox
        id="country-combobox"
        class="combobox"
        placeholder="Search countries..."
        collection={@items}
        filter={false}
        on_input_value_change="search"
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
