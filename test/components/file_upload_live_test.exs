defmodule Corex.FileUploadLiveTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  alias Corex.FileUploadLive

  defp base_upload(overrides \\ []) do
    defaults = [
      name: :attachment,
      ref: "phx-test-ref",
      entries: [],
      errors: [],
      max_entries: 3,
      max_file_size: 8_000_000,
      chunk_size: 64_000,
      chunk_timeout: 10_000,
      accept: :any,
      acceptable_types: MapSet.new(),
      acceptable_exts: MapSet.new(),
      external: false,
      allowed?: true,
      auto_upload?: false,
      progress_event: nil,
      writer: nil,
      cid: nil,
      client_key: "ck",
      entry_refs_to_pids: %{},
      entry_refs_to_metas: %{}
    ]

    struct(Phoenix.LiveView.UploadConfig, Keyword.merge(defaults, overrides))
  end

  defp image_entry(upload, opts \\ []) do
    defaults = [
      ref: "entry-ref-1",
      upload_ref: upload.ref,
      valid?: true,
      done?: false,
      cancelled?: false,
      client_name: "photo.png",
      client_size: 1_500_000,
      client_type: "image/png",
      client_relative_path: "",
      client_last_modified: 0,
      client_meta: nil,
      upload_config: upload,
      progress: 0,
      preflighted?: true,
      uuid: "uuid-1"
    ]

    struct(Phoenix.LiveView.UploadEntry, Keyword.merge(defaults, opts))
  end

  describe "file_upload_live/1" do
    test "renders scope and live upload input hook" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_live_minimal/1, [])
      assert html =~ ~s(data-scope="file-upload")
      assert html =~ ~s(data-part="root")
      assert html =~ ~s(data-phx-hook="Phoenix.LiveFileUpload")
      assert html =~ ~s(phx-drop-target="phx-test-ref")
      assert html =~ "phx-test-ref"
    end

    test "renders label slot from helper" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_live_minimal/1, [])
      assert html =~ "Files"
    end

    test "renders entries with image preview and sizes" do
      upload = base_upload()
      entry = image_entry(upload)
      upload = %{upload | entries: [entry]}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUploadLive.file_upload_live upload={@upload} field={:attachment} id="ful-entries">
              <:close>Remove</:close>
            </FileUploadLive.file_upload_live>
            """
          end,
          %{upload: upload}
        )

      assert html =~ "photo.png"
      assert html =~ "1.4 MB"
      assert html =~ ~s(data-part="item-preview-image")
      assert html =~ ~s(phx-value-ref="entry-ref-1")
    end

    test "renders non-image entry without preview" do
      upload = base_upload()

      entry =
        image_entry(upload,
          client_type: "application/pdf",
          client_name: "doc.pdf",
          client_size: 512
        )

      upload = %{upload | entries: [entry]}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUploadLive.file_upload_live upload={@upload} field={:attachment} id="ful-pdf">
              <:close>Remove</:close>
            </FileUploadLive.file_upload_live>
            """
          end,
          %{upload: upload}
        )

      assert html =~ "doc.pdf"
      assert html =~ "512 B"
      refute html =~ ~s(data-part="item-preview-image")
    end

    test "renders upload errors with custom error slot" do
      upload =
        base_upload(
          errors: [
            {"phx-test-ref", :too_many_files},
            {"phx-test-ref", :too_large},
            {"phx-test-ref", :not_accepted},
            {"phx-test-ref", {:writer_failure, :x}},
            {"phx-test-ref", :external_client_failure},
            {"phx-test-ref", :unknown}
          ]
        )

      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUploadLive.file_upload_live upload={@upload} field={:attachment} id="ful-errors">
              <:close>Remove</:close>
              <:error :let={msg}><span data-err>{msg}</span></:error>
            </FileUploadLive.file_upload_live>
            """
          end,
          %{upload: upload}
        )

      assert html =~ ~s(data-err)
      assert html =~ "Too many files"
      assert html =~ ":unknown"
    end

    test "renders default dropzone and open labels with partial translation" do
      upload = base_upload()

      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUploadLive.file_upload_live
              upload={@upload}
              field={:attachment}
              id="ful-defaults"
              translation={%Corex.FileUpload.Translation{dropzone: "Drop here"}}
            >
              <:close>Remove</:close>
            </FileUploadLive.file_upload_live>
            """
          end,
          %{upload: upload}
        )

      assert html =~ "Drop here"
      assert html =~ ~s(data-part="dropzone")
    end

    test "renders custom dropzone and open slots" do
      upload = base_upload()

      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUploadLive.file_upload_live upload={@upload} field={:attachment} id="ful-custom">
              <:label>Pick files</:label>
              <:dropzone>Drop zone</:dropzone>
              <:open>Browse</:open>
              <:close>Remove</:close>
            </FileUploadLive.file_upload_live>
            """
          end,
          %{upload: upload}
        )

      assert html =~ "Pick files"
      assert html =~ "Drop zone"
      assert html =~ "Browse"
    end
  end
end
