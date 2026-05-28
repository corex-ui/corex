defmodule E2eWeb.BlogLiveTest do
  use E2eWeb.ConnCase, async: true

  test "blog index lists posts in card grid", %{conn: conn} do
    conn = get(conn, ~p"/blog")
    html = html_response(conn, 200)

    assert html =~ "blog__grid"
    assert html =~ "Journal"
    assert html =~ "How Fast Is the Checkbox API?"
    assert html =~ "badge"
    assert html =~ "How Fast Is the Checkbox API?"
    refute html =~ "Getting started with Corex"
  end

  test "blog post shows continue reading and adjacent navigation", %{conn: conn} do
    conn =
      get(conn, ~p"/blog/the-vanilla-js-machine-that-doesnt-need-a-framework")

    html = html_response(conn, 200)

    assert html =~ "All articles"
    assert html =~ "blog__post-hero"
    assert html =~ "blog__read-next"
    assert html =~ "Continue reading"
    assert html =~ "Two Brains"
    assert html =~ "Nine Thousand Airports"
    assert html =~ "blog__post-nav"
    assert html =~ "hero-chevron-left"
    assert html =~ "hero-chevron-right"
    refute html =~ "blog__post-footer"
    refute html =~ "blog__continue"
  end

  test "anatomy article renders focused content", %{conn: conn} do
    conn = get(conn, ~p"/blog/anatomy-of-a-corex-component")
    html = html_response(conn, 200)

    assert html =~ "Anatomy of a Corex Component"
    assert html =~ "accordion_root"
    assert html =~ "data-scope"
    assert html =~ "compound"
    assert html =~ "The ladder"
    refute html =~ "mix corex.new"
  end

  test "stub posts link to anatomy article", %{conn: conn} do
    vanilla_conn =
      get(conn, ~p"/blog/the-vanilla-js-machine-that-doesnt-need-a-framework")

    vanilla_html = html_response(vanilla_conn, 200)

    machines_conn =
      get(conn, ~p"/blog/two-brains-liveview-assigns-and-zag-machines")

    machines_html = html_response(machines_conn, 200)

    assert vanilla_html =~ "anatomy-of-a-corex-component"
    assert machines_html =~ "anatomy-of-a-corex-component"
  end

  test "blog post page renders markdown body", %{conn: conn} do
    conn = get(conn, ~p"/blog/anatomy-of-a-corex-component")
    html = html_response(conn, 200)

    assert html =~ "Anatomy of a Corex Component"
    assert html =~ "accordion_item"
    assert html =~ "blog__article-shell"
    assert html =~ "min read"
  end

  test "design tokens article renders utilities and contrast section", %{conn: conn} do
    conn = get(conn, ~p"/blog/paint-the-parts-the-machine-already-owns")
    html = html_response(conn, 200)

    assert html =~ "ui-input"
    assert html =~ "Contrast is a number"
  end

  test "unknown slug redirects to blog index", %{conn: conn} do
    conn = get(conn, ~p"/blog/does-not-exist")
    assert redirected_to(conn) == ~p"/blog"
    assert Phoenix.Flash.get(conn.assigns.flash, :error)
  end

  test "blog index paginates four posts per page", %{conn: conn} do
    conn = get(conn, ~p"/blog")
    html = html_response(conn, 200)

    assert html =~ "blog-index-pagination"

    conn = get(conn, ~p"/blog?page=2")
    page2_html = html_response(conn, 200)

    assert page2_html =~ "blog-index-pagination"
    refute page2_html =~ "How Fast Is the Checkbox API?"
    assert page2_html =~ "Anatomy of a Corex Component"
  end

  test "arabic blog index uses translated shell", %{conn: conn} do
    conn = get(conn, "/ar/blog")
    html = html_response(conn, 200)

    assert html =~ "blog__grid"
    assert html =~ "اليوميات"
    assert html =~ "ما سرعة Checkbox"
    refute html =~ "How Fast Is the Checkbox API?"
  end
end
