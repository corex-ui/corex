defmodule E2eWeb.ToastApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToastDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("toast_api_push_info", _params, socket) do
    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "Info", "From server", :info, 5000)}
  end

  @impl true
  def handle_event("toast_api_push_success", _params, socket) do
    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "Success", "From server", :success, 5000)}
  end

  @impl true
  def handle_event("toast_api_push_error", _params, socket) do
    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "Error", "From server", :error, 5000)}
  end

  @impl true
  def handle_event("toast_api_push_loading", _params, socket) do
    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "Loading", "From server", :info, :infinity,
       loading: true
     )}
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
        id="toast-api-page"
        title="Toast · API"
        subtitle="Create from client bindings, client JS, or push from the server. Types are info, success, and error; use optional loading: true for the loading slot."
      >
        <.demo_section
          id="toast-api-create-client-binding"
          title="Create toast (Client binding)"
          code={@codes.create_toast_client_binding}
        >
          <:preview><Demo.api_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-api-create-client-js"
          title="Create toast (Client JS)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.create_toast_client_js_heex
            },
            %{value: "js", label: "JS", language: :js, code: @codes.create_toast_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.create_toast_client_ts}
          ]}
        >
          <:preview><Demo.api_create_toast_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-api-push-server"
          title="Push toast (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.push_toast_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.push_toast_server_elixir
            }
          ]}
        >
          <:preview><Demo.api_push_toast_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
