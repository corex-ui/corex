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
    assert html =~ "rounded-md"
    assert html =~ "ui-ghost"
    assert html =~ "text-success-text"
    assert html =~ "min-h-0"
    assert html =~ "flex-1"
    assert html =~ "lg:grid-cols-2"
    assert html =~ "grid-cols-2 max-sm:grid-cols-1"
    refute html =~ "md:grid-cols-2"
    refute html =~ "max-h-28"
    assert html =~ ~S(id="site-nav-dialog")
    assert html =~ "aria-label=\"Main navigation\""
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
  end

  test "homepage renders highlights section", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)

    assert html =~ ~S(id="home-highlights")
    assert html =~ ~S(id="home-highlights-heading")
    assert html =~ ~S(id="home-tech-marquee")
    assert html =~ "43+"
    assert html =~ "100+"
    assert html =~ "100%"
    assert html =~ "Components"
    assert html =~ "API &amp; Events" or html =~ "API & Events"
    assert html =~ "Open Source"
    assert html =~ "A11y"
    assert html =~ "Built in"
    assert html =~ "/images/tech/elixir.svg"
    assert html =~ "/images/tech/phoenix.svg"
    assert html =~ "/images/tech/tableau.jpg"
    assert html =~ "/images/tech/zag.webp"
    assert html =~ "/images/tech/ecto.png"
    assert html =~ "/images/tech/tailwind.svg"
    assert html =~ "/images/tech/hex.svg"
    assert html =~ "/images/tech/typescript.svg"
    refute html =~ "/images/tech/figma.svg"
    refute html =~ "/images/tech/html5.svg"
    refute html =~ "/images/tech/css.svg"
    refute html =~ "/images/tech/javascript.svg"
    assert html =~ "title=\"Elixir\""
    assert html =~ "title=\"Phoenix\""
    assert html =~ "title=\"Tableau\""
    assert html =~ "title=\"Ecto\""
    assert html =~ "Built for the Elixir ecosystem"
    refute html =~ "By the numbers"
    refute html =~ "bag of CSS classes"
    assert html =~ "phx-hook=\"Marquee\"" or html =~ "data-scope=\"marquee\""
    refute html =~ "grayscale"
  end

  test "homepage renders highlights before installer", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)

    refute html =~ ~S(id="home-design")

    highlights = :binary.match(html, ~S(id="home-highlights"))
    installer = :binary.match(html, ~S(id="home-installer"))

    assert highlights
    assert installer
    assert elem(highlights, 0) < elem(installer, 0)
  end

  test "homepage renders installer section", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)

    for id <- [
          "home-installer",
          "home-installer-heading",
          "home-installer-archives",
          "home-installer-archives-clipboard",
          "home-installer-generator",
          "home-installer-name",
          "home-installer-defaults",
          "home-installer-addons",
          "home-installer-command",
          "home-installer-clipboard"
        ] do
      assert html =~ ~s(id="#{id}")
    end

    assert html =~ "phx-hook=\"HomeInstaller\""
    assert html =~ "home-installer-changed"
    assert html =~ "mix corex.new my_app"
    assert html =~ "mix archive.install hex phx_new"
    assert html =~ "mix archive.install hex corex_new"
    assert html =~ "tableau_new"
    assert html =~ "data-archives-phoenix"
    assert html =~ "data-archives-tableau"
    assert html =~ ~S(data-value="phoenix")
    assert html =~ ~S(data-value="tableau")
    assert html =~ ~S(data-value="design")
    assert html =~ ~S(data-value="mcp")
    assert html =~ ~S(data-value="usage-rules")
    assert html =~ ~S(data-value="mode")
    assert html =~ ~S(data-value="theme")
    assert html =~ ~S(data-value="a11y")
    assert html =~ ~S(data-value="lang")
    assert html =~ "for=\"home-installer-name-input\""
    assert html =~ "data-scope=\"code\""
    assert html =~ "data-part=\"content\""
    assert html =~ "hero-question-mark-circle"
    assert html =~ "ui-width-full"
    assert html =~ "w-fit"
    assert html =~ "absolute top-2 right-2"
    refute html =~ "archives.sh"
    refute html =~ "create.sh"
  end

  test "docs page uses classic sticky header chrome", %{conn: conn} do
    conn = get(conn, ~p"/accordion/anatomy")
    html = html_response(conn, 200)

    refute html =~ ~S(id="home-header")
    refute html =~ ~S(id="home-footer")
    assert html =~ ~S(id="site-nav-dialog")
    assert html =~ "dialog--side"
    assert html =~ "aria-label=\"Main navigation\""
    assert html =~ "sticky top-0"
    assert html =~ "border-b border-border"
  end
end
