defmodule Corex.SwitchTest do
  use ExUnit.Case, async: true

  alias Corex.Switch
  alias Corex.Switch.Connect

  describe "set_checked/2" do
    test "returns JS command when checked is true" do
      js = Switch.set_checked("my-switch", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when checked is false" do
      js = Switch.set_checked("my-switch", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_checked/3" do
    test "pushes event to socket with true" do
      socket = %Phoenix.LiveView.Socket{}
      result = Switch.set_checked(socket, "my-switch", true)
      assert %Phoenix.LiveView.Socket{} = result
    end

    test "pushes event to socket with false" do
      socket = %Phoenix.LiveView.Socket{}
      result = Switch.set_checked(socket, "my-switch", false)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "toggle_checked/1" do
    test "returns JS command" do
      js = Switch.toggle_checked("my-switch")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "toggle_checked/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Switch.toggle_checked(socket, "my-switch")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-switch", dir: "ltr", checked: false}
      result = Connect.root(assigns)
      assert result["id"] == "switch:test-switch"
      assert result["data-scope"] == "switch"
      assert result["data-part"] == "root"
      assert result["data-state"] == "unchecked"
      assert result["htmlFor"] == "switch:test-switch:input"
    end

    test "data-state is checked when checked is true" do
      assigns = %{id: "test-switch", dir: "ltr", checked: true}
      result = Connect.root(assigns)
      assert result["data-state"] == "checked"
    end

    test "computes root with rtl direction" do
      assigns = %{id: "test-switch", dir: "rtl", checked: false}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.hidden_input/1" do
    test "returns hidden input attributes when uncontrolled" do
      assigns = %{
        id: "test-switch",
        name: "notifications",
        checked: false,
        disabled: false,
        required: false,
        invalid: false,
        value: "true",
        controlled: false
      }

      result = Connect.hidden_input(assigns)
      assert result["id"] == "switch:test-switch:input"
      assert result["type"] == "checkbox"
      assert result["name"] == "notifications"
      assert result["value"] == "true"
      assert result["checked"] == nil
    end

    test "returns checked when controlled and checked" do
      assigns = %{
        id: "test-switch",
        name: nil,
        checked: true,
        disabled: false,
        required: false,
        invalid: false,
        value: "true",
        controlled: true
      }

      result = Connect.hidden_input(assigns)
      assert result["checked"] == ""
    end

    test "returns checked false when controlled and unchecked" do
      assigns = %{
        id: "test-switch",
        name: nil,
        checked: false,
        disabled: false,
        required: false,
        invalid: false,
        value: "true",
        controlled: true
      }

      result = Connect.hidden_input(assigns)
      assert result["checked"] == "false"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes when unchecked" do
      assigns = %{id: "test-switch", dir: "ltr", checked: false}
      result = Connect.control(assigns)
      assert result["id"] == "switch:test-switch:control"
      assert result["data-scope"] == "switch"
      assert result["data-part"] == "control"
      assert result["data-state"] == "unchecked"
    end

    test "returns control attributes when checked" do
      assigns = %{id: "test-switch", dir: "ltr", checked: true}
      result = Connect.control(assigns)
      assert result["data-state"] == "checked"
    end
  end

  describe "Connect.thumb/1" do
    test "returns thumb attributes" do
      assigns = %{id: "test-switch", dir: "ltr", checked: false}
      result = Connect.thumb(assigns)
      assert result["id"] == "switch:test-switch:thumb"
      assert result["data-part"] == "thumb"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-switch", dir: "ltr", checked: false}
      result = Connect.label(assigns)
      assert result["id"] == "switch:test-switch:label"
      assert result["data-part"] == "label"
    end
  end
end
