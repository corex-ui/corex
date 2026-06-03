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

  test "run/2 writes layouts, assets, and wires corex_design compiler" do
    Corex.New.MixHelper.in_tmp("generate bundled", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      capture_io(fn ->
        assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      end)

      assert File.exists?(Path.join("lib/my_app_web/components", "layouts.ex"))
      refute File.exists?(Path.join("assets/corex", "main.css"))

      mix_exs = File.read!("mix.exs")
      assert mix_exs =~ "{:corex_design,"
      assert mix_exs =~ ":corex_design"

      config = File.read!("config/config.exs")
      assert config =~ "config :corex_design"
      assert config =~ "output: \"assets/css/corex.tailwind.css\""

      assert File.read!(Path.join("assets/css", "app.css")) =~ ~s(@import "./corex.tailwind.css")
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

      config = File.read!("config/config.exs")
      assert config =~ ~s(themes: ["neo", "uno", "duo", "leo"])
    end)
  end

  test "run/2 without design skips corex css imports and corex_design wiring" do
    Corex.New.MixHelper.in_tmp("generate no design", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(design: false)
               )

      refute File.exists?(Path.join("assets/corex", "main.css"))
      refute File.read!(Path.join("assets/css", "app.css")) =~ "corex.tailwind.css"
      refute File.read!("mix.exs") =~ "{:corex_design,"
      refute File.read!("config/config.exs") =~ "config :corex_design"
    end)
  end

  test "run/2 with --dev uses relative corex.mjs import" do
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

        refute File.exists?(Path.join("assets/corex", "main.css"))
        assert File.read!(Path.join("assets/js", "app.js")) =~ "corex.mjs"
        refute File.read!(Path.join("assets/js", "app.js")) =~ ~s(import corex from "corex")

        mix_exs = File.read!("mix.exs")
        assert mix_exs =~ "{:corex_design,"
        assert mix_exs =~ "design"
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

  test "run/2 with mcp false skips endpoint MCP plug patch side effects" do
    Corex.New.MixHelper.in_tmp("generate no mcp", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(mcp: false)
               )

      refute File.read!(Path.join("lib/my_app_web", "endpoint.ex")) =~ "plug Corex.MCP"
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

      config = File.read!("config/config.exs")
      assert config =~ ~s(themes: ["neo", "duo"])
      refute config =~ ~s("leo")
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

      config = File.read!("config/config.exs")
      assert config =~ ~s(themes: ["neo", "uno", "duo", "leo"])
    end)
  end
end
