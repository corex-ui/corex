defmodule Corex.TourTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Tour, only: [tour: 1]

  alias Corex.Tour.Connect

  test "renders closed overlay on the server" do
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
    assert html =~ ~S(data-part="backdrop")
    assert html =~ ~S(data-part="spotlight")
    assert html =~ ~S(data-part="content")
    assert html =~ ~S(data-part="positioner")
    assert html =~ ~S(hidden)
    refute html =~ "translate3d(0, -100vh, 0)"
    refute html =~ ~S(data-state="open")
  end

  test "Connect stamps closed backdrop and content" do
    backdrop = Connect.backdrop(%{id: "tour", dir: "ltr"})
    content = Connect.content(%{id: "tour", dir: "ltr"})
    positioner = Connect.positioner(%{id: "tour", dir: "ltr"})
    assert backdrop["hidden"] == true
    assert backdrop["data-state"] == "closed"
    assert content["hidden"] == true
    assert content["aria-hidden"] == "true"
    assert positioner["hidden"] == true
    refute Map.get(positioner, "style", "") =~ "-100vh"
  end
end
