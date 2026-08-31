defmodule Corex.ScrollAreaTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.ScrollArea, only: [scroll_area: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.scroll_area id="scroll-area-unit" class="scroll-area" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="ScrollArea")
    assert html =~ ~S(data-scope="scroll-area")
  end
end
