defmodule Corex.EditableTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Editable.Connect

  describe "editable/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_editable/1, [])
      assert html =~ ~r/data-scope="editable"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-editable", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "editable:test-editable"
      assert result["data-scope"] == "editable"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.area/1" do
    test "returns area attributes" do
      assigns = %{
        id: "test-editable",
        dir: "ltr",
        editing: false,
        empty: false,
        auto_resize: true
      }

      result = Connect.area(assigns)
      assert result["data-scope"] == "editable"
      assert result["data-part"] == "area"
    end
  end
end
