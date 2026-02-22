defmodule Corex.ComboboxTest do
  use ExUnit.Case, async: true

  alias Corex.Combobox.Connect

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
end
