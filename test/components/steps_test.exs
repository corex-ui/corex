defmodule Corex.StepsTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Steps, only: [steps: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.steps id="steps-unit" class="steps" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Steps")
    assert html =~ ~S(data-scope="steps")
  end
end
