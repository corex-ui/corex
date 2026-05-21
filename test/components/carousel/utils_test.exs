defmodule Corex.Carousel.UtilsTest do
  use ExUnit.Case, async: true

  alias Corex.Carousel.Utils
  alias Corex.Image

  describe "compute_slide_metrics/1" do
    test "computes pages and nav disabled state" do
      items = [Image.new("a.jpg", alt: "A"), Image.new("b.jpg", alt: "B")]

      {_items, slide_count, total_pages, prev_disabled, next_disabled, _spp} =
        Utils.compute_slide_metrics(%{items: items, slides_per_page: 1, page: 1, loop: false})

      assert slide_count == 2
      assert total_pages == 2
      assert prev_disabled
      refute next_disabled
    end

    test "uses item_count when provided" do
      {_items, slide_count, total_pages, _prev, _next, _spp} =
        Utils.compute_slide_metrics(%{item_count: 5, slides_per_page: 2, page: 1})

      assert slide_count == 5
      assert total_pages == 3
    end
  end

  describe "validate_items!/2" do
    test "accepts Corex.Image items without slot" do
      assert Utils.validate_items!([Image.new("a.jpg", alt: "A")], false) == :ok
    end

    test "raises for non-image items without slot" do
      assert_raise ArgumentError, ~r/must be %Corex.Image{}*/, fn ->
        Utils.validate_items!(["bad"], false)
      end
    end
  end
end
