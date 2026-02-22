defmodule Corex.NumberInputTest do
  use ExUnit.Case, async: true

  alias Corex.NumberInput.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-number"}
      result = Connect.root(assigns)
      assert result["id"] == "number-input:test-number"
      assert result["data-scope"] == "number-input"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-number"}
      result = Connect.label(assigns)
      assert result["id"] == "number-input:test-number:label"
      assert result["for"] == "number-input:test-number:input"
    end
  end
end
