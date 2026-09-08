defmodule E2eWeb.NavigateEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "patterns page renders navigate examples", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/navigate/patterns")
    assert html =~ "navigate"
  end
end
