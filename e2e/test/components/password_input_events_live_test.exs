defmodule E2eWeb.PasswordInputEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "password_visibility_changed inserts a log row", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/password-input/events", on_error: :warn)

    html =
      render_click(view, "password_visibility_changed", %{
        "id" => "password-input-events-server",
        "visible" => true
      })

    assert html =~ ~s(data-part="row")
  end
end
