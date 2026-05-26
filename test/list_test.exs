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
          [label: "A", value: "a"],
          [label: "B"]
        ])

      assert length(items) == 2
      assert Enum.all?(items, &is_struct(&1, Item))
      assert Enum.at(items, 0).label == "A"
      assert Enum.at(items, 0).value == "a"
      assert Enum.at(items, 1).label == "B"
      assert Enum.at(items, 1).value == "item-2"
    end

    test "creates list from maps" do
      items = List.new([%{label: "X"}, %{label: "Y"}])
      assert length(items) == 2
      assert Enum.at(items, 0).label == "X"
    end

    test "raises for invalid list format" do
      assert_raise ArgumentError, ~r/Expected keyword lists, maps, or %Corex\.List\.Item/, fn ->
        List.new(["a", "b"])
      end
    end

    test "passes through existing Item structs" do
      i1 = Item.new(label: "A", value: "a")
      i2 = Item.new(label: "B", value: "b")
      assert List.new([i1, i2]) == [i1, i2]
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
      assert is_binary(item.value)
      assert String.starts_with?(item.value, "list-")
    end

    test "raises when label missing" do
      assert_raise ArgumentError, ~r/Required fields/, fn ->
        Item.new(value: "x")
      end
    end

    test "raises for non-keyword non-map input" do
      assert_raise ArgumentError, ~r/Expected a keyword list or map/, fn ->
        Item.new("string")
      end
    end
  end

  test "Item.new generates unique list- prefixed values" do
    item1 = Item.new(%{label: "A"})
    item2 = Item.new(%{label: "B"})
    assert String.starts_with?(item1.value, "list-")
    assert String.starts_with?(item2.value, "list-")
    refute item1.value == item2.value
  end
end
