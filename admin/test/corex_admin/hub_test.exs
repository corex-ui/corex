defmodule CorexAdmin.HubTest do
  use ExUnit.Case, async: true

  test "rejects empty on_mount" do
    assert_raise ArgumentError, fn ->
      CorexAdmin.__validate_opts__(Fake,
        otp_app: :corex_admin,
        actor_assign: :current_scope,
        on_mount: [],
        policy: CorexAdmin.Test.Policy,
        layout: {CorexAdmin.Test.Layouts, :app},
        resources: []
      )
    end
  end

  test "expands slugs from registered resources" do
    config = CorexAdmin.Test.Admin.__corex_admin__()

    assert {:ok, CorexAdmin.Test.TicketResource} =
             CorexAdmin.resource_for_slug(CorexAdmin.Test.Admin, "tickets")

    assert config.policy == CorexAdmin.Test.Policy
  end
end
