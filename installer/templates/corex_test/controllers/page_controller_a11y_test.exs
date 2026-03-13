defmodule <%= @web_namespace %>.PageControllerA11yTest do
  use <%= @web_namespace %>.ConnCase, async: true
  use Wallaby.Feature

  feature "home page has no accessibility violations", %{session: session} do
<%= if @locale do %>    default_locale = Application.get_env(:<%= @app_name %>, :locales, ["en"]) |> List.first()
    path = "/#{default_locale}"

<% else %>    path = ~p"/"

<% end %>    session
    |> visit(path)
    |> A11yAudit.Wallaby.assert_no_violations()
  end
end
