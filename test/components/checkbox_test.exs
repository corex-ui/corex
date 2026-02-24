defmodule Corex.CheckboxTest do
  use ExUnit.Case, async: true

  alias Corex.Checkbox
  alias Corex.Checkbox.Connect

  describe "set_checked/2" do
    test "returns JS command when checked is true" do
      js = Checkbox.set_checked("my-checkbox", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when checked is false" do
      js = Checkbox.set_checked("my-checkbox", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_checked/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Checkbox.set_checked(socket, "my-checkbox", false)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "toggle_checked/1" do
    test "returns JS command" do
      js = Checkbox.toggle_checked("my-checkbox")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "toggle_checked/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Checkbox.toggle_checked(socket, "my-checkbox")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: false}
      result = Connect.root(assigns)
      assert result["id"] == "checkbox:test-checkbox"
      assert result["data-scope"] == "checkbox"
      assert result["data-part"] == "root"
      assert result["data-state"] == "unchecked"
    end

    test "data-state is checked when checked is true" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: true}
      result = Connect.root(assigns)
      assert result["data-state"] == "checked"
    end

    test "computes root with rtl direction" do
      assigns = %{id: "test-checkbox", dir: "rtl", checked: false}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.hidden_input/1" do
    test "returns hidden input attributes" do
      assigns = %{
        id: "test-checkbox",
        name: "terms",
        checked: false,
        disabled: false,
        required: false,
        invalid: false,
        value: "true",
        controlled: false
      }

      result = Connect.hidden_input(assigns)
      assert result["id"] == "checkbox:test-checkbox:input"
      assert result["type"] == "checkbox"
      assert result["value"] == "true"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: false}
      result = Connect.control(assigns)
      assert result["id"] == "checkbox:test-checkbox:control"
      assert result["data-scope"] == "checkbox"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: false}
      result = Connect.label(assigns)
      assert result["id"] == "checkbox:test-checkbox:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: false}
      result = Connect.indicator(assigns)
      assert result["id"] == "checkbox:test-checkbox:indicator"
      assert result["data-part"] == "indicator"
      assert result["data-state"] == "unchecked"
    end

    test "indicator shows checked state" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: true}
      result = Connect.indicator(assigns)
      assert result["data-state"] == "checked"
    end
  end
end
