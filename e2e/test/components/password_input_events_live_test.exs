defmodule E2eWeb.PasswordInputEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "password_visibility_changed inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/password-input/events", on_error: :warn)

    html =
      render_click(view, "password_visibility_changed", %{
        "id" => "password-input-events-server",
        "visible" => true
      })

    assert html =~ ~S(data-part="row")
  end
end
