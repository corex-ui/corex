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

    test "rtl applies dir on root only not on input" do
      html =
        render_component(&PasswordInput.password_input/1,
          id: "rtl-markup-test",
          name: "secret",
          dir: "rtl"
        )

      assert [{"div", root_attrs, _} | _] = find_in_html(html, ~S([data-part="root"]))
      assert {"dir", "rtl"} in root_attrs

      assert [{"input", input_attrs, _} | _] = find_in_html(html, ~S([data-part="input"]))
      refute Enum.any?(input_attrs, fn {k, _} -> k == "dir" end)
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes with dir" do
      assigns = %{id: "test-password", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "password-input:test-password"
      assert result["data-scope"] == "password-input"
      assert result["data-part"] == "root"
      assert result["dir"] == "ltr"
    end

    test "returns rtl dir on root" do
      assigns = %{id: "test-password", dir: "rtl"}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes without dir" do
      assigns = %{id: "test-password"}
      result = Connect.label(assigns)
      assert result["data-scope"] == "password-input"
      assert result["data-part"] == "label"
      assert result["for"] == "p-input-test-password-input"
      refute Map.has_key?(result, "dir")
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes without dir" do
      assigns = %{id: "test-password"}
      result = Connect.control(assigns)
      assert result["id"] == "password-input:test-password:control"
      assert result["data-part"] == "control"
      refute Map.has_key?(result, "dir")
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes with name without dir" do
      assigns = %{id: "test-password", name: "pass", disabled: false}
      result = Connect.input(assigns)
      assert result["id"] == "p-input-test-password-input"
      assert result["name"] == "pass"
      assert result["data-part"] == "input"
      refute Map.has_key?(result, "dir")
    end
  end

  describe "Connect.visibility_trigger/1" do
    test "returns visibility trigger attributes without dir" do
      assigns = %{id: "test-password"}
      result = Connect.visibility_trigger(assigns)
      assert result["data-part"] == "visibility-trigger"
      assert result["aria-label"] == "Toggle password visibility"
      refute Map.has_key?(result, "dir")
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes without dir" do
      assigns = %{id: "test-password"}
      result = Connect.indicator(assigns)
      assert result["data-part"] == "indicator"
      assert result["aria-hidden"] == "true"
      refute Map.has_key?(result, "dir")
    end
  end

  describe "Connect.props/1" do
    test "maps visible to default-visible only" do
      assigns = %{
        id: "test-password",
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
      assert result["data-default-visible"] == ""
      refute Map.has_key?(result, "data-visible")
    end
  end
end
