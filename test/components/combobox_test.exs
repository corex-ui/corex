defmodule Corex.ComboboxTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Combobox.Connect

  describe "combobox/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox/1, [])
      assert html =~ ~r/data-scope="combobox"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with collection and empty slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_items/1, [])
      assert html =~ ~r/data-part="empty"/
      assert html =~ ~r/data-part="item".*data-value="a"/
      assert html =~ ~r/A/
    end

    test "renders with custom item slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_item_slot/1, [])
      assert html =~ ~r/data-part="item-text"/
      assert html =~ ~r/X!/
    end

    test "renders with clear_trigger and item_indicator slots" do
      html =
        render_component(
          &CorexTest.ComponentHelpers.render_combobox_with_clear_and_indicator/1,
          []
        )

      assert html =~ ~r/data-part="clear-trigger"/
      assert html =~ ~r/data-part="item-indicator"/
    end

    test "renders with grouped collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_grouped/1, [])
      assert html =~ ~r/data-part="item-group"/
      assert html =~ ~r/item-group-label/
    end

    test "renders with filter false" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_filter_false/1, [])
      assert html =~ ~r/data-scope="combobox"/
      assert html =~ ~r/data-value="c"/
    end

    test "renders with multiple and controlled" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_combobox_controlled_multiple/1, [])

      assert result =~ ~r/data-value/
      assert result =~ ~r/data-multiple/
    end

    test "renders with errors" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_errors/1, [])
      assert html =~ ~r/data-part="error"/
      assert html =~ ~r/Required/
    end

    test "Connect.props with filter false sets data-filter to nil" do
      assigns =
        Map.merge(default_combobox_props(), %{
          id: "test",
          collection: [%{id: "a", label: "A"}],
          controlled: false,
          value: [],
          dir: "ltr",
          filter: false
        })

      result = Connect.props(assigns)
      assert result["data-filter"] == nil
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-combobox", invalid: false, read_only: false}
      result = Connect.root(assigns)
      assert result["id"] == "combobox:test-combobox"
      assert result["data-scope"] == "combobox"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{
        id: "test-combobox",
        dir: "ltr",
        required: false,
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.label(assigns)
      assert result["id"] == "combobox:test-combobox:label"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-combobox", dir: "ltr", disabled: false, invalid: false}
      result = Connect.control(assigns)
      assert result["id"] == "combobox:test-combobox:control"
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes" do
      assigns = %{
        id: "test-combobox",
        dir: "ltr",
        disabled: false,
        invalid: false,
        placeholder: nil,
        auto_focus: false
      }

      result = Connect.input(assigns)
      assert result["data-part"] == "input"
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes" do
      assigns = %{id: "test-combobox", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["data-part"] == "positioner"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-combobox", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["data-part"] == "content"
    end
  end

  describe "Connect.props/1" do
    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-combobox",
        collection: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_combobox_props(), assigns))
      assert result["id"] == "test-combobox"
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-combobox",
        collection: [%{id: "a", label: "A"}],
        controlled: true,
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_combobox_props(), assigns))
      assert result["data-value"] == "a"
    end
  end

  defp default_combobox_props do
    %{
      invalid: false,
      read_only: false,
      disabled: false,
      name: nil,
      open: false,
      placeholder: nil,
      always_submit_on_enter: false,
      auto_focus: false,
      close_on_select: false,
      input_behavior: "autohighlight",
      loop_focus: false,
      multiple: false,
      form: nil,
      required: false,
      positioning: nil,
      on_open_change: nil,
      on_open_change_client: nil,
      on_input_value_change: nil,
      on_value_change: nil,
      bubble: false,
      filter: true
    }
  end
end
