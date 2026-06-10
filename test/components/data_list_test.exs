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

      assert html =~ ~S(data-part="empty")
      assert html =~ "No entries"
    end

    test "empty slot is outside dl for definition list accessibility" do
      html =
        render_component(&DataList.data_list/1, %{
          items: [],
          empty: [%{inner_block: fn _, _ -> "No entries" end}]
        })

      doc = parse_html_fragment(html)

      assert [_] = Floki.find(doc, "[data-part=\"empty\"]")
      assert Floki.find(doc, "dl") == []
      assert Floki.find(doc, "dl [data-part=\"empty\"]") == []
    end

    test "items render in dl without empty as a direct dl child" do
      items =
        Corex.Content.new([
          %{label: "Name", content: "Alice"}
        ])

      html = render_component(&DataList.data_list/1, %{items: items})

      doc = parse_html_fragment(html)

      assert [_] = Floki.find(doc, "dl[data-part=\"root\"]")
      assert Floki.find(doc, "dl [data-part=\"empty\"]") == []

      for item <- Floki.find(doc, "dl [data-part=\"item\"]") do
        child_tags =
          item
          |> Floki.children()
          |> Enum.map(fn {tag, _, _} -> tag end)

        assert child_tags == ["dt", "dd"]
      end
    end

    test "empty slot with items keeps empty outside dl" do
      items =
        Corex.Content.new([
          %{label: "Name", content: "Alice"}
        ])

      html =
        render_component(&DataList.data_list/1, %{
          items: items,
          empty: [%{inner_block: fn _, _ -> "No entries" end}]
        })

      doc = parse_html_fragment(html)

      assert [_] = Floki.find(doc, "[data-part=\"empty\"]")
      assert [_] = Floki.find(doc, "dl [data-part=\"item\"]")
      assert Floki.find(doc, "dl [data-part=\"empty\"]") == []
    end

    test "renders items from Corex.Content" do
      items =
        Corex.Content.new([
          %{label: "Name", content: "Alice"},
          %{label: "Age", content: "30"}
        ])

      html = render_component(&DataList.data_list/1, %{items: items})

      assert html =~ ~S(data-part="label")
      assert html =~ ~S(data-part="content")
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
      assert html =~ "my-list"
    end

    test "passes orientation and dir to root" do
      items = Corex.Content.new([%{label: "Name", content: "Alice"}])

      html =
        render_component(&DataList.data_list/1, %{
          items: items,
          orientation: "horizontal",
          dir: "rtl"
        })

      assert html =~ ~S(data-orientation="horizontal")
      assert html =~ ~S(dir="rtl")
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
