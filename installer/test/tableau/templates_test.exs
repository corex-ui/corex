defmodule Corex.New.Tableau.TemplatesTest do
  use ExUnit.Case, async: true

  alias Corex.New.Tableau.Templates

  test "list_templates/0 returns all bundled template keys" do
    keys = Templates.list_templates()

    assert :root_layout in keys
    assert :post_layout in keys
    assert :home_page in keys
    assert :blog_index_page in keys
    assert :not_found_page in keys
    assert :config_module in keys
    assert :application_module in keys
    assert :mcp_module in keys
    assert :md_ex_converter in keys
    assert :theme_module in keys
    assert :mode_module in keys
    assert :root_index_page in keys
    assert :gettext_module in keys
    assert :gettext_sigil_module in keys
    assert :locale_module in keys
    assert :site_css in keys
    assert :site_js in keys
    assert :config_exs in keys
    assert :dev_exs in keys
    assert :prod_exs in keys
    assert :test_exs in keys
    assert :mix_exs in keys
    assert :sample_post in keys
    assert :gen_post_task in keys
    assert length(keys) == 24
  end

  @base_assigns [
    app_module: "MyBlog",
    otp_app: :my_blog,
    mode: false,
    theme: false,
    lang: false,
    mcp: true,
    design: true,
    themes: ["neo"],
    default_theme: "neo",
    components: ~w(toast layout-heading typo icon link button scrollbar)a,
    corex_js_import: "corex",
    corex_dep_source: "\"~> 0.2.0\"",
    corex_design_dep_source: "\"~> 0.2\", runtime: false, only: :dev",
    corex_mcp_dep_source: "\"~> 0.2.0\", only: [:dev, :test]"
  ]

  @lang_assigns Keyword.merge(@base_assigns,
                  lang: true,
                  components: ~w(toast layout-heading typo icon link button scrollbar select)a
                )

  describe "root_layout/1" do
    test "renders a valid Tableau layout module" do
      out = Templates.root_layout(@base_assigns)
      assert out =~ "defmodule MyBlog.RootLayout do"
      assert out =~ "use Tableau.Layout"
      assert out =~ "use Corex"
      assert out =~ "Blog"
      assert out =~ "<.toast_group"
      assert out =~ "<.toast_client_error"
    end

    test "includes theme/mode head scripts when enabled" do
      assigns = Keyword.merge(@base_assigns, mode: true, theme: true)
      out = Templates.root_layout(assigns)
      assert out =~ "MyBlog.Mode.head_script()"
      assert out =~ "MyBlog.Theme.head_script()"
      assert out =~ "MyBlog.Mode.mode_toggle"
      assert out =~ "MyBlog.Theme.theme_toggle"
    end

    test "omits theme/mode when disabled" do
      out = Templates.root_layout(@base_assigns)
      refute out =~ "Mode.head_script"
      refute out =~ "Theme.head_script"
      refute out =~ "mode_toggle"
      refute out =~ "theme_toggle"
    end

    test "includes language select and locale attrs when lang is on" do
      out = Templates.root_layout(@lang_assigns)
      assert out =~ "data-locale="
      assert out =~ "data-locales="
      assert out =~ "id=\"corex-language-switch\""
      assert out =~ "MyBlog.Locale"
      assert out =~ "corex:set-locale"
    end

    test "omits data-theme when design is off" do
      out = Templates.root_layout(Keyword.put(@base_assigns, :design, false))
      refute out =~ "data-theme="
      refute out =~ "data-mode="
    end
  end

  describe "post_layout/1" do
    test "renders a valid post layout with typo prose" do
      out = Templates.post_layout(@base_assigns)
      assert out =~ "defmodule MyBlog.PostLayout do"
      assert out =~ "use Tableau.Layout, layout: MyBlog.RootLayout"
      assert out =~ "typo prose"
      assert out =~ "Back to blog"
    end
  end

  describe "home_page/1" do
    test "renders a home page with layout_heading" do
      out = Templates.home_page(@base_assigns)
      assert out =~ "defmodule MyBlog.HomePage do"
      assert out =~ "Corex for Tableau"
      assert out =~ "<.layout_heading"
      assert out =~ "permalink: \"/\""
    end

    test "emits Module.create per locale when lang is on" do
      out = Templates.home_page(@lang_assigns)
      assert out =~ "Module.create"
      assert out =~ ~S[permalink = "/#{locale}/"]
      refute out =~ ~S[permalink: "/"]
    end
  end

  describe "blog_index_page/1" do
    test "renders a blog index page listing posts" do
      out = Templates.blog_index_page(@base_assigns)
      assert out =~ "defmodule MyBlog.BlogIndexPage do"
      assert out =~ "permalink: \"/blog\""
      assert out =~ "sorted_posts"
    end

    test "emits per-locale blog permalinks when lang is on" do
      out = Templates.blog_index_page(@lang_assigns)
      assert out =~ "Module.create"
      assert out =~ ~S[permalink = "/#{locale}/blog/"]
    end
  end

  describe "root_index_page/1" do
    test "renders a root index that reuses HomePage" do
      out = Templates.root_index_page(@lang_assigns)
      assert out =~ "defmodule MyBlog.RootIndexPage do"
      assert out =~ "permalink: \"/\""
      assert out =~ "MyBlog.HomePage.template"
    end
  end

  describe "not_found_page/1" do
    test "renders a 404 page" do
      out = Templates.not_found_page(@base_assigns)
      assert out =~ "defmodule MyBlog.NotFoundPage do"
      assert out =~ "permalink: \"/404.html\""
      assert out =~ "Page not found"
    end
  end

  describe "site_css/1" do
    test "includes corex import when design is on" do
      out = Templates.site_css(@base_assigns)
      assert out =~ "@import \"../corex/corex.css\""
      assert out =~ "@import \"tailwindcss\""
    end

    test "omits corex import when design is off" do
      out = Templates.site_css(Keyword.put(@base_assigns, :design, false))
      refute out =~ "corex.css"
      assert out =~ "@import \"tailwindcss\""
    end

    test "includes dark mode variant when mode is on" do
      out = Templates.site_css(Keyword.put(@base_assigns, :mode, true))
      assert out =~ "@custom-variant dark"
    end
  end

  describe "site_js/1" do
    test "imports corex hooks and creates LiveSocket" do
      out = Templates.site_js(@base_assigns)
      assert out =~ "corex/hooks"
      assert out =~ "LiveSocket"
      assert out =~ "Toast"
    end

    test "includes Select and Toggle hooks when theme and mode are on" do
      assigns = Keyword.merge(@base_assigns, mode: true, theme: true)
      out = Templates.site_js(assigns)
      assert out =~ "Select"
      assert out =~ "Toggle"
      assert out =~ "phx:set-mode"
      assert out =~ "phx:set-theme"
    end

    test "omits Select/Toggle when mode and theme are off" do
      out = Templates.site_js(@base_assigns)
      refute out =~ "Select:"
      refute out =~ "Toggle:"
    end

    test "imports locale.js and Select when lang is on" do
      out = Templates.site_js(@lang_assigns)
      assert out =~ ~S[import "./locale.js"]
      assert out =~ "Select:"
    end
  end

  describe "config_exs/1" do
    test "includes Tableau, esbuild, and tailwind config" do
      out = Templates.config_exs(@base_assigns)
      assert out =~ "config :tableau"
      assert out =~ "config :esbuild"
      assert out =~ "config :tailwind"
      assert out =~ "config :my_blog"
      assert out =~ "site_name"
    end

    test "includes corex_design config when design is on" do
      out = Templates.config_exs(@base_assigns)
      assert out =~ "config :corex_design"
    end

    test "omits corex_design config when design is off" do
      out = Templates.config_exs(Keyword.put(@base_assigns, :design, false))
      refute out =~ "config :corex_design"
    end
  end

  describe "mix_exs/1" do
    test "includes tableau and corex deps" do
      out = Templates.mix_exs(@base_assigns)
      assert out =~ ":tableau"
      assert out =~ ":corex"
      assert out =~ ":my_blog"
      assert out =~ "corex_design"
      assert out =~ "corex_mcp"
    end

    test "includes corex_design compiler when design is on" do
      out = Templates.mix_exs(@base_assigns)
      assert out =~ "compilers: Mix.compilers() ++ [:corex_design]"
    end

    test "omits corex_design compiler when design is off" do
      out = Templates.mix_exs(Keyword.put(@base_assigns, :design, false))
      refute out =~ ":corex_design"
    end

    test "omits corex_mcp dep when mcp is off" do
      out = Templates.mix_exs(Keyword.put(@base_assigns, :mcp, false))
      refute out =~ "corex_mcp"
    end

    test "includes gettext and localize when lang is on" do
      out = Templates.mix_exs(@lang_assigns)
      assert out =~ "gettext"
      assert out =~ "gettext_sigils"
      assert out =~ "localize_web"
      assert out =~ "localize.download_locales"
      assert out =~ ":localize"
    end
  end

  describe "locale modules" do
    test "locale module exposes the soonex_i18n surface" do
      out = Templates.locale_module(@lang_assigns)
      assert out =~ "defmodule MyBlog.Locale do"
      assert out =~ "def swap_path"
      assert out =~ "def language_select_items"
      assert out =~ "def selected_path"
    end

    test "gettext module lists en fr ar" do
      out = Templates.gettext_module(@lang_assigns)
      assert out =~ "locales: ~w(en fr ar)"
    end
  end

  describe "sample_post/1" do
    test "renders a valid markdown post" do
      out = Templates.sample_post(@base_assigns)
      assert out =~ "layout: MyBlog.PostLayout"
      assert out =~ "Welcome to your new blog"
      assert out =~ "permalink: /blog/welcome/"
    end
  end

  describe "support modules" do
    test "config module reads from application env" do
      out = Templates.config_module(@base_assigns)
      assert out =~ "defmodule MyBlog.Config do"
      assert out =~ ":my_blog"
      assert out =~ "site_name"
      assert out =~ "mcp_enabled?"
    end

    test "application module starts MCP conditionally" do
      out = Templates.application_module(@base_assigns)
      assert out =~ "defmodule MyBlog.Application do"
      assert out =~ "MyBlog.Config.mcp_enabled?()"
      assert out =~ "MyBlog.Mcp"
    end

    test "mcp module uses Corex.MCP plug" do
      out = Templates.mcp_module(@base_assigns)
      assert out =~ "defmodule MyBlog.Mcp do"
      assert out =~ "plug(Corex.MCP)"
    end

    test "theme module renders head script and toggle" do
      out = Templates.theme_module(@base_assigns)
      assert out =~ "defmodule MyBlog.Theme do"
      assert out =~ "head_script"
      assert out =~ "theme_toggle"
      assert out =~ "select_items"
    end

    test "mode module renders head script and toggle" do
      out = Templates.mode_module(@base_assigns)
      assert out =~ "defmodule MyBlog.Mode do"
      assert out =~ "head_script"
      assert out =~ "mode_toggle"
      assert out =~ "prefers-color-scheme"
    end
  end
end
