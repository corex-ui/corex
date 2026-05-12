defmodule E2eWeb.DatePickerPatternsLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "DatePickerPatternsLive" do
    test "controlled value updates and does not revert when the server assigns a new value", %{
      conn: conn
    } do
      {:ok, live, html} = live(conn, ~p"/date-picker/patterns")

      assert html =~ "date-picker-patterns-page"
      assert html =~ "date-picker-patterns-status"
      assert html =~ "Selected:"
      refute html =~ "2026-04-10"

      html =
        live
        |> element("#date-picker-patterns-controlled")
        |> render_hook("pattern_date_changed", %{
          "id" => "date-picker-patterns-controlled",
          "value" => "2026-04-10"
        })

      assert html =~ "2026-04-10"
      refute html =~ "Selected:  - "

      html =
        live
        |> element("#date-picker-patterns-controlled")
        |> render_hook("pattern_date_changed", %{
          "id" => "date-picker-patterns-controlled",
          "value" => "2026-05-20"
        })

      assert html =~ "2026-05-20"
      refute html =~ "2026-04-10"
    end
  end
end
