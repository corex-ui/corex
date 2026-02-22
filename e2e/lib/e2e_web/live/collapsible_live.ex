defmodule E2eWeb.CollapsibleLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_open", %{"value" => "true"}, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "my-collapsible", true)}
  end

  def handle_event("set_open", %{"value" => "false"}, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "my-collapsible", false)}
  end

  def handle_event("open_change", %{"id" => _id, "open" => _open}, socket) do
    {:noreply, socket}
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
      <div class="layout__row">
        <h1>Collapsible</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Collapsible.set_open("my-collapsible", true)}
          class="button button--sm"
        >
          Open
        </button>
        <button
          phx-click={Corex.Collapsible.set_open("my-collapsible", false)}
          class="button button--sm"
        >
          Close
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_open" value="true" class="button button--sm">
          Open
        </button>
        <button phx-click="set_open" value="false" class="button button--sm">
          Close
        </button>
      </div>
      <.collapsible
        id="my-collapsible"
        on_open_change="open_change"
        class="collapsible"
      >
        <:trigger>Toggle Content</:trigger>
        <:content>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
        </:content>
      </.collapsible>
    </Layouts.app>
    """
  end
end
