defmodule Corex.TreeTest do
  use ExUnit.Case, async: true

  alias Corex.Tree
  alias Corex.Tree.Item

  describe "Tree.new/1" do
    test "returns empty list for empty input" do
      assert Tree.new([]) == []
    end

    test "creates list of items from keyword lists" do
      items =
        Tree.new([
          [label: "File", id: "file"],
          [label: "Edit"]
        ])

      assert length(items) == 2
      assert Enum.all?(items, &is_struct(&1, Item))
      assert Enum.at(items, 0).label == "File"
      assert Enum.at(items, 0).id == "file"
      assert Enum.at(items, 1).label == "Edit"
    end

    test "creates nested items with children" do
      items =
        Tree.new([
          [label: "File", children: [[label: "New"], [label: "Open"]]]
        ])

      assert length(items) == 1
      assert Enum.at(items, 0).label == "File"
      assert length(Enum.at(items, 0).children) == 2
      assert Enum.at(Enum.at(items, 0).children, 0).label == "New"
      assert Enum.at(Enum.at(items, 0).children, 1).label == "Open"
    end

    test "creates items from maps" do
      items = Tree.new([%{label: "Map item", id: "map1"}])
      assert length(items) == 1
      assert Enum.at(items, 0).label == "Map item"
      assert Enum.at(items, 0).id == "map1"
    end

    test "creates items with group and meta" do
      items =
        Tree.new([
          [label: "A1", id: "a1", group: "Group A"],
          [label: "B1", id: "b1", group: "Group B", meta: %{key: "val"}]
        ])

      assert length(items) == 2
      assert Enum.at(items, 0).group == "Group A"
      assert Enum.at(items, 1).group == "Group B"
      assert Enum.at(items, 1).meta == %{key: "val"}
    end

    test "raises for invalid list format" do
      assert_raise ArgumentError, ~r/invalid item format/, fn ->
        Tree.new(["a", "b"])
      end
    end

    test "raises for non-list input" do
      assert_raise ArgumentError, ~r/Expected a list/, fn ->
        Tree.new("not a list")
      end
    end
  end

  describe "Tree.Item.new/1" do
    test "creates item from map" do
      item = Item.new(%{label: "From map"})
      assert item.label == "From map"
      assert is_binary(item.id)
    end

    test "creates item with required label" do
      item = Item.new(label: "Foo")
      assert item.label == "Foo"
      assert is_binary(item.id)
      assert String.starts_with?(item.id, "tree-")
      assert item.children == []
    end

    test "creates item with children" do
      item = Item.new(label: "Parent", children: [[label: "Child"]])
      assert item.label == "Parent"
      assert length(item.children) == 1
      assert Enum.at(item.children, 0).label == "Child"
    end

    test "raises for invalid child type" do
      assert_raise ArgumentError, ~r/Invalid child item/, fn ->
        Item.new(label: "Parent", children: [[label: "Valid"], 123])
      end
    end

    test "raises when label missing" do
      assert_raise ArgumentError, ~r/Required fields/, fn ->
        Item.new(id: "x")
      end
    end

    test "raises for non-keyword non-map input" do
      assert_raise ArgumentError, ~r/Expected a keyword list or map/, fn ->
        Item.new("string")
      end
    end
  end

  describe "Tree.generate_id/0" do
    test "returns unique id" do
      id1 = Tree.generate_id()
      id2 = Tree.generate_id()
      assert is_binary(id1)
      assert String.starts_with?(id1, "tree-")
      refute id1 == id2
    end
  end
end
