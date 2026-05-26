defmodule E2eWeb.FloatingPanelPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

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
      <.demo_playground
        path={@path}
        id="floating-panel-play-page"
        title="Floating Panel · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.switch
            class="switch switch--sm"
            id="fp-draggable"
            checked={@draggable}
            on_checked_change="draggable_changed"
          >
            <:label>Draggable</:label>
          </.switch>
          <.switch
            class="switch switch--sm"
            id="fp-resizable"
            checked={@resizable}
            on_checked_change="resizable_changed"
          >
            <:label>Resizable</:label>
          </.switch>
        </:controls>
        <:canvas>
          <div class="w-full flex justify-center">
            <.floating_panel
              id={"floating-panel-play-#{@remount}"}
              draggable={@draggable}
              resizable={@resizable}
              class="floating-panel"
            >
              <:trigger>
                <span data-closed>Open panel</span>
                <span data-open>Close panel</span>
              </:trigger>
              <:title>Panel</:title>
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
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
