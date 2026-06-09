defmodule Corex.IconTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  test "renders wrapper with text size and heroicon slot" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Icon.icon text="sm">
            <Corex.Heroicon.heroicon name="hero-link" />
          </Corex.Icon.icon>
          """
        end,
        %{}
      )

    assert html =~ ~s(class="icon icon--text-sm")
    assert html =~ "hero-link"
    assert html =~ ~s(data-icon)
    refute html =~ "badge"
  end

  test "renders slot image inside wrapper" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <Corex.Icon.icon text="xs">
            <img src="/images/tech/zag.webp" alt="" />
          </Corex.Icon.icon>
          """
        end,
        %{}
      )

    assert html =~ ~s(class="icon icon--text-xs")
    assert html =~ ~s(src="/images/tech/zag.webp")
    refute html =~ "badge"
  end
end
