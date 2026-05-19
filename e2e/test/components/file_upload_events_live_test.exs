defmodule E2eWeb.FileUploadEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "fu_ev_server inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload/events", on_error: :warn)

    html =
      render_click(view, "fu_ev_server", %{
        "id" => "file-upload-events-server",
        "acceptedCount" => 1,
        "rejectedCount" => 0
      })

    assert html =~ ~S(data-part="row")
  end
end
