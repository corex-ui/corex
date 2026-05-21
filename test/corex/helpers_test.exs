defmodule Corex.HelpersTest do
  use ExUnit.Case, async: true

  alias Corex.Helpers
  alias Corex.List.Item

  describe "get_boolean/1" do
    test "returns empty string for true" do
      assert Helpers.get_boolean(true) == ""
    end

    test "returns nil for false" do
      assert Helpers.get_boolean(false) == nil
    end

    test "returns nil for nil" do
      assert Helpers.get_boolean(nil) == nil
    end
  end

  describe "get_boolean/2" do
    test "returns empty string when controlled and value is truthy" do
      assert Helpers.get_boolean(true, true) == ""
      assert Helpers.get_boolean(true, "x") == ""
    end

    test "returns nil when controlled and value is falsy" do
      assert Helpers.get_boolean(true, false) == nil
      assert Helpers.get_boolean(true, nil) == nil
    end

    test "returns nil when uncontrolled" do
      assert Helpers.get_boolean(false, true) == nil
      assert Helpers.get_boolean(false, false) == nil
      assert Helpers.get_boolean(nil, true) == nil
    end
  end

  describe "get_default_boolean/2" do
    test "returns empty string when uncontrolled and value is truthy" do
      assert Helpers.get_default_boolean(false, true) == ""
    end

    test "returns nil when uncontrolled and value is falsy" do
      assert Helpers.get_default_boolean(false, false) == nil
      assert Helpers.get_default_boolean(false, nil) == nil
    end

    test "returns nil when controlled" do
      assert Helpers.get_default_boolean(true, true) == nil
      assert Helpers.get_default_boolean(true, false) == nil
    end
  end

  describe "validate_value!/1" do
    test "returns empty list for empty input" do
      assert Helpers.validate_value!([]) == []
    end

    test "returns list when all elements are strings" do
      assert Helpers.validate_value!(["a", "b"]) == ["a", "b"]
      assert Helpers.validate_value!(["x"]) == ["x"]
    end

    test "raises when list contains non-strings" do
      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!([1, 2, 3])
      end

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!(["a", :atom])
      end
    end

    test "raises for non-list input" do
      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!("string")
      end

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!(%{})
      end

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!(123)
      end
    end
  end

  describe "normalize_items/1" do
    test "preserves redirect fields from Corex.List.Item" do
      item =
        Item.new(
          label: "A",
          value: "a",
          to: "/x",
          redirect: :patch,
          new_tab: true,
          meta: %{k: 1}
        )

      [row] = Helpers.normalize_items([item])
      assert row.value == "a"
      assert row.to == "/x"
      assert row.redirect == :patch
      assert row.new_tab == true
      assert row.meta == %{k: 1}
    end

    test "preserves redirect fields from maps" do
      [row] =
        Helpers.normalize_items([
          %{value: "b", label: "B", to: "/y", redirect: :navigate, new_tab: false, meta: %{}}
        ])

      assert row.to == "/y"
      assert row.redirect == :navigate
      assert row.new_tab == false
    end

    test "raises on invalid redirect atom" do
      assert_raise ArgumentError, ~r/invalid item :redirect/, fn ->
        Helpers.normalize_items([%{value: "c", label: "C", redirect: :oops}])
      end
    end

    test "raises for invalid item type" do
      assert_raise ArgumentError, ~r/Items must be Corex.List.Item/, fn ->
        Helpers.normalize_items(["bad"])
      end
    end
  end

  describe "normalize_string_list_value!/1" do
    test "parses csv string" do
      assert Helpers.normalize_string_list_value!("a, b") == ["a", "b"]
    end

    test "graphemes option splits string without comma" do
      assert Helpers.normalize_string_list_value!("12", graphemes: true) == ["1", "2"]
    end
  end

  describe "controlled_string_value/2" do
    test "controlled mode uses value only" do
      assert Helpers.controlled_string_value(true, "a") == {"a", nil}
    end

    test "uncontrolled mode uses default value only" do
      assert Helpers.controlled_string_value(false, "a") == {nil, "a"}
    end

    test "nil value yields nil pair" do
      assert Helpers.controlled_string_value(true, nil) == {nil, nil}
    end
  end

  describe "controlled_dataset_values/2" do
    test "controlled mode uses value only" do
      assert Helpers.controlled_dataset_values(true, "a,b") == {"a,b", nil}
    end

    test "uncontrolled mode uses default value only" do
      assert Helpers.controlled_dataset_values(false, "a,b") == {nil, "a,b"}
    end

    test "nil joined yields nil pair" do
      assert Helpers.controlled_dataset_values(true, nil) == {nil, nil}
    end
  end

  describe "data_state/3" do
    test "returns true or false val" do
      assert Helpers.data_state(true, "on", "off") == "on"
      assert Helpers.data_state(false, "on", "off") == "off"
    end
  end

  describe "get_boolean helpers" do
    test "get_boolean and get_default_boolean" do
      assert Helpers.get_boolean(true) == ""
      refute Helpers.get_boolean(false)
      assert Helpers.get_default_boolean(false, true) == ""
      refute Helpers.get_default_boolean(true, true)
      assert Helpers.get_boolean(true, true) == ""
      refute Helpers.get_boolean(true, false)
    end
  end

  describe "validate_tabs_value!/1" do
    test "accepts string and nil" do
      assert Helpers.validate_tabs_value!("tab") == "tab"
      assert Helpers.validate_tabs_value!(nil) == nil
    end

    test "raises for invalid value" do
      assert_raise ArgumentError, fn ->
        Helpers.validate_tabs_value!(123)
      end
    end
  end

  describe "validate_content_items_required!/2" do
    test "raises when items nil" do
      assert_raise ArgumentError, fn ->
        Helpers.validate_content_items_required!(%{items: nil}, "Tabs")
      end
    end

    test "raises for invalid item struct" do
      assert_raise ArgumentError, fn ->
        Helpers.validate_content_items_required!(%{items: [%{label: "x"}]}, "Tabs")
      end
    end

    test "returns assigns for valid items" do
      item = Corex.Content.Item.new(%{label: "L", content: "C"})

      assert %{items: [^item]} =
               Helpers.validate_content_items_required!(%{items: [item]}, "Tabs")
    end

    test "passes through other assigns" do
      assert %{foo: 1} = Helpers.validate_content_items_required!(%{foo: 1}, "Tabs")
    end
  end

  describe "groups" do
    test "has_groups? and normalize_groups" do
      items = [%{label: "A", group: "G1"}, %{label: "B", group: "G2"}, %{label: "C"}]
      assert Helpers.has_groups?(items)
      assert Helpers.normalize_groups(items) == ["G1", "G2"]
      assert Helpers.group_by_group(items) |> length() == 3
    end
  end

  describe "entry helpers" do
    test "entry_value and entry_selected?" do
      assert Helpers.entry_value(%{value: "a"}) == "a"
      assert Helpers.entry_value(%{}) == ""
      assert Helpers.entry_selected?(%{value: "a"}, ["a", "b"])
      refute Helpers.entry_selected?(%{value: "c"}, ["a"])
    end
  end

  describe "maybe_put helpers" do
    test "maybe_put and dir helpers" do
      assert Helpers.maybe_put(%{}, :k, nil) == %{}
      assert Helpers.maybe_put(%{}, :k, "v") == %{k: "v"}
      assert Helpers.maybe_put_data_dir(%{}, "ltr") == %{"data-dir" => "ltr"}
      assert Helpers.maybe_put_dir(%{}, "rtl") == %{"dir" => "rtl"}
      assert Helpers.maybe_put_data_dir_from(%{}, %{dir: "ltr"}) == %{"data-dir" => "ltr"}
      assert Helpers.maybe_put_dir_from(%{}, %{dir: "rtl"}) == %{"dir" => "rtl"}
    end
  end

  describe "respond_to_fields/1" do
    test "returns respond_to map" do
      assert Helpers.respond_to_fields(respond_to: :both) == %{respond_to: "both"}
      assert Helpers.respond_to_fields(respond_to: :client) == %{respond_to: "client"}
      assert Helpers.respond_to_fields([]) == %{respond_to: "server"}

      assert_raise ArgumentError, fn ->
        Helpers.respond_to_fields(respond_to: :invalid)
      end
    end
  end
end
