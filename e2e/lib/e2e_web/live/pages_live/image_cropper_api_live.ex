defmodule E2eWeb.ImageCropperApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="image-cropper-api-page"
        title="ImageCropper · API"
        subtitle="Host API."
      >
        <.demo_section id="image-cropper-api-preview" title="View preview">
          <:preview>
            <div class="flex w-full flex-col gap-space">
              <.action
                phx-click={Corex.ImageCropper.preview("image-cropper-api")}
                class="button ui-size-sm"
              >
                View preview
              </.action>
              <.image_cropper id="image-cropper-api" class="image-cropper" src="/images/beach.jpg" />
              <img
                data-image-cropper-preview="image-cropper-api"
                alt="Crop preview"
                class="max-w-xs rounded-md border border-border"
                hidden
              />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
