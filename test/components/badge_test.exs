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

    assert html =~ "badge--semantic-accent"
    assert html =~ "badge--size-sm"
    assert html =~ "New"
  end
end
