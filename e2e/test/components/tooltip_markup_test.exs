defmodule E2eWeb.TooltipMarkupTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "static tooltip page" do
    test "renders tooltip data attributes", %{conn: conn} do
      conn = get(conn, ~p"/tooltip/anatomy")
      html = html_response(conn, 200)

      assert html =~ ~r/data-scope="tooltip"/
      assert html =~ ~r/data-part="trigger"/
      assert html =~ ~r/data-part="positioner"/
      assert html =~ ~r/data-part="content"/
    end

    test "renders arrow parts when show_arrow", %{conn: conn} do
      conn = get(conn, ~p"/tooltip/anatomy")
      html = html_response(conn, 200)

      assert html =~ ~r/data-part="arrow"/
      assert html =~ ~r/data-part="arrow-tip"/
    end
  end

  describe "live tooltip page" do
    test "renders tooltip data attributes", %{conn: conn} do
      {_view, html} = live_ok!(conn, ~p"/tooltip/events")

      assert html =~ ~r/data-scope="tooltip"/
      assert html =~ ~r/data-part="trigger"/
      assert html =~ ~r/data-part="positioner"/
      assert html =~ ~r/data-part="content"/
    end

    test "patterns page wires on_trigger_value_change for multi-trigger LiveView", %{conn: conn} do
      {_view, html} = live_ok!(conn, ~p"/tooltip/patterns")

      assert html =~ "tooltip-patterns-page"
      assert html =~ ~S(id="tooltip-pattern-users")
      assert html =~ ~S(data-on-trigger-value-change="tooltip_pattern_trigger_value")
      assert html =~ ~S(id="tooltip:tooltip-pattern-users:trigger:1")
      assert html =~ "tooltip-pattern-profile-links"
      assert html =~ ~S(id="tooltip-profile-1")
      assert html =~ ~S(id="tooltip-profile-2")
      assert html =~ "tooltip-pattern-profile-link-multi"
      assert html =~ ~S(id="tooltip-pattern-profile-link-multi-tool")
      assert html =~ ~S(data-on-trigger-value-change="tooltip_pattern_link_multi_value")
      assert html =~ ~S(id="tooltip:tooltip-pattern-profile-link-multi-tool:trigger:1")
      assert html =~ "tooltip-pattern-menu-item"
      assert html =~ ~S(id="menu:tooltip-pattern-menu")
      assert html =~ ~S(id="tooltip-pattern-menu-support")
      assert html =~ ~S(id="tooltip:tooltip-pattern-menu-support:trigger")
      assert html =~ ~S|id="tooltip:tooltip-pattern-menu-support:trigger" tabindex="-1"|
    end

    test "renders arrow parts when show_arrow", %{conn: conn} do
      {_view, html} = live_ok!(conn, ~p"/tooltip/events")

      assert html =~ ~r/data-part="arrow"/
      assert html =~ ~r/data-part="arrow-tip"/
    end
  end
end
