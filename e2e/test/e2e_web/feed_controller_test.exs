defmodule E2eWeb.FeedControllerTest do
  use E2eWeb.ConnCase, async: true

  test "GET /feed.xml", %{conn: conn} do
    conn = get(conn, "/feed.xml")
    body = response(conn, 200)

    assert body =~ ~S(<?xml version="1.0" encoding="UTF-8"?>)
    assert body =~ "<rss version=\"2.0\""
    assert body =~ "<title>Corex Blog</title>"
    assert body =~ "/feed.xml"
    assert body =~ "/en/blog/anatomy-of-a-corex-component/"
    assert body =~ "Anatomy of a Corex component"
    refute body =~ "getting-started-with-corex"
    refute body =~ "Getting started with Corex"
  end
end
