defmodule Corex.TocTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Toc, only: [toc: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.toc id="toc-unit" class="toc" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Toc")
    assert html =~ ~S(data-scope="toc")
  end
end
