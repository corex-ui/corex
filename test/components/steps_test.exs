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

  test "content slots render copy and hide inactive panels" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.steps id="steps-slots" class="steps">
            <:content index={0}>First panel</:content>
            <:content index={1}>Second panel</:content>
            <:content index={2}>Third panel</:content>
          </.steps>
          """
        end,
        %{}
      )

    assert html =~ "First panel"
    assert html =~ "Second panel"
    refute html =~ "inner_block"
    assert html =~ ~s(data-part="content")
    assert html =~ "hidden"
  end
end
