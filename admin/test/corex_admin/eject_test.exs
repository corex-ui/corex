defmodule CorexAdmin.EjectTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Eject

  test "every ejectable block's source is locatable" do
    for mod <- Eject.ejectable() do
      assert {:ok, path} = Eject.source_path(mod)
      assert File.exists?(path)
      assert Path.extname(path) == ".ex"
    end
  end

  test "the shared base and label vocabulary stay in the package" do
    refute CorexAdmin.UI in Eject.ejectable()
    refute CorexAdmin.UI.Labels in Eject.ejectable()
  end

  test "rewriting moves block names into the host namespace" do
    {:ok, path} = Eject.source_path(CorexAdmin.UI.Index)
    rewritten = path |> File.read!() |> Eject.rewrite(MyAppWeb.Admin.Components)

    assert rewritten =~ "defmodule MyAppWeb.Admin.Components.Index do"
    assert rewritten =~ "MyAppWeb.Admin.Components.Dialogs"
    assert rewritten =~ "MyAppWeb.Admin.Components.Fields"

    # The imports macro and the translated vocabulary are not ejected, so they
    # must still resolve to the package.
    assert rewritten =~ "use CorexAdmin.UI"
    refute rewritten =~ "MyAppWeb.Admin.Components.Labels"
  end

  test "rewritten blocks compile in the host namespace" do
    sources =
      for mod <- Eject.ejectable() do
        {:ok, path} = Eject.source_path(mod)
        path |> File.read!() |> Eject.rewrite(CorexAdmin.EjectFixture.Components)
      end

    modules =
      Enum.flat_map(sources, fn source ->
        source |> Code.compile_string() |> Enum.map(&elem(&1, 0))
      end)

    assert CorexAdmin.EjectFixture.Components.Index in modules
    assert CorexAdmin.EjectFixture.Components.Filters in modules
    assert function_exported?(CorexAdmin.EjectFixture.Components.Index, :page, 1)
  after
    for mod <- Eject.ejectable() do
      :code.purge(Module.concat(CorexAdmin.EjectFixture.Components, Eject.block_name(mod)))
      :code.delete(Module.concat(CorexAdmin.EjectFixture.Components, Eject.block_name(mod)))
    end
  end

  test "a manifest round-trips through render and read" do
    manifest = %{
      "CorexAdmin.UI.Index" => %{version: "9.9.9", sha256: "deadbeef"}
    }

    dir = Path.join(System.tmp_dir!(), "corex_admin_eject_#{System.unique_integer([:positive])}")
    File.mkdir_p!(Path.join(dir, "priv/corex_admin"))
    File.write!(Path.join(dir, Eject.manifest_path()), Eject.render_manifest(manifest))

    assert Eject.read_manifest(dir) == manifest
  after
    :ok
  end

  test "audit flags a block whose upstream source has moved on" do
    manifest = %{
      "CorexAdmin.UI.Index" => %{version: "0.0.1", sha256: "not-the-current-digest"}
    }

    assert [{"CorexAdmin.UI.Index", {:stale, "0.0.1", _installed}}] = Eject.audit(manifest)
  end

  test "audit reports a block that is still current" do
    {:ok, path} = Eject.source_path(CorexAdmin.UI.Index)

    manifest = %{
      "CorexAdmin.UI.Index" => %{version: Eject.version(), sha256: Eject.digest(path)}
    }

    assert [{"CorexAdmin.UI.Index", :current}] = Eject.audit(manifest)
  end

  test "audit refuses a manifest key that is not an ejectable block" do
    manifest = %{"CorexAdmin.Live.Index.Controller" => %{version: "1.0.0", sha256: "x"}}

    assert [{_key, {:unknown, reason}}] = Eject.audit(manifest)
    assert reason =~ "not an ejectable block"
  end
end
