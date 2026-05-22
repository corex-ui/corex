defmodule E2eWeb.PaginationApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.PaginationDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page, 1) |> assign(:codes, demo_codes())}
  end

  defp demo_codes do
    %{
      binding: Demo.api_set_page_client_binding_heex(),
      server_heex: Demo.api_set_page_server_heex(),
      server_elixir: Demo.api_set_page_server_elixir()
    }
  end

  @impl true
  def handle_event("pagination_api_page_3", _params, socket) do
    {:noreply, Corex.Pagination.set_page(socket, "pagination-api-srv", 3)}
  end

  @impl true
  def handle_event("pagination_api_page_changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, page)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="pagination-api-page"
        title="Pagination · API"
        subtitle="set_page via LiveView JS or server push. Page numbers are 1-based."
      >
        <.demo_section
          id="pagination-api-client-binding"
          title="LiveView binding"
          code={@codes.binding}
        >
          <:preview><Demo.api_set_page_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="pagination-api-server"
          title="Server push"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.server_elixir}
          ]}
        >
          <:preview><Demo.api_set_page_server_example page={@page} /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
