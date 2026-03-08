defmodule <%= @web_namespace %>.PageControllerTest do
  use <%= @web_namespace %>.ConnCase

  test "GET /", %{conn: conn} do
<%= if @locale do %>    default_locale = Application.get_env(:<%= @app_name %>, :locales, ["en"]) |> List.first()
    conn = get(conn, "/#{default_locale}")
<% else %>    conn = get(conn, ~p"/")
<% end %>    assert html_response(conn, 200) =~ "Corex"
  end
end
