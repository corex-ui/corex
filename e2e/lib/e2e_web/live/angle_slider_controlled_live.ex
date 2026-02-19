defmodule E2eWeb.AngleSliderControlledLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:angle, 90)

    {:ok, socket}
  end

  def handle_event("angle_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :angle, value)}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    angle =
      case Float.parse(value) do
        {num, _} -> num
        :error -> 0
      end

    socket = assign(socket, :angle, angle)
    {:noreply, Corex.AngleSlider.set_value(socket, "my-angle-slider", angle)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Angle Slider</h1>
        <h2>Controlled</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.AngleSlider.set_value("my-angle-slider", 0)}
          class="button button--sm"
        >
          Set to 0°
        </button>
        <button
          phx-click={Corex.AngleSlider.set_value("my-angle-slider", 90)}
          class="button button--sm"
        >
          Set to 90°
        </button>
        <button
          phx-click={Corex.AngleSlider.set_value("my-angle-slider", 180)}
          class="button button--sm"
        >
          Set to 180°
        </button>
        <button
          phx-click={Corex.AngleSlider.set_value("my-angle-slider", 270)}
          class="button button--sm"
        >
          Set to 270°
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="0" class="button button--sm">
          Set to 0°
        </button>
        <button phx-click="set_value" value="90" class="button button--sm">
          Set to 90°
        </button>
        <button phx-click="set_value" value="180" class="button button--sm">
          Set to 180°
        </button>
        <button phx-click="set_value" value="270" class="button button--sm">
          Set to 270°
        </button>
      </div>
      <p class="layout__row">
        Current value: <code>{@angle}</code>°
      </p>
      <.angle_slider
        id="my-angle-slider"
        class="angle-slider"
        marker_values={[0, 90, 180, 270]}
        value={@angle}
        on_value_change="angle_changed"
      >
        <:label>Angle</:label>
      </.angle_slider>
    </Layouts.app>
    """
  end
end
