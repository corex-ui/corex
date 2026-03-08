defmodule <%= @web_namespace %>.ErrorHTMLTest do
  use <%= @web_namespace %>.ConnCase, async: true

  import Phoenix.Template, only: [render_to_string: 4]

  test "renders 404.html" do
    html = render_to_string(<%= @web_namespace %>.ErrorHTML, "404", "html", [])
    assert html =~ "404"
    assert html =~ "Page Not Found"
    assert html =~ "does not exist"
  end

  test "returns 404 for nonexistent route", %{conn: conn} do
    path =
      <%= if @locale do %>"/" <> (Application.get_env(:<%= @app_name %>, :locales, ["en"]) |> List.first()) <> "/nonexistent"<% else %>"/nonexistent"<% end %>

    conn = get(conn, path)
    assert conn.status == 404
    assert html_response(conn, 404) =~ "404"
    assert html_response(conn, 404) =~ "does not exist"
  end

  test "renders 500.html" do
    assert render_to_string(<%= @web_namespace %>.ErrorHTML, "500", "html", []) ==
             "Internal Server Error"
  end
end
