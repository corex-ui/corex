defmodule E2eWeb.Admin do
  @moduledoc false

  use CorexAdmin,
    otp_app: :corex_web,
    actor_assign: :current_scope,
    on_mount: [
      E2eWeb.ModeLive,
      E2eWeb.ThemeLive,
      E2eWeb.AccessibilityLive,
      E2eWeb.PathLive,
      {E2eWeb.AdminAuth, :ensure_demo}
    ],
    policy: E2eWeb.AdminPolicy,
    layout: {E2eWeb.Layouts, :admin},
    title: "Admin",
    description: "Support queue and editorial calendar for this demo session",
    resources: [
      E2eWeb.Admin.TicketResource,
      E2eWeb.Admin.PostResource,
      E2eWeb.Admin.AuthorResource
    ]
end
