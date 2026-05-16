defmodule Corex.Pagination.UtilsTest do
  use ExUnit.Case, async: true

  alias Corex.Pagination.Utils

  describe "pages/4" do
    test "all pages when total fits in window" do
      assert Utils.pages(1, 5, 1, 1) == [
               %{type: :page, value: 1},
               %{type: :page, value: 2},
               %{type: :page, value: 3},
               %{type: :page, value: 4},
               %{type: :page, value: 5}
             ]
    end

    test "ellipsis in the middle when active page is central" do
      entries = Utils.pages(5, 10, 1, 1)

      assert Enum.any?(entries, &(&1 == %{type: :ellipsis}))
      assert Enum.at(entries, 0) == %{type: :page, value: 1}
      assert Enum.at(entries, -1) == %{type: :page, value: 10}
    end

    test "empty when no pages" do
      assert Utils.pages(1, 0, 1, 1) == []
    end
  end

  describe "format_item_label/3" do
    test "interpolates page and total" do
      assert Utils.format_item_label("Page %{page} of %{total_pages}", 2, 5) ==
               "Page 2 of 5"
    end
  end

  describe "page_href/5" do
    test "builds query string" do
      assert Utils.page_href("/items", "page", "page_size", 2, 10) ==
               "/items?page=2&page_size=10"
    end

    test "appends to existing query" do
      assert Utils.page_href("/items?sort=asc", "page", "page_size", 2, 10) ==
               "/items?sort=asc&page=2&page_size=10"
    end
  end
end
