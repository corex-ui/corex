defmodule Corex.DateInputTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.DateInput, only: [date_input: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.date_input id="date-input-unit" class="date-input" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="DateInput")
    assert html =~ ~S(data-scope="date-input")
  end
end
