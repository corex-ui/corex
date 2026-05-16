defmodule E2eWeb.ToggleApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToggleDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    codes = %{
      server_heex: Demo.api_server_heex(),
      server_elixir: Demo.api_server_elixir(),
      client_binding: Demo.api_client_binding_heex(),
      client_js_heex: Demo.api_client_js_heex(),
      client_js: Demo.api_client_js_js(),
      client_js_ts: Demo.api_client_js_ts()
    }

    {:ok, socket |> assign(:codes, codes) |> assign(:api_srv_pressed, false)}
  end

  @impl true
  def handle_event("toggle_api_on", _, socket) do
    socket = assign(socket, :api_srv_pressed, true)
    {:noreply, Corex.Toggle.set_pressed(socket, "toggle-api-srv", true)}
  end

  @impl true
  def handle_event("toggle_api_off", _, socket) do
    socket = assign(socket, :api_srv_pressed, false)
    {:noreply, Corex.Toggle.set_pressed(socket, "toggle-api-srv", false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        id="toggle-api-page"
        title="Toggle · API"
        subtitle="lorem, duis, and donec: server push, client binding, and DOM dispatch."
      >
        <.demo_section
          id="toggle-api-server"
          title="Server push"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="flex flex-wrap gap-4 items-center">
                <.action class="button button--sm" phx-click="toggle_api_on">donec</.action>
                <.action class="button button--sm" phx-click="toggle_api_off">lorem</.action>
              </div>
              <.toggle id="toggle-api-srv" class="toggle" controlled pressed={@api_srv_pressed}>
                duis
              </.toggle>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="toggle-api-client-binding" title="Client binding" code={@codes.client_binding}>
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="flex flex-wrap gap-4 items-center">
                <.action class="button button--sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", true)}>
                  donec
                </.action>
                <.action class="button button--sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", false)}>
                  lorem
                </.action>
              </div>
              <.toggle id="toggle-api-bind" class="toggle" pressed={false}>
                duis
              </.toggle>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="toggle-api-client-js"
          title="Client JS"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.client_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.client_js_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="flex flex-wrap gap-4 items-center">
                <.action
                  class="button button--sm"
                  phx-click={
                    Phoenix.LiveView.JS.dispatch("corex:toggle:set-pressed",
                      to: "#toggle-api-cjs",
                      detail: %{pressed: false},
                      bubbles: false
                    )
                  }
                >
                  lorem
                </.action>
              </div>
              <.toggle id="toggle-api-cjs" class="toggle" pressed>
                duis
              </.toggle>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
