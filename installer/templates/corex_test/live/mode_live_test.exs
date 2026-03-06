defmodule <%= @web_namespace %>.ModeLiveTest do
  use <%= @web_namespace %>.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "connected mount renders data-mode and mode script", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"en/live")
    assert html =~ "data-mode=\"light\""
    assert html =~ "phx:set-mode"
  end
end
