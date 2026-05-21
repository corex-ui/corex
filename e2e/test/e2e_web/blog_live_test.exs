defmodule E2eWeb.BlogLiveTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "blog index lists posts in card grid", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/blog")

    assert html =~ "blog__grid"
    assert html =~ "Journal"
    assert html =~ "Corex and State Machines"
    assert html =~ "badge"
    assert has_element?(view, "a", "Corex and State Machines")
    refute has_element?(view, "a", "Getting started with Corex")
  end

  test "blog post shows continue reading and adjacent navigation", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/blog/vanilla-js")

    assert html =~ "All articles"
    assert html =~ "blog__post-hero"
    assert html =~ "blog__read-next"
    assert html =~ "Continue reading"
    assert html =~ "Corex and State Machines"
    assert html =~ "How to render 9000+ items in a Combobox?"
    assert html =~ "blog__post-nav"
    assert html =~ "hero-chevron-left"
    assert html =~ "hero-chevron-right"
    refute html =~ "blog__post-footer"
    refute html =~ "blog__continue"
  end

  test "anatomy article renders focused content", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/blog/anatomy-of-a-corex-component")

    assert html =~ "Anatomy of a Corex component"
    assert html =~ "Corex.Content.new"
    assert html =~ "Corex.List.new"
    assert html =~ "compound"
    assert html =~ "Manual Slots"
    refute html =~ "VanillaMachine"
    refute html =~ "mix corex.new"
  end

  test "stub posts link to anatomy article", %{conn: conn} do
    {:ok, _view, vanilla_html} = live(conn, ~p"/blog/vanilla-js")
    {:ok, _view, machines_html} = live(conn, ~p"/blog/state-machines")

    assert vanilla_html =~ "anatomy-of-a-corex-component"
    assert machines_html =~ "anatomy-of-a-corex-component"
  end

  test "blog post page renders markdown body", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/blog/anatomy-of-a-corex-component")

    assert html =~ "Anatomy of a Corex component"
    assert html =~ "clipboard"
    assert html =~ "Corex.Content.new"
    assert html =~ "blog__article-shell"
    assert html =~ "min read"
  end

  test "blog post renders corex callout", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/blog/corex-design-a11y")

    assert html =~ "corex-callout"
    assert html =~ "Contrast from day one"
  end

  test "unknown slug redirects to blog index", %{conn: conn} do
    assert {:error, {:live_redirect, %{to: "/en/blog"}}} =
             live(conn, ~p"/blog/does-not-exist")
  end

  test "blog index paginates four posts per page", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/blog")

    assert html =~ "blog-index-pagination"
    assert has_element?(view, "#blog-index-pagination")

    {:ok, _view, page2_html} = live(conn, ~p"/blog?page=2")

    assert page2_html =~ "blog-index-pagination"
    refute page2_html =~ "Corex and State Machines"
    assert page2_html =~ "Anatomy of a Corex component"
  end

  test "arabic blog index uses translated shell", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/ar/blog")

    assert html =~ "Journal"
    assert html =~ "تشريح مكوّن Corex"
  end
end
