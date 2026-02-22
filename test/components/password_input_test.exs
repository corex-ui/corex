defmodule Corex.PasswordInputTest do
  use ExUnit.Case, async: true

  alias Corex.PasswordInput.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-password", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "password-input:test-password"
      assert result["data-scope"] == "password-input"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-password", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["data-scope"] == "password-input"
      assert result["data-part"] == "label"
      assert result["for"] == "p-input-test-password-input"
    end
  end
end
