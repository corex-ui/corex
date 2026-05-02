defmodule E2eWeb.AccordionPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias Corex.Accordion

  @accordion_id "my-accordion"

  defp item_values, do: ~w(lorem duis donec)

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
        trigger: t1,
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        disabled: "lorem" in disabled
      },
      %{
        value: "duis",
        trigger: t2,
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        disabled: "duis" in disabled
      },
      %{
        value: "donec",
        trigger: t3,
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
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
      dir: "ltr",
      color: "default",
      size: "md"
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:disabled_select_items, disabled_select_items())
      |> assign(:accordion_color_items, accordion_color_items())
      |> assign(:accordion_size_items, accordion_size_items())
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
     |> sync_items()
     |> push_playground_accordion_value()}
  end

  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_items: []})
     |> sync_items()
     |> push_playground_accordion_value()}
  end

  defp update_control(socket, "orientation", value) do
    socket
    |> update(:controls, &%{&1 | orientation: value})
    |> sync_items()
  end

  defp update_control(socket, "color", value) do
    update(socket, :controls, &%{&1 | color: value})
  end

  defp update_control(socket, "size", value) do
    update(socket, :controls, &%{&1 | size: value})
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
    order = item_values()
    disabled = Map.get(controls, :disabled_items, [])
    enabled = Enum.filter(order, &(&1 not in disabled))

    if controls.multiple do
      enabled
    else
      case enabled do
        [] -> []
        [first | _] -> [first]
      end
    end
  end

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  defp control_id("playground-collapsible-" <> _), do: "collapsible"
  defp control_id("accordion-color"), do: "color"
  defp control_id("accordion-size"), do: "size"
  defp control_id(id), do: id

  defp disabled_select_items do
    [
      %{label: "Lorem", id: "lorem"},
      %{label: "Duis", id: "duis"},
      %{label: "Donec", id: "donec"}
    ]
  end

  defp accordion_color_items do
    [
      %{label: "Default", id: "default"},
      %{label: "Accent", id: "accent"},
      %{label: "Brand", id: "brand"},
      %{label: "Alert", id: "alert"},
      %{label: "Info", id: "info"},
      %{label: "Success", id: "success"}
    ]
  end

  defp accordion_size_items do
    [
      %{label: "SM", id: "sm"},
      %{label: "MD", id: "md"},
      %{label: "LG", id: "lg"},
      %{label: "XL", id: "xl"}
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
      <.demo_playground
        title="Accordion · Playground"
        heading_class="layout-heading"
      >
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

          <.select
            id="playground-disabled-items"
            class="select select--accent w-4xs"
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
            class="switch"
            id={"playground-collapsible-#{@controls.multiple}"}
            checked={@controls.collapsible}
            on_checked_change="control_changed"
          >
            <:label>Collapsible</:label>
          </.switch>

          <.switch
            class="switch"
            id="multiple"
            checked={@controls.multiple}
            on_checked_change="control_changed"
          >
            <:label>Multiple</:label>
          </.switch>

          <.select
            id="accordion-color"
            class="select select--accent  w-4xs"
            value={[@controls.color]}
            deselectable={false}
            items={@accordion_color_items}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Color"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Color</:label>
          </.select>

          <.select
            id="accordion-size"
            class="select select--accent w-4xs"
            value={[@controls.size]}
            deselectable={false}
            items={@accordion_size_items}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Size"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Size</:label>
          </.select>
        </:controls>
        <:canvas>
          <.accordion
            id="my-accordion"
            class={[
              "accordion",
              @controls.color != "default" && "accordion--#{@controls.color}",
              "accordion--#{@controls.size}"
            ]}
            value={~w(lorem duis donec)}
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
    </Layouts.app>
    """
  end
end
