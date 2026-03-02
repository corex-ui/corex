defmodule Corex.ContentTest do
  use ExUnit.Case, async: true

  alias Corex.Content
  alias Corex.Content.Item

  describe "Content.new/1" do
    test "returns empty list for empty input" do
      assert Content.new([]) == []
    end

    test "creates list of items from keyword lists" do
      items =
        Content.new([
          [trigger: "T1", content: "C1"],
          [trigger: "T2", content: "C2"]
        ])

      assert length(items) == 2
      assert Enum.all?(items, &is_struct(&1, Item))
      assert Enum.at(items, 0).trigger == "T1"
      assert Enum.at(items, 0).content == "C1"
      assert Enum.at(items, 1).trigger == "T2"
      assert Enum.at(items, 1).content == "C2"
    end

    test "creates list of items from maps" do
      items =
        Content.new([
          %{trigger: "T1", content: "C1"},
          %{trigger: "T2", content: "C2"}
        ])

      assert length(items) == 2
      assert Enum.at(items, 0).trigger == "T1"
      assert Enum.at(items, 1).trigger == "T2"
    end

    test "accepts id, disabled, meta on items" do
      items =
        Content.new([
          [id: "custom-id", trigger: "T1", content: "C1", disabled: true, meta: %{x: 1}]
        ])

      assert length(items) == 1
      assert Enum.at(items, 0).id == "custom-id"
      assert Enum.at(items, 0).disabled == true
      assert Enum.at(items, 0).meta == %{x: 1}
    end

    test "raises for invalid list format" do
      assert_raise ArgumentError, ~r/invalid item format/, fn ->
        Content.new(["not", "keyword"])
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
      item = Item.new(trigger: "Lorem", content: "Consectetur")
      assert item.trigger == "Lorem"
      assert item.content == "Consectetur"
      assert is_binary(item.id)
      assert String.starts_with?(item.id, "content-")
      assert item.disabled == false
    end

    test "creates item from map" do
      item = Item.new(%{trigger: "T", content: "C"})
      assert item.trigger == "T"
      assert item.content == "C"
    end

    test "accepts explicit id" do
      item = Item.new(id: "my-id", trigger: "T", content: "C")
      assert item.id == "my-id"
    end

    test "raises when trigger missing" do
      assert_raise ArgumentError, ~r/Required fields/, fn ->
        Item.new(content: "C only")
      end
    end

    test "raises when content missing" do
      assert_raise ArgumentError, ~r/Required fields/, fn ->
        Item.new(trigger: "T only")
      end
    end

    test "raises for non-keyword non-map input" do
      assert_raise ArgumentError, ~r/Expected a keyword list or map/, fn ->
        Item.new("string")
      end

      assert_raise ArgumentError, ~r/Expected a keyword list or map/, fn ->
        Item.new(123)
      end
    end
  end

  describe "Content.generate_id/0" do
    test "returns unique id string" do
      id1 = Content.generate_id()
      id2 = Content.generate_id()
      assert is_binary(id1)
      assert String.starts_with?(id1, "content-")
      refute id1 == id2
    end
  end
end
