defmodule CorexAdmin.Test.Auth do
  @moduledoc false

  def on_mount(:ensure_admin, _params, session, socket) do
    scope = %{
      demo_id: session["admin_demo_id"] || "test-demo",
      role: session_role(session)
    }

    {:cont, Phoenix.Component.assign(socket, :current_scope, scope)}
  end

  defp session_role(%{"role" => role}) when role in ["admin", :admin], do: :admin
  defp session_role(%{"role" => _}), do: :viewer
  defp session_role(_), do: :admin
end
