defmodule Corex.DataListTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.DataList

  describe "data_list/1" do
    test "renders empty data_list" do
      html = render_component(&DataList.data_list/1, %{item: []})
      assert html =~ ~s(data-scope="data-list")
      assert html =~ ~s(data-part="root")
    end

    test "renders data_list with items" do
      html =
        render_component(&DataList.data_list/1, %{
          item: [
            %{title: "Name", inner_block: fn _, _ -> "Alice" end},
            %{title: "Age", inner_block: fn _, _ -> "30" end}
          ]
        })

      assert html =~ ~s(data-scope="data-list")
      assert html =~ ~s(data-part="root")
      assert html =~ ~s(data-part="item")
      assert html =~ ~s(data-part="content")
      assert html =~ ~s(data-part="title")

      assert html =~ "Name"
      assert html =~ "Alice"
      assert html =~ "Age"
      assert html =~ "30"
    end

    test "passes rest attributes to root" do
      html = render_component(&DataList.data_list/1, %{class: "my-list", item: []})
      assert html =~ ~s(class="my-list")
    end
  end
end
