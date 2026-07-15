defmodule Corex.New.Tableau.GenerateTest do
  use ExUnit.Case, async: false

  alias Corex.New.Tableau.Generate

  defp base_opts(overrides \\ []) do
    Keyword.merge(
      [
        otp_app: :my_blog,
        app_module: MyBlog,
        mode: false,
        theme: false,
        design: true,
        mcp: true
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
      assert File.exists?("lib/my_blog/layouts/post_layout.ex")
      assert File.exists?("lib/my_blog/pages/home_page.ex")
      assert File.exists?("lib/my_blog/pages/blog_index_page.ex")
      assert File.exists?("lib/my_blog/pages/not_found_page.ex")
      assert File.exists?("lib/my_blog/config.ex")
      assert File.exists?("lib/my_blog/application.ex")
      assert File.exists?("lib/my_blog/mcp.ex")
      assert File.exists?("lib/my_blog/md_ex_converter.ex")
      assert File.exists?("lib/mix/tasks/post.ex")
      assert File.exists?("assets/css/site.css")
      assert File.exists?("assets/js/site.js")
      assert File.exists?("assets/vendor/heroicons.js")
      assert File.exists?("config/config.exs")
      assert File.exists?("config/dev.exs")
      assert File.exists?("config/prod.exs")
      assert File.exists?("config/test.exs")
      assert File.exists?("mix.exs")
      assert File.exists?("_posts/2026-01-01-welcome.md")
      assert File.dir?("extra")

      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "defmodule MyBlog.RootLayout"
      assert File.read!("lib/mix/tasks/post.ex") =~ "defmodule Mix.Tasks.MyBlog.Gen.Post"
      assert File.read!("lib/mix/tasks/post.ex") =~ "layout: MyBlog.PostLayout"
      assert File.read!("mix.exs") =~ ":tableau"
      assert File.read!("mix.exs") =~ "corex_mcp"
      assert File.read!("config/config.exs") =~ "config :corex_design"
      assert File.read!("config/config.exs") =~ ~S[import_config "#{config_env()}.exs"]
      assert File.read!("assets/css/site.css") =~ "corex.css"
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
      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "Mode.head_script"
      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "Theme.head_script"
      assert File.read!("assets/js/site.js") =~ "Select"
      assert File.read!("assets/js/site.js") =~ "Toggle"
    end)
  end

  test "run/2 without design skips corex_design" do
    Corex.New.MixHelper.in_tmp("tableau generate no design", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(design: false)
      assert :ok == Generate.run(install_dir, opts)

      refute File.read!("config/config.exs") =~ "config :corex_design"
      refute File.read!("mix.exs") =~ "corex_design"
      refute File.read!("assets/css/site.css") =~ "corex.css"
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
      refute File.read!("assets/js/site.js") =~ "Select:"
      refute File.read!("assets/js/site.js") =~ "Toggle:"
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

      home_page = File.read!("lib/my_blog/pages/home_page.ex")
      assert home_page =~ "Module.create"
      assert home_page =~ "/\#{locale}/"
      refute home_page =~ "permalink: \"/\""

      assert File.read!("lib/my_blog/pages/root_index_page.ex") =~ "permalink: \"/\""
      assert File.read!("lib/my_blog/pages/blog_index_page.ex") =~ "/\#{locale}/blog/"

      site_js = File.read!("assets/js/site.js")
      assert site_js =~ ~S[import "./locale.js"]
      assert site_js =~ "Select:"

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
      assert js =~ "../../fake_corex/priv/static/hooks.mjs"
      assert js =~ "../../fake_corex/priv/static/toast.mjs"
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
