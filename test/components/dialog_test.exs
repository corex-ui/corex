defmodule Corex.DialogTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Dialog
  alias Corex.Dialog.Connect

  describe "dialog/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_dialog/1, [])
      assert html =~ ~r/data-scope="dialog"/
      assert html =~ ~r/data-part="content"/
      assert html =~ ~r/Open/
      assert html =~ ~r/Dialog content/
    end
  end

  describe "set_open/2" do
    test "returns JS command when open is true" do
      js = Dialog.set_open("my-dialog", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when open is false" do
      js = Dialog.set_open("my-dialog", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_open/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Dialog.set_open(socket, "my-dialog", false)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.trigger/1" do
    test "returns trigger attributes when closed" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.trigger(assigns)
      assert result["id"] == "dialog:test-dialog:trigger"
      assert result["data-scope"] == "dialog"
      assert result["data-part"] == "trigger"
      assert result["aria-expanded"] == "false"
      assert result["data-state"] == "closed"
      assert result["aria-controls"] == "dialog:test-dialog:content"
      assert result["aria-haspopup"] == "dialog"
    end

    test "returns trigger attributes when open" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.trigger(assigns)
      assert result["aria-expanded"] == "true"
      assert result["data-state"] == "open"
    end
  end

  describe "Connect.backdrop/1" do
    test "returns backdrop attributes when open" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.backdrop(assigns)
      assert result["id"] == "dialog:test-dialog:backdrop"
      assert result["data-part"] == "backdrop"
      refute Map.has_key?(result, "hidden")
    end

    test "returns backdrop with hidden when closed" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.backdrop(assigns)
      assert result["hidden"] == ""
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes" do
      assigns = %{id: "test-dialog", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["id"] == "dialog:test-dialog:positioner"
      assert result["data-part"] == "positioner"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes when open" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.content(assigns)
      assert result["id"] == "dialog:test-dialog:content"
      assert result["role"] == "dialog"
      assert result["data-state"] == "open"
      refute Map.has_key?(result, "hidden")
    end

    test "returns content with hidden when closed" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.content(assigns)
      assert result["hidden"] == ""
    end
  end

  describe "Connect.title/1" do
    test "returns title attributes" do
      assigns = %{id: "test-dialog", dir: "ltr"}
      result = Connect.title(assigns)
      assert result["id"] == "dialog:test-dialog:title"
      assert result["data-part"] == "title"
    end
  end

  describe "Connect.description/1" do
    test "returns description attributes" do
      assigns = %{id: "test-dialog", dir: "ltr"}
      result = Connect.description(assigns)
      assert result["id"] == "dialog:test-dialog:description"
      assert result["data-part"] == "description"
    end
  end

  describe "Connect.close_trigger/1" do
    test "returns close trigger attributes" do
      assigns = %{id: "test-dialog", dir: "ltr"}
      result = Connect.close_trigger(assigns)
      assert result["id"] == "dialog:test-dialog:close-trigger"
      assert result["data-part"] == "close-trigger"
      assert result["aria-label"] == "Close"
    end
  end

  describe "dialog/1 with options" do
    test "renders with nested dialog_title, dialog_description, dialog_close_trigger" do
      html = render_component(&CorexTest.ComponentHelpers.render_dialog_nested_slots/1, [])
      assert html =~ ~r/Nested Title/
      assert html =~ ~r/Nested desc/
      assert html =~ ~r/Body/
    end

    test "renders with controlled and title/description slots" do
      html = render_component(&CorexTest.ComponentHelpers.render_dialog_controlled/1, [])
      assert html =~ ~r/data-scope="dialog"/
      assert html =~ ~r/Title/
      assert html =~ ~r/Description/
      assert html =~ ~r/Content/
    end
  end
end
