defmodule <%= @web_namespace %>.Plugs.ModeTest do
  use <%= @web_namespace %>.ConnCase, async: true

  test "assigns :mode to \"light\" when no cookie", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert conn.assigns[:mode] == "light"
  end

  test "assigns :mode to \"dark\" when phx_mode cookie is dark", %{conn: conn} do
    conn =
      conn
      |> put_req_cookie("phx_mode", "dark")
      |> get(~p"/")

    assert conn.assigns[:mode] == "dark"
  end
end
