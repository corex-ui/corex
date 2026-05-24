defmodule E2eWeb.SelectFormPageTest do
  use E2eWeb.ConnCase

  test "GET form page includes named value input for phoenix and ecto forms", %{conn: conn} do
    conn = get(conn, ~p"/select/form")
    html = html_response(conn, 200)

    assert html =~ ~S(name="select_phoenix[country]")
    assert html =~ ~S(name="select_ecto[country]")
    assert html =~ ~S(id="select-form-phoenix")
    assert html =~ ~S(id="select-form-ecto")
  end

  test "POST phoenix form with country", %{conn: conn} do
    conn = get(conn, ~p"/select/form")
    html = html_response(conn, 200)

    token =
      Regex.run(~r/name="_csrf_token" value="([^"]+)"/, html)
      |> List.last()

    conn =
      post(conn, ~p"/select/form", %{
        "_csrf_token" => token,
        "select_phoenix" => %{"country" => "fra"}
      })

    assert redirected_to(conn) =~ "/select/form#select-form-phoenix"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted: country=\"fra\""
  end

  test "POST ecto form with country", %{conn: conn} do
    conn = get(conn, ~p"/select/form")
    html = html_response(conn, 200)

    token =
      Regex.run(~r/name="_csrf_token" value="([^"]+)"/, html)
      |> List.last()

    conn =
      post(conn, ~p"/select/form", %{
        "_csrf_token" => token,
        "select_ecto" => %{"country" => "fra"}
      })

    assert redirected_to(conn) =~ "/select/form#select-form-ecto"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted: country=\"fra\""
  end
end
