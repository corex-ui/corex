defmodule E2eWeb.NumberInputPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  defp default_controls do
    %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr",
      min: 0.0,
      max: 100.0,
      step: 0.1
    }
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = Map.merge(default_controls(), socket.assigns[:controls] || %{})

    {:ok, assign(socket, :controls, controls)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  def handle_event("min_changed", %{"value" => value}, socket) do
    {:noreply, update(socket, :controls, &Map.put(&1, :min, parse_float(value, &1.min)))}
  end

  def handle_event("max_changed", %{"value" => value}, socket) do
    {:noreply, update(socket, :controls, &Map.put(&1, :max, parse_float(value, &1.max)))}
  end

  def handle_event("step_changed", %{"value" => value}, socket) do
    step = parse_float(value, socket.assigns.controls.step)
    step = if step <= 0, do: 0.1, else: step
    {:noreply, update(socket, :controls, &Map.put(&1, :step, step))}
  end

  defp parse_float(value, fallback) do
    case Float.parse(to_string(value)) do
      {num, _} -> num
      :error -> fallback
    end
  end

  defp update_control(socket, "disabled", true),
    do: update(socket, :controls, &%{&1 | disabled: true})

  defp update_control(socket, "disabled", false),
    do: update(socket, :controls, &Map.put(&1, :disabled, false))

  defp update_control(socket, "invalid", v),
    do: update(socket, :controls, &Map.put(&1, :invalid, v))

  defp update_control(socket, "read_only", v),
    do: update(socket, :controls, &Map.put(&1, :read_only, v))

  defp update_control(socket, "dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, _, _), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground path={@path} title="Number Input · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.number_input
            id="number-input-min"
            class="number-input ui-size-sm max-w-3xs"
            value={to_string(@controls.min)}
            step={0.1}
            on_value_change="min_changed"
          >
            <:label>Min</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>

          <.number_input
            id="number-input-max"
            class="number-input ui-size-sm max-w-3xs"
            value={to_string(@controls.max)}
            step={0.1}
            on_value_change="max_changed"
          >
            <:label>Max</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>

          <.number_input
            id="number-input-step"
            class="number-input ui-size-sm max-w-3xs"
            value={to_string(@controls.step)}
            step={0.1}
            min={0.1}
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

          <.switch
            class="switch ui-size-sm"
            id="disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
          <.switch
            class="switch ui-size-sm"
            id="read_only"
            checked={@controls.read_only}
            on_checked_change="control_changed"
          >
            <:label>Read only</:label>
          </.switch>
          <.switch
            class="switch ui-size-sm"
            id="invalid"
            checked={@controls.invalid}
            on_checked_change="control_changed"
          >
            <:label>Invalid</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.number_input
            id="number-input-playground"
            class="number-input max-w-2xs"
            value="12.5"
            min={@controls.min}
            max={@controls.max}
            step={@controls.step}
            dir={@controls.dir}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
          >
            <:label>Quantity</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
