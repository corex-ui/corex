defmodule Corex.Integration.CodeGeneration.DevCorexNewTest do
  @moduledoc """
  End-to-end check for `mix corex.new ... --dev <repo>` before publishing Hex.

  Uses `--no-design` so the scaffold skips copying consumer design assets.
  """
  use Corex.Integration.CodeGeneratorCase, async: false

  if Mix.Task.get("phx.new") == nil do
    @moduletag skip: "requires phx_new archive (mix archive.install hex phx_new)"
  end

  @tag timeout: 600_000
  test "mix corex.new with --dev applies Corex install (esbuild ESM, hooks, config, web)" do
    with_installer_tmp("dev_corex_new", fn tmp_dir ->
      app = "dev_corex_phx_app"
      {app_root_path, output} = generate_corex_app_dev_corex(tmp_dir, app)

      web = Path.join(app_root_path, "lib/#{app}_web.ex")
      cfg = Path.join(app_root_path, "config/config.exs")
      mix = Path.join(app_root_path, "mix.exs")

      assert output =~ "mix phx.new" and output =~ "installing Corex"

      assert_file(mix, ~r/:corex/)
      assert_file(mix, ~r/path:/)
      assert_file(cfg, ~r/--format=esm/)
      assert_file(cfg, ~r/--splitting/)
      assert_file(web, ~r/use Corex/)

      app_js = Path.join(app_root_path, "assets/js/app.js")

      assert_file(app_js, fn c ->
        assert c =~ ~r/import corex from "\.\./
        assert c =~ "corex.mjs"
      end)

      app_css = Path.join(app_root_path, "assets/css/app.css")
      assert File.exists?(app_css)

      assert_no_compilation_warnings(app_root_path)
    end)
  end
end
