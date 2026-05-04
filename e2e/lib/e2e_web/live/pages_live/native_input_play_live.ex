defmodule E2eWeb.NativeInputPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, disabled: false)}
  end

  @impl true
  def handle_event("disabled_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :disabled, checked == true or checked == "true")}
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
        id="native-input-play-page"
        title="Native Input · Playground"
        subtitle="Toggle a few props."
      >
        <.demo_section
          id="native-input-play"
          title="Playground"
          code={E2eWeb.Demos.NativeInputDemo.playground_code()}
        >
          <:preview>
            <div class="layout__row items-start gap-ui-padding">
              <div class="flex flex-col gap-2">
                <.switch
                  class="switch"
                  id="ni-disabled"
                  checked={@disabled}
                  on_checked_change="disabled_changed"
                >
                  <:label>Disabled (demo text)</:label>
                </.switch>
              </div>
              <E2eWeb.Demos.NativeInputDemo.playground_example disabled={@disabled} />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
