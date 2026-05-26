defmodule E2eWeb.ColorPickerPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr"
    }

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:value, "#3b82f6")}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  def handle_event("play_value", %{"id" => _, "valueAsString" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
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
      <.demo_playground path={@path} title="Color Picker · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />
          <.switch
            class="switch switch--sm"
            id="disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
          <.switch
            class="switch switch--sm"
            id="read_only"
            checked={@controls.read_only}
            on_checked_change="control_changed"
          >
            <:label>Read only</:label>
          </.switch>
          <.switch
            class="switch switch--sm"
            id="invalid"
            checked={@controls.invalid}
            on_checked_change="control_changed"
          >
            <:label>Invalid</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.color_picker
            id="color-picker-playground"
            class="color-picker"
            label="Pick a color"
            presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
            value={@value}
            dir={@controls.dir}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
            on_value_change="play_value"
          />
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
