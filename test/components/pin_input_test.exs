defmodule Corex.PinInputTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.PinInput
  alias Corex.PinInput.Connect

  describe "pin_input/1" do
    test "renders" do
      html = render_component(&PinInput.pin_input/1, name: "pin", length: 4)
      assert html =~ ~r/data-scope="pin-input"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-pin", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "pin-input:test-pin"
      assert result["data-scope"] == "pin-input"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-pin", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "pin-input:test-pin:label"
    end
  end
end
