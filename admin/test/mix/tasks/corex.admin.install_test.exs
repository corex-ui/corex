defmodule Mix.Tasks.Corex.Admin.InstallTest do
  use ExUnit.Case, async: true

  test "installer policy template is deny-all" do
    contents =
      File.read!(
        Application.app_dir(:corex_admin, "priv/templates/corex.admin.install/policy.ex")
      )

    assert contents =~
             "def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}"

    refute contents =~ "do: :ok"
  end

  test "installer hub uses a LiveView admin layout, not slot-based Layouts.app" do
    hub =
      File.read!(Application.app_dir(:corex_admin, "priv/templates/corex.admin.install/admin.ex"))

    layout =
      File.read!(
        Application.app_dir(:corex_admin, "priv/templates/corex.admin.install/admin_layout.ex")
      )

    assert hub =~ "layout: {<%= inspect web_module %>.AdminLayout, :admin}"
    refute hub =~ "Layouts, :app"
    assert layout =~ "{@inner_content}"
    assert layout =~ "Components.nav_tree"
    refute layout =~ "render_slot(@inner_block)"
  end

  test "resource generator template points at a context, not Repo" do
    contents =
      File.read!(
        Application.app_dir(:corex_admin, "priv/templates/corex.admin.gen.resource/resource.ex")
      )

    assert contents =~ "use CorexAdmin.Resource"
    assert contents =~ "context:"
    refute contents =~ "Repo."
  end
end
