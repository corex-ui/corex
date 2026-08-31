defmodule Corex.ImageCropperTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.ImageCropper, only: [image_cropper: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.image_cropper id="image-cropper-unit" class="image-cropper" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="ImageCropper")
    assert html =~ ~S(data-scope="image-cropper")
  end
end
