defmodule Corex.List.NormalizeTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias Corex.List.Item
  alias Corex.List.Normalize

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

      [row] = Normalize.normalize_items([item])
      assert row.value == "a"
      assert row.to == "/x"
      assert row.redirect == :patch
      assert row.new_tab == true
      assert row.meta == %{k: 1}
    end

    test "preserves redirect fields from maps" do
      [row] =
        Normalize.normalize_items([
          %{value: "b", label: "B", to: "/y", redirect: :navigate, new_tab: false, meta: %{}}
        ])

      assert row.to == "/y"
      assert row.redirect == :navigate
      assert row.new_tab == false
    end

    test "warns and falls back to no redirect on an invalid redirect atom" do
      log =
        capture_log(fn ->
          [row] = Normalize.normalize_items([%{value: "c", label: "C", redirect: :oops}])
          assert row.redirect == nil
        end)

      assert log =~ "invalid item :redirect"
      assert log =~ ":oops"
    end

    test "warns and drops entries that are not items" do
      log =
        capture_log(fn ->
          assert Normalize.normalize_items(["bad", %{label: "Good", value: "g"}]) == [
                   %{
                     value: "g",
                     label: "Good",
                     disabled: false,
                     group: nil,
                     to: nil,
                     redirect: nil,
                     new_tab: false,
                     meta: %{}
                   }
                 ]
        end)

      assert log =~ "maps with :label"
      assert log =~ "dropping it"
    end
  end

  describe "grouping" do
    test "detects groups and buckets by group" do
      items = [%{label: "A", group: "G1"}, %{label: "B", group: "G2"}, %{label: "C"}]
      assert Normalize.has_groups?(items)
      assert length(Normalize.group_by_group(items)) == 3
    end

    test "ungrouped items report no groups" do
      refute Normalize.has_groups?([%{label: "A"}, %{label: "B"}])
    end
  end

  describe "entry helpers" do
    test "entry_value and entry_selected?" do
      assert Normalize.entry_value(%{value: "a"}) == "a"
      assert Normalize.entry_value(%{}) == ""
      assert Normalize.entry_selected?(%{value: "a"}, ["a", "b"])
      refute Normalize.entry_selected?(%{value: "c"}, ["a"])
    end
  end

  describe "field_value_list/1" do
    test "treats an unset field as nothing selected" do
      for blank <- [nil, "", "[]", []] do
        assert Normalize.field_value_list(blank) == []
      end
    end

    test "wraps a single value and drops blanks inside a list" do
      assert Normalize.field_value_list("a") == ["a"]
      assert Normalize.field_value_list(["a", "", nil, "b"]) == ["a", "b"]
      assert Normalize.field_value_list([:a, 1]) == ["a", "1"]
    end
  end

  describe "put_disabled_attrs/2" do
    test "adds the disabled pair only for a disabled entry" do
      assert Normalize.put_disabled_attrs(%{}, %{disabled: true}) == %{
               "data-disabled" => "",
               "aria-disabled" => "true"
             }

      assert Normalize.put_disabled_attrs(%{}, %{disabled: false}) == %{}
      assert Normalize.put_disabled_attrs(%{}, %{}) == %{}
    end
  end

  describe "selected_label/2" do
    setup do
      %{items: [%{value: "a", label: "Apple"}, %{value: "b", label: "Banana"}]}
    end

    test "returns nil rather than an empty string so callers can fall back", %{items: items} do
      assert Normalize.selected_label(items, []) == nil
      assert Normalize.selected_label(items, ["gone"]) == nil
    end

    test "joins the labels of the resolved entries", %{items: items} do
      assert Normalize.selected_label(items, ["a"]) == "Apple"
      assert Normalize.selected_label(items, ["a", "b"]) == "Apple, Banana"
    end

    test "skips a value the item list no longer carries", %{items: items} do
      assert Normalize.selected_label(items, ["a", "gone"]) == "Apple"
    end
  end

  describe "value_for_hidden_input/2" do
    test "posts a bare value for single select" do
      assert Normalize.value_for_hidden_input(["a"], false) == "a"
      assert Normalize.value_for_hidden_input(["a", "b"], false) == "a"
    end

    test "posts a comma-joined list for multi select" do
      assert Normalize.value_for_hidden_input(["a", "b"], true) == "a,b"
    end

    test "posts an empty string when nothing is selected" do
      assert Normalize.value_for_hidden_input([], true) == ""
      assert Normalize.value_for_hidden_input([], false) == ""
    end
  end
end
