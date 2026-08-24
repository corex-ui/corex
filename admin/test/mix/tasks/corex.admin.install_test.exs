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
