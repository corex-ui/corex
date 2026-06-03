defmodule E2eWeb.DocAuthoringLive do
  @moduledoc false

  alias E2eWeb.DocAuthoring

  def on_mount(:default, _params, session, socket) do
    authoring = DocAuthoring.normalize_authoring(session["authoring"])

    DocAuthoring.put(authoring)

    {:cont, Phoenix.Component.assign(socket, :authoring, authoring)}
  end
end
