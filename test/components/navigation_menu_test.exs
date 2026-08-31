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
end
