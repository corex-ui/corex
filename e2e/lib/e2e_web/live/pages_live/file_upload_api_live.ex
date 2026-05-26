defmodule E2eWeb.FileUploadApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.FileUploadDemo, as: Demo

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("api_fu_open_server", %{"id" => id}, socket) do
    {:noreply, Corex.FileUpload.open_file_picker(socket, id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="file-upload-api-page"
        title="File Upload · API"
        subtitle="Open the native file picker from bindings, LiveView, or a DOM event."
      >
        <.demo_section
          id="file-upload-api-open-phx"
          title="open_file_picker (Phoenix binding)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: Demo.api_open_phoenix_binding_heex()
            }
          ]}
        >
          <:preview><Demo.api_open_phoenix_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="file-upload-api-open-server"
          title={~t"open_file_picker (push_event from LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.api_open_server_heex()},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.api_open_server_elixir()
            }
          ]}
        >
          <:preview><Demo.api_open_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="file-upload-api-open-js"
          title={~t"open_file_picker (CustomEvent from JavaScript)"}
          code_tabs={[
            %{value: "js", label: ~t"JS", language: :js, code: Demo.api_open_client_js()}
          ]}
        >
          <:preview><Demo.api_open_client_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
