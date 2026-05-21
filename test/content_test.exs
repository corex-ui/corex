defmodule Corex.ContentTest do
  use ExUnit.Case, async: true

  alias Corex.Content
  alias Corex.Content.Item

  describe "Content.new/1" do
    test "returns empty list for empty input" do
      assert Content.new([]) == []
    end

    test "raises when row uses :trigger instead of :label" do
      assert_raise ArgumentError, fn ->
        Content.new([%{trigger: "Q1", content: "A1"}])
      end
    end

    test "raises when row has unknown :trigger alongside :label" do
      assert_raise ArgumentError, fn ->
        Content.new([%{label: "L", trigger: "ignored", content: "C"}])
      end
    end

    test "creates list of items from maps" do
      items =
        Content.new([
          %{label: "T1", content: "C1"},
          %{label: "T2", content: "C2"}
        ])

      assert length(items) == 2
      assert Enum.all?(items, &is_struct(&1, Item))
      assert Enum.at(items, 0).label == "T1"
      assert Enum.at(items, 0).content == "C1"
      assert Enum.at(items, 1).label == "T2"
      assert Enum.at(items, 1).content == "C2"
    end

    test "creates list of items from keyword lists" do
      items =
        Content.new([
          [label: "T1", content: "C1"],
          [label: "T2", content: "C2", disabled: true]
        ])

      assert length(items) == 2
      assert Enum.at(items, 0).value == "item-1"
      assert Enum.at(items, 1).disabled == true
    end

    test "raises when row is not a map or keyword list" do
      assert_raise ArgumentError, ~r/Expected a map or keyword list/, fn ->
        Content.new([%{label: "T1", content: "C1"}, "invalid"])
      end
    end

    test "raises when keyword list row is not a keyword list" do
      assert_raise ArgumentError, ~r/invalid items/, fn ->
        Content.new([["not", "keywords"]])
      end
    end

    test "accepts value, disabled, meta on items" do
      items =
        Content.new([
          %{value: "custom-id", label: "T1", content: "C1", disabled: true, meta: %{x: 1}}
        ])

      assert length(items) == 1
      assert Enum.at(items, 0).value == "custom-id"
      assert Enum.at(items, 0).disabled == true
      assert Enum.at(items, 0).meta == %{x: 1}
    end

    test "raises when row contains unknown :id" do
      assert_raise ArgumentError, ~r/Failed to create Corex.Content.Item/, fn ->
        Content.new([%{id: "x", label: "T1", content: "C1"}])
      end
    end

    test "raises for invalid list format" do
      assert_raise ArgumentError, ~r/invalid items/, fn ->
        Content.new(["not", "keyword"])
      end

      assert_raise ArgumentError, ~r/invalid items/, fn ->
        Content.new([1, 2, 3])
      end
    end

    test "raises for non-list input" do
      assert_raise ArgumentError, ~r/Expected a list/, fn ->
        Content.new("not a list")
      end

      assert_raise ArgumentError, ~r/Expected a list/, fn ->
        Content.new(%{})
      end
    end
  end

  describe "Content.Item.new/1" do
    test "creates item with required fields" do
      item = Item.new(%{value: "item-1", label: "Lorem", content: "Consectetur"})
      assert item.label == "Lorem"
      assert item.content == "Consectetur"
      assert item.disabled == false
    end

    test "creates item from map" do
      item = Item.new(%{value: "item-1", label: "T", content: "C"})
      assert item.label == "T"
      assert item.content == "C"
    end

    test "raises when map has :trigger instead of :label" do
      assert_raise ArgumentError, fn ->
        Item.new(%{value: "v", trigger: "Question", content: "Answer"})
      end
    end

    test "auto-generates value when omitted" do
      item = Item.new(%{label: "Lorem", content: "C"})
      assert item.label == "Lorem"
      assert String.starts_with?(item.value, "content-")
    end

    test "accepts explicit value" do
      item = Item.new(%{value: "my-id", label: "T", content: "C"})
      assert item.value == "my-id"
    end

    test "raises when label missing" do
      assert_raise ArgumentError, ~r/Failed to create Corex\.Content\.Item/, fn ->
        Item.new(%{value: "item-1", content: "C only"})
      end
    end

    test "raises when content missing" do
      assert_raise ArgumentError, ~r/Failed to create Corex\.Content\.Item/, fn ->
        Item.new(%{value: "item-1", label: "T only"})
      end
    end

    test "raises for non-keyword non-map input" do
      assert_raise ArgumentError, ~r/Expected a map/, fn ->
        Item.new("string")
      end

      assert_raise ArgumentError, ~r/Expected a map/, fn ->
        Item.new(123)
      end
    end
  end

  test "Item.new generates unique content- prefixed values" do
    item1 = Item.new(%{label: "A", content: "C"})
    item2 = Item.new(%{label: "B", content: "D"})
    assert String.starts_with?(item1.value, "content-")
    assert String.starts_with?(item2.value, "content-")
    refute item1.value == item2.value
  end
end
