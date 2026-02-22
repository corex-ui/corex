defmodule E2eWeb.ThemeLive do
  @moduledoc """
  Assigns the theme from the session to the LiveView socket.
  """
  def on_mount(:default, _params, session, socket) do
    theme = session["theme"] || "neo"

    {:cont, Phoenix.Component.assign(socket, :theme, theme)}
  end
end
