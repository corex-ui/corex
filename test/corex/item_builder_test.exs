defmodule Corex.ItemBuilderTest do
  use ExUnit.Case, async: true

  alias Corex.ItemBuilder
  alias Corex.List.Item, as: ListItem

  describe "generate_id/1" do
    test "returns prefixed unique id" do
      id = ItemBuilder.generate_id("list")
      assert String.starts_with?(id, "list-")
    end
  end

  describe "build_item/3" do
    test "builds struct with index value" do
      item =
        ItemBuilder.build_item(ListItem, %{label: "A"},
          index: 2,
          required_fields: [:label],
          example: "ex"
        )

      assert %ListItem{label: "A", value: "item-2"} = item
    end

    test "builds struct with id prefix when no index" do
      item =
        ItemBuilder.build_item(ListItem, %{label: "B"},
          id_prefix: "list",
          required_fields: [:label],
          example: "Corex.List.Item.new(label: \"B\")"
        )

      assert %ListItem{label: "B"} = item
      assert String.starts_with?(item.value, "list-")
    end

    test "raises ArgumentError with example on invalid attrs" do
      assert_raise ArgumentError, ~r/Corex.List.Item/, fn ->
        ItemBuilder.build_item(ListItem, %{},
          required_fields: [:label],
          example: "Corex.List.Item.new(label: \"B\")"
        )
      end
    end
  end
end
