defmodule E2eWeb.ComboboxPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @combobox_id "combobox-playground"

  @countries [
    %{label: "France", value: "fra"},
    %{label: "Belgium", value: "bel"},
    %{label: "Germany", value: "deu"},
    %{label: "Netherlands", value: "nld"},
    %{label: "Switzerland", value: "che"},
    %{label: "Austria", value: "aut"}
  ]

  @disabled_select_items Enum.map(@countries, &%{label: &1.label, value: &1.value})

  defp playground_items(controls) do
    disabled = Map.get(controls, :disabled_item_ids, [])

    Corex.List.new(
      Enum.map(@countries, fn c ->
        if c.value in disabled, do: Map.put(c, :disabled, true), else: c
      end)
    )
  end

  defp normalize_play_value(controls, play_value) do
    disabled = Map.get(controls, :disabled_item_ids, [])
    Enum.filter(List.wrap(play_value), &(&1 not in disabled))
  end

  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr",
      orientation: "vertical",
      close_on_select: true,
      disabled_item_ids: []
    }

    {:ok,
     socket
     |> assign(:combobox_id, @combobox_id)
     |> assign(:controls, controls)
     |> assign(:disabled_select_items, @disabled_select_items)
     |> assign(:items, playground_items(controls))
     |> assign(:play_value, [])
     |> assign(:play_patch_rev, 0)}
  end

  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, control_bool(checked))}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply, apply_disabled_items(socket, value)}
  end

  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply, apply_disabled_items(socket, [])}
  end

  def handle_event("combobox_play_value_changed", %{"value" => value}, socket)
      when is_list(value) do
    {:noreply,
     socket
     |> assign(:play_value, value)
     |> assign(:play_patch_rev, socket.assigns.play_patch_rev + 1)}
  end

  def handle_event("combobox_play_value_changed", %{"value" => value}, socket) do
    {:noreply,
     socket
     |> assign(:play_value, List.wrap(value))
     |> assign(:play_patch_rev, socket.assigns.play_patch_rev + 1)}
  end

  defp apply_disabled_items(socket, value) do
    socket
    |> update(:controls, &%{&1 | disabled_item_ids: value})
    |> sync_items()
  end

  defp sync_items(socket) do
    controls = socket.assigns.controls
    available_ids = Enum.map(@countries, & &1.value)
    filtered = Enum.filter(controls.disabled_item_ids, &(&1 in available_ids))
    controls = %{controls | disabled_item_ids: filtered}
    old_play = socket.assigns.play_value
    play_value = normalize_play_value(controls, old_play)

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:items, playground_items(controls))
      |> assign(:play_value, play_value)

    if play_value != old_play do
      Corex.Combobox.set_value(socket, @combobox_id, play_value)
    else
      socket
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

  defp update_control(socket, "dir", v),
    do: update(socket, :controls, &Map.put(&1, :dir, v))

  defp update_control(socket, "orientation", v),
    do: update(socket, :controls, &Map.put(&1, :orientation, v))

  defp update_control(socket, "close_on_select", v),
    do: update(socket, :controls, &Map.put(&1, :close_on_select, v))

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
      <.demo_playground path={@path} title={~t"Combobox · Playground"} heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--size-sm toggle--max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label={~t"Vertical orientation"}>
              <.heroicon name="hero-arrows-up-down" />
            </:item>
            <:item value="horizontal" aria_label={~t"Horizontal orientation"}>
              <.heroicon name="hero-arrows-right-left" />
            </:item>
          </.toggle_group>

          <.select
            id="combobox-playground-disabled-items"
            size="sm"
            class="w-4xs"
            positioning={%Corex.Positioning{same_width: true}}
            multiple
            deselectable={true}
            close_on_select={false}
            value={@controls.disabled_item_ids}
            items={@disabled_select_items}
            on_value_change="disabled_items_changed"
            translation={%Corex.Select.Translation{placeholder: "Disabled items"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled items</:label>
          </.select>

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
          <.switch
            class="switch switch--size-sm"
            id="close_on_select"
            checked={@controls.close_on_select}
            on_checked_change="control_changed"
          >
            <:label>Close on select</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.combobox
            id={@combobox_id}
            translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
            items={@items}
            value={@play_value}
            close_on_select={@controls.close_on_select}
            on_value_change="combobox_play_value_changed"
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
            dir={@controls.dir}
            orientation={@controls.orientation}
          >
            <:label>Playground</:label>
            <:empty>No results</:empty>
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
            <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
          </.combobox>
          <p id="combobox-playground-patch-rev" data-rev={@play_patch_rev} hidden aria-hidden="true">
          </p>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
