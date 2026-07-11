defmodule E2eWeb.AccordionPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_playground: 1, playground_dir_toggle: 1]

  alias Corex.Accordion

  @accordion_id "my-accordion"

  defp item_values, do: ~W(lorem duis donec)

  defp accordion_items(controls) do
    disabled = Map.get(controls, :disabled_items, [])
    horizontal? = Map.get(controls, :orientation) == "horizontal"

    {t1, t2, t3} =
      if horizontal? do
        {"Lorem", "Duis", "Donec"}
      else
        {
          "Lorem duis donec sit amet",
          "Duis dictum gravida odio ac pharetra?",
          "Donec condimentum ex mi"
        }
      end

    Corex.Content.new([
      %{
        value: "lorem",
        label: t1,
        content: ~t"Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        disabled: "lorem" in disabled
      },
      %{
        value: "duis",
        label: t2,
        content: ~t"Nullam eget vestibulum ligula, at interdum tellus.",
        disabled: "duis" in disabled
      },
      %{
        value: "donec",
        label: t3,
        content: ~t"Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: "donec" in disabled
      }
    ])
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled_items: [],
      orientation: "vertical",
      collapsible: true,
      multiple: true,
      dir: "ltr"
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:disabled_select_items, disabled_select_items())
      |> assign(:items, accordion_items(controls))

    {:ok, socket}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = control_bool(raw)
    {:noreply, update_control(socket, control_id(id), checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
  end

  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_items: value})
     |> sync_items()}
  end

  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_items: []})
     |> sync_items()}
  end

  defp update_control(socket, "orientation", value) do
    socket
    |> update(:controls, &%{&1 | orientation: value})
    |> sync_items()
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, "collapsible", true) do
    socket
    |> update(:controls, &%{&1 | collapsible: true})
    |> push_playground_accordion_value()
  end

  defp update_control(socket, "collapsible", false) do
    socket
    |> update(:controls, &%{&1 | collapsible: false, multiple: false})
    |> push_playground_accordion_value()
  end

  defp update_control(socket, "multiple", true) do
    socket
    |> update(:controls, &%{&1 | multiple: true, collapsible: true})
    |> push_playground_accordion_value()
  end

  defp update_control(socket, "multiple", false) do
    socket
    |> update(:controls, &%{&1 | multiple: false})
    |> push_playground_accordion_value()
  end

  defp update_control(socket, _unknown, _checked), do: socket

  defp sync_items(socket) do
    assign(socket, :items, accordion_items(socket.assigns.controls))
  end

  defp push_playground_accordion_value(socket) do
    Accordion.set_value(
      socket,
      @accordion_id,
      playground_accordion_reset_value(socket.assigns.controls)
    )
  end

  defp playground_accordion_reset_value(controls) do
    if controls.multiple do
      item_values()
    else
      [hd(item_values())]
    end
  end

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  defp control_id("playground-collapsible-" <> _), do: "collapsible"
  defp control_id(id), do: id

  defp disabled_select_items do
    [
      %{label: ~t"Lorem", value: "lorem"},
      %{label: ~t"Duis", value: "duis"},
      %{label: ~t"Donec", value: "donec"}
    ]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      path={@path}
      mode={@mode}
      theme={@theme}
    >
      <.demo_page
        path={@path}
        id="accordion-play-page"
        title="Accordion · Playground"
      >
        <.demo_playground id="accordion-playground">
          <:controls>
            <.playground_dir_toggle
              id="dir"
              on_value_change="control_changed"
              value={[@controls.dir]}
            />

            <.toggle_group
              class="toggle-group ui-size-sm max-w-3xs"
              id="orientation"
              on_value_change="control_changed"
              multiple={false}
              deselectable={false}
              value={[@controls.orientation]}
            >
              <:item value="vertical" aria_label="Vertical orientation">
                <.heroicon name="hero-arrows-up-down" class="icon ui-size-lg" />
              </:item>
              <:item value="horizontal" aria_label="Horizontal orientation">
                <.heroicon name="hero-arrows-right-left" class="icon ui-size-lg" />
              </:item>
            </.toggle_group>

            <.select
              id="playground-disabled-items"
              class="select ui-size-sm w-4xs"
              multiple
              deselectable={true}
              close_on_select={false}
              value={@controls.disabled_items}
              items={@disabled_select_items}
              on_value_change="disabled_items_changed"
              translation={%Corex.Select.Translation{placeholder: "Select items"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Disabled items</:label>
            </.select>

            <.switch
              class="switch ui-size-sm"
              id={"playground-collapsible-#{@controls.multiple}"}
              checked={@controls.collapsible}
              on_checked_change="control_changed"
            >
              <:label>Collapsible</:label>
            </.switch>

            <.switch
              class="switch ui-size-sm"
              id="multiple"
              checked={@controls.multiple}
              on_checked_change="control_changed"
            >
              <:label>Multiple</:label>
            </.switch>
          </:controls>
          <:canvas>
            <.accordion
              id="my-accordion"
              class="accordion"
              value={~W(lorem duis donec)}
              items={@items}
              collapsible={@controls.multiple or @controls.collapsible}
              multiple={@controls.multiple}
              orientation={@controls.orientation}
              dir={@controls.dir}
            >
              <:content :let={item}>
                <p class="break-words">{item.content}</p>
              </:content>
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:canvas>
        </.demo_playground>
      </.demo_page>
    </Layouts.app>
    """
  end
end
