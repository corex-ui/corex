defmodule Corex.Integration.CodeGeneration.CorexInstallArgsTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "bare-flag UX for mix igniter.install corex" do
    test "accepts --mode --theme --lang without --corex.* prefix" do
      with_installer_tmp("corex_bare_flags", fn tmp_dir ->
        {app_root_path, _} = generate_plain_phoenix_app(tmp_dir, "my_app")

        mix_run!(
          [
            "igniter.install",
            "corex",
            "--yes",
            "--yes-to-deps",
            "--mode",
            "--theme",
            "--lang",
            "--no-design"
          ],
          app_root_path
        )

        web = Path.join(app_root_path, "lib/my_app_web")

        for rel <- ["plugs/mode.ex", "plugs/theme.ex", "plugs/path.ex"] do
          assert File.exists?(Path.join(web, rel)),
                 "expected #{rel} to be generated when bare --mode/--theme/--lang are passed"
        end

        router = File.read!(Path.join(web, "router.ex"))
        assert router =~ "MyAppWeb.Plugs.Mode"
        assert router =~ "MyAppWeb.Plugs.Theme"
        assert router =~ "MyAppWeb.Plugs.Path"
      end)
    end
  end
end
