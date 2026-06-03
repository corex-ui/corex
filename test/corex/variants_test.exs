defmodule Corex.VariantsTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  test "style attrs merge bem modifiers without styling data attributes" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Badge.badge size="sm">Tag</Corex.Badge.badge>
          """
        end,
        %{}
      )

    assert html =~ "badge--sm"
    refute html =~ "data-badge"
    refute html =~ "data-badge-size"
  end
end
