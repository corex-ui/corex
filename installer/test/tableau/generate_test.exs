defmodule Corex.New.Tableau.GenerateTest do
  use ExUnit.Case, async: false

  alias Corex.New.Shared
  alias Corex.New.Tableau.Generate

  test "bundled_tableau_asset! points at installer priv/tableau" do
    blog = Shared.bundled_tableau_asset!("assets/css/blog.css")
    prose = Shared.bundled_tableau_asset!("assets/css/prose.css")
    locale = Shared.bundled_tableau_asset!("assets/js/locale.js")
    heroicons = Shared.bundled_tableau_asset!("assets/vendor/heroicons.js")

    assert String.ends_with?(blog, "priv/tableau/assets/css/blog.css")
    assert File.read!(blog) =~ ".blog__nav"
    assert File.read!(prose) =~ "prose"
    assert File.read!(locale) =~ "locale"
    assert File.exists?(heroicons)
  end

  defp base_opts(overrides \\ []) do
    Keyword.merge(
      [
        otp_app: :my_blog,
        app_module: MyBlog,
        mode: false,
        theme: false,
        design: true,
        mcp: true,
        usage_rules: true
      ],
      overrides
    )
  end

  test "run/2 writes all core files" do
    Corex.New.MixHelper.in_tmp("tableau generate base", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))
      File.mkdir_p!(Path.join(install_dir, "lib/layouts"))
      File.mkdir_p!(Path.join(install_dir, "lib/pages"))

      File.write!(
        Path.join(install_dir, "lib/layouts/root_layout.ex"),
        "defmodule Broken do\nend\n"
      )

      File.write!(
        Path.join(install_dir, "lib/pages/home_page.ex"),
        "defmodule BrokenPage do\nend\n"
      )

      assert :ok == Generate.run(install_dir, base_opts())

      refute File.exists?("lib/layouts")
      refute File.exists?("lib/pages")
      assert File.exists?("lib/my_blog/layouts/root_layout.ex")
      assert File.read!(".formatter.exs") =~ "Phoenix.LiveView.HTMLFormatter"
      assert File.read!(".formatter.exs") =~ "import_deps: [:phoenix]"
      assert File.read!("config/config.exs") =~ "Enum.join("
      refute File.read!("config/prod.exs") =~ ~r/\A\s*\n/
      assert File.exists?("lib/my_blog/layouts/post_layout.ex")
      assert File.exists?("lib/my_blog/layouts/tag_layout.ex")
      assert File.exists?("lib/my_blog/layouts/shell.ex")
      assert File.exists?("lib/my_blog/pages/home_page.ex")
      refute File.exists?("lib/my_blog/pages/design_page.ex")
      refute File.exists?("lib/my_blog/pages/guides_page.ex")
      assert File.exists?("lib/my_blog/pages/blog_index_page.ex")
      assert File.exists?("lib/my_blog/pages/tags_index_page.ex")
      assert File.exists?("lib/my_blog/pages/not_found_page.ex")
      assert File.exists?("lib/my_blog/config.ex")
      assert File.exists?("lib/my_blog/application.ex")
      assert File.exists?("lib/my_blog/mcp.ex")
      assert File.exists?(".cursor/mcp.json")
      assert File.read!(".cursor/mcp.json") =~ "http://localhost:4004/corex/mcp"
      assert File.exists?("lib/my_blog/md_ex_converter.ex")
      assert File.exists?("lib/my_blog/markdown/code_blocks.ex")
      assert File.exists?("lib/my_blog/markdown/block_renderer.ex")
      assert File.exists?("lib/mix/tasks/post.ex")
      assert File.exists?("assets/css/site.css")
      assert File.exists?("assets/css/blog.css")
      assert File.exists?("assets/css/prose.css")
      assert File.read!("assets/css/blog.css") =~ ".blog__nav"
      assert File.exists?("assets/js/site.js")
      assert File.exists?("assets/vendor/heroicons.js")
      assert File.read!("assets/vendor/heroicons.js") =~ "heroicons"
      assert File.exists?("config/config.exs")
      assert File.exists?("config/dev.exs")
      assert File.exists?("config/prod.exs")
      assert File.exists?("config/test.exs")
      assert File.exists?("mix.exs")
      assert File.exists?("_posts/2026-01-01-welcome.md")
      assert File.dir?("extra")

      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "defmodule MyBlog.RootLayout"
      assert File.read!("lib/my_blog/md_ex_converter.ex") =~ "CodeBlocks.transform()"
      assert File.read!("lib/my_blog/markdown/code_blocks.ex") =~ "MyBlog.Markdown.CodeBlocks"
      assert File.read!("lib/mix/tasks/post.ex") =~ "defmodule Mix.Tasks.MyBlog.Gen.Post"
      assert File.read!("lib/mix/tasks/post.ex") =~ "layout: MyBlog.PostLayout"
      assert File.read!("mix.exs") =~ ":tableau"
      assert File.read!("mix.exs") =~ ~s({:mdex, "~> 0.13.5", override: true})
      assert File.read!("mix.exs") =~ ~s({:makeup, "~> 1.2"})
      assert File.read!("mix.exs") =~ "corex_mcp"
      assert File.read!("mix.exs") =~ "usage_rules"
      refute File.read!("mix.exs") =~ "[:corex_design"
      refute File.read!("mix.exs") =~ "++ [:corex_design]"
      assert File.read!("config/config.exs") =~ "config :corex_design"
      assert File.read!("config/config.exs") =~ "header_id_prefix"
      assert File.read!("config/config.exs") =~ "Tableau.TagExtension"
      assert File.read!("config/config.exs") =~ ~S[import_config "#{config_env()}.exs"]
      assert File.read!("config/config.exs") =~ ":code"
      assert File.read!("config/config.exs") =~ ":clipboard"
      assert File.read!("assets/css/site.css") =~ "corex.css"
      assert File.read!("assets/css/site.css") =~ ~s(@source "../corex")
      assert File.read!("assets/css/site.css") =~ ~s(@import "./prose.css")

      mix_exs = File.read!("mix.exs")
      refute mix_exs =~ "gettext"
      refute mix_exs =~ "localize_web"
      refute mix_exs =~ ":localize"

      root = File.read!("lib/my_blog/layouts/root_layout.ex")
      refute root =~ "~t\""
      refute root =~ "GettextSigil"
      refute root =~ "Locale"
      refute File.read!("lib/my_blog/pages/home_page.ex") =~ "~t\""
      refute File.read!("lib/my_blog/markdown/block_renderer.ex") =~ "GettextSigil"
      refute File.dir?("priv/gettext")
    end)
  end

  test "run/2 with a11y writes accessibility module and config" do
    Corex.New.MixHelper.in_tmp("tableau generate a11y", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))
      File.mkdir_p!(Path.join(install_dir, "lib/layouts"))
      File.mkdir_p!(Path.join(install_dir, "lib/pages"))

      assert :ok == Generate.run(install_dir, base_opts(a11y: true))

      assert File.exists?("lib/my_blog/accessibility.ex")

      assert File.read!("config/config.exs") =~
               "accessibility: [:text, :contrast, :motion, :cursor, :focus, :links]"

      assert File.read!("config/config.exs") =~ "modes: [:light, :dark]"
      assert File.read!("config/config.exs") =~ "default_theme: :neo"
      assert File.read!("config/config.exs") =~ "themes: [:neo]"
      assert File.read!("config/config.exs") =~ "toggle-group"
      a11y = File.read!("lib/my_blog/accessibility.ex")
      assert a11y =~ "Accessibility.axes()"
      assert a11y =~ "def accessibility_open_button(assigns)"
      assert a11y =~ ~s(viewBox="0 0 512 512")
      assert a11y =~ "[--ctl-text:calc(var(--spacing-size-sm)*0.65)]"
      refute a11y =~ "fixed bottom-space end-space"
      refute a11y =~ "h-size-md"
      refute a11y =~ "hero-adjustments-horizontal"
      root_layout = File.read!("lib/my_blog/layouts/root_layout.ex")
      assert root_layout =~ "Accessibility.head_script"
      assert root_layout =~ "accessibility_panel"
      assert root_layout =~ "accessibility_open_button"
      assert root_layout =~ "hidden sm:inline-flex"
      assert File.read!("assets/js/site.js") =~ "ToggleGroup"
      assert File.read!("assets/js/site.js") =~ "Dialog"
    end)
  end

  test "run/2 with mode and theme writes toggle modules" do
    Corex.New.MixHelper.in_tmp("tableau generate flags", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(mode: true, theme: true)
      assert :ok == Generate.run(install_dir, opts)

      assert File.exists?("lib/my_blog/theme.ex")
      assert File.exists?("lib/my_blog/mode.ex")
      theme = File.read!("lib/my_blog/theme.ex")
      mode = File.read!("lib/my_blog/mode.ex")
      refute theme =~ "GettextSigil"
      refute theme =~ "~t\""
      refute mode =~ "GettextSigil"
      refute mode =~ "~t\""
      assert theme =~ "Theme"
      assert mode =~ "Dark mode"
      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "Mode.head_script"
      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "Theme.head_script"
      assert File.read!("assets/js/site.js") =~ "Select"
      assert File.read!("assets/js/site.js") =~ "Toggle"
    end)
  end

  test "run/2 without design skips corex_design dep and copies static export" do
    Corex.New.MixHelper.in_tmp("tableau generate no design", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(design: false)
      assert :ok == Generate.run(install_dir, opts)

      refute File.read!("config/config.exs") =~ "config :corex_design"
      refute File.read!("mix.exs") =~ "corex_design"
      assert File.exists?("assets/corex/corex.css")
      assert File.read!("assets/css/site.css") =~ "corex.css"
      refute File.exists?("assets/css/corex-base.css")
      refute File.read!("assets/css/site.css") =~ "corex-base.css"
    end)
  end

  test "run/2 without mcp skips mcp module and corex_mcp dep" do
    Corex.New.MixHelper.in_tmp("tableau generate no mcp", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(mcp: false)
      assert :ok == Generate.run(install_dir, opts)

      refute File.exists?("lib/my_blog/mcp.ex")
      refute File.read!("config/dev.exs") =~ "mcp_enabled"
      refute File.read!("mix.exs") =~ "corex_mcp"
    end)
  end

  test "run/2 without usage_rules skips usage_rules dep and helper" do
    Corex.New.MixHelper.in_tmp("tableau generate no usage rules", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      assert :ok == Generate.run(install_dir, base_opts(usage_rules: false))

      mix_exs = File.read!("mix.exs")
      refute mix_exs =~ "usage_rules"
      refute mix_exs =~ "package_skills"
    end)
  end

  test "run/2 without mode or theme skips those modules" do
    Corex.New.MixHelper.in_tmp("tableau generate no toggles", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      assert :ok == Generate.run(install_dir, base_opts())

      refute File.exists?("lib/my_blog/theme.ex")
      refute File.exists?("lib/my_blog/mode.ex")
      refute File.exists?("lib/my_blog/locale.ex")
      refute File.read!("assets/js/site.js") =~ ~S[import {Select}]
      refute File.read!("assets/js/site.js") =~ ~S[import {Toggle}]
      refute File.read!("assets/js/site.js") =~ "Select,"
      refute File.read!("assets/js/site.js") =~ "Toggle,"
      refute File.read!("assets/js/site.js") =~ "locale.js"
    end)
  end

  test "run/2 with lang writes Locale, Gettext, locale.js, and per-locale pages" do
    Corex.New.MixHelper.in_tmp("tableau generate lang", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(lang: true, design: true)
      assert :ok == Generate.run(install_dir, opts)

      assert File.exists?("lib/my_blog/locale.ex")
      assert File.exists?("lib/my_blog/gettext.ex")
      assert File.exists?("lib/my_blog/gettext_sigil.ex")
      assert File.exists?("lib/my_blog/pages/root_index_page.ex")
      assert File.exists?("assets/js/locale.js")
      assert File.dir?("priv/gettext/en")
      assert File.dir?("priv/gettext/fr")
      assert File.dir?("priv/gettext/ar")

      locale_ex = File.read!("lib/my_blog/locale.ex")
      assert locale_ex =~ "def locales"
      assert locale_ex =~ "def default_locale_string"
      assert locale_ex =~ "def current"
      assert locale_ex =~ "def lang"
      assert locale_ex =~ "def dir"
      assert locale_ex =~ "def label"
      assert locale_ex =~ "def swap_path"
      assert locale_ex =~ "def current_path"
      assert locale_ex =~ "def selected_path"
      assert locale_ex =~ "def language_select_items"
      assert locale_ex =~ "def language_select_value"

      root_layout = File.read!("lib/my_blog/layouts/root_layout.ex")
      assert root_layout =~ "data-locale="
      assert root_layout =~ "data-locales="
      assert root_layout =~ "data-rtl-locales="
      assert root_layout =~ "data-locale-selected-path="
      assert root_layout =~ "data-public-path-prefix="
      assert root_layout =~ "id=\"corex-language-switch\""
      assert root_layout =~ "on_value_change_client=\"corex:set-locale\""
      refute root_layout =~ "defp page_path_from_page"
      refute root_layout =~ ":tags_path"
      refute root_layout =~ ~S[~t"Tags"]
      assert root_layout =~ ~S|~t"#{name = site_name} - Corex for Tableau"|
      assert root_layout =~ ~S[~t"Site"]
      assert root_layout =~ ~S[~t"Primary"]

      refute File.exists?("lib/my_blog/pages/tags_index_page.ex")
      refute File.exists?("lib/my_blog/layouts/tag_layout.ex")
      refute File.read!("config/config.exs") =~ "Tableau.TagExtension"

      home_page = File.read!("lib/my_blog/pages/home_page.ex")
      assert home_page =~ "Module.create"
      assert home_page =~ "/\#{locale}/"
      refute home_page =~ "permalink: \"/\""

      assert File.read!("lib/my_blog/pages/root_index_page.ex") =~ "permalink: \"/\""
      assert File.read!("lib/my_blog/pages/blog_index_page.ex") =~ "/\#{locale}/blog/"
      assert File.read!("lib/my_blog/pages/blog_index_page.ex") =~ "String.starts_with?"
      assert File.read!("lib/my_blog/pages/blog_index_page.ex") =~ "post[:permalink]"
      refute File.read!("lib/my_blog/pages/blog_index_page.ex") =~ "Browse tags"
      refute File.read!("lib/my_blog/pages/blog_index_page.ex") =~ "post_tags"

      assert File.exists?("_posts/2026-01-01-welcome.md")
      assert File.exists?("_posts/2026-01-01-welcome-fr.md")
      assert File.exists?("_posts/2026-01-01-welcome-ar.md")
      assert File.read!("_posts/2026-01-01-welcome.md") =~ "permalink: /en/blog/welcome/"
      refute File.read!("_posts/2026-01-01-welcome.md") =~ "tags:"
      assert File.read!("_posts/2026-01-01-welcome-fr.md") =~ "permalink: /fr/blog/welcome/"
      assert File.read!("_posts/2026-01-01-welcome-fr.md") =~ "Bienvenue sur votre nouveau blog"
      refute File.read!("_posts/2026-01-01-welcome-fr.md") =~ "tags:"
      assert File.read!("_posts/2026-01-01-welcome-ar.md") =~ "permalink: /ar/blog/welcome/"
      assert File.read!("_posts/2026-01-01-welcome-ar.md") =~ "مرحبًا بك في مدونتك الجديدة"
      assert File.read!("lib/mix/tasks/post.ex") =~ "permalink: /en/blog/:title/"

      fr_po = File.read!("priv/gettext/fr/LC_MESSAGES/default.po")
      assert fr_po =~ ~s(msgid "Home")
      assert fr_po =~ ~s(msgstr "Accueil")
      assert fr_po =~ ~s(msgid "Back to home")
      ar_po = File.read!("priv/gettext/ar/LC_MESSAGES/default.po")
      assert ar_po =~ ~s(msgid "Tags")
      assert ar_po =~ ~s(msgstr "الوسوم")

      site_js = File.read!("assets/js/site.js")
      assert site_js =~ ~S[import "./locale.js"]
      assert site_js =~ ~S[import {Select} from "corex/select"]
      assert site_js =~ "Select,"

      mix_exs = File.read!("mix.exs")
      assert mix_exs =~ "gettext"
      assert mix_exs =~ "gettext_sigils"
      assert mix_exs =~ "localize_web"
      assert mix_exs =~ ":localize"
      assert mix_exs =~ "localize.download_locales"

      config = File.read!("config/config.exs")
      assert config =~ "gettext_backend: MyBlog.Gettext"
      assert config =~ ~S[default_locale: "en"]
      assert config =~ ~S[supported_locales: ~w(en fr ar)]
      assert config =~ "select"
    end)
  end

  test "run/2 with --dev uses path deps and relative corex.mjs import" do
    Corex.New.MixHelper.in_tmp("tableau generate dev", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      corex_root = Path.join(install_dir, "fake_corex")
      File.mkdir_p!(Path.join(corex_root, "priv/static"))
      File.write!(Path.join(corex_root, "priv/static/corex.mjs"), "export {}\n")

      opts = base_opts(dev: "fake_corex")
      assert :ok == Generate.run(install_dir, opts)

      mix = File.read!("mix.exs")
      assert mix =~ ~S[path: "fake_corex"]
      assert mix =~ ~S[path: "fake_corex/design"]

      js = File.read!("assets/js/site.js")
      assert js =~ "../../fake_corex/priv/static/toast.mjs"
      refute js =~ "hooks.mjs"
      refute js =~ ~s[from "corex"]
    end)
  end

  test "run/2 with --dev raises when corex.mjs is missing" do
    Corex.New.MixHelper.in_tmp("tableau generate dev missing mjs", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))
      File.mkdir_p!(Path.join(install_dir, "empty_corex"))

      assert_raise Mix.Error, ~r/Expected Corex bundle/, fn ->
        Generate.run(install_dir, base_opts(dev: "empty_corex"))
      end
    end)
  end
end
