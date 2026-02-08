defmodule E2eWeb.ClipboardLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Clipboard.set_value(socket, "my-clipboard", value)}
  end

  def handle_event("copy", _params, socket) do
    {:noreply, Corex.Clipboard.copy(socket, "my-clipboard")}
  end

  def handle_event("value_change", %{"id" => _id, "value" => _value}, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode}>
      <div class="layout__row">
        <h1>Clipboard</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Clipboard.set_value("my-clipboard", "Hello, World!")}
          class="button button--sm"
        >
          Set to "Hello, World!"
        </button>
        <button
          phx-click={Corex.Clipboard.set_value("my-clipboard", "info@netoum.com")}
          class="button button--sm"
        >
          Set to "info@netoum.com"
        </button>
        <button
          phx-click={Corex.Clipboard.copy("my-clipboard")}
          class="button button--sm"
        >
          Copy
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="Hello, World!" class="button button--sm">
          Set to "Hello, World!"
        </button>
        <button phx-click="set_value" value="info@netoum.com" class="button button--sm">
          Set to "info@netoum.com"
        </button>
        <button phx-click="copy" class="button button--sm">
          Copy
        </button>
      </div>
      <.clipboard
        id="my-clipboard"
        value="info@netoum.com"
        trigger_aria_label="Copy to clipboard"
        input_aria_label="Value to copy"
        on_value_change="value_change"
        class="clipboard"
      >
        <:label>Contact Netoum</:label>
        <:trigger>
          <.icon name="hero-clipboard" class="icon data-copy" />
          <.icon name="hero-check" class="icon data-copied" />
        </:trigger>
      </.clipboard>
    </Layouts.app>
    """
  end
end
