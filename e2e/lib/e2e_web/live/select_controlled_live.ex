defmodule E2eWeb.SelectControlledLive do
  use E2eWeb, :live_view

  @items [
    %{label: "France", id: "fra"},
    %{label: "Belgium", id: "bel"},
    %{label: "Germany", id: "deu"},
    %{label: "Netherlands", id: "nld"},
    %{label: "Switzerland", id: "che"},
    %{label: "Austria", id: "aut"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:value, [])
     |> assign(:items, @items)}
  end

  def handle_event("value_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply, assign(socket, :value, value)}
  end

  def handle_event("value_changed", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    new_value = if value == "", do: [], else: [value]
    {:noreply, assign(socket, :value, new_value)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Select</:title>
        <:subtitle>Controlled Live View</:subtitle>
      </.layout_heading>

      <h3>Controlled State: {inspect(@value)}</h3>

      <div class="layout__row">
        <.action phx-click={JS.push("set_value", value: %{value: "fra"})} class="button button--sm">
          Set to France
        </.action>
        <.action phx-click={JS.push("set_value", value: %{value: "deu"})} class="button button--sm">
          Set to Germany
        </.action>
        <.action phx-click={JS.push("set_value", value: %{value: ""})} class="button button--sm">
          Clear
        </.action>
      </div>

      <div class="mt-4">
        <.select
          id="controlled-select"
          class="select"
          controlled
          value={@value}
          items={@items}
          on_value_change="value_changed"
          translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        >
          <:label>Country</:label>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
        </.select>
      </div>
    </Layouts.app>
    """
  end
end
