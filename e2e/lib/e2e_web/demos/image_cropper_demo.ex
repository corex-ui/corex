defmodule E2eWeb.Demos.ImageCropperDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.image_cropper class="image-cropper" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.image_cropper id="image-cropper-anatomy-minimal" class="image-cropper" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.image_cropper id="image-cropper-style-accent" class="image-cropper ui-accent" />
    """
  end
end
