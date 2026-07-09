defmodule E2eWeb.NavigatePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, external: false)}
  end

  @impl true
  def handle_event("external_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :external, checked == true or checked == "true")}
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
        id="navigate-playground-page"
        title="Navigate · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.switch
            class="switch switch--sm"
            id="external"
            checked={@external}
            on_checked_change="external_changed"
          >
            <:label>External</:label>
          </.switch>
        </:controls>
        <:canvas>
          <div class="flex flex-wrap items-center gap-space gap-2 items-center">
            <.navigate
              to={if(@external, do: "https://example.com", else: "#")}
              class="link"
              external={@external}
            >
              Link
              <span :if={@external} aria-hidden="true">
                <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
              </span>
            </.navigate>

            <.navigate to="#" class="link" download="report.pdf">
              Download
              <span aria-hidden="true">
                <.heroicon name="hero-arrow-down-tray" class="icon" />
              </span>
            </.navigate>
          </div>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
