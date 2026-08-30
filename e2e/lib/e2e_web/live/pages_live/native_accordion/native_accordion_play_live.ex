defmodule E2eWeb.NativeAccordionPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_playground: 1, playground_dir_toggle: 1]

  alias Corex.NativeAccordion

  defp items do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem duis donec sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:controls, %{dir: "ltr", collapsible: true, multiple: true})
     |> assign(:open, ["lorem"])
     |> assign(:items, items())
     |> assign(:controlled_id, "native-accordion-controlled")
     |> assign(:uncontrolled_id, "native-accordion-uncontrolled")}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = raw in [true, "true"]
    {:noreply, update_control(socket, control_id(id), checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
  end

  def handle_event("faq_toggle", params, socket) do
    {:noreply,
     NativeAccordion.handle_toggle(socket, :open, params,
       multiple: socket.assigns.controls.multiple,
       collapsible: socket.assigns.controls.collapsible
     )}
  end

  defp update_control(socket, "dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "collapsible", checked) do
    controls =
      if checked do
        %{socket.assigns.controls | collapsible: true}
      else
        %{socket.assigns.controls | collapsible: false, multiple: false}
      end

    assign(socket, :controls, controls)
  end

  defp update_control(socket, "multiple", checked) do
    controls =
      if checked do
        %{socket.assigns.controls | multiple: true, collapsible: true}
      else
        %{socket.assigns.controls | multiple: false}
      end

    socket
    |> assign(:controls, controls)
    |> then(fn s ->
      if checked, do: s, else: assign(s, :open, Enum.take(s.assigns.open, 1))
    end)
  end

  defp update_control(socket, _, _), do: socket

  defp control_id("playground-collapsible-" <> _), do: "collapsible"
  defp control_id(id), do: id

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} path={@path} mode={@mode} theme={@theme}>
      <.demo_page
        path={@path}
        id="native-accordion-play-page"
        title="Native Accordion · Playground"
      >
        <.demo_playground id="native-accordion-playground">
          <:controls>
            <.playground_dir_toggle
              id="dir"
              on_value_change="control_changed"
              value={[@controls.dir]}
            />

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
            <div class="flex flex-col gap-space-xl w-full max-w-xl">
              <section class="flex flex-col gap-space-sm">
                <h2 class="text-lg font-semibold">Controlled (LiveView value)</h2>
                <p class="text-sm opacity-80">
                  Open: {inspect(@open)} — no phx-hook / Zag machine
                </p>
                <.native_accordion
                  id={@controlled_id}
                  class="accordion"
                  controlled
                  value={@open}
                  on_value_change="faq_toggle"
                  collapsible={@controls.collapsible}
                  multiple={@controls.multiple}
                  dir={@controls.dir}
                  items={@items}
                >
                  <:content :let={item}>
                    <p class="break-words">{item.content}</p>
                  </:content>
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.native_accordion>
              </section>

              <section class="flex flex-col gap-space-sm">
                <h2 class="text-lg font-semibold">Uncontrolled (JS pipes)</h2>
                <p class="text-sm opacity-80">
                  Client-only toggle via LiveView JS commands
                </p>
                <.native_accordion
                  id={@uncontrolled_id}
                  class="accordion"
                  controlled={false}
                  value={["lorem"]}
                  multiple={@controls.multiple}
                  collapsible={@controls.collapsible}
                  dir={@controls.dir}
                  items={@items}
                >
                  <:content :let={item}>
                    <p class="break-words">{item.content}</p>
                  </:content>
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.native_accordion>
              </section>
            </div>
          </:canvas>
        </.demo_playground>
      </.demo_page>
    </Layouts.app>
    """
  end
end
