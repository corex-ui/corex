defmodule <%= inspect web_module %>.Admin do
  @moduledoc false

  use CorexAdmin,
    otp_app: <%= inspect otp_app %>,
    actor_assign: :current_scope,
    on_mount: [{<%= inspect web_module %>.UserAuth, :ensure_authenticated}],
    policy: <%= inspect web_module %>.AdminPolicy,
    layout: {<%= inspect web_module %>.AdminLayout, :admin},
    title: "Admin",
    resources: []
end
