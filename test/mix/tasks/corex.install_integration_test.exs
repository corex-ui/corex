defmodule Mix.Tasks.Corex.InstallIntegrationTest do
  use ExUnit.Case, async: false

  @moduletag :integration
  @tag :tmp_dir
  @tag timeout: 180_000

  test "runs full install in real Phoenix project (covers non-test-mode igniter paths)", %{
    tmp_dir: tmp_dir
  } do
    project_dir = Path.join(tmp_dir, "demo")
    corex_path = Path.expand("../../..", __DIR__)

    {_, 0} =
      System.cmd(
        "mix",
        [
          "phx.new",
          project_dir,
          "--no-ecto",
          "--no-mailer",
          "--no-install"
        ], cd: File.cwd!())

    env = System.get_env() |> Map.put("MIX_ENV", "dev") |> Map.to_list()
    {_, 0} = System.cmd("mix", ["deps.get"], cd: project_dir, env: env)
    {_, 0} = System.cmd("mix", ["compile"], cd: project_dir, env: env)

    {output, 0} =
      System.cmd("mix", ["igniter.install", "corex@path:#{corex_path}", "--yes", "--no-design"],
        cd: project_dir,
        env: env
      )

    templates_root = Path.join(project_dir, "priv/templates")

    assert File.dir?(Path.join(templates_root, "phx.gen.html")),
           "templates not copied. install output: #{output}"

    assert File.dir?(Path.join(templates_root, "phx.gen.live"))

    app_js = File.read!(Path.join(project_dir, "assets/js/app.js"))
    assert app_js =~ ~r/from "corex"/
  end
end
