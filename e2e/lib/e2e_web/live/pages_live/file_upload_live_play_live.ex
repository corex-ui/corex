defmodule E2eWeb.FileUploadLivePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:dir, "ltr")
     |> allow_upload(:play,
       accept: :any,
       max_entries: 3,
       max_file_size: 8_000_000
     )}
  end

  @impl true
  def handle_event("validate", _params, socket), do: {:noreply, socket}

  def handle_event("file_upload_live_cancel", params, socket) do
    %{"ref" => ref, "upload_field" => field} = params
    name = String.to_existing_atom(field)
    {:noreply, cancel_upload(socket, name, ref)}
  end

  def handle_event("control_changed", %{"value" => [value | _], "id" => "dir"}, socket)
      when is_binary(value) do
    {:noreply, assign(socket, :dir, value)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_playground
        path={@path}
        title="File Upload live · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle id="dir" on_value_change="control_changed" value={[@dir]} />
        </:controls>
        <:canvas>
          <form
            phx-change="validate"
            class="w-full flex justify-center"
            id="file-upload-live-playground-form"
          >
            <.file_upload_live
              id="file-upload-live-playground"
              class="file-upload"
              upload={@uploads.play}
              field={:play}
              dir={@dir}
            >
              <:label>Files</:label>
              <:close>
                <.heroicon name="hero-x-mark" />
              </:close>
            </.file_upload_live>
          </form>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
