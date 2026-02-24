defmodule Corex.SelectTest do
  use ExUnit.Case, async: true

  alias Corex.Select.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-select", invalid: false, read_only: false}
      result = Connect.root(assigns)
      assert result["id"] == "select:test-select"
      assert result["data-scope"] == "select"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{
        id: "test-select",
        dir: "ltr",
        required: false,
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.label(assigns)
      assert result["id"] == "select:test-select:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-select", dir: "ltr", disabled: false, invalid: false}
      result = Connect.control(assigns)
      assert result["id"] == "select:test-select:control"
      assert result["data-scope"] == "select"
    end
  end
end
