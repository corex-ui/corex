defmodule Corex.BadgeTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  test "renders badge with semantic and size modifiers" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Badge.badge semantic="accent" size="sm">New</Corex.Badge.badge>
          """
        end,
        %{}
      )

    assert html =~ "badge--accent"
    assert html =~ "badge--sm"
    assert html =~ "New"
  end
end
