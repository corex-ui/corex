defmodule E2eWeb.PinInputPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{disabled: false, invalid: false, read_only: false}

    {:ok, assign(socket, :controls, controls)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  defp update_control(socket, "disabled", true),
    do: update(socket, :controls, &%{&1 | disabled: true})

  defp update_control(socket, "disabled", false),
    do: update(socket, :controls, &Map.put(&1, :disabled, false))

  defp update_control(socket, "invalid", v),
    do: update(socket, :controls, &Map.put(&1, :invalid, v))

  defp update_control(socket, "read_only", v),
    do: update(socket, :controls, &Map.put(&1, :read_only, v))

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
      <.demo_playground path={@path} title="Pin Input · Playground" heading_class="layout-heading">
        <:controls>
          <.switch
            size="sm"
            id="disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
          <.switch
            size="sm"
            id="read_only"
            checked={@controls.read_only}
            on_checked_change="control_changed"
          >
            <:label>Read only</:label>
          </.switch>
          <.switch
            size="sm"
            id="invalid"
            checked={@controls.invalid}
            on_checked_change="control_changed"
          >
            <:label>Invalid</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.pin_input
            id="pin-input-playground"
            count={4}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
          >
            <:label>Code</:label>
          </.pin_input>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
