defmodule E2eWeb.SignatureFormSubmitTest do
  use E2eWeb.ConnCase

  setup do
    Localize.put_locale(:en)
    :ok
  end

  defp post_form(params) do
    build_conn()
    |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
    |> post(~p"/signature-pad/form", params)
  end

  test "POST ecto form without signature key re-renders with validation error", %{conn: _conn} do
    conn = post_form(%{"signature_ecto" => %{"_sent" => "1"}})

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    assert html =~ "signature-form-ecto"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST with no form params re-renders ecto validation error", %{conn: _conn} do
    conn = post_form(%{})

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST ecto form with empty signature array re-renders with validation error", %{
    conn: _conn
  } do
    conn =
      post_form(%{
        "signature_ecto" => %{
          "_sent" => "1",
          "signature" => [""]
        }
      })

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end
end
