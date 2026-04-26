defmodule E2eWeb.ComboboxPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @items [
    %{label: "France", id: "fra", disabled: true},
    %{label: "Belgium", id: "bel"},
    %{label: "Germany", id: "deu"},
    %{label: "Netherlands", id: "nld"},
    %{label: "Switzerland", id: "che"},
    %{label: "Austria", id: "aut"}
  ]

  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr",
      orientation: "vertical"
    }

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:items, Corex.List.new(@items))
     |> assign(:play_value, [])}
  end

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

  defp update_control(socket, "orientation", v),
    do: update(socket, :controls, &Map.put(&1, :orientation, v))

  defp update_control(socket, _, _), do: socket

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground title="Combobox · Playground" heading_class="layout-heading">
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
          <.combobox
            id="combobox-playground"
            class="combobox"
            translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
            items={@items}
            value={@play_value}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
            dir={@controls.dir}
            orientation={@controls.orientation}
          >
            <:label>Playground</:label>
            <:empty>No results</:empty>
            <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
            <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
          </.combobox>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
