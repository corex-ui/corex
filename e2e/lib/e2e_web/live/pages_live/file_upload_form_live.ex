defmodule E2eWeb.FileUploadFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2eWeb.Demos.FileUploadDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "File upload form")
     |> assign(:live_heex, FileUploadDemo.form_live_upload_heex())
     |> assign(:live_elixir, FileUploadDemo.form_live_upload_elixir())
     |> allow_upload(:attachment,
       accept: ~w(.jpg .jpeg .png .gif .webp .pdf .txt),
       max_entries: 3,
       max_file_size: 8_000_000
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    results =
      consume_uploaded_entries(socket, :attachment, fn %{path: path}, entry ->
        _ = File.rm!(path)
        {:ok, entry.client_name}
      end)

    message =
      case results do
        [] -> "No files consumed"
        names -> "Uploaded: #{Enum.join(names, ", ")}"
      end

    {:noreply,
     socket
     |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)}
  end

  def handle_event("file_upload_live_cancel", params, socket) do
    %{"ref" => ref, "upload_field" => field} = params
    name = String.to_existing_atom(field)
    {:noreply, cancel_upload(socket, name, ref)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        id="file-upload-form-live-page"
        title="File Upload live · Form"
        subtitle="Live View uploads (allow_upload)"
      >
        <.demo_section
          id="file-upload-live-form-allow-upload"
          title="allow_upload"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_elixir}
          ]}
        >
          <:preview>
            <form
              phx-change="validate"
              phx-submit="save"
              id="file-upload-live-form"
              class="w-full max-w-2xs flex flex-col gap-space items-center"
            >
              <.file_upload_live
                upload={@uploads.attachment}
                field={:attachment}
                id="file-upload-live-field"
              >
                <:label>Attachment</:label>
                <:close>
                  <.heroicon name="hero-x-mark" />
                </:close>
              </.file_upload_live>
              <.action type="submit" class="button button--accent w-full">Submit</.action>
            </form>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
