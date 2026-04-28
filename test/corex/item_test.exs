defmodule Corex.ItemTest do
  use ExUnit.Case, async: true

  alias Corex.Item

  describe "build/1" do
    test "builds from map with title and value" do
      item = Item.build(%{title: "Name", value: "Ada"})
      assert item.title == "Name"
      assert item.value == "Ada"
      assert item.meta == %{}
    end

    test "generates value when omitted" do
      item = Item.build(%{title: "Only"})
      assert item.title == "Only"
      assert is_binary(item.value)
      assert item.value =~ "item-"
    end

    test "raises on non-map" do
      assert_raise ArgumentError, fn -> Item.build(:not_a_map) end
    end

    test "raises when title missing" do
      assert_raise ArgumentError, fn -> Item.build(%{value: "x"}) end
    end
  end

  describe "new/1" do
    test "maps list with explicit values" do
      items = Item.new([%{title: "A", value: "1"}, %{title: "B", value: "2"}])
      assert length(items) == 2
      assert Enum.at(items, 0).value == "1"
      assert Enum.at(items, 1).meta == %{}
    end

    test "indexes default values as item-1, item-2" do
      items = Item.new([%{title: "A"}, %{title: "B"}])
      assert Enum.at(items, 0).value == "item-1"
      assert Enum.at(items, 1).value == "item-2"
    end

    test "empty list" do
      assert Item.new([]) == []
    end

    test "raises on non-list-of-maps" do
      assert_raise ArgumentError, fn -> Item.new([:x]) end
      assert_raise ArgumentError, fn -> Item.new(:bad) end
    end
  end
end
