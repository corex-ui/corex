defmodule E2eWeb.AccordionLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:accordion_value, nil)
      |> assign(:accordion_focused_value, nil)

    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", String.split(value, ","))}
  end

  def handle_event("get_value", _params, socket) do
    {:noreply, push_event(socket, "accordion_value", %{})}
  end

  def handle_event("get_focused_value", _params, socket) do
    {:noreply, push_event(socket, "accordion_focused_value", %{})}
  end

  def handle_event("accordion_value_response", %{"value" => value}, socket) do
    {:noreply, assign(socket, :accordion_value, value)}
  end

  def handle_event("accordion_focused_value_response", %{"value" => value}, socket) do
    {:noreply, assign(socket, :accordion_focused_value, value)}
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
          Open Lorem
        </button>
        <button
          phx-click={Corex.Accordion.set_value("my-accordion", ["lorem", "donec"])}
          class="button button--sm"
        >
          Open Lorem & Donec
        </button>
        <button phx-click={Corex.Accordion.set_value("my-accordion", [])} class="button button--sm">
          Close all Items
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value={Enum.join(["lorem"], ",")} class="button button--sm">
          Open Lorem
        </button>
        <button
          phx-click="set_value"
          value={Enum.join(["lorem", "donec"], ",")}
          class="button button--sm"
        >
          Open Lorem & Donec
        </button>
        <button phx-click="set_value" value="" class="button button--sm">
          Close all Items
        </button>
        <button phx-click="get_value" class="button button--sm">
          Get current value
        </button>
        <button phx-click="get_focused_value" class="button button--sm">
          Get focused value
        </button>
      </div>
      <div :if={@accordion_value != nil || @accordion_focused_value != nil} class="layout__row">
        <p :if={@accordion_value != nil}>
          Current value: <code>{inspect(@accordion_value)}</code>
        </p>
        <p :if={@accordion_focused_value != nil}>
          Focused value: <code>{inspect(@accordion_focused_value)}</code>
        </p>
      </div>
      <.accordion
        class="accordion"
        id="my-accordion"
        items={
          Corex.Content.new([
            [
              id: "lorem",
              trigger: "Lorem ipsum dolor sit amet",
              content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
              meta: %{indicator: "hero-chevron-right"}
            ],
            [
              trigger: "Duis dictum gravida odio ac pharetra?",
              content: "Nullam eget vestibulum ligula, at interdum tellus.",
              meta: %{indicator: "hero-chevron-right"}
            ],
            [
              id: "donec",
              trigger: "Donec condimentum ex mi",
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
              disabled: true,
              meta: %{indicator: "hero-chevron-right"}
            ]
          ])
        }
      >
        <:item :let={item}>
          <.accordion_trigger item={item}>
            {item.data.trigger}
            <:indicator>
              <.icon name={item.data.meta.indicator} />
            </:indicator>
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
