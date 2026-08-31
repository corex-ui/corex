defmodule E2eWeb.TourApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("tour_api_start", _params, socket) do
    {:noreply, Corex.Tour.start(socket, "tour-api-srv")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="tour-api-page"
        title="Tour · API"
        subtitle="Start the tour after JS is available. Overlay stays closed on the server."
      >
        <.demo_section id="tour-api-client-binding" title="Start (Client binding)">
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <.action phx-click={Corex.Tour.start("tour-api-cb")} class="button ui-size-sm">
                Start
              </.action>
              <.tour id="tour-api-cb" class="tour" />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="tour-api-client-js" title="Start (Client JS)">
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <button
                type="button"
                class="button ui-size-sm"
                onclick="document.getElementById('tour-api-cjs')?.dispatchEvent(new CustomEvent('corex:tour:start', {bubbles: false, detail: {}}))"
              >Start</button>
              <.tour id="tour-api-cjs" class="tour" />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="tour-api-server" title="Start (Server)">
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <.action phx-click="tour_api_start" class="button ui-size-sm">Start</.action>
              <.tour id="tour-api-srv" class="tour" />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
