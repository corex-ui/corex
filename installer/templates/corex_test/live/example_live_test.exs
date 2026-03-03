defmodule <%= @web_namespace %>.ExampleLiveTest do
  use <%= @web_namespace %>.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/live")
    assert html =~ "Live View"
  end
end
