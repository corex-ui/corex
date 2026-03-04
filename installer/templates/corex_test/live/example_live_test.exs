defmodule <%= @web_namespace %>.ExampleLiveTest do
  use <%= @web_namespace %>.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
<%= if @language_switcher do %>    default_locale = Application.get_env(:<%= @app_name %>, :locales, ["en"]) |> List.first()
    {:ok, _view, html} = live(conn, "/#{default_locale}/live")
<% else %>    {:ok, _view, html} = live(conn, ~p"/live")
<% end %>    assert html =~ "Live View"
  end
end
