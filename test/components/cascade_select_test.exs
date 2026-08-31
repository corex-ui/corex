defmodule Corex.CascadeSelectTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.CascadeSelect, only: [cascade_select: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.cascade_select id="cascade-select-unit" class="cascade-select" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="CascadeSelect")
    assert html =~ ~S(data-scope="cascade-select")
  end
end
