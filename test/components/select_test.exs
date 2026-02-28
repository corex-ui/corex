defmodule Corex.SelectTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Select.Connect

  describe "select/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_select/1, [])
      assert html =~ ~r/data-scope="select"/
      assert html =~ ~r/data-part="root"/
    end
  end

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

  describe "Connect.positioner/1" do
    test "returns positioner attributes" do
      assigns = %{id: "test-select", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["data-part"] == "positioner"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-select", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["data-part"] == "content"
    end
  end

  describe "Connect.props/1" do
    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-select",
        collection: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["id"] == "test-select"
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-select",
        collection: [%{id: "a", label: "A"}],
        controlled: true,
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["data-value"] == "a"
    end
  end

  defp default_select_props do
    %{
      invalid: false,
      read_only: false,
      disabled: false,
      name: nil,
      placeholder: nil,
      close_on_select: true,
      loop_focus: false,
      multiple: false,
      form: nil,
      required: false,
      positioning: nil,
      on_value_change: nil,
      on_value_change_client: nil,
      redirect: false,
      redirect_new_tab: false
    }
  end
end
