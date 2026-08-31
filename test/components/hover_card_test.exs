defmodule Corex.HoverCardTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.HoverCard, only: [hover_card: 1]

  describe "hover_card/1" do
    test "renders trigger and content" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.hover_card id="hc-unit">
              <:trigger>Hover</:trigger>
              <:content>Preview</:content>
            </.hover_card>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-scope="hover-card")
      assert html =~ ~S(id="hover-card:hc-unit:popper")
      assert html =~ "Hover"
      assert html =~ "Preview"
      assert html =~ ~S(data-part="arrow")
    end

    test "omits arrow when show_arrow is false" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.hover_card id="hc-no-arrow" show_arrow={false}>
              <:trigger>T</:trigger>
              <:content>C</:content>
            </.hover_card>
            """
          end,
          %{}
        )

      refute html =~ ~S(data-part="arrow")
    end
  end

  describe "set_open/2" do
    test "returns JS dispatch" do
      assert %Phoenix.LiveView.JS{} = Corex.HoverCard.set_open("hc-unit", true)
    end
  end
end
