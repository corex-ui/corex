defmodule E2eWeb.NavigatePatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  def mount(params, _session, socket) do
    {:ok, assign(socket, :tab, Map.get(params, "tab"))}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, :tab, Map.get(params, "tab"))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="navigate-patterns-page"
        title={~t"Navigate · Pattern"}
        subtitle={~t"to, type (href, navigate, patch), external, and download on <.navigate>."}
      >
        <.demo_section
          id="navigate-patterns-href"
          title={~t"Trigger · href"}
          code={E2eWeb.Demos.NavigateDemo.patterns_href_code()}
        >
          <:preview><E2eWeb.Demos.NavigateDemo.patterns_href_example /></:preview>
        </.demo_section>

        <.demo_section
          id="navigate-patterns-navigate"
          title={~t"Trigger · navigate"}
          code={E2eWeb.Demos.NavigateDemo.patterns_navigate_code()}
        >
          <:preview><E2eWeb.Demos.NavigateDemo.patterns_navigate_example /></:preview>
        </.demo_section>

        <.demo_section
          id="navigate-patterns-patch"
          title={~t"Trigger · patch"}
          code={E2eWeb.Demos.NavigateDemo.patterns_patch_code()}
        >
          <:preview>
            <div class="flex flex-col gap-space">
              <E2eWeb.Demos.NavigateDemo.patterns_patch_example />
              <%= if @tab do %>
                <p class="text-sm text-ui-ink-muted">Patched query: tab={@tab}</p>
              <% end %>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="navigate-patterns-external-download"
          title={~t"External and download"}
          code={E2eWeb.Demos.NavigateDemo.patterns_external_and_download_code()}
        >
          <:preview><E2eWeb.Demos.NavigateDemo.patterns_external_and_download_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
