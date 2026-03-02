defmodule Corex.ActionTest do
  use CorexTest.ComponentCase, async: true

  describe "action/1" do
    test "renders button with default type" do
      result = render_component(&CorexTest.ComponentHelpers.render_action/1, %{})
      assert [_] = find_in_html(result, "button")
      assert text_in_html(result) =~ "Click"
    end

    test "renders button with type submit" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_opts/1,
          type: "submit",
          aria_label: nil,
          disabled: false
        )

      assert [_] = find_in_html(result, "button[type=submit]")
      assert text_in_html(result) =~ "Save"
    end

    test "renders button with aria_label" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_opts/1,
          type: "button",
          aria_label: "Close dialog",
          disabled: false
        )

      assert [_] = find_in_html(result, ~s(button[aria-label="Close dialog"]))
    end

    test "renders disabled button" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_opts/1,
          type: "button",
          aria_label: nil,
          disabled: true
        )

      assert [_] = find_in_html(result, "button[disabled]")
    end
  end
end
