defmodule <%= @web_namespace %>.ModeControllerTest do
  use <%= @web_namespace %>.ConnCase, async: true

  test "GET / renders data-mode, mode toggle, and mode script", %{conn: conn} do
    conn = get(conn, ~p"/en")
    html = html_response(conn, 200)
    assert html =~ "data-mode=\"light\""
    assert html =~ "mode-switcher"
    assert html =~ "phx:set-mode"
  end
end
