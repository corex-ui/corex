defmodule E2eWeb.FileUploadLiveAnatomyLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.FileUploadDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> allow_upload(:anatomy_minimal,
       accept: :any,
       max_entries: 2,
       max_file_size: 2_000_000
     )
     |> allow_upload(:anatomy_label,
       accept: :any,
       max_entries: 2,
       max_file_size: 2_000_000
     )
     |> allow_upload(:anatomy_custom,
       accept: :any,
       max_entries: 2,
       max_file_size: 2_000_000
     )}
  end

  @impl true
  def handle_event("validate", _params, socket), do: {:noreply, socket}

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
        id="file-upload-live-anatomy-page"
        title="File Upload live · Anatomy"
        subtitle="LiveView uploads (allow_upload) and Corex.FileUploadLive."
      >
        <.demo_section
          id="file-upload-live-anatomy-minimal"
          title="Minimal"
          code={FileUploadDemo.live_anatomy_minimal_code()}
        >
          <:preview>
            <form
              phx-change="validate"
              class="w-full max-w-2xs mx-auto"
              id="file-upload-live-anatomy-minimal-form"
            >
              <.file_upload_live
                upload={@uploads.anatomy_minimal}
                field={:anatomy_minimal}
                id="file-upload-live-anatomy-minimal"
              >
                <:close>
                  <.heroicon name="hero-x-mark" />
                </:close>
              </.file_upload_live>
            </form>
          </:preview>
        </.demo_section>
        <.demo_section
          id="file-upload-live-anatomy-label"
          title="With label"
          code={FileUploadDemo.live_anatomy_with_label_code()}
        >
          <:preview>
            <form
              phx-change="validate"
              class="w-full max-w-2xs mx-auto"
              id="file-upload-live-anatomy-label-form"
            >
              <.file_upload_live
                upload={@uploads.anatomy_label}
                field={:anatomy_label}
                id="file-upload-live-anatomy-label"
              >
                <:label>Files</:label>
                <:close>
                  <.heroicon name="hero-x-mark" />
                </:close>
              </.file_upload_live>
            </form>
          </:preview>
        </.demo_section>
        <.demo_section
          id="file-upload-live-anatomy-custom-slots"
          title="Custom slots"
          code={FileUploadDemo.live_anatomy_custom_slots_code()}
        >
          <:preview>
            <form
              phx-change="validate"
              class="w-full max-w-2xs mx-auto"
              id="file-upload-live-anatomy-custom-form"
            >
              <.file_upload_live
                upload={@uploads.anatomy_custom}
                field={:anatomy_custom}
                id="file-upload-live-anatomy-custom"
              >
                <:dropzone>
                  <span>Custom dropzone</span>
                </:dropzone>
                <:open>
                  <span>Custom trigger</span>
                </:open>
                <:close>
                  <.heroicon name="hero-x-mark" />
                </:close>
              </.file_upload_live>
            </form>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
