defmodule Corex.Integration.CodeGeneration.IgniterNewWithoutPhxNewArchiveTest do
  use Corex.Integration.CodeGeneratorCase, async: false

  @tag timeout: 600_000
  test "mix corex.new works without phx_new archive (igniter.new path)" do
    if System.get_env("COREX_NETWORK_TESTS") != "1" do
      assert true
    else
      with_installer_tmp("igniter_new_without_phx_new_archive", fn tmp_dir ->
        mix_home = Path.join(tmp_dir, "mix_home")
        File.mkdir_p!(mix_home)

        {out, code} =
          System.cmd(
            "mix",
            ["archive.install", "hex", "igniter_new", "--force"],
            stderr_to_stdout: true,
            env: [{"MIX_HOME", mix_home}]
          )

        assert code == 0
        assert out =~ "igniter_new"

        app_path = Path.expand("phx_absence_app", tmp_dir)
        corex_root = Path.expand("../../..", __DIR__)

        {output, exit_code} =
          System.cmd(
            "mix",
            [
              "corex.new",
              app_path,
              "--no-install",
              "--no-version-check",
              "--no-design",
              "--dev-corex",
              corex_root
            ],
            stderr_to_stdout: true,
            cd: Path.expand("../../", __DIR__),
            env: [{"MIX_HOME", mix_home}]
          )

        assert exit_code == 0
        assert output =~ "mix igniter.new"
      end)
    end
  end
end

