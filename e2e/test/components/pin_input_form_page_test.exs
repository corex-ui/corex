defmodule E2eWeb.PinInputFormPageTest do
  use E2eWeb.ConnCase, async: true

  test "phoenix form preview renders pin digit inputs in markup", %{conn: conn} do
    conn = get(conn, "/en/pin-input/form")
    html = html_response(conn, 200)

    assert html =~ "pin-input-form-page"
    assert html =~ ~S(id="pin-input-form-phoenix_pin")
    assert html =~ ~S(phx-hook="PinInput")
    assert html =~ ~S(data-part="input")
    assert html =~ ~S(data-index="0")
    refute html =~ ~S(id="pin-input-form-phoenix-section-tabs-content-preview" hidden)
  end
end
