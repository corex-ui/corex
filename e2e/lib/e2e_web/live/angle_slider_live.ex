defmodule E2eWeb.AngleSliderLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:angle_value, nil)
      |> assign(:angle_value_as_degree, nil)
      |> assign(:angle_dragging, nil)

    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    angle =
      case Float.parse(value) do
        {num, _} -> num
        :error -> 0
      end

    {:noreply, Corex.AngleSlider.set_value(socket, "my-angle-slider", angle)}
  end

  def handle_event("get_value", _params, socket) do
    {:noreply, push_event(socket, "angle_slider_value", %{})}
  end

  def handle_event("angle_slider_value_response", %{"value" => value} = params, socket) do
    socket =
      socket
      |> assign(:angle_value, value)
      |> assign(:angle_value_as_degree, params["valueAsDegree"])
      |> assign(:angle_dragging, params["dragging"])

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Angle Slider</h1>
        <h2>Live View</h2>
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
        <button phx-click="get_value" class="button button--sm">
          Get current value
        </button>
      </div>
      <div :if={@angle_value != nil || @angle_value_as_degree != nil} class="layout__row">
        <p :if={@angle_value != nil}>
          Current value: <code>{@angle_value}</code>
        </p>
        <p :if={@angle_value_as_degree != nil}>
          Value as degree: <code>{@angle_value_as_degree}</code>
        </p>
        <p :if={@angle_dragging != nil}>
          Dragging: <code>{inspect(@angle_dragging)}</code>
        </p>
      </div>
      <.angle_slider id="my-angle-slider" class="angle-slider" marker_values={[0, 90, 180, 270]}>
        <:label>Angle</:label>
      </.angle_slider>
    </Layouts.app>
    """
  end
end
