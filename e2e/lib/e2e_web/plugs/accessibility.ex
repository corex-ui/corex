defmodule E2eWeb.Plugs.Accessibility do
  @moduledoc false

  import Plug.Conn

  alias Corex.Design.Accessibility

  def init(opts), do: opts

  def call(conn, _opts) do
    a11y =
      conn.cookies
      |> Map.get("phx_a11y", "")
      |> Accessibility.parse()

    conn
    |> assign(:a11y, a11y)
    |> put_session(:a11y, a11y)
  end
end
