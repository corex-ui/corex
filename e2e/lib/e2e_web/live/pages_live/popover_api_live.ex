defmodule E2eWeb.PopoverApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.PopoverDemo, as: Demo

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("popover_api_open", _params, socket) do
    {:noreply, Corex.Popover.set_open(socket, "popover-api-srv", true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="popover-api-page"
        title="Popover · API"
        subtitle="Set open from bindings or the server."
      >
        <.demo_section id="popover-api-set-open-client-binding" title="Set open (Client binding)">
          <:preview><Demo.api_set_open_client_binding_example /></:preview>
        </.demo_section>
        <.demo_section id="popover-api-set-open-server" title="Set open (Server)">
          <:preview><Demo.api_set_open_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
