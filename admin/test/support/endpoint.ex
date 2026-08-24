defmodule CorexAdmin.Test.Endpoint do
  @moduledoc false
  use Phoenix.Endpoint, otp_app: :corex_admin

  @session_options [
    store: :cookie,
    key: "_corex_admin_test",
    signing_salt: "corexadmin",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CorexAdmin.Test.Router
end
