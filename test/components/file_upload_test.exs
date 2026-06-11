defmodule Corex.FileUploadTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  alias Corex.FileUpload
  alias Corex.FileUpload.Connect
  alias Corex.FileUpload.Translation

  describe "file_upload/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_minimal/1, [])
      assert html =~ ~r/data-scope="file-upload"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with label slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_full/1, [])
      assert html =~ ~r/data-scope="file-upload"/
      assert html =~ "Attachment"
    end

    test "renders with field" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_with_field/1, [])
      assert html =~ ~r/data-scope="file-upload"/
      assert html =~ ~r/name="user\[avatar\]"/
      assert html =~ ~r/data-part="hidden-input-sentinel"/
    end

    test "renders :close slot as item-delete template" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_with_close/1, [])
      assert html =~ ~r/data-file-upload-item-close-template/
      assert html =~ "data-test-close"
    end

    test "renders field errors and default translation labels" do
      form =
        to_form(
          %{"doc" => nil},
          as: :user,
          errors: [doc: {"is required", []}]
        )

      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUpload.file_upload field={@form[:doc]} invalid>
              <:close><span>X</span></:close>
              <:error :let={msg}>{msg}</:error>
            </FileUpload.file_upload>
            """
          end,
          %{form: form}
        )

      assert html =~ "is required"
      assert html =~ ~S(data-part="dropzone")
      assert html =~ ~S(data-part="trigger")
    end

    test "renders custom dropzone and open slots" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <FileUpload.file_upload
              id="fu-slots"
              name="doc"
              translation={%Corex.FileUpload.Translation{dropzone: "Drop here", open: "Browse"}}
            >
              <:dropzone>Custom drop</:dropzone>
              <:open>Custom open</:open>
              <:close><span>X</span></:close>
            </FileUpload.file_upload>
            """
          end,
          %{}
        )

      assert html =~ "Custom drop"
      assert html =~ "Custom open"
    end
  end

  describe "Translation" do
    test "resolve fills partial from defaults" do
      defaults = Translation.resolve(nil)
      partial = %Translation{dropzone: "Drop"}
      merged = Translation.resolve(partial)
      assert merged.dropzone == "Drop"
      assert merged.open == defaults.open
    end
  end

  describe "API helpers" do
    test "clear_files/1 returns JS" do
      assert %Phoenix.LiveView.JS{} = FileUpload.clear_files("fu-1")
    end

    test "clear_files/2 pushes to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = FileUpload.clear_files(socket, "fu-1")
    end

    test "clear_rejected_files/1 and /2" do
      assert %Phoenix.LiveView.JS{} = FileUpload.clear_rejected_files("fu-1")

      assert %Phoenix.LiveView.Socket{} =
               FileUpload.clear_rejected_files(%Phoenix.LiveView.Socket{}, "fu-1")
    end

    test "open_file_picker/1 and /2" do
      assert %Phoenix.LiveView.JS{} = FileUpload.open_file_picker("fu-1")

      assert %Phoenix.LiveView.Socket{} =
               FileUpload.open_file_picker(%Phoenix.LiveView.Socket{}, "fu-1")
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-up", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "file:test-up"
      assert result["data-scope"] == "file-upload"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.hidden_input/1" do
    test "returns hidden file input attributes" do
      assigns = %{id: "test-up", disabled: false, name: "user[avatar]", form: "f1"}
      result = Connect.hidden_input(assigns)
      assert result["id"] == "file:test-up:input"
      assert result["type"] == "file"
      assert result["tabindex"] == -1
      assert result["aria-hidden"] == true
      assert result["style"] =~ "position:absolute"
      assert result["name"] == "user[avatar]"
      assert result["form"] == "f1"
    end
  end

  describe "Connect.item_group/1" do
    test "returns accepted list attributes" do
      assigns = %{id: "test-up", type: "accepted", dir: "ltr", disabled: false}
      result = Connect.item_group(assigns)
      assert result["data-file-type"] == "accepted"
      assert result["data-type"] == "accepted"
      assert result["data-part"] == "item-group"
      assert result["dir"] == "ltr"
      refute Map.has_key?(result, "data-disabled")
    end

    test "sets data-disabled when disabled" do
      assigns = %{id: "test-up", type: "accepted", dir: "ltr", disabled: true}
      result = Connect.item_group(assigns)
      assert result["data-disabled"] == ""
    end
  end

  describe "Connect.input_sentinel/1" do
    test "returns sentinel hidden input attributes" do
      assigns = %{id: "test-up", name: "user[avatar]", form: "f1"}
      result = Connect.input_sentinel(assigns)
      assert result["type"] == "hidden"
      assert result["id"] == "file:test-up:sentinel"
      assert result["data-part"] == "hidden-input-sentinel"
      assert result["name"] == "user[avatar]"
      assert result["form"] == "f1"
    end
  end
end
