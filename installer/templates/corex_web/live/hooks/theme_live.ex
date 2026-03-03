defmodule <%= @web_namespace %>.ThemeLive do
  def on_mount(:default, _params, session, socket) do
    themes = Application.get_env(:<%= @app_name %>, :themes, ["neo"])
    default_theme = List.first(themes) || "neo"
    theme = session["theme"] || default_theme

    {:cont,
     socket
     |> Phoenix.Component.assign(:theme, theme)
     |> Phoenix.Component.assign(:themes, themes)}
  end
end
