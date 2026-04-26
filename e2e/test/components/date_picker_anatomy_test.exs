defmodule E2eWeb.DatePickerAnatomyTest do
  use E2eWeb.ConnCase, async: true

  test "anatomy: range has two visible inputs, multiple exposes max cap attribute", %{conn: conn} do
    conn = get(conn, "/en/date-picker/anatomy")
    html = html_response(conn, 200)

    assert length(Regex.scan(~r/data-part="input"/, html)) == 4
    assert html =~ "id=\"date-picker-anatomy-multiple\""
    assert html =~ "data-max-selected-dates=\"3\""
  end
end
