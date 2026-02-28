defmodule Corex.ListboxTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Listbox.Connect

  describe "listbox/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox/1, [])
      assert html =~ ~r/data-scope="listbox"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-listbox", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "listbox:test-listbox"
      assert result["data-scope"] == "listbox"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-listbox", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "listbox:test-listbox:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-listbox", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["id"] == "listbox:test-listbox:content"
    end
  end
end
