defmodule E2eWeb.TagsInputFormPageTest do
  use E2eWeb.ConnCase

  test "GET form page includes array submit inputs for phoenix and ecto forms", %{conn: conn} do
    conn = get(conn, ~p"/tags-input/form")
    html = html_response(conn, 200)

    assert html =~ ~S(name="tags_input_phoenix[tags][]")
    assert html =~ ~S(name="tags_input_ecto[tags][]")
    assert html =~ ~S(id="tags-input-form-phoenix")
    assert html =~ ~S(id="tags-input-form-ecto")
  end

  test "POST phoenix form with tags list", %{conn: conn} do
    conn = get(conn, ~p"/tags-input/form")
    html = html_response(conn, 200)

    token =
      Regex.run(~r/name="_csrf_token" value="([^"]+)"/, html)
      |> List.last()

    conn =
      post(conn, ~p"/tags-input/form", %{
        "_csrf_token" => token,
        "tags_input_phoenix" => %{"tags" => ["alpha", "beta"]}
      })

    assert redirected_to(conn) =~ "/tags-input/form#tags-input-form-phoenix"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted: tags=[\"alpha\", \"beta\"]"
  end

  test "POST ecto form with tags list", %{conn: conn} do
    conn = get(conn, ~p"/tags-input/form")
    html = html_response(conn, 200)

    token =
      Regex.run(~r/name="_csrf_token" value="([^"]+)"/, html)
      |> List.last()

    conn =
      post(conn, ~p"/tags-input/form", %{
        "_csrf_token" => token,
        "tags_input_ecto" => %{"tags" => ["alpha", "beta"]}
      })

    assert redirected_to(conn) =~ "/tags-input/form#tags-input-form-ecto"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted: tags=[\"alpha\", \"beta\"]"
  end
end
