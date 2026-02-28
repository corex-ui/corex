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

  describe "Connect.value_text/1" do
    test "returns value text attributes" do
      assigns = %{id: "test-listbox"}
      result = Connect.value_text(assigns)
      assert result["id"] == "listbox:test-listbox:value-text"
      assert result["data-part"] == "value-text"
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes" do
      assigns = %{id: "test-listbox"}
      result = Connect.input(assigns)
      assert result["id"] == "listbox:test-listbox:input"
      assert result["data-part"] == "input"
    end
  end

  describe "Connect.item_group/1" do
    test "returns item group attributes" do
      assigns = %{id: "test-listbox", group_id: "g1"}
      result = Connect.item_group(assigns)
      assert result["id"] == "listbox:test-listbox:item-group:g1"
      assert result["data-part"] == "item-group"
      assert result["data-id"] == "g1"
    end
  end

  describe "Connect.item_group_label/1" do
    test "returns item group label attributes" do
      assigns = %{id: "test-listbox", html_for: "g1"}
      result = Connect.item_group_label(assigns)
      assert result["id"] == "listbox:test-listbox:item-group-label:g1"
      assert result["data-part"] == "item-group-label"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes" do
      assigns = %{id: "test-listbox", value: "opt1"}
      result = Connect.item(assigns)
      assert result["id"] == "listbox:test-listbox:item:opt1"
      assert result["data-part"] == "item"
      assert result["data-value"] == "opt1"
    end
  end

  describe "Connect.item_text/1" do
    test "returns item text attributes" do
      assigns = %{id: "test-listbox", item: %{id: "x", label: "X"}}
      result = Connect.item_text(assigns)
      assert result["id"] == "listbox:test-listbox:item-text:x"
      assert result["data-part"] == "item-text"
    end

    test "uses value when item has value key" do
      assigns = %{id: "test-listbox", item: %{value: "v1", label: "L"}}
      result = Connect.item_text(assigns)
      assert result["id"] == "listbox:test-listbox:item-text:v1"
    end
  end

  describe "Connect.item_indicator/1" do
    test "returns item indicator attributes" do
      assigns = %{id: "test-listbox", item: %{id: "y", label: "Y"}}
      result = Connect.item_indicator(assigns)
      assert result["id"] == "listbox:test-listbox:item-indicator:y"
      assert result["data-part"] == "item-indicator"
    end
  end

  describe "Connect.props/1" do
    test "returns props when controlled" do
      assigns = %{
        id: "test-listbox",
        collection: [%{id: "a", label: "A"}],
        controlled: true,
        value: ["a"],
        dir: "ltr",
        orientation: "vertical",
        loop_focus: false,
        selection_mode: "single",
        select_on_highlight: false,
        deselectable: false,
        typeahead: false,
        disabled: false,
        on_value_change: nil,
        on_value_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-value"] == "a"
      assert result["data-controlled"] == ""
    end

    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-listbox",
        collection: [%{id: "a", label: "A"}],
        controlled: false,
        value: ["a"],
        dir: "ltr",
        orientation: "vertical",
        loop_focus: false,
        selection_mode: "single",
        select_on_highlight: false,
        deselectable: false,
        typeahead: false,
        disabled: false,
        on_value_change: nil,
        on_value_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == "a"
      assert result["data-value"] == nil
    end
  end

  describe "listbox/1 with options" do
    test "renders with grouped collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox_grouped/1, [])
      assert html =~ ~r/data-scope="listbox"/
    end

    test "renders with controlled" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox_controlled/1, [])
      assert html =~ ~r/data-scope="listbox"/
      assert html =~ ~r/data-controlled/
    end

    test "renders with Corex.List.Item collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox_list_items/1, [])
      assert html =~ ~r/data-scope="listbox"/
      assert html =~ ~r/Item 1/
      assert html =~ ~r/Item 2/
    end
  end
end
