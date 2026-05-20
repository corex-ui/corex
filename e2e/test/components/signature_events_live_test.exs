defmodule E2eWeb.SignatureEventsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "signature_drawn inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/signature-pad/events", on_error: :warn)

    html =
      render_click(view, "signature_drawn", %{
        "id" => "signature-events-server",
        "url" => "data:image/png;base64,AAAA"
      })

    assert html =~ ~S(data-part="row")
  end
end
