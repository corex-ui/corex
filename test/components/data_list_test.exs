defmodule Corex.DataListTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.DataList

  describe "data_list/1" do
    test "renders empty data_list with empty slot" do
      html =
        render_component(&DataList.data_list/1, %{
          items: [],
          empty: [%{inner_block: fn _, _ -> "No entries" end}]
        })

      assert html =~ ~s(data-part="empty")
      assert html =~ "No entries"
    end

    test "renders items from Corex.Content" do
      items =
        Corex.Content.new([
          %{label: "Name", content: "Alice"},
          %{label: "Age", content: "30"}
        ])

      html = render_component(&DataList.data_list/1, %{items: items})

      assert html =~ ~s(data-part="label")
      assert html =~ ~s(data-part="content")
      assert html =~ "Name"
      assert html =~ "Alice"
      assert html =~ "Age"
      assert html =~ "30"
    end

    test "renders manual label and content slots" do
      html =
        render_component(&DataList.data_list/1, %{
          items: [],
          label: [
            %{value: "a", inner_block: fn _, _ -> "Label A" end},
            %{value: "b", inner_block: fn _, _ -> "Label B" end}
          ],
          content: [
            %{value: "a", inner_block: fn _, _ -> "Content A" end},
            %{value: "b", inner_block: fn _, _ -> "Content B" end}
          ]
        })

      assert html =~ "Label A"
      assert html =~ "Content A"
      assert html =~ "Label B"
      assert html =~ "Content B"
    end

    test "renders custom label and content slots with items" do
      items =
        Corex.Content.new([
          %{value: "x", label: "Status", content: "Active", meta: %{tag: "ok"}}
        ])

      html =
        render_component(&DataList.data_list/1, %{
          items: items,
          label: [%{inner_block: fn _slot, entry -> "L:#{entry.label}" end}],
          content: [%{inner_block: fn _slot, entry -> "C:#{entry.content}" end}]
        })

      assert html =~ "L:Status"
      assert html =~ "C:Active"
    end

    test "passes rest attributes to wrapper" do
      html = render_component(&DataList.data_list/1, %{class: "my-list", items: []})
      assert html =~ ~s(class="my-list")
    end

    test "passes orientation and dir to root" do
      html =
        render_component(&DataList.data_list/1, %{
          items: [],
          orientation: "horizontal",
          dir: "rtl"
        })

      assert html =~ ~s(data-orientation="horizontal")
      assert html =~ ~s(dir="rtl")
    end

    test "raises when items and manual slots are combined" do
      assert_raise ArgumentError, fn ->
        render_component(&DataList.data_list/1, %{
          items: Corex.Content.new([%{label: "A", content: "1"}]),
          label: [%{value: "a", inner_block: fn _, _ -> "A" end}],
          content: [%{value: "a", inner_block: fn _, _ -> "1" end}]
        })
      end
    end
  end
end
