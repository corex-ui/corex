defmodule E2eWeb.FileUploadTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Browser
  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.FileUploadModel, as: FileUpload

  @moduletag :file_upload

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section exposes file upload trigger", %{session: session} do
      session =
        ComponentBehaviorSpec.visit_ready(session, FileUpload, :file_upload, :anatomy)

      Enum.reduce(FileUpload.anatomy_section_ids(), session, fn section_id, sess ->
        sess
        |> FileUpload.wait_section_file_upload_ready(section_id)
        |> FileUpload.click_trigger_in_section(section_id)
        |> FileUpload.wait_section_file_upload_ready(section_id)
      end)
    end

    feature "custom slots section shows dropzone", %{session: session} do
      section = "file-upload-anatomy-custom-slots"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FileUpload, :file_upload, :anatomy)
        |> FileUpload.wait_section_file_upload_ready(section)

      assert has?(
               session,
               css(
                 ~s|section##{section} [data-scope="file-upload"][data-part="dropzone"]|,
                 visible: :any
               )
             )
    end
  end

  describe "api" do
    feature "open file picker action is present", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FileUpload, :file_upload, :api)
        |> FileUpload.wait_host_file_upload_ready("file-upload-api-phx")

      assert has?(
               session,
               css("#file-upload-api-phx [data-scope='file-upload'][data-part='trigger']",
                 visible: :any
               )
             )
    end
  end

  describe "events" do
    feature "events page mounts upload hosts", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FileUpload, :file_upload, :events)
        |> FileUpload.prepare_live_form()
        |> FileUpload.wait_host_file_upload_ready("file-upload-events-server")

      assert has?(
               session,
               css(
                 "#file-upload-events-client[phx-hook='FileUpload']:not([data-loading])",
                 visible: :any
               )
             )
    end
  end

  describe "form" do
    feature "form page renders file upload field", %{session: session} do
      alias E2eWeb.FileUploadModel, as: FileUpload

      session
      |> visit("/en/file-upload/form")
      |> assert_has(css("#file-upload-form-page", visible: :any))
      |> FileUpload.wait_section_file_upload_ready("file-upload-form-phoenix")
    end
  end
end
