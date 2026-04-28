defmodule Corex.Integration.CodeGeneration.CorexIncrementalFlagsTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "incrementally adding Corex flags after install" do
    test "plain corex.new then add --lang then --mode --theme reaches same final tree" do
      with_installer_tmp("corex_incremental", fn tmp_dir ->
        {incremental_root, _} = generate_corex_app(tmp_dir, "my_app")

        mix_run!(
          ["igniter.install", "corex", "--yes", "--lang"],
          incremental_root
        )

        assert_corex_lang_path_plug_invariants!(incremental_root, "my_app")

        mix_run!(
          ["igniter.install", "corex", "--yes", "--mode", "--theme"],
          incremental_root
        )

        web = Path.join(incremental_root, "lib/my_app_web")
        router = File.read!(Path.join(web, "router.ex"))
        layouts = File.read!(Path.join(web, "components/layouts.ex"))

        assert router =~ "Plugs.Mode"
        assert router =~ "Plugs.Theme"
        assert router =~ "Plugs.Path"
        assert Regex.scan(~r/MyAppWeb\.Plugs\.Mode/, router) |> length() == 1
        assert Regex.scan(~r/MyAppWeb\.Plugs\.Theme/, router) |> length() == 1
        assert Regex.scan(~r/MyAppWeb\.Plugs\.Path/, router) |> length() == 1

        mode_plug = File.read!(Path.join(web, "plugs/mode.ex"))
        theme_plug = File.read!(Path.join(web, "plugs/theme.ex"))
        path_plug = File.read!(Path.join(web, "plugs/path.ex"))

        assert mode_plug =~ "defmodule MyAppWeb.Plugs.Mode"
        assert theme_plug =~ "defmodule MyAppWeb.Plugs.Theme"
        assert path_plug =~ "defmodule MyAppWeb.Plugs.Path"

        assert layouts =~ "def language_switch"
      end)
    end

    test "single-call corex.new --mode --theme --lang matches incremental sequence semantically" do
      with_installer_tmp("corex_single_call", fn tmp_dir ->
        {single_root, _} =
          generate_corex_app(tmp_dir, "my_app", ["--mode", "--theme", "--lang"])

        for rel <- [
              "lib/my_app_web/plugs/mode.ex",
              "lib/my_app_web/plugs/theme.ex",
              "lib/my_app_web/plugs/path.ex"
            ] do
          assert File.exists?(Path.join(single_root, rel))
        end

        layouts = File.read!(Path.join(single_root, "lib/my_app_web/components/layouts.ex"))
        assert layouts =~ "def language_switch"
      end)
    end
  end
end
