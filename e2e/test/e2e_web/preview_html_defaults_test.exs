defmodule E2eWeb.PreviewHtmlDefaultsTest do
  use E2eWeb.ConnCase, async: true

  test "main site html defaults data-mode and theme without cookies", %{conn: conn} do
    html = conn |> get(~p"/action/style") |> html_response(200)

    assert html =~ ~s(data-mode="light")
    assert html =~ ~s(data-theme="neo")
    refute html =~ "data-accessibility"
  end
end
