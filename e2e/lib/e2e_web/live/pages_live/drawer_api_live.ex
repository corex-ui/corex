defmodule E2eWeb.DrawerApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DrawerDemo, as: Demo

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("drawer_api_open", _params, socket) do
    {:noreply, Corex.Drawer.set_open(socket, "drawer-api-srv", true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="drawer-api-page" title="Drawer · API" subtitle="Set open from bindings or the server.">
        <.demo_section id="drawer-api-set-open-client-binding" title="Set open (Client binding)">
          <:preview><Demo.api_set_open_client_binding_example /></:preview>
        </.demo_section>
        <.demo_section id="drawer-api-set-open-server" title="Set open (Server)">
          <:preview><Demo.api_set_open_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
