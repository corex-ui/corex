defmodule E2eWeb.HomePageTest do
  use E2eWeb.ConnCase, async: true

  test "homepage renders main accordion API hero", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)

    for id <- [
          "home",
          "home-header",
          "home-footer",
          "home-hero-heading",
          "home-hero-interactive",
          "hero-accordion",
          "hero-events-table",
          "hero-events-badge"
        ] do
      assert html =~ ~s(id="#{id}")
    end

    assert html =~ "real API"
    assert html =~ "Browse components"
    assert html =~ "ui-rounded-full"
    assert html =~ "ui-ghost"
    assert html =~ "text-success-text"
    assert html =~ "min-h-0"
    assert html =~ "flex-1"
    assert html =~ "lg:grid-cols-2"
    refute html =~ "md:grid-cols-2"
    refute html =~ "max-h-28"
    assert html =~ ~S(id="site-nav-menu")
    assert html =~ "phx-hook=\"HomeHero\""
    assert html =~ "hero-accordion-changed"
    assert html =~ "data-hero-accordion-value"
    refute html =~ ~S(id="hero-code")
    refute html =~ "min-h-72"
    refute html =~ ~S(id="home-hero-demo")
    refute html =~ ~S(id="home-anatomy")
    refute html =~ ~S(id="home-api")
    refute html =~ ~S(id="home-cta")
    refute html =~ ~S(id="home-catalog")
    refute html =~ "dialog--side"
  end

  test "docs page uses classic sticky header chrome", %{conn: conn} do
    conn = get(conn, ~p"/accordion/anatomy")
    html = html_response(conn, 200)

    refute html =~ ~S(id="home-header")
    refute html =~ ~S(id="home-footer")
    refute html =~ "dialog--side"
    assert html =~ ~S(id="site-nav-menu")
    assert html =~ "sticky top-0"
    assert html =~ "border-b border-border"
  end
end
