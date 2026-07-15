defmodule Corex.New.GenerateTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias Corex.New.{Generate, ScaffoldHelper}

  test "bundled_gettext_catalog_root points at installer priv when snapshot exists" do
    root = Generate.bundled_gettext_catalog_root()
    assert File.exists?(Path.join(root, "default.pot"))
    assert File.exists?(Path.join(root, "en/LC_MESSAGES/default.po"))
    assert String.ends_with?(root, "priv/gettext")
  end

  test "archive_priv_gettext_root resolves from compiled module beam path" do
    beam = :code.which(Corex.New.Generate)

    if is_binary(beam) or is_list(beam) do
      beam = if is_list(beam), do: List.to_string(beam), else: beam
      expected = beam |> Path.dirname() |> Path.join("../priv/gettext") |> Path.expand()

      if File.exists?(Path.join(expected, "default.pot")) do
        assert Generate.bundled_gettext_catalog_root() == expected
      end
    end
  end

  test "run/2 writes layouts, assets, and corex_design config" do
    Corex.New.MixHelper.in_tmp("generate design", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      capture_io(fn ->
        assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      end)

      assert File.exists?(Path.join("lib/my_app_web/components", "layouts.ex"))
      refute File.exists?(Path.join("assets", "corex_design.exs"))
      refute File.exists?(Path.join("assets/corex", "main.css"))

      mix_exs = File.read!("mix.exs")
      assert mix_exs =~ ~r/\{:corex_design,/
      assert mix_exs =~ ~r/\{:corex_mcp,\s*"~> 0.2",\s*only:\s*:dev\}/
      assert File.read!("config/config.exs") =~ "config :corex_design"
      assert File.read!(Path.join("assets/css", "app.css")) =~ "../corex/corex.css"
    end)
  end

  test "run/2 with mode, theme, and lang writes plugs, locale, and hooks" do
    Corex.New.MixHelper.in_tmp("generate flags", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      opts = ScaffoldHelper.base_generate_opts(mode: true, theme: true, lang: true)

      assert :ok == Generate.run(File.cwd!(), opts)

      assert File.exists?(Path.join("lib/my_app_web/plugs", "mode.ex"))
      assert File.exists?(Path.join("lib/my_app_web/plugs", "theme.ex"))
      assert File.exists?(Path.join("lib/my_app_web", "locale.ex"))
      assert File.exists?(Path.join("lib/my_app_web/hooks", "layout.ex"))
      assert File.read!(Path.join("lib/my_app_web/components", "layouts.ex")) =~ "mode_toggle"

      web_ex = File.read!(Path.join("lib", "my_app_web.ex"))

      assert web_ex =~ "path_prefixes: [{MyAppWeb.Locale, :current, []}]"

      locale_ex = File.read!(Path.join("lib/my_app_web", "locale.ex"))
      assert locale_ex =~ "def current do"
      assert locale_ex =~ "format_language_select_label"
      assert locale_ex =~ "titlecase_word"

      assert File.exists?(Path.join(["priv", "gettext", "default.pot"]))
      assert File.exists?(Path.join(["priv", "gettext", "en", "LC_MESSAGES", "default.po"]))
      assert File.exists?(Path.join(["priv", "gettext", "fr", "LC_MESSAGES", "default.po"]))
      assert File.exists?(Path.join(["priv", "gettext", "ar", "LC_MESSAGES", "default.po"]))
    end)
  end

  test "run/2 without design skips corex css imports and design config" do
    Corex.New.MixHelper.in_tmp("generate no design", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(design: false)
               )

      refute File.exists?(Path.join("assets", "corex_design.exs"))
      refute File.exists?(Path.join("assets/corex", "main.css"))
      refute File.read!(Path.join("assets/css", "app.css")) =~ "../corex/main.css"
      refute File.read!("mix.exs") =~ ~r/\{:corex_design,/
    end)
  end

  test "run/2 with --dev uses path deps and relative corex.mjs import" do
    Corex.New.MixHelper.in_tmp("generate dev", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())
      corex_root = ScaffoldHelper.corex_repo_root()
      mjs = Path.join([corex_root, "priv/static/corex.mjs"])

      if File.exists?(mjs) do
        assert :ok ==
                 Generate.run(
                   File.cwd!(),
                   ScaffoldHelper.base_generate_opts(dev: corex_root)
                 )

        mix_exs = File.read!("mix.exs")
        assert mix_exs =~ "path: #{inspect(corex_root)}"
        assert mix_exs =~ "path: #{inspect(Path.join(corex_root, "design"))}"
        assert File.read!(Path.join("assets/js", "app.js")) =~ "corex.mjs"
        refute File.read!(Path.join("assets/js", "app.js")) =~ ~s(import corex from "corex")
      else
        assert_raise Mix.Error, ~r/Expected Corex bundle/, fn ->
          Generate.run(
            File.cwd!(),
            ScaffoldHelper.base_generate_opts(dev: corex_root)
          )
        end
      end
    end)
  end

  test "run/2 raises when dev path lacks corex.mjs" do
    Corex.New.MixHelper.in_tmp("generate bad dev", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())
      empty = Path.join(File.cwd!(), "empty_corex")
      File.mkdir_p!(empty)

      assert_raise Mix.Error, ~r/Expected Corex bundle/, fn ->
        Generate.run(
          File.cwd!(),
          ScaffoldHelper.base_generate_opts(dev: empty)
        )
      end
    end)
  end

  test "run/2 without dev option keeps npm corex import" do
    Corex.New.MixHelper.in_tmp("generate default import", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      assert File.read!(Path.join("assets/js", "app.js")) =~ ~s(from "corex")
    end)
  end

  test "run/2 with blank dev path keeps npm corex import" do
    Corex.New.MixHelper.in_tmp("generate blank dev", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(dev: "   ")
               )

      assert File.read!(Path.join("assets/js", "app.js")) =~ ~s(from "corex")
    end)
  end

  test "run/2 with mcp false skips endpoint MCP plug and corex_mcp dep" do
    Corex.New.MixHelper.in_tmp("generate no mcp", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(mcp: false)
               )

      refute File.read!(Path.join("lib/my_app_web", "endpoint.ex")) =~ "plug Corex.MCP"
      refute File.read!("mix.exs") =~ "{:corex_mcp,"
    end)
  end

  test "run/2 honors custom themes list when theme is enabled" do
    Corex.New.MixHelper.in_tmp("generate custom themes", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(theme: true, themes: ["neo", "duo"])
               )

      css = File.read!(Path.join("assets/css", "app.css"))
      assert css =~ "../corex/corex.css"
      config = File.read!("config/config.exs")
      assert config =~ "neo"
      assert config =~ "duo"
      refute config =~ ~r/themes:.*leo/
    end)
  end

  test "run/2 omits home page when stock home template is absent" do
    Corex.New.MixHelper.in_tmp("generate no home", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      home = Path.join("lib/my_app_web/controllers/page_html", "home.html.heex")

      File.rm!(home)

      assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      refute File.exists?(home)
      assert File.exists?(Path.join("lib/my_app_web/components/layouts", "root.html.heex"))
    end)
  end

  test "normalize_opts uses default theme list when theme is enabled" do
    Corex.New.MixHelper.in_tmp("generate themes", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(theme: true)
               )

      css = File.read!(Path.join("assets/css", "app.css"))
      assert css =~ "../corex/corex.css"
      config = File.read!("config/config.exs")
      assert config =~ "neo"
      assert config =~ "leo"
    end)
  end
end
