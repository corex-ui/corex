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

  describe "playground" do
    feature "attach file shows item in list", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FileUpload, :file_upload, :playground)
        |> FileUpload.wait_host_file_upload_ready("file-upload-playground")
        |> FileUpload.attach_fixture("file-upload-playground")
        |> FileUpload.see_file_name("file-upload-playground", "sample.txt")
        |> FileUpload.wait_item_count("file-upload-playground", 1)

      assert has?(
               session,
               css(
                 ~S|#file-upload-playground [data-scope="file-upload"][data-part="item"]|,
                 count: 1,
                 visible: :any
               )
             )
    end

    feature "delete item removes it from list", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(FileUpload, :file_upload, :playground)
      |> FileUpload.wait_host_file_upload_ready("file-upload-playground")
      |> FileUpload.attach_fixture("file-upload-playground")
      |> FileUpload.see_file_name("file-upload-playground", "sample.txt")
      |> FileUpload.click_delete_item("file-upload-playground", "sample.txt")
      |> FileUpload.refute_file_name("file-upload-playground", "sample.txt")
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

    feature "attach file triggers server event log", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FileUpload, :file_upload, :events)
        |> FileUpload.prepare_live_form()
        |> FileUpload.wait_host_file_upload_ready("file-upload-events-server")

      before_count = FileUpload.log_row_count(session, "file-upload-events-log-server")

      session
      |> FileUpload.attach_fixture("file-upload-events-server")
      |> FileUpload.see_file_name("file-upload-events-server", "sample.txt")
      |> FileUpload.wait_log_rows_grew("file-upload-events-log-server", before_count,
        timeout: 10_000
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
