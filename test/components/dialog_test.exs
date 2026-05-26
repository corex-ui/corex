defmodule Corex.DialogTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Animation.Scale
  alias Corex.Dialog
  alias Corex.Dialog.Anatomy.{CloseTrigger, Props}
  alias Corex.Dialog.Connect
  alias Corex.Dialog.Translation, as: DialogTranslation

  describe "dialog/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_dialog/1, [])
      assert html =~ ~r/data-scope="dialog"/
      assert html =~ ~r/data-part="content"/
      assert html =~ ~r/Open/
      assert html =~ ~r/Dialog content/
      assert html =~ ~r/data-animation="js"/
      assert html =~ "data-anim-scale-duration"
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

  describe "Connect.backdrop/2" do
    test "returns backdrop attributes when open (instant)" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.backdrop(assigns, "instant")
      assert result["id"] == "dialog:test-dialog:backdrop"
      assert result["data-part"] == "backdrop"
      refute Map.has_key?(result, "hidden")
    end

    test "returns backdrop with hidden when closed and animation is instant" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.backdrop(assigns, "instant")
      assert result["hidden"] == ""
      assert result["data-state"] == "closed"
    end

    test "omits hidden when closed and animation is js" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.backdrop(assigns, "js")
      refute Map.has_key?(result, "hidden")
      assert result["data-state"] == "closed"
    end

    test "omits hidden when closed and animation is custom" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.backdrop(assigns, "custom")
      refute Map.has_key?(result, "hidden")
      assert result["data-state"] == "closed"
    end

    test "omits hidden when open and animation is js" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.backdrop(assigns, "js")
      refute Map.has_key?(result, "hidden")
      assert result["data-state"] == "open"
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes when closed" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.positioner(assigns)
      assert result["id"] == "dialog:test-dialog:positioner"
      assert result["data-part"] == "positioner"
      assert result["data-state"] == "closed"
      refute Map.has_key?(result, "style")
      refute Map.has_key?(result, "hidden")
    end

    test "returns positioner attributes when open" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.positioner(assigns)
      assert result["data-state"] == "open"
      refute Map.has_key?(result, "style")
      refute Map.has_key?(result, "hidden")
    end
  end

  describe "Connect.content/2" do
    test "returns content attributes when open (instant)" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true, role: "dialog"}
      result = Connect.content(assigns, "instant")
      assert result["id"] == "dialog:test-dialog:content"
      assert result["role"] == "dialog"
      assert result["data-state"] == "open"
      refute Map.has_key?(result, "hidden")
    end

    test "uses aria-label when no title" do
      assigns = %{
        id: "test-dialog",
        dir: "ltr",
        open: false,
        role: "dialog",
        has_title: false,
        has_description: false,
        label: "Confirm"
      }

      result = Connect.content(assigns, "instant")
      assert result["aria-label"] == "Confirm"
      refute Map.has_key?(result, "aria-labelledby")
      refute Map.has_key?(result, "aria-describedby")
    end

    test "uses aria-labelledby and aria-describedby when title and description present" do
      assigns = %{
        id: "test-dialog",
        dir: "ltr",
        open: true,
        role: "dialog",
        has_title: true,
        has_description: true
      }

      result = Connect.content(assigns, "instant")
      assert result["aria-labelledby"] == "dialog:test-dialog:title"
      assert result["aria-describedby"] == "dialog:test-dialog:description"
      refute Map.has_key?(result, "aria-label")
    end

    test "returns alertdialog role when set" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true, role: "alertdialog"}
      result = Connect.content(assigns, "instant")
      assert result["role"] == "alertdialog"
    end

    test "returns content with hidden when closed and animation is instant" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false, role: "dialog"}
      result = Connect.content(assigns, "instant")
      assert result["hidden"] == ""
      assert result["data-state"] == "closed"
    end

    test "omits hidden when closed and animation is js" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.content(assigns, "js")
      refute Map.has_key?(result, "hidden")
      assert result["data-state"] == "closed"
    end

    test "omits hidden when closed and animation is custom" do
      assigns = %{id: "test-dialog", dir: "ltr", open: false}
      result = Connect.content(assigns, "custom")
      refute Map.has_key?(result, "hidden")
      assert result["data-state"] == "closed"
    end

    test "omits hidden when open and animation is js" do
      assigns = %{id: "test-dialog", dir: "ltr", open: true}
      result = Connect.content(assigns, "js")
      refute Map.has_key?(result, "hidden")
      assert result["data-state"] == "open"
    end
  end

  describe "Connect.props/1" do
    test "merges animation_options into data attributes" do
      anim = %Scale{duration: 0.5, scale_start: 0.9, scale_end: 1.0}

      m =
        Connect.props(%Props{
          id: "d1",
          animation: "js",
          animation_options: anim
        })

      assert m["data-animation"] == "js"
      assert m["data-anim-scale-duration"] == 0.5
      assert m["data-anim-transform-scale-start"] == 0.9
      assert m["data-anim-transform-scale-end"] == 1.0
    end

    test "does not merge animation_options when animation is not js" do
      m =
        Connect.props(%Props{
          id: "d2",
          animation: "custom",
          animation_options: %Scale{duration: 0.9, scale_start: 0.5, scale_end: 1.0}
        })

      assert m["data-animation"] == "custom"
      refute Map.has_key?(m, "data-anim-scale-duration")
    end

    test "embeds default dialog accessible name for client-side Zag props" do
      m =
        Connect.props(%Props{
          id: "d3",
          animation: "instant",
          label: DialogTranslation.resolve(nil).label
        })

      assert m["data-dialog-default-label"] == "Dialog"
    end

    test "honours label in props when set" do
      m =
        Connect.props(%Props{
          id: "d4",
          animation: "instant",
          label: "Custom"
        })

      assert m["data-dialog-default-label"] == "Custom"
    end

    test "emits role and initial_focus data attributes" do
      m =
        Connect.props(%Props{
          id: "d5",
          role: "alertdialog",
          initial_focus: "cancel-btn",
          final_focus: "dialog:d5:trigger"
        })

      assert m["data-role"] == "alertdialog"
      assert m["data-initial-focus"] == "cancel-btn"
      assert m["data-final-focus"] == "dialog:d5:trigger"
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
      assigns = %CloseTrigger{id: "test-dialog", dir: "ltr", open: false, aria_label: "Close"}
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
