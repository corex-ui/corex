defmodule Corex.CheckboxTest do
  use CorexTest.ComponentCase, async: true
  use Phoenix.Component

  import Corex.Checkbox

  alias Corex.Checkbox
  alias Corex.Checkbox.Connect

  defp checkbox_with_indicator_slots(assigns) do
    ~H"""
    <.checkbox id="test-checkbox"  name="cb">
      <:indicator><span id="ind-test">x</span></:indicator>
      <:indeterminate><span id="indet-test">y</span></:indeterminate>
    </.checkbox>
    """
  end

  describe "checkbox/1" do
    test "renders" do
      html =
        render_component(&Checkbox.checkbox/1, id: "test-checkbox", checked: false, name: "cb")

      assert html =~ ~r/data-scope="checkbox"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r//
    end

    test "renders with checked true has data-state checked on root and control" do
      html =
        render_component(&Checkbox.checkbox/1, id: "test-checkbox", checked: true, name: "cb")

      assert html =~ ~r/data-state="checked"/
    end

    test "renders controlled with checked true has data-checked and no data-default-checked" do
      html =
        render_component(&Checkbox.checkbox/1,
          id: "test-checkbox",
          controlled: true,
          checked: true,
          name: "cb"
        )

      assert html =~ ~r/data-controlled/
      assert html =~ ~r/data-checked="true"/
      refute html =~ ~r/data-default-checked/
    end

    test "renders controlled with checked false has data-checked false" do
      html =
        render_component(&Checkbox.checkbox/1,
          id: "test-checkbox",
          controlled: true,
          checked: false,
          name: "cb"
        )

      assert html =~ ~r/data-checked="false"/
    end

    test "renders uncontrolled with checked true has data-default-checked and no data-checked" do
      html =
        render_component(&Checkbox.checkbox/1,
          id: "test-checkbox",
          controlled: false,
          checked: true,
          name: "cb"
        )

      assert html =~ ~r/data-default-checked="true"/
      refute html =~ ~r/data-checked=/
    end

    test "renders indeterminate visual state and default attr" do
      html =
        render_component(&Checkbox.checkbox/1,
          id: "test-checkbox",
          controlled: false,
          checked: :indeterminate,
          name: "cb"
        )

      assert html =~ ~r/data-state="indeterminate"/
      assert html =~ ~r/data-default-checked="indeterminate"/
    end

    test "omits indicator and indeterminate surfaces when slots are empty" do
      html = render_component(&Checkbox.checkbox/1, id: "test-checkbox", name: "cb")
      refute html =~ ~r/data-part="indicator"/
      refute html =~ ~r/data-part="indeterminate"/
    end

    test "renders indicator and indeterminate parts when slots are used" do
      html = rendered_to_string(checkbox_with_indicator_slots(%{}))

      assert html =~ ~r/data-part="indicator"/
      assert html =~ ~r/data-part="indeterminate"/
      assert html =~ ~r/ind-test/
      assert html =~ ~r/indet-test/
    end

    test "renders with errors displays error container" do
      html =
        render_component(&Checkbox.checkbox/1,
          id: "test-checkbox",
          name: "cb",
          errors: ["is required"]
        )

      assert html =~ ~r/data-part="error"/
    end

    test "renders with field from form has correct hidden input name and id" do
      form = Phoenix.Component.to_form(%{"terms" => false}, as: :user)
      html = render_component(&Checkbox.checkbox/1, field: form[:terms])
      assert html =~ ~r/name="user\[terms\]"/
      assert html =~ ~r/id="user_terms"/
    end
  end

  describe "checkbox_skeleton/1" do
    test "renders loading root, control, label placeholder, and indicator" do
      html = render_component(&Checkbox.checkbox_skeleton/1, class: "checkbox")
      assert html =~ ~r/data-scope="checkbox"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/data-loading/
      assert html =~ ~r/data-part="control"/
      assert html =~ ~r/data-part="indicator"/
      assert html =~ ~r/data-part="label"/
      refute html =~ ~r/\bdir=/
      assert html =~ ~r/data-orientation="horizontal"/
    end

    test "passes dir and orientation to host and root" do
      html =
        render_component(&Checkbox.checkbox_skeleton/1,
          class: "checkbox",
          dir: "rtl",
          orientation: "vertical"
        )

      assert html =~ ~r/dir="rtl"/
      assert html =~ ~r/data-orientation="vertical"/
    end

    test "omits label placeholder when skeleton_label is false" do
      html =
        render_component(&Checkbox.checkbox_skeleton/1, skeleton_label: false, class: "checkbox")

      assert html =~ ~r/data-loading/
      assert html =~ ~r/data-part="control"/
      refute html =~ ~r/data-part="label"/
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
      assigns = %{id: "test-checkbox", dir: "ltr", checked: false, orientation: "horizontal"}
      result = Connect.root(assigns)
      assert result["id"] == "checkbox:test-checkbox"
      assert result["data-scope"] == "checkbox"
      assert result["data-part"] == "root"
      assert result["data-state"] == "unchecked"
    end

    test "data-state is checked when checked is true" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: true, orientation: "horizontal"}
      result = Connect.root(assigns)
      assert result["data-state"] == "checked"
    end

    test "data-state is indeterminate when checked is indeterminate" do
      assigns = %{
        id: "test-checkbox",
        dir: "ltr",
        checked: :indeterminate,
        orientation: "horizontal"
      }

      result = Connect.root(assigns)
      assert result["data-state"] == "indeterminate"
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

  describe "Connect.indeterminate/1" do
    test "returns indeterminate surface attributes" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: false}
      result = Connect.indeterminate(assigns)
      assert result["id"] == "checkbox:test-checkbox:indeterminate"
      assert result["data-part"] == "indeterminate"
      assert result["data-state"] == "unchecked"
    end

    test "indeterminate surface shows indeterminate state" do
      assigns = %{id: "test-checkbox", dir: "ltr", checked: :indeterminate}
      result = Connect.indeterminate(assigns)
      assert result["data-state"] == "indeterminate"
    end
  end
end
