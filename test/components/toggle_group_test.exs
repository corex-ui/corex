defmodule Corex.ToggleGroupTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.ToggleGroup
  alias Corex.ToggleGroup.Connect

  describe "toggle_group/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_toggle_group/1, [])
      assert html =~ ~r/data-scope="toggle-group"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "set_value/2" do
    test "returns JS command with single value" do
      js = ToggleGroup.set_value("my-toggle-group", ["item-1"])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command with multiple values" do
      js = ToggleGroup.set_value("my-toggle-group", ["item-1", "item-2"])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "accepts empty list" do
      js = ToggleGroup.set_value("my-toggle-group", [])
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = ToggleGroup.set_value(socket, "my-toggle-group", ["item-1"])
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-toggle", dir: "ltr", orientation: "horizontal", disabled: false}
      result = Connect.root(assigns)
      assert result["id"] == "toggle-group:test-toggle"
      assert result["data-scope"] == "toggle-group"
      assert result["data-part"] == "root"
      assert result["data-orientation"] == "horizontal"
    end

    test "computes root with vertical orientation" do
      assigns = %{id: "test-toggle", dir: "ltr", orientation: "vertical", disabled: false}
      result = Connect.root(assigns)
      assert result["data-orientation"] == "vertical"
    end
  end

  describe "Connect.props/1" do
    test "returns correct value encoding for controlled and uncontrolled" do
      # uncontrolled with value
      assigns_unc = %Corex.ToggleGroup.Anatomy.Props{
        id: "t1",
        value: ["a", "b"],
        controlled: false,
        deselectable: true,
        loopFocus: true,
        rovingFocus: true,
        disabled: false,
        multiple: true,
        orientation: "horizontal",
        dir: "ltr",
        on_value_change: nil,
        on_value_change_client: nil
      }

      props_unc = Connect.props(assigns_unc)
      assert props_unc["data-default-value"] == "a,b"
      assert props_unc["data-value"] == nil
      assert props_unc["data-deselectable"] == ""
      assert props_unc["data-loop-focus"] == ""

      # controlled with value
      assigns_ctrl = %Corex.ToggleGroup.Anatomy.Props{
        id: "t2",
        value: ["c"],
        controlled: true,
        deselectable: false,
        loopFocus: false,
        rovingFocus: false,
        disabled: true,
        multiple: false,
        orientation: "vertical",
        dir: "rtl",
        on_value_change: "vc",
        on_value_change_client: "vcc"
      }

      props_ctrl = Connect.props(assigns_ctrl)
      assert props_ctrl["data-default-value"] == nil
      assert props_ctrl["data-value"] == "c"
      assert props_ctrl["data-disabled"] == ""
      assert props_ctrl["data-multiple"] == nil
    end
  end

  describe "Connect.validate_value!/1" do
    test "raises error on non-list" do
      assert_raise ArgumentError, ~r/value must be a list of strings, got: "not a list"/, fn ->
        Connect.validate_value!("not a list")
      end
    end

    test "raises error on list with non-strings" do
      assert_raise ArgumentError, ~r/value must be a list of strings, got: \["a", 1\]/, fn ->
        Connect.validate_value!(["a", 1])
      end
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes when off" do
      assigns = %{
        id: "test-toggle",
        value: "opt-1",
        values: [],
        dir: "ltr",
        orientation: "horizontal",
        disabled: false,
        disabled_root: false,
        aria_label: nil
      }

      result = Connect.item(assigns)
      assert result["data-value"] == "opt-1"
      assert result["data-state"] == "off"
    end

    test "returns item attributes when on" do
      assigns = %{
        id: "test-toggle",
        value: "opt-1",
        values: ["opt-1"],
        dir: "ltr",
        orientation: "horizontal",
        disabled: false,
        disabled_root: false,
        aria_label: nil
      }

      result = Connect.item(assigns)
      assert result["data-state"] == "on"
    end
  end
end
