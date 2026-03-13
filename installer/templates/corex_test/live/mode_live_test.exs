defmodule <%= @web_namespace %>.ModeLiveTest do
  use <%= @web_namespace %>.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "connected mount renders data-mode and mode script", %{conn: conn} do
<%= if @locale do %>    default_locale = Application.get_env(:<%= @app_name %>, :locales, ["en"]) |> List.first()
    {:ok, _view, html} = live(conn, "/#{default_locale}/live")
<% else %>    {:ok, _view, html} = live(conn, ~p"/live")
<% end %>    assert html =~ "data-mode=\"light\""
    assert html =~ "phx:set-mode"
  end
end
