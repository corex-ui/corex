defmodule E2eWeb.PasswordInputPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{disabled: false, invalid: false, read_only: false, dir: "ltr"}

    {:ok, assign(socket, :controls, controls)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value | _], "id" => "dir"}, socket)
      when is_binary(value) do
    {:noreply, update(socket, :controls, &Map.put(&1, :dir, value))}
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
      <.demo_playground
        path={@path}
        title="Password Input · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

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
          <.password_input
            id="password-input-playground"
            name="user[password]"
            dir={@controls.dir}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
          >
            <:label>Password</:label>
            <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
            <:hidden_indicator>
              <.heroicon name="hero-eye-slash" />
            </:hidden_indicator>
          </.password_input>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
