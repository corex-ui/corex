defmodule Corex.CarouselTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Carousel
  alias Corex.Carousel.Connect

  describe "carousel/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_carousel/1, [])
      assert html =~ ~r/data-scope="carousel"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/src=/
      assert html =~ ~r/phx-mounted=/
    end

    test "renders multiple slides with vertical layout" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Carousel.carousel
              id="carousel-multi"
              items={[
                Corex.Image.new("/a.jpg", alt: "A"),
                Corex.Image.new("/b.jpg", alt: "B")
              ]}
              orientation="vertical"
              slides_per_page={2}
              spacing="8px"
              autoplay
            >
              <:prev_trigger>Prev</:prev_trigger>
              <:next_trigger>Next</:next_trigger>
            </Carousel.carousel>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-orientation="vertical")
      assert html =~ ~S(data-part="indicator-group")
    end
  end

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

  describe "play/1 and pause/1" do
    test "return JS dispatch commands" do
      for {fun, event} <- [
            {&Carousel.play/1, "corex:carousel:play"},
            {&Carousel.pause/1, "corex:carousel:pause"}
          ] do
        js = fun.("c1")
        assert %Phoenix.LiveView.JS{} = js
        ops = Map.get(js, :ops, [])

        assert Enum.any?(ops, fn
                 ["dispatch", %{event: ^event}] -> true
                 _ -> false
               end)
      end
    end
  end

  describe "scroll_next/1 and scroll_prev/1" do
    test "return JS dispatch commands" do
      js = Carousel.scroll_next("c1")
      assert %Phoenix.LiveView.JS{} = js
      ops = Map.get(js, :ops, [])

      assert Enum.any?(ops, fn
               ["dispatch", %{event: "corex:carousel:scroll-next"}] -> true
               _ -> false
             end)

      js2 = Carousel.scroll_next("c1", true)
      assert %Phoenix.LiveView.JS{} = js2

      js3 = Carousel.scroll_prev("c2")
      ops3 = Map.get(js3, :ops, [])

      assert Enum.any?(ops3, fn
               ["dispatch", %{event: "corex:carousel:scroll-prev"}] -> true
               _ -> false
             end)
    end
  end

  describe "play/2, pause/2, scroll_next/2, scroll_prev/2" do
    test "push hook events on the socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Carousel.play(socket, "x")
      assert %Phoenix.LiveView.Socket{} = Carousel.pause(socket, "x")
      assert %Phoenix.LiveView.Socket{} = Carousel.scroll_next(socket, "x")
      assert %Phoenix.LiveView.Socket{} = Carousel.scroll_prev(socket, "x")
      assert %Phoenix.LiveView.Socket{} = Carousel.scroll_next(socket, "x", true)
      assert %Phoenix.LiveView.Socket{} = Carousel.scroll_prev(socket, "x", true)
    end
  end
end
