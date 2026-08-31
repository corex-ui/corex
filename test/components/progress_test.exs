defmodule Corex.ProgressTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Progress, only: [progress: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.progress id="progress-unit" class="progress" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Progress")
    assert html =~ ~S(data-scope="progress")
  end
end
