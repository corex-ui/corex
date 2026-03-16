defmodule E2eWeb.TooltipMarkupTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @locale "en"

  describe "static tooltip page" do
    test "renders tooltip data attributes", %{conn: conn} do
      conn = get(conn, ~p"/#{@locale}/tooltip")
      html = html_response(conn, 200)

      assert html =~ ~r/data-scope="tooltip"/
      assert html =~ ~r/data-part="trigger"/
      assert html =~ ~r/data-part="positioner"/
      assert html =~ ~r/data-part="content"/
    end

    test "renders arrow parts when show_arrow", %{conn: conn} do
      conn = get(conn, ~p"/#{@locale}/tooltip")
      html = html_response(conn, 200)

      assert html =~ ~r/data-part="arrow"/
      assert html =~ ~r/data-part="arrow-tip"/
    end
  end

  describe "live tooltip page" do
    test "renders tooltip data attributes", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/tooltip")

      assert html =~ ~r/data-scope="tooltip"/
      assert html =~ ~r/data-part="trigger"/
      assert html =~ ~r/data-part="positioner"/
      assert html =~ ~r/data-part="content"/
    end

    test "renders arrow parts when show_arrow", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/tooltip")

      assert html =~ ~r/data-part="arrow"/
      assert html =~ ~r/data-part="arrow-tip"/
    end
  end
end
