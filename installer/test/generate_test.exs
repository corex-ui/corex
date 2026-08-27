defmodule Corex.New.GenerateTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias Corex.New.{Generate, ScaffoldHelper, Shared}

  test "bundled_gettext_catalog_root points at installer priv when snapshot exists" do
    root = Shared.bundled_gettext_catalog_root()
    assert File.exists?(Path.join(root, "default.pot"))
    assert File.exists?(Path.join(root, "en/LC_MESSAGES/default.po"))
    assert String.ends_with?(root, "priv/gettext")

    pot = File.read!(Path.join(root, "default.pot"))
    assert pot =~ ~s(msgid "The Phoenix UI with a")
    assert pot =~ ~s(msgid "real API")
    assert pot =~ ~s(msgid "Open menu")
    assert pot =~ ~s(msgid " · Phoenix Framework")
    assert pot =~ ~s(msgid "%{name}: a Phoenix app powered by Corex.")
    refute pot =~ ~s(msgid "Corex for Phoenix")
    refute pot =~ ~s(msgid "Demo Site")
    refute pot =~ ~s(msgid "Hex Doc")

    fr = File.read!(Path.join(root, "fr/LC_MESSAGES/default.po"))
    assert fr =~ ~s(msgid "The Phoenix UI with a")
    assert fr =~ ~s(msgstr "L'UI Phoenix avec une")
    assert fr =~ ~s(msgid "%{name}: a Phoenix app powered by Corex.")
    assert fr =~ "une application Phoenix"

    ar = File.read!(Path.join(root, "ar/LC_MESSAGES/default.po"))
    assert ar =~ ~s(msgid "real API")
    refute ar =~ ~s(msgstr "real API")
  end

  test "archive_priv_gettext_root resolves from compiled module beam path" do
    beam = :code.which(Shared)

    if is_binary(beam) or is_list(beam) do
      beam = if is_list(beam), do: List.to_string(beam), else: beam
      expected = beam |> Path.dirname() |> Path.join("../priv/gettext") |> Path.expand()

      if File.exists?(Path.join(expected, "default.pot")) do
        assert Shared.bundled_gettext_catalog_root() == expected
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
      assert mix_exs =~ ~r/\{:corex_mcp,\s*"~> 0.2",\s*only:\s*\[:dev,\s*:test\]\}/
      assert File.exists?(".cursor/mcp.json")
      assert File.read!(".cursor/mcp.json") =~ "http://localhost:4000/corex/mcp"
      assert mix_exs =~ ~r/\{:usage_rules,\s*"~> 1.1",\s*only:\s*:dev\}/
      assert mix_exs =~ "usage_rules: usage_rules()"
      refute mix_exs =~ "[:corex_design"
      refute mix_exs =~ "++ [:corex_design]"
      assert mix_exs =~ "package_skills: [:corex]"
      config = File.read!("config/config.exs")
      assert config =~ "config :corex_design"
      assert config =~ "default_theme: :neo"
      assert config =~ "themes: [:neo]"
      assert File.read!(Path.join("assets/css", "app.css")) =~ "../corex/corex.css"
      assert File.read!(Path.join("assets/css", "app.css")) =~ ~s(@source "../corex")
    end)
  end

  test "run/2 with a11y writes plug, hook, panel, and design config" do
    Corex.New.MixHelper.in_tmp("generate a11y", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts(a11y: true))

      assert File.exists?(Path.join("lib/my_app_web/plugs", "accessibility.ex"))
      assert File.exists?(Path.join("lib/my_app_web/hooks", "accessibility.ex"))

      layouts = File.read!(Path.join("lib/my_app_web/components", "layouts.ex"))
      assert layouts =~ "def accessibility_panel(assigns)"
      assert layouts =~ "def accessibility_open_button(assigns)"
      assert layouts =~ "[--ctl-text:calc(var(--spacing-size-sm)*0.65)]"
      assert layouts =~ ~s(viewBox="0 0 512 512")
      refute layouts =~ "fixed bottom-space end-space"
      refute layouts =~ "h-size-md"
      refute layouts =~ "hero-adjustments-horizontal"
      refute layouts =~ ~r/<\/footer>\s*<\.accessibility_panel/
      assert layouts =~ "<.accessibility_panel"
      assert layouts =~ "<.accessibility_open_button"

      root = File.read!(Path.join("lib/my_app_web/components/layouts", "root.html.heex"))
      assert root =~ "phx:a11y"
      assert root =~ "a11y_data_attrs"
      assert root =~ "Corex.Design.Accessibility.axes()"
      refute root =~ "<.accessibility_panel"

      config = File.read!("config/config.exs")

      assert config =~
               "accessibility: [:text, :contrast, :motion, :cursor, :focus, :links]"

      assert config =~ "layout: [a11y: true]"
      assert config =~ "toggle-group"

      assert File.read!("lib/my_app_web/router.ex") =~ "Plugs.Accessibility"
      assert File.read!("lib/my_app_web.ex") =~ "on_mount MyAppWeb.Hooks.Accessibility"
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
      assert locale_ex =~ "def lang do\n    current()"
      assert locale_ex =~ "format_language_select_label"
      assert locale_ex =~ "titlecase_word"

      assert File.exists?(Path.join(["priv", "gettext", "default.pot"]))
      assert File.exists?(Path.join(["priv", "gettext", "en", "LC_MESSAGES", "default.po"]))
      assert File.exists?(Path.join(["priv", "gettext", "fr", "LC_MESSAGES", "default.po"]))
      assert File.exists?(Path.join(["priv", "gettext", "ar", "LC_MESSAGES", "default.po"]))

      layouts = File.read!("lib/my_app_web/components/layouts.ex")
      assert layouts =~ ~S[~t"Site"]
      assert layouts =~ ~S[~t"Primary"]
      assert layouts =~ ~S[aria-label={~t"Primary"}]
      assert layouts =~ "class=\"hidden items-center gap-space-lg md:flex lg:gap-space-xl\""
      assert layouts =~ ~s|%{label: "Neo", value: "neo"}|

      home = File.read!("lib/my_app_web/controllers/page_html/home.html.heex")
      assert home =~ ~S[~t"API"]
      assert home =~ ~S[~t"Accordion"]
      assert home =~ ~S[content: ~t"Structure, custom slots, and compound mode for full control."]

      root = File.read!("lib/my_app_web/components/layouts/root.html.heex")
      assert root =~ ~S[~t" · Phoenix Framework"]
      assert root =~ ~S|~t"#{name = "MyApp"}: a Phoenix app powered by Corex."|
      refute root =~ ~r/dir=\{MyAppWeb\.Locale\.dir\(\)\}\n\n/

      assert File.exists?("lib/my_app_web/controllers/error_html.ex")
      assert File.exists?("lib/my_app_web/controllers/error_html/404.html.heex")

      assert File.read!("lib/my_app_web/controllers/error_html/404.html.heex") =~
               ~S[~t"Page not found"]

      refute File.read!("lib/my_app_web/controllers/error_html/404.html.heex") =~ ~r/\A\s*\n/

      fr_po = File.read!("priv/gettext/fr/LC_MESSAGES/default.po")
      assert fr_po =~ ~s(msgid "Site")
      assert fr_po =~ ~s(msgid " · Phoenix Framework")
    end)
  end

  test "run/2 without design ships static corex export and skips corex_design dep" do
    Corex.New.MixHelper.in_tmp("generate no design", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(design: false)
               )

      refute File.exists?(Path.join("assets", "corex_design.exs"))
      assert File.exists?(Path.join("assets/corex", "corex.css"))
      assert File.read!(Path.join("assets/css", "app.css")) =~ "../corex/corex.css"
      refute File.read!("mix.exs") =~ ~r/\{:corex_design,/
      refute File.exists?("assets/css/corex-base.css")
      refute File.read!("assets/css/app.css") =~ "corex-base.css"
      refute File.exists?("lib/my_app_web/components/core_components.ex")
      refute File.read!("lib/my_app_web.ex") =~ "CoreComponents"
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
      refute File.exists?(".cursor/mcp.json")
    end)
  end

  test "run/2 with usage_rules false skips usage_rules dep and helper" do
    Corex.New.MixHelper.in_tmp("generate no usage rules", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(usage_rules: false)
               )

      mix_exs = File.read!("mix.exs")
      refute mix_exs =~ "{:usage_rules,"
      refute mix_exs =~ "usage_rules: usage_rules()"
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

  test "run/2 scaffold produces consistent file tree across default opts" do
    Corex.New.MixHelper.in_tmp("generate scaffold consistency", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      capture_io(fn ->
        assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      end)

      expected_files = [
        "lib/my_app_web.ex",
        "lib/my_app_web/router.ex",
        "lib/my_app_web/endpoint.ex",
        "mix.exs",
        "config/config.exs",
        "assets/js/app.js",
        "assets/css/app.css",
        "lib/my_app_web/components/layouts.ex"
      ]

      for file <- expected_files do
        assert File.exists?(file), "expected #{file} to exist after generate"
      end

      web_ex = File.read!("lib/my_app_web.ex")
      assert web_ex =~ "use Corex"
      refute web_ex =~ "CoreComponents"
      refute File.exists?("lib/my_app_web/components/core_components.ex")
      refute File.exists?("assets/css/corex-base.css")
      refute File.read!("assets/css/app.css") =~ "corex-base.css"

      mix_exs = File.read!("mix.exs")
      assert mix_exs =~ "{:corex,"
      assert mix_exs =~ "{:corex_design,"
      assert mix_exs =~ "{:corex_mcp,"
      refute mix_exs =~ "{:daisyui"
      refute mix_exs =~ "localize_web"
      refute mix_exs =~ "gettext_sigils"

      endpoint_ex = File.read!("lib/my_app_web/endpoint.ex")
      assert endpoint_ex =~ "plug Corex.MCP"

      config = File.read!("config/config.exs")
      assert config =~ "config :corex_design"

      app_css = File.read!("assets/css/app.css")
      assert app_css =~ "../corex/corex.css"

      router = File.read!("lib/my_app_web/router.ex")
      refute router =~ ~s(get "/design", PageController, :design)
      refute router =~ ~s(get "/guides", PageController, :guides)
      assert router =~ ~s(get "/", PageController, :home)

      page_controller = File.read!("lib/my_app_web/controllers/page_controller.ex")
      refute page_controller =~ "def design(conn"
      refute page_controller =~ "def guides(conn"

      refute File.exists?("lib/my_app_web/controllers/page_html/design.html.heex")
      refute File.exists?("lib/my_app_web/controllers/page_html/guides.html.heex")
      assert File.exists?("lib/my_app_web/controllers/page_html/home.html.heex")

      layouts = File.read!("lib/my_app_web/components/layouts.ex")
      assert layouts =~ ~s(id="site-nav-dialog")
      assert layouts =~ "Components"
      assert layouts =~ "Hexdocs"
      refute layouts =~ ~S[~p"/design"]
      refute layouts =~ ~S[~p"/guides"]
      refute layouts =~ "~t\""
      refute layouts =~ "Locale"

      home = File.read!("lib/my_app_web/controllers/page_html/home.html.heex")
      assert home =~ "The Phoenix UI"
      assert home =~ ~s(id="home-accordion")
      refute home =~ "~t\""

      root = File.read!("lib/my_app_web/components/layouts/root.html.heex")
      assert root =~ ~s(suffix=" · Phoenix Framework")
      refute root =~ "~t\""

      refute File.dir?("priv/gettext")
      refute File.exists?("lib/my_app_web/locale.ex")
      refute File.exists?("lib/my_app_web/controllers/error_html/404.html.heex")
    end)
  end

  test "run/2 with all flags produces consistent scaffold" do
    Corex.New.MixHelper.in_tmp("generate all flags consistency", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      opts =
        ScaffoldHelper.base_generate_opts(
          mode: true,
          theme: true,
          lang: true,
          design: true,
          mcp: true
        )

      assert :ok == Generate.run(File.cwd!(), opts)

      web_ex = File.read!("lib/my_app_web.ex")
      assert web_ex =~ "use Corex"
      assert web_ex =~ "path_prefixes"

      router = File.read!("lib/my_app_web/router.ex")
      assert router =~ "plug MyAppWeb.Plugs.Mode"
      assert router =~ "plug MyAppWeb.Plugs.Theme"

      config = File.read!("config/config.exs")
      assert config =~ "config :corex"
      assert config =~ "config :corex_design"
      assert config =~ "config :localize"
      assert config =~ "layout:"

      assert File.exists?("lib/my_app_web/plugs/mode.ex")
      assert File.exists?("lib/my_app_web/plugs/theme.ex")
      assert File.exists?("lib/my_app_web/locale.ex")
      assert File.exists?("lib/my_app_web/hooks/layout.ex")
      assert File.exists?("lib/my_app_web/controllers/error_html.ex")
      assert File.exists?("lib/my_app_web/controllers/error_html/404.html.heex")
    end)
  end
end
