defmodule Corex.NavigationMenuTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.NavigationMenu, only: [navigation_menu: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.navigation_menu id="navigation-menu-unit" class="navigation-menu" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="NavigationMenu")
    assert html =~ ~S(data-scope="navigation-menu")
  end

  test "renders list items as triggers and links" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.navigation_menu
            id="navigation-menu-items"
            class="navigation-menu"
            items={
              Corex.List.new([
                %{value: "product", label: "Product"},
                %{value: "docs", label: "Docs", to: "#docs"}
              ])
            }
          >
            <:content value="product">Panel</:content>
          </.navigation_menu>
          """
        end,
        %{}
      )

    assert html =~ ~S(data-part="trigger")
    assert html =~ ~S(data-part="link")
    assert html =~ ~S(href="#docs")
    assert html =~ "hero-chevron-down"
    assert html =~ "Panel"
  end
end
