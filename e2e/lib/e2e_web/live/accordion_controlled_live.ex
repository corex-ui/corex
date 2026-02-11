defmodule E2eWeb.AccordionControlledLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:value, ["lorem"])
      |> assign(:items, accordion_items())

    {:ok, socket}
  end

  defp accordion_items do
    Corex.Content.new([
      [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla."],
      [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex."],
      [id: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis non, pellentesque elit. Pellentesque sagittis fermentum."]
    ])
  end

  def handle_event("on_value_change", %{"id" => _id, "value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def handle_event("on_focus_change", %{"id" => _id, "value" => _value}, socket) do
    {:noreply, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", String.split(value, ","))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Accordion</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Accordion.set_value("my-accordion", ["lorem"])}
          class="button button--sm"
        >
          Open Item 1
        </button>
        <button
          phx-click={Corex.Accordion.set_value("my-accordion", ["lorem", "duis"])}
          class="button button--sm"
        >
          Open Item 1 and 2
        </button>
        <button phx-click={Corex.Accordion.set_value("my-accordion", [])} class="button button--sm">
          Close all Items
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value={Enum.join(["lorem"], ",")} class="button button--sm">
          Open Item 1
        </button>
        <button
          phx-click="set_value"
          value={Enum.join(["lorem", "duis"], ",")}
          class="button button--sm"
        >
          Open Item 1 and 2
        </button>
        <button phx-click="set_value" value="" class="button button--sm">
          Close all Items
        </button>
      </div>
      <.accordion
        id="my-accordion"
        class="accordion"
        items={@items}
        value={@value}
        controlled
        on_value_change="on_value_change"
        on_focus_change="on_focus_change"
      >
        <:item :let={item}>
          <.accordion_trigger item={item}>
            {item.data.trigger}
          </.accordion_trigger>
          <.accordion_content item={item}>
            {item.data.content}
          </.accordion_content>
        </:item>
      </.accordion>
    </Layouts.app>
    """
  end
end
