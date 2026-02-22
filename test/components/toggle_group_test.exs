defmodule Corex.ToggleGroupTest do
  use ExUnit.Case, async: true

  alias Corex.ToggleGroup
  alias Corex.ToggleGroup.Connect

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
