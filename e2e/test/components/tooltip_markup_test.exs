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
      {:ok, _view, html} = live(conn, ~p"/tooltip/events")

      assert html =~ ~r/data-scope="tooltip"/
      assert html =~ ~r/data-part="trigger"/
      assert html =~ ~r/data-part="positioner"/
      assert html =~ ~r/data-part="content"/
    end

    test "patterns page wires on_trigger_value_change for multi-trigger LiveView", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/tooltip/patterns")

      assert html =~ "tooltip-patterns-page"
      assert html =~ ~s(id="tooltip-pattern-users")
      assert html =~ ~s(data-on-trigger-value-change="tooltip_pattern_trigger_value")
      assert html =~ ~s(id="tooltip:tooltip-pattern-users:trigger:1")
      assert html =~ "tooltip-pattern-profile-links"
      assert html =~ ~s(id="tooltip-profile-1")
      assert html =~ ~s(id="tooltip-profile-2")
      assert html =~ "tooltip-pattern-profile-link-multi"
      assert html =~ ~s(id="tooltip-pattern-profile-link-multi-tool")
      assert html =~ ~s(data-on-trigger-value-change="tooltip_pattern_link_multi_value")
      assert html =~ ~s(id="tooltip:tooltip-pattern-profile-link-multi-tool:trigger:1")
    end

    test "renders arrow parts when show_arrow", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/tooltip/events")

      assert html =~ ~r/data-part="arrow"/
      assert html =~ ~r/data-part="arrow-tip"/
    end
  end
end
