defmodule <%= @web_namespace %>.ModeLive do
  def on_mount(:default, _params, session, socket) do
    mode = session["mode"] || "light"

    {:cont, Phoenix.Component.assign(socket, :mode, mode)}
  end
end
