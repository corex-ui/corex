defmodule Corex.FileUploadLiveTest do
  use CorexTest.ComponentCase, async: true

  describe "file_upload_live/1" do
    test "renders scope and live upload input hook" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_live_minimal/1, [])
      assert html =~ ~s(data-scope="file-upload")
      assert html =~ ~s(data-part="root")
      assert html =~ ~s(data-phx-hook="Phoenix.LiveFileUpload")
      assert html =~ ~s(phx-drop-target="phx-test-ref")
      assert html =~ "phx-test-ref"
    end
  end
end
