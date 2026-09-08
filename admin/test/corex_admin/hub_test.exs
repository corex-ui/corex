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
    assert config.title == "Admin"
    assert config.description == nil
    assert config.home == CorexAdmin.Live.Home
    assert config.pages == []
  end

  test "accepts hub chrome and page seams" do
    opts =
      CorexAdmin.__validate_opts__(FakeHub,
        otp_app: :corex_admin,
        actor_assign: :current_scope,
        on_mount: [{CorexAdmin.Test.Auth, :ensure_admin}],
        policy: CorexAdmin.Test.Policy,
        layout: {CorexAdmin.Test.Layouts, :app},
        title: "Staff",
        description: "Internal",
        home: FakeDashboard,
        pages: [{"/reports", FakeReports}],
        resources: []
      )

    config = CorexAdmin.__expand_config__(FakeHub, opts)

    assert config.title == "Staff"
    assert config.description == "Internal"
    assert config.home == FakeDashboard
    assert config.pages == [{"/reports", FakeReports}]
    assert CorexAdmin.Router.home_live(config.home) == {FakeDashboard, :index}
    assert CorexAdmin.Router.home_live({FakeDashboard, :show}) == {FakeDashboard, :show}
  end

  test "rejects unsafe page paths" do
    opts =
      CorexAdmin.__validate_opts__(FakeHub,
        otp_app: :corex_admin,
        actor_assign: :current_scope,
        on_mount: [{CorexAdmin.Test.Auth, :ensure_admin}],
        policy: CorexAdmin.Test.Policy,
        layout: {CorexAdmin.Test.Layouts, :app},
        pages: [{"/:resource", FakeReports}],
        resources: []
      )

    assert_raise ArgumentError, fn ->
      CorexAdmin.__expand_config__(FakeHub, opts)
    end
  end
end
