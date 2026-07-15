defmodule Corex.Connect.ItemNavTest do
  use ExUnit.Case, async: true

  alias Corex.Connect.ItemNav

  test "puts data-to for allowed hrefs" do
    attrs = ItemNav.put_item_nav_attrs(%{}, %{to: "/docs", redirect: nil, new_tab: false})
    assert attrs["data-to"] == "/docs"
    refute Map.has_key?(attrs, "data-redirect")
    refute Map.has_key?(attrs, "data-new-tab")
  end

  test "encodes redirect modes and new_tab" do
    attrs =
      ItemNav.put_item_nav_attrs(%{}, %{to: nil, redirect: :navigate, new_tab: true})

    assert attrs["data-redirect"] == "navigate"
    assert attrs["data-new-tab"] == ""
  end

  test "encodes redirect false" do
    attrs = ItemNav.put_item_nav_attrs(%{}, %{redirect: false, new_tab: false})
    assert attrs["data-redirect"] == "false"
  end

  test "skips disallowed to" do
    attrs = ItemNav.put_item_nav_attrs(%{}, %{to: "javascript:alert(1)"})
    refute Map.has_key?(attrs, "data-to")
  end
end
