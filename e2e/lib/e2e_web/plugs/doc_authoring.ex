defmodule E2eWeb.Plugs.DocAuthoring do
  @moduledoc false

  import Plug.Conn

  alias E2eWeb.DocAuthoring

  def init(opts), do: opts

  def call(conn, _opts) do
    authoring = DocAuthoring.normalize_authoring(conn.cookies["phx_authoring"])

    DocAuthoring.put(authoring)

    conn
    |> assign(:authoring, authoring)
    |> put_session(:authoring, authoring)
  end
end
