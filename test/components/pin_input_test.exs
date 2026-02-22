defmodule Corex.PinInputTest do
  use ExUnit.Case, async: true

  alias Corex.PinInput.Connect

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
