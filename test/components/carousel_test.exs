defmodule Corex.CarouselTest do
  use ExUnit.Case, async: true

  alias Corex.Carousel.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{
        id: "test-carousel",
        dir: "ltr",
        orientation: "horizontal",
        slides_per_page: 1,
        spacing: "0px"
      }

      result = Connect.root(assigns)
      assert result["id"] == "carousel:test-carousel"
      assert result["data-scope"] == "carousel"
      assert result["data-part"] == "root"
      assert result["data-orientation"] == "horizontal"
    end

    test "computes root with vertical orientation" do
      assigns = %{
        id: "test-carousel",
        dir: "ltr",
        orientation: "vertical",
        slides_per_page: 1,
        spacing: "0px"
      }

      result = Connect.root(assigns)
      assert result["data-orientation"] == "vertical"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-carousel", orientation: "horizontal"}
      result = Connect.control(assigns)
      assert result["id"] == "carousel:test-carousel:control"
      assert result["data-scope"] == "carousel"
      assert result["data-part"] == "control"
    end
  end

  describe "Connect.item_group/1" do
    test "returns item group attributes for horizontal" do
      assigns = %{id: "test-carousel", orientation: "horizontal", dir: "ltr"}
      result = Connect.item_group(assigns)
      assert result["id"] == "carousel:test-carousel:item-group"
      assert result["data-scope"] == "carousel"
    end
  end
end
