defmodule Corex.TreeTest do
  use ExUnit.Case, async: true

  alias Corex.Tree
  alias Corex.Tree.Item

  describe "Tree.new/1" do
    test "returns empty list for empty input" do
      assert Tree.new([]) == []
    end

    test "creates list of items from maps" do
      items =
        Tree.new([
          %{label: "File", value: "file"},
          %{label: "Edit"}
        ])

      assert length(items) == 2
      assert Enum.all?(items, &is_struct(&1, Item))
      assert Enum.at(items, 0).label == "File"
      assert Enum.at(items, 0).value == "file"
      assert Enum.at(items, 1).label == "Edit"
    end

    test "creates nested items with children" do
      items =
        Tree.new([
          %{label: "File", children: [%{label: "New"}, %{label: "Open"}]}
        ])

      assert length(items) == 1
      assert Enum.at(items, 0).label == "File"
      assert length(Enum.at(items, 0).children) == 2
      assert Enum.at(Enum.at(items, 0).children, 0).label == "New"
      assert Enum.at(Enum.at(items, 0).children, 1).label == "Open"
    end

    test "creates items with group and meta" do
      items =
        Tree.new([
          %{label: "A1", value: "a1", group: "Group A"},
          %{label: "B1", value: "b1", group: "Group B", meta: %{key: "val"}}
        ])

      assert length(items) == 2
      assert Enum.at(items, 0).group == "Group A"
      assert Enum.at(items, 1).group == "Group B"
      assert Enum.at(items, 1).meta == %{key: "val"}
    end

    test "raises for list of non-maps" do
      assert_raise ArgumentError, ~r/non-map items/, fn ->
        Tree.new(["a", "b"])
      end
    end

    test "raises for list of keyword lists" do
      assert_raise ArgumentError, ~r/non-map items/, fn ->
        Tree.new([[label: "Keyword"]])
      end
    end

    test "raises when nested child map uses unknown :id" do
      assert_raise ArgumentError, ~r/key :id not found/, fn ->
        Tree.new([%{label: "P", children: [%{label: "C", id: "bad"}]}])
      end
    end

    test "raises for non-list input" do
      assert_raise ArgumentError, ~r/Expected a list of maps/, fn ->
        Tree.new("not a list")
      end
    end
  end

  describe "Tree.Item.new/1" do
    test "creates item from map" do
      item = Item.new(%{label: "From map"})
      assert item.label == "From map"
      assert is_binary(item.value)
      assert String.starts_with?(item.value, "tree-")
      assert item.children == []
    end

    test "preserves explicit value" do
      item = Item.new(%{label: "Foo", value: "custom"})
      assert item.value == "custom"
    end

    test "raises when map contains unknown :id" do
      assert_raise ArgumentError, ~r/key :id not found/, fn ->
        Item.new(%{label: "X", id: "only-id"})
      end
    end

    test "creates item with children" do
      item = Item.new(%{label: "Parent", children: [%{label: "Child"}]})
      assert item.label == "Parent"
      assert length(item.children) == 1
      assert Enum.at(item.children, 0).label == "Child"
    end

    test "passes through existing Tree.Item children without re-wrapping" do
      child = Item.new(%{label: "Prebuilt", value: "prebuilt"})
      parent = Item.new(%{label: "Parent", children: [child]})

      assert length(parent.children) == 1
      assert Enum.at(parent.children, 0) == child
    end

    test "raises for invalid child type" do
      assert_raise ArgumentError, ~r/Invalid child item/, fn ->
        Item.new(%{label: "Parent", children: [%{label: "Valid"}, 123]})
      end
    end

    test "raises when label missing" do
      assert_raise ArgumentError, ~r/Required fields/, fn ->
        Item.new(%{value: "x"})
      end
    end

    test "raises for keyword list input" do
      assert_raise ArgumentError, ~r/Expected a map/, fn ->
        Item.new(label: "Foo")
      end
    end

    test "raises for non-keyword non-map input" do
      assert_raise ArgumentError, ~r/Expected a map/, fn ->
        Item.new("string")
      end
    end
  end

  test "Item.new generates unique tree- prefixed values" do
    item1 = Item.new(%{label: "A"})
    item2 = Item.new(%{label: "B"})
    assert String.starts_with?(item1.value, "tree-")
    assert String.starts_with?(item2.value, "tree-")
    refute item1.value == item2.value
  end

  describe "validate_items_assigns!/2" do
    test "allows nil items for menu" do
      assert Tree.validate_items_assigns!(%{items: nil}, component: "menu") == %{items: nil}
    end

    test "raises when tree_view items nil" do
      assert_raise ArgumentError, ~r/tree_view requires/, fn ->
        Tree.validate_items_assigns!(%{items: nil}, component: "tree_view", required: true)
      end
    end

    test "raises for invalid item struct" do
      assert_raise ArgumentError, ~r/Expected %Corex.Tree.Item/, fn ->
        Tree.validate_items_assigns!(%{items: [%{label: "x"}]}, component: "menu")
      end
    end
  end
end
