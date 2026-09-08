defmodule CorexAdmin.Test.Admin do
  @moduledoc false

  use CorexAdmin,
    otp_app: :corex_admin,
    actor_assign: :current_scope,
    on_mount: [{CorexAdmin.Test.Auth, :ensure_admin}],
    policy: CorexAdmin.Test.Policy,
    layout: {CorexAdmin.Test.Layouts, :app},
    resources: [CorexAdmin.Test.TicketResource]
end
