defmodule E2eWeb.EditablePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{disabled: false, invalid: false, read_only: false, dir: "ltr"}

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:play_value, "My custom value")}
  end

  @impl true
  def handle_event("editable_play_value_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :play_value, to_string(value))}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, control_bool(checked))}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  defp update_control(socket, "disabled", true),
    do: update(socket, :controls, &%{&1 | disabled: true})

  defp update_control(socket, "disabled", false),
    do: update(socket, :controls, &Map.put(&1, :disabled, false))

  defp update_control(socket, "invalid", v),
    do: update(socket, :controls, &Map.put(&1, :invalid, v))

  defp update_control(socket, "read_only", v),
    do: update(socket, :controls, &Map.put(&1, :read_only, v))

  defp update_control(socket, "dir", v),
    do: update(socket, :controls, &Map.put(&1, :dir, v))

  defp update_control(socket, _, _), do: socket

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground title="Editable · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

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
            <:label>Read only</:label>
          </.switch>
          <.switch
            class="switch"
            id="invalid"
            checked={@controls.invalid}
            on_checked_change="control_changed"
          >
            <:label>Invalid</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.editable
            id="editable-playground"
            class="editable"
            value={@play_value}
            on_value_change="editable_play_value_changed"
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
            dir={@controls.dir}
          >
            <:label>Name</:label>
            <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
            <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
            <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
          </.editable>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
