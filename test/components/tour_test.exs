defmodule Corex.TourTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Tour, only: [tour: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.tour id="tour-unit" class="tour" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Tour")
    assert html =~ ~S(data-scope="tour")
  end
end
