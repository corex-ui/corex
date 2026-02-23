defmodule E2eWeb.ColorPickerLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:value, nil)

    {:ok, socket}
  end

  def handle_event("set_open", %{"open" => open} = _params, socket) do
    open? = open in [true, "true"]
    {:noreply, Corex.ColorPicker.set_open(socket, "my-color-picker", open?)}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.ColorPicker.set_value(socket, "my-color-picker", value)}
  end

  def handle_event("on_value_change", %{"id" => _id, "valueAsString" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def handle_event("on_open_change", %{"id" => _id, "open" => _open}, socket) do
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
        <h1>Color Picker</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.ColorPicker.set_open("my-color-picker", true)}
          class="button button--sm"
        >
          Open
        </button>
        <button
          phx-click={Corex.ColorPicker.set_open("my-color-picker", false)}
          class="button button--sm"
        >
          Close
        </button>
        <button
          phx-click={Corex.ColorPicker.set_value("my-color-picker", "#FF0000")}
          class="button button--sm"
        >
          Set Red
        </button>
        <button
          phx-click={Corex.ColorPicker.set_value("my-color-picker", "#1909C0")}
          class="button button--sm"
        >
          Set Blue
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_open" phx-value-open="true" class="button button--sm">
          Open
        </button>
        <button phx-click="set_open" phx-value-open="false" class="button button--sm">
          Close
        </button>
        <button phx-click="set_value" phx-value-value="#FF0000" class="button button--sm">
          Set Red
        </button>
        <button phx-click="set_value" phx-value-value="#00FF00" class="button button--sm">
          Set Green
        </button>
      </div>
      <div :if={@value != nil} class="layout__row">
        <p>
          Current value: <code>{@value}</code>
        </p>
      </div>
      <.color_picker
        id="my-color-picker"
        default_value="rgb(25, 9, 192, 0.9)"
        label="Select Color (RGBA)"
        presets={["#FF0000", "#00FF00", "#0000FF", "rgb(25, 9, 192, 0.9)"]}
        class="color-picker"
        on_value_change="on_value_change"
        on_open_change="on_open_change"
      />
    </Layouts.app>
    """
  end
end
