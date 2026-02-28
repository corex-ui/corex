defmodule Corex.ListTest do
  use ExUnit.Case, async: true

  alias Corex.List
  alias Corex.List.Item

  describe "List.new/1" do
    test "returns empty list for empty input" do
      assert List.new([]) == []
    end

    test "creates list of items from keyword lists" do
      items =
        List.new([
          [label: "A", id: "a"],
          [label: "B"]
        ])

      assert length(items) == 2
      assert Enum.all?(items, &is_struct(&1, Item))
      assert Enum.at(items, 0).label == "A"
      assert Enum.at(items, 0).id == "a"
      assert Enum.at(items, 1).label == "B"
      assert is_binary(Enum.at(items, 1).id)
    end

    test "creates list from maps" do
      items = List.new([%{label: "X"}, %{label: "Y"}])
      assert length(items) == 2
      assert Enum.at(items, 0).label == "X"
    end

    test "raises for invalid list format" do
      assert_raise ArgumentError, ~r/invalid item format/, fn ->
        List.new(["a", "b"])
      end
    end

    test "raises for non-list input" do
      assert_raise ArgumentError, ~r/Expected a list/, fn ->
        List.new("not a list")
      end
    end
  end

  describe "List.Item.new/1" do
    test "creates item with required label" do
      item = Item.new(label: "Foo")
      assert item.label == "Foo"
      assert is_binary(item.id)
      assert String.starts_with?(item.id, "list-")
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

  describe "List.generate_id/0" do
    test "returns unique id" do
      id1 = List.generate_id()
      id2 = List.generate_id()
      assert is_binary(id1)
      assert String.starts_with?(id1, "list-")
      refute id1 == id2
    end
  end
end
