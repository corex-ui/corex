defmodule CorexAdmin.Test.Router do
  @moduledoc false
  use Phoenix.Router
  import Phoenix.LiveView.Router
  import CorexAdmin.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {CorexAdmin.Test.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/" do
    pipe_through(:browser)
    live_corex_admin("/admin", CorexAdmin.Test.Admin)
  end
end
