defmodule Corex.CheckboxTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Checkbox
  alias Corex.Checkbox.Connect

  describe "checkbox/1" do
    test "renders" do
      html = render_component(&Checkbox.checkbox/1, checked: false, name: "cb")
      assert html =~ ~r/data-scope="checkbox"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/data-js="pending"/
    end

    test "renders with checked true has data-state checked on root and control" do
      html = render_component(&Checkbox.checkbox/1, checked: true, name: "cb")
      assert html =~ ~r/data-state="checked"/
    end

    test "renders controlled with checked true has data-checked and no data-default-checked" do
      html = render_component(&Checkbox.checkbox/1, controlled: true, checked: true, name: "cb")
      assert html =~ ~r/data-controlled/
      assert html =~ ~r/data-checked/
      refute html =~ ~r/data-default-checked/
    end

    test "renders uncontrolled with checked true has data-default-checked and no data-checked" do
      html = render_component(&Checkbox.checkbox/1, controlled: false, checked: true, name: "cb")
      assert html =~ ~r/data-default-checked/
      refute html =~ ~r/data-checked/
    end

    test "renders with errors displays error container" do
      html = render_component(&Checkbox.checkbox/1, name: "cb", errors: ["is required"])
      assert html =~ ~r/data-part="error"/
    end

    test "renders with field from form has correct hidden input name and id" do
      form = Phoenix.Component.to_form(%{"terms" => false}, as: :user)
      html = render_component(&Checkbox.checkbox/1, field: form[:terms])
      assert html =~ ~r/name="user\[terms\]"/
      assert html =~ ~r/id="user_terms"/
    end
  end

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
