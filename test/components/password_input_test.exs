defmodule Corex.PasswordInputTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.PasswordInput
  alias Corex.PasswordInput.Connect

  describe "password_input/1" do
    test "renders" do
      html = render_component(&PasswordInput.password_input/1, name: "pass")
      assert html =~ ~r/data-scope="password-input"/
      assert html =~ ~r/data-part="root"/
    end
  end

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
