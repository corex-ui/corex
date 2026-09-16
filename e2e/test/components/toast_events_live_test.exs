defmodule E2eWeb.ToastEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "toast_api_push_info renders the API page", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/toast/api")

    html = render_click(view, "toast_api_push_info", %{})
    assert html =~ "toast"
  end
end
