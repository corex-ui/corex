defmodule E2eWeb.AngleSliderPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      read_only: false,
      invalid: false,
      dir: "ltr",
      orientation: "vertical",
      step: 1,
      show_markers: true,
      value_text_as: "degree"
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:angle, 90)

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"checked" => checked, "id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, checked)}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"value" => [value], "id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, value)}
  end

  @impl true
  def handle_event("step_changed", %{"value" => value}, socket) do
    step =
      case Float.parse(to_string(value)) do
        {num, _} when num < 0.1 -> 0.1
        {num, _} when num > 90.0 -> 90.0
        {num, _} -> num
        :error -> socket.assigns.controls.step
      end

    {:noreply, update(socket, :controls, &Map.put(&1, :step, step))}
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

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, "orientation", value) do
    update(socket, :controls, &%{&1 | orientation: value})
  end

  defp update_control(socket, "value_text_as", value) do
    update(socket, :controls, &%{&1 | value_text_as: value})
  end

  defp update_control(socket, _unknown, _checked), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground title="Angle Slider · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label="Vertical orientation">
              <.heroicon name="hero-arrows-up-down" class="icon icon--lg" />
            </:item>
            <:item value="horizontal" aria_label="Horizontal orientation">
              <.heroicon name="hero-arrows-right-left" class="icon icon--lg" />
            </:item>
          </.toggle_group>

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
            <:label>Show Markers</:label>
          </.switch>

          <.number_input
            id="angle-slider-step"
            class="number-input number-input--sm w-4xs"
            value={to_string(@controls.step)}
            step={0.5}
            min={0.5}
            max={90.0}
            on_value_change="step_changed"
          >
            <:label>Step</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>

          <.select
            id="value_text_as"
            class="select select--accent w-4xs"
            value={[@controls.value_text_as]}
            deselectable={false}
            items={[
              %{id: "degree", label: "Degree"},
              %{id: "raw", label: "Raw"}
            ]}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Value format"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Value as</:label>
          </.select>
        </:controls>
        <:canvas>
          <.angle_slider
            id="my-angle-slider"
            class="angle-slider"
            value_text_as={@controls.value_text_as}
            marker_values={if(@controls.show_markers, do: [0, 90, 180, 270], else: [])}
            value={@angle}
            step={@controls.step}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
            dir={@controls.dir}
            orientation={@controls.orientation}
          >
            <:label>Angle</:label>
          </.angle_slider>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
