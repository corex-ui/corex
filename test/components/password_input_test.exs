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

    test "renders with all slots" do
      html = render_component(&CorexTest.ComponentHelpers.render_password_input_full/1, [])
      assert html =~ ~r/data-scope="password-input"/
      assert html =~ ~r/Password/
      assert html =~ ~r/Show|Hide/
    end

    test "renders with field" do
      html = render_component(&CorexTest.ComponentHelpers.render_password_input_with_field/1, [])
      assert html =~ ~r/data-scope="password-input"/
      assert html =~ ~r/name="user\[password\]"/
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

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-password", dir: "ltr"}
      result = Connect.control(assigns)
      assert result["id"] == "password-input:test-password:control"
      assert result["data-part"] == "control"
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes with name" do
      assigns = %{id: "test-password", dir: "ltr", name: "pass", disabled: false}
      result = Connect.input(assigns)
      assert result["id"] == "p-input-test-password-input"
      assert result["name"] == "pass"
      assert result["data-part"] == "input"
    end
  end

  describe "Connect.visibility_trigger/1" do
    test "returns visibility trigger attributes" do
      assigns = %{id: "test-password", dir: "ltr"}
      result = Connect.visibility_trigger(assigns)
      assert result["data-part"] == "visibility-trigger"
      assert result["aria-label"] == "Toggle password visibility"
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes" do
      assigns = %{id: "test-password", dir: "ltr"}
      result = Connect.indicator(assigns)
      assert result["data-part"] == "indicator"
      assert result["aria-hidden"] == "true"
    end
  end

  describe "Connect.props/1" do
    test "returns props when controlled visible" do
      assigns = %{
        id: "test-password",
        controlled_visible: true,
        visible: true,
        disabled: false,
        invalid: false,
        read_only: false,
        required: false,
        ignore_password_managers: false,
        name: "pass",
        form: nil,
        dir: "ltr",
        auto_complete: nil,
        on_visibility_change: nil,
        on_visibility_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-visible"] == ""
      assert result["data-default-visible"] == nil
    end

    test "returns props when uncontrolled visible" do
      assigns = %{
        id: "test-password",
        controlled_visible: false,
        visible: true,
        disabled: false,
        invalid: false,
        read_only: false,
        required: false,
        ignore_password_managers: false,
        name: nil,
        form: nil,
        dir: "ltr",
        auto_complete: nil,
        on_visibility_change: nil,
        on_visibility_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-visible"] != nil
      assert result["data-visible"] == nil
    end
  end
end
