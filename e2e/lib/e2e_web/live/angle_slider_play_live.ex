defmodule E2eWeb.AngleSliderPlayLive do
  use E2eWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: true,
      read_only: true,
      invalid: true,
      step: 1,
      show_markers: true
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:angle, 90)

    {:ok, socket}
  end

  @impl true
  def handle_event("angle_changed", %{"value" => value}, socket) do
    parsed_value =
      case Float.parse(to_string(value)) do
        {num, _} -> if num > 360, do: 360, else: if(num < 0, do: 0, else: num)
        :error -> 0
      end

    {:noreply, assign(socket, :angle, parsed_value)}
  end

  def handle_event(
        "control_changed",
        %{"checked" => checked, "id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event(
        "control_changed",
        %{"value" => [value], "id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, value)}
  end

  defp update_control(socket, "disabled", true) do
    update(socket, :controls, &%{&1 | disabled: true})
  end

  defp update_control(socket, "disabled", false) do
    update(socket, :controls, &Map.put(&1, :disabled, false))
  end

  defp update_control(socket, "read_only", true) do
    update(socket, :controls, &%{&1 | read_only: true})
  end

  defp update_control(socket, "read_only", false) do
    update(socket, :controls, &Map.put(&1, :read_only, false))
  end

  defp update_control(socket, "invalid", checked) do
    update(socket, :controls, &Map.put(&1, :invalid, checked))
  end

  defp update_control(socket, "show_markers", checked) do
    update(socket, :controls, &Map.put(&1, :show_markers, checked))
  end

  defp update_control(socket, "step", value) do
    step =
      case value do
        "0.5" -> 0.5
        "1" -> 1
        "5" -> 5
        "15" -> 15
        "45" -> 45
        "90" -> 90
        _ -> 1
      end

    update(socket, :controls, &Map.put(&1, :step, step))
  end

  defp update_control(socket, _unknown, _checked), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Angle Slider</h1>
        <h2>Playground</h2>
      </div>

      <div class="flex flex-col gap-ui-gap">
        <.switch
          class="switch"
          id="disabled"

          checked={@controls.disabled}
          on_checked_change="control_changed"
        >
          <:label>Disabled</:label>
        </.switch>

        <.switch
          class="switch"
          id="read_only"
          checked={@controls.read_only}
          on_checked_change="control_changed"
        >
          <:label>Read Only</:label>
        </.switch>

        <.switch
          class="switch"
          id="invalid"
          checked={@controls.invalid}
          on_checked_change="control_changed"
        >
          <:label>Invalid</:label>
        </.switch>

        <.switch
          class="switch"
          id="show_markers"

          checked={@controls.show_markers}
          on_checked_change="control_changed"
        >
          <:label>Show Markers (0°, 90°, 180°, 270°)</:label>
        </.switch>

        <.toggle_group
          class="toggle-group"
          id="step"
          on_value_change="control_changed"
          multiple={false}
          deselectable={false}
          value={[to_string(@controls.step)]}
        >
          <:item value="0.5">0.5</:item>
          <:item value="1">1</:item>
          <:item value="5">5</:item>
          <:item value="15">15</:item>
          <:item value="45">45</:item>
          <:item value="90">90</:item>
        </.toggle_group>
      </div>

      <p class="layout__row">
        Current value: <code>{@angle}</code>°
      </p>

      <.angle_slider
        id="my-angle-slider"
        class="angle-slider"
        marker_values={if(@controls.show_markers, do: [0, 90, 180, 270], else: [])}
        value={@angle}
        step={@controls.step}
        disabled={@controls.disabled}
        read_only={@controls.read_only}
        invalid={@controls.invalid}

        on_value_change="angle_changed"
      >
        <:label>Angle</:label>
      </.angle_slider>
    </Layouts.app>
    """
  end
end
