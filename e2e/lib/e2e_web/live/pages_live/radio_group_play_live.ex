defmodule E2eWeb.RadioGroupPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr",
      orientation: "vertical"
    }

    items = [
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:items, items)
     |> assign(:value, "a")}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value | _], "id" => "dir"}, socket)
      when is_binary(value) do
    {:noreply, update(socket, :controls, &Map.put(&1, :dir, value))}
  end

  def handle_event("control_changed", %{"value" => [value | _], "id" => "orientation"}, socket)
      when is_binary(value) do
    {:noreply, update(socket, :controls, &Map.put(&1, :orientation, value))}
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
      <.demo_playground path={@path} title="Radio Group · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm max-w-3xs"
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
          <.radio_group
            id="radio-group-playground"
            name="rg-play"
            class="radio-group"
            items={@items}
            value={@value}
            dir={@controls.dir}
            orientation={@controls.orientation}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
          >
            <:label>Playground</:label>
            <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
          </.radio_group>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
