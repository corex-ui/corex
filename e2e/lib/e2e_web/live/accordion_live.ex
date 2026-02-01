defmodule E2eWeb.AccordionLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", String.split(value, ","))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="layout__row">
        <h1>Accordion</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Accordion.set_value("my-accordion", ["item-0"])}
          class="button button--sm"
        >
          Open Item 1
        </button>
        <button
          phx-click={Corex.Accordion.set_value("my-accordion", ["item-0", "item-1"])}
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
        <button phx-click="set_value" value={Enum.join(["item-0"], ",")} class="button button--sm">
          Open Item 1
        </button>
        <button
          phx-click="set_value"
          value={Enum.join(["item-0", "item-1"], ",")}
          class="button button--sm"
        >
          Open Item 1 and 2
        </button>
        <button phx-click="set_value" value="" class="button button--sm">
          Close all Items
        </button>
      </div>
      <.accordion id="my-accordion" class="accordion">
        <:item :let={item}>
          <.accordion_trigger item={item}>
            Lorem ipsum dolor sit amet
          </.accordion_trigger>
          <.accordion_content item={item}>
            Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
          </.accordion_content>
        </:item>
        <:item :let={item}>
          <.accordion_trigger item={item}>
            Duis dictum gravida odio ac pharetra?
          </.accordion_trigger>
          <.accordion_content item={item}>
            Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
          </.accordion_content>
        </:item>
        <:item :let={item}>
          <.accordion_trigger item={item}>
            Donec condimentum ex mi
          </.accordion_trigger>
          <.accordion_content item={item}>
            Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis non, pellentesque elit. Pellentesque sagittis fermentum.
          </.accordion_content>
        </:item>
      </.accordion>
    </Layouts.app>
    """
  end
end
