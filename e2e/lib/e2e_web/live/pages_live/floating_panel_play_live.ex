defmodule E2eWeb.FloatingPanelPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       draggable: true,
       resizable: true,
       remount: 0
     )}
  end

  @impl true
  def handle_event("draggable_changed", %{"checked" => checked, "id" => _}, socket) do
    v = checked == true or checked == "true"
    r = socket.assigns.remount + 1
    {:noreply, assign(socket, draggable: v, remount: r)}
  end

  @impl true
  def handle_event("resizable_changed", %{"checked" => checked, "id" => _}, socket) do
    v = checked == true or checked == "true"
    r = socket.assigns.remount + 1
    {:noreply, assign(socket, resizable: v, remount: r)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="floating-panel-play-page"
        title="Floating Panel · Playground"
        subtitle="Drag and resize. Open state is toggled in the browser only."
      >
        <.demo_section
          id="floating-panel-play"
          title="Playground"
          code={E2eWeb.Demos.FloatingPanelDemo.anatomy_basic_code()}
        >
          <:preview>
            <div class="layout__row items-start gap-ui-padding">
              <div class="flex flex-col gap-2">
                <.switch
                  class="switch"
                  id="fp-draggable"
                  checked={@draggable}
                  on_checked_change="draggable_changed"
                >
                  <:label>Draggable</:label>
                </.switch>
                <.switch
                  class="switch"
                  id="fp-resizable"
                  checked={@resizable}
                  on_checked_change="resizable_changed"
                >
                  <:label>Resizable</:label>
                </.switch>
              </div>

              <.floating_panel
                id={"floating-panel-play-#{@remount}"}
                draggable={@draggable}
                resizable={@resizable}
                class="floating-panel"
              >
                <:open_trigger>Close panel</:open_trigger>
                <:closed_trigger>Open panel</:closed_trigger>
                <:minimize_trigger>
                  <.heroicon name="hero-arrow-down-left" class="icon" />
                </:minimize_trigger>
                <:maximize_trigger>
                  <.heroicon name="hero-arrows-pointing-out" class="icon" />
                </:maximize_trigger>
                <:default_trigger>
                  <.heroicon name="hero-rectangle-stack" class="icon" />
                </:default_trigger>
                <:close_trigger>
                  <.heroicon name="hero-x-mark" class="icon" />
                </:close_trigger>
                <:content>
                  <p>Lorem ipsum dolor sit amet.</p>
                </:content>
              </.floating_panel>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
