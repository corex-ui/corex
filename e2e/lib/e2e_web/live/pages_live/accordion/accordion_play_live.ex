defmodule E2eWeb.AccordionPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage,
    only: [
      demo_page: 1,
      demo_playground: 1,
      demo_preview_tabs: 1,
      authoring_preview: 1,
      playground_dir_toggle: 1,
      playground_orientation_toggle: 1
    ]

  alias Corex.Accordion

  @accordion_id "my-accordion"

  @snippet_item_entries [
    {"lorem", "Lorem ipsum dolor sit amet",
     "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
    {"duis", "Duis dictum gravida odio ac pharetra?",
     "Nullam eget vestibulum ligula, at interdum tellus."},
    {"donec", "Donec condimentum ex mi", "Congue molestie ipsum gravida a. Sed ac eros luctus."}
  ]

  defp item_values, do: ~W(lorem duis donec)

  defp accordion_items(controls) do
    disabled = Map.get(controls, :disabled_items, [])

    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: ~t"Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        disabled: "lorem" in disabled
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content: ~t"Nullam eget vestibulum ligula, at interdum tellus.",
        disabled: "duis" in disabled
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
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
      |> assign_play_snippet()

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
    |> assign_play_snippet()
  end

  defp update_control(socket, "dir", value) do
    socket
    |> update(:controls, &%{&1 | dir: value})
    |> assign_play_snippet()
  end

  defp update_control(socket, "collapsible", true) do
    socket
    |> update(:controls, &%{&1 | collapsible: true})
    |> assign_play_snippet()
    |> push_playground_accordion_value()
  end

  defp update_control(socket, "collapsible", false) do
    socket
    |> update(:controls, &%{&1 | collapsible: false, multiple: false})
    |> assign_play_snippet()
    |> push_playground_accordion_value()
  end

  defp update_control(socket, "multiple", true) do
    socket
    |> update(:controls, &%{&1 | multiple: true, collapsible: true})
    |> assign_play_snippet()
    |> push_playground_accordion_value()
  end

  defp update_control(socket, "multiple", false) do
    socket
    |> update(:controls, &%{&1 | multiple: false})
    |> assign_play_snippet()
    |> push_playground_accordion_value()
  end

  defp update_control(socket, _unknown, _checked), do: assign_play_snippet(socket)

  defp sync_items(socket) do
    socket
    |> assign(:items, accordion_items(socket.assigns.controls))
    |> assign_play_snippet()
  end

  defp assign_play_snippet(socket) do
    assign(socket, :play_snippet, play_snippet(socket.assigns.controls))
  end

  defp play_snippet(controls) do
    collapsible = controls.multiple or controls.collapsible

    collapsible_attr =
      if collapsible, do: "\n  collapsible", else: ""

    multiple_attr =
      if controls.multiple, do: "\n  multiple", else: ""

    code = """
    <.accordion
      variant="subtle"
      #{E2eWeb.AuthoringSnippet.items_attr(snippet_items_code(controls))}
      orientation="#{controls.orientation}"
      dir="#{controls.dir}"#{collapsible_attr}#{multiple_attr}
    >
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """

    E2eWeb.AuthoringSnippet.playground_heex_snippets(String.trim(code))
  end

  defp snippet_items_code(%{disabled_items: []}) do
    E2eWeb.AuthoringSnippet.items_code()
  end

  defp snippet_items_code(controls) do
    disabled = MapSet.new(controls.disabled_items)

    lines =
      @snippet_item_entries
      |> Enum.map(&snippet_item_entry(&1, disabled))

    "Corex.Content.new([\n#{Enum.join(lines, ",\n")}\n])"
  end

  defp snippet_item_entry({value, label, content}, disabled) do
    disabled_attr = if MapSet.member?(disabled, value), do: ", disabled: true", else: ""

    ~s(  %{value: "#{value}", label: "#{label}", content: "#{content}"#{disabled_attr}})
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

            <.playground_orientation_toggle
              id="orientation"
              on_value_change="control_changed"
              value={[@controls.orientation]}
            />

            <.select
              id="playground-disabled-items"
              size="sm"
              class="w-4xs"
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
              size="sm"
              id={"playground-collapsible-#{@controls.multiple}"}
              checked={@controls.collapsible}
              on_checked_change="control_changed"
            >
              <:label>Collapsible</:label>
            </.switch>

            <.switch
              size="sm"
              id="multiple"
              checked={@controls.multiple}
              on_checked_change="control_changed"
            >
              <:label>Multiple</:label>
            </.switch>
          </:controls>
          <:canvas>
            <.demo_preview_tabs
              id="accordion-play-preview"
              code={@play_snippet}
              trigger_class="button button--size-sm"
            >
              <:preview>
                <.authoring_preview>
                  <:styled>
                    <.accordion
                      id="my-accordion"
                      variant="subtle"
                      value={~W(lorem duis donec)}
                      items={@items}
                      collapsible={@controls.multiple or @controls.collapsible}
                      multiple={@controls.multiple}
                      orientation={@controls.orientation}
                      dir={@controls.dir}
                    >
                      <:content :let={item}>
                        <p>{item.content}</p>
                      </:content>
                      <:indicator>
                        <.heroicon name="hero-chevron-right" />
                      </:indicator>
                    </.accordion>
                  </:styled>
                  <:markup>
                    <.accordion
                      id="my-accordion"
                      unstyled
                      value={~W(lorem duis donec)}
                      items={@items}
                      collapsible={@controls.multiple or @controls.collapsible}
                      multiple={@controls.multiple}
                      orientation={@controls.orientation}
                      dir={@controls.dir}
                    >
                      <:content :let={item}>
                        <p>{item.content}</p>
                      </:content>
                      <:indicator>
                        <.heroicon name="hero-chevron-right" />
                      </:indicator>
                    </.accordion>
                  </:markup>
                </.authoring_preview>
              </:preview>
            </.demo_preview_tabs>
          </:canvas>
        </.demo_playground>
      </.demo_page>
    </Layouts.app>
    """
  end
end
