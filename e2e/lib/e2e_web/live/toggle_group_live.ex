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
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Toggle Group</h1>
        <h2>Live View</h2>
      </div>
      <div class="layout__row">
        <button
          phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["lorem"])}
          class="button button--sm"
        >
          Set Lorem
        </button>
        <button
          phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["lorem", "donec"])}
          class="button button--sm"
        >
          Set Lorem and Donec
        </button>
        <button
          phx-click={Corex.ToggleGroup.set_value("my-toggle-group", [])}
          class="button button--sm"
        >
          Set no items
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="lorem" class="button button--sm">
          Set Lorem
        </button>
        <button
          phx-click="set_value"
          value="lorem,donec"
          class="button button--sm"
        >
          Set Lorem and Donec
        </button>
        <button phx-click="set_value" value={nil} class="button button--sm">
          Set no items
        </button>
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
