defmodule E2eWeb.ToggleGroupLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "my-toggle-group", String.split(value, ","))}
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
        <:title>Toggle Group</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>

      <h3>Client Api</h3>
      <div class="layout__row">
        <.action
          phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["lorem"])}
          class="button button--sm"
        >
          Set Lorem
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["lorem", "donec"])}
          class="button button--sm"
        >
          Set Lorem and Donec
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("my-toggle-group", [])}
          class="button button--sm"
        >
          Set no items
        </.action>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <.action phx-click="set_value" value="lorem" class="button button--sm">
          Set Lorem
        </.action>
        <.action
          phx-click="set_value"
          value="lorem,donec"
          class="button button--sm"
        >
          Set Lorem and Donec
        </.action>
        <.action phx-click="set_value" class="button button--sm">
          Set no items
        </.action>
      </div>
      <.toggle_group id="my-toggle-group" class="toggle-group">
        <:item value="lorem">
          Lorem
        </:item>

        <:item value="duis">
          Duis
        </:item>
        <:item value="donec">
          Donec
        </:item>
      </.toggle_group>
    </Layouts.app>
    """
  end
end
