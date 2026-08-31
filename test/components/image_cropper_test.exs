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

  test "does not stamp crop handles before JS hydrates" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.image_cropper id="image-cropper-handles" class="image-cropper" />
          """
        end,
        %{}
      )

    refute html =~ ~S(data-part="handle")
    refute html =~ ~S(data-part="selection")
    assert html =~ "/images/beach.jpg"
  end
end
