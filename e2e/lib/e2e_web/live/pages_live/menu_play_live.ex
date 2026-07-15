defmodule E2eWeb.MenuPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @playground_item_options [
    %{label: "Listbox", value: "listbox"},
    %{label: "Corex", value: "corex"},
    %{label: "Tabs", value: "tabs"},
    %{label: "Combobox (nested)", value: "combobox"},
    %{label: "Date picker (nested)", value: "date-picker"},
    %{label: "Menu (nested)", value: "menu"},
    %{label: "Dialog (nested)", value: "dialog"}
  ]

  defp playground_items(controls) do
    disabled_ids = Map.get(controls, :disabled_item_ids, [])

    [
      playground_item("listbox", "Listbox", disabled_ids),
      %Corex.Tree.Item{
        value: "corex",
        label: "Corex",
        disabled: "corex" in disabled_ids,
        children:
          Enum.map(E2eWeb.Demos.MenuDemo.demo_nested_flat_children(), fn child ->
            %{child | disabled: child.value in disabled_ids}
          end)
      },
      playground_item("tabs", ~t"Tabs", disabled_ids)
    ]
  end

  defp playground_item(value, label, disabled_ids) do
    %Corex.Tree.Item{
      value: value,
      label: label,
      disabled: value in disabled_ids
    }
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      dir: "ltr",
      close_on_select: false,
      loop_focus: false,
      disabled: false,
      disabled_item_ids: []
    }

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:disabled_item_options, @playground_item_options)
     |> assign(:items, playground_items(controls))
     |> assign(:selected, nil)}
  end

  @impl true
  def handle_event("menu_play_selected", %{"value" => value}, socket) do
    {:noreply, assign(socket, :selected, value)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = control_bool(raw)
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_item_ids: value})
     |> sync_items()}
  end

  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_item_ids: []})
     |> sync_items()}
  end

  defp sync_items(socket) do
    assign(socket, :items, playground_items(socket.assigns.controls))
  end

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  defp update_control(socket, "dir", value), do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "close_on_select", checked),
    do: update(socket, :controls, &%{&1 | close_on_select: checked})

  defp update_control(socket, "loop_focus", checked),
    do: update(socket, :controls, &%{&1 | loop_focus: checked})

  defp update_control(socket, "menu-playground-disabled", true),
    do: update(socket, :controls, &%{&1 | disabled: true})

  defp update_control(socket, "menu-playground-disabled", false),
    do: update(socket, :controls, &Map.put(&1, :disabled, false))

  defp update_control(socket, _unknown, _value), do: socket

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
        id="menu-playground-page"
        title="Menu · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.select
            id="menu-playground-disabled-items"
            class="select ui-size-sm w-4xs"
            positioning={%Corex.Positioning{same_width: true}}
            multiple
            deselectable={true}
            close_on_select={false}
            value={@controls.disabled_item_ids}
            items={@disabled_item_options}
            on_value_change="disabled_items_changed"
            translation={%Corex.Select.Translation{placeholder: "Disabled items"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled items</:label>
          </.select>

          <.switch
            class="switch ui-size-sm"
            id="menu-playground-disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>

          <.switch
            class="switch ui-size-sm"
            id="close_on_select"
            checked={@controls.close_on_select}
            on_checked_change="control_changed"
          >
            <:label>Close on select</:label>
          </.switch>

          <.switch
            class="switch ui-size-sm"
            id="loop_focus"
            checked={@controls.loop_focus}
            on_checked_change="control_changed"
          >
            <:label>Loop focus</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.menu
            id="menu-playground"
            class="menu"
            dir={@controls.dir}
            close_on_select={@controls.close_on_select}
            loop_focus={@controls.loop_focus}
            disabled={@controls.disabled}
            on_select="menu_play_selected"
            items={@items}
          >
            <:trigger>Corex</:trigger>
            <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
            <:nested_indicator><.heroicon name="hero-chevron-right" /></:nested_indicator>
            <:item :let={item}>
              {item.label}
              <.heroicon :if={@selected == item.value} name="hero-check" class="icon" />
            </:item>
          </.menu>
          <p id="menu-playground-selected" data-value={@selected} hidden aria-hidden="true"></p>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
