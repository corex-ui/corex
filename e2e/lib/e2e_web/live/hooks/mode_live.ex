defmodule E2eWeb.ModeLive do
  @moduledoc """
  Assigns the mode from the session to the LiveView socket.
  """
  def on_mount(:default, _params, session, socket) do
    mode = session["mode"] || "light"

    {:cont, Phoenix.Component.assign(socket, :mode, mode)}
  end
end
