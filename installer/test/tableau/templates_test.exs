defmodule Corex.New.Tableau.TemplatesTest do
  use ExUnit.Case, async: true

  alias Corex.New.Tableau.Templates

  test "list_templates/0 returns all bundled template keys" do
    keys = Templates.list_templates()

    assert :root_layout in keys
    assert :post_layout in keys
    assert :tag_layout in keys
    assert :shell in keys
    assert :home_page in keys
    refute :design_page in keys
    refute :guides_page in keys
    assert :blog_index_page in keys
    assert :tags_index_page in keys
    assert :not_found_page in keys
    assert :config_module in keys
    assert :application_module in keys
    assert :mcp_module in keys
    assert :md_ex_converter in keys
    assert :code_blocks in keys
    assert :block_renderer in keys
    assert :theme_module in keys
    assert :mode_module in keys
    assert :accessibility_module in keys
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
    assert length(keys) == 30
  end

  @base_assigns [
    app_module: "MyBlog",
    otp_app: :my_blog,
    mode: false,
    theme: false,
    a11y: false,
    lang: false,
    mcp: true,
    usage_rules: true,
    design: true,
    themes: ["neo"],
    default_theme: "neo",
    components: ~w(
      toast layout-heading typo icon link button dialog password-input
      scrollbar checkbox data-list data-table date-picker native-input number-input
      select toggle toggle-group
    )a,
    corex_js_import: "corex",
    corex_dep_source: "\"~> 0.2.0\"",
    corex_design_dep_source: "\"~> 0.2\", runtime: false, only: :dev",
    corex_mcp_dep_source: "\"~> 0.2.0\", only: [:dev, :test]"
  ]

  @lang_assigns Keyword.merge(@base_assigns,
                  lang: true,
                  components: ~w(
                    toast layout-heading typo icon link button dialog password-input
                    scrollbar checkbox data-list data-table date-picker native-input number-input
                    select toggle toggle-group
                  )a
                )

  describe "root_layout/1" do
    test "renders a valid Tableau layout module" do
      out = Templates.root_layout(@base_assigns)
      assert out =~ "defmodule MyBlog.RootLayout do"
      assert out =~ "use Tableau.Layout"
      assert out =~ "use Corex"
      assert out =~ ~s(id="site-nav-dialog")
      assert out =~ ~s(to={@home_path})
      assert out =~ ~s(to={@blog_path})
      assert out =~ ~s(to={@tags_path})
      assert out =~ "Home"
      assert out =~ "Blog"
      assert out =~ "Tags"
      assert out =~ "Hexdocs"
      assert out =~ "Components"
      assert out =~ "corex.gigalixirapp.com"
      assert out =~ "ui-size-xl"
      assert out =~ "ui-size-md"
      assert out =~ "gap-space-lg md:flex lg:gap-space-xl"
      assert out =~ "overflow-y-auto"
      assert out =~ "min-h-[calc(100dvh-var(--spacing-size-lg))]"
      refute out =~ ~S[to={"/design"}]
      refute out =~ ~S[to={"/guides"}]
      assert out =~ "<.toast_group"
      assert out =~ "<.toast_client_error"
      assert out =~ "defp page_path_from_page"
    end

    test "lang layout omits page_path_from_page and sets locale path assigns" do
      out = Templates.root_layout(@lang_assigns)
      refute out =~ "defp page_path_from_page"
      assert out =~ "Locale.swap_path(\"/blog\", locale)"
      refute out =~ "Locale.swap_path(\"/tags\", locale)"
      refute out =~ ":tags_path"
      refute out =~ ~S[~t"Tags"]
    end

    test "includes theme/mode head scripts when enabled" do
      assigns = Keyword.merge(@base_assigns, mode: true, theme: true)
      out = Templates.root_layout(assigns)
      assert out =~ "MyBlog.Mode.head_script()"
      assert out =~ "MyBlog.Theme.head_script()"
      assert out =~ "MyBlog.Mode.mode_toggle"
      assert out =~ "MyBlog.Theme.theme_toggle"
      assert out =~ ~s(id="theme-select")
      assert out =~ ~s(id="theme-select-mobile")
      assert out =~ ~s(id="mode-switcher")
      assert out =~ ~s(id="mode-switcher-mobile")
    end

    test "omits theme/mode when disabled" do
      out = Templates.root_layout(@base_assigns)
      refute out =~ "Mode.head_script"
      refute out =~ "Theme.head_script"
      refute out =~ "mode_toggle"
      refute out =~ "theme_toggle"
    end

    test "includes language select under footer brand when lang is on" do
      out = Templates.root_layout(@lang_assigns)
      assert out =~ "data-locale="
      assert out =~ "data-locales="
      assert out =~ "id=\"corex-language-switch\""
      assert out =~ "MyBlog.Locale"
      assert out =~ "corex:set-locale"
      assert out =~ "Open source. MIT License."
    end

    test "omits data-theme when design is off" do
      out = Templates.root_layout(Keyword.put(@base_assigns, :design, false))
      refute out =~ "data-theme="
      refute out =~ "data-mode="
    end

    test "translates document title and nav aria labels when lang is on" do
      out = Templates.root_layout(@lang_assigns)
      assert out =~ ~S|~t"#{name = site_name} - Corex for Tableau"|
      assert out =~ ~S[~t"Site"]
      assert out =~ ~S[~t"Primary"]
    end

    test "keeps plain English document title when lang is off" do
      out = Templates.root_layout(@base_assigns)
      assert out =~ ~S["#{site_name} - Corex for Tableau"]
      refute out =~ ~S|~t"#{name = site_name} - Corex for Tableau"|
    end
  end

  describe "post_layout/1" do
    test "renders a valid post layout with typo markdown prose" do
      out = Templates.post_layout(@base_assigns)
      assert out =~ "defmodule MyBlog.PostLayout do"
      assert out =~ "use Tableau.Layout, layout: MyBlog.RootLayout"
      assert out =~ "typo markdown prose"
      assert out =~ "Back to blog"
      assert out =~ "Browse tags"
      assert out =~ "blog__nav"
      assert out =~ "link ui-nav"
      assert out =~ "blog__hero--post"
      assert out =~ "blog__display"
    end

    test "omits tags UI when lang is on" do
      out = Templates.post_layout(@lang_assigns)
      refute out =~ "Browse tags"
      refute out =~ "post_tags"
      refute out =~ "tag_permalink"
      assert out =~ "Back to blog"
      assert out =~ "blog__nav"
      assert out =~ "link ui-nav"
    end
  end

  describe "home_page/1" do
    test "renders a home page with hero and accordion API" do
      out = Templates.home_page(@base_assigns)
      assert out =~ "defmodule MyBlog.HomePage do"
      assert out =~ "The Phoenix UI"
      assert out =~ "real API"
      assert out =~ ~s(id="home-accordion")
      assert out =~ "Corex.Accordion.set_value"
      assert out =~ "permalink: \"/\""
      refute out =~ "<.layout_heading"
      refute out =~ ~S[to="/design"]
      refute out =~ ~S[to="/guides"]
      refute out =~ "<.button"
    end

    test "emits Module.create per locale when lang is on" do
      out = Templates.home_page(@lang_assigns)
      assert out =~ "Module.create"
      assert out =~ ~S[permalink = "/#{locale}/"]
      assert out =~ "The Phoenix UI"
      refute out =~ "Locale.swap_path(\"/design\""
      refute out =~ ~S[permalink: "/"]
    end
  end

  describe "blog_index_page/1" do
    test "renders a blog index page listing posts" do
      out = Templates.blog_index_page(@base_assigns)
      assert out =~ "defmodule MyBlog.BlogIndexPage do"
      assert out =~ "permalink: \"/blog\""
      assert out =~ "sorted_posts"
      assert out =~ "blog__nav"
      assert out =~ "link ui-nav"
      assert out =~ "Browse tags"
      assert out =~ "blog__hero"
      assert out =~ "blog__display"
      assert out =~ "blog__card"
      assert out =~ "blog__grid"
    end

    test "emits per-locale blog permalinks when lang is on" do
      out = Templates.blog_index_page(@lang_assigns)
      assert out =~ "Module.create"
      assert out =~ ~S[permalink = "/#{locale}/blog/"]
      assert out =~ "String.starts_with?"
      assert out =~ "post[:permalink]"
      assert out =~ "blog__nav"
      assert out =~ "link ui-nav"
      refute out =~ "Browse tags"
      refute out =~ "post_tags"
      refute out =~ "tags_path"
    end
  end

  describe "tags_index_page/1" do
    test "renders tags as cards not badges" do
      out = Templates.tags_index_page(@base_assigns)
      assert out =~ "defmodule MyBlog.TagsIndexPage do"
      assert out =~ "blog__nav"
      assert out =~ "link ui-nav"
      assert out =~ "blog__hero"
      assert out =~ "blog__card"
      assert out =~ "blog__grid"
      refute out =~ "badge ui-brand ui-size-md"
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
      assert out =~ "@import \"./blog.css\""
      assert out =~ "@import \"./prose.css\""
    end

    test "omits corex import when design is off" do
      out = Templates.site_css(Keyword.put(@base_assigns, :design, false))
      refute out =~ "corex.css"
      assert out =~ ~s(@import "./corex-base.css")
    end

    test "includes dark mode variant when mode is on" do
      out = Templates.site_css(Keyword.put(@base_assigns, :mode, true))
      assert out =~ "@custom-variant dark"
    end
  end

  describe "site_js/1" do
    test "imports corex hooks and creates LiveSocket" do
      out = Templates.site_js(@base_assigns)
      assert out =~ ~S[import {Toast} from "corex/toast"]
      assert out =~ ~S[import {Dialog} from "corex/dialog"]
      assert out =~ ~S[import {Accordion} from "corex/accordion"]
      assert out =~ ~S[import {Clipboard} from "corex/clipboard"]
      assert out =~ "LiveSocket"
      assert out =~ "Toast,"
      assert out =~ "Dialog,"
      assert out =~ "Accordion,"
      assert out =~ "Clipboard,"
      assert out =~ "disableDebug"
      refute out =~ "longPollFallbackMs"
      refute out =~ "corex/hooks"
    end

    test "includes Select and Toggle hooks when theme and mode are on" do
      assigns = Keyword.merge(@base_assigns, mode: true, theme: true)
      out = Templates.site_js(assigns)
      assert out =~ ~S[import {Select} from "corex/select"]
      assert out =~ ~S[import {Toggle} from "corex/toggle"]
      assert out =~ "Select,"
      assert out =~ "Toggle,"
      assert out =~ "phx:set-mode"
      assert out =~ "phx:set-theme"
    end

    test "omits Select/Toggle when mode and theme are off" do
      out = Templates.site_js(@base_assigns)
      refute out =~ ~S[import {Select}]
      refute out =~ ~S[import {Toggle}]
      refute out =~ "Select,"
      refute out =~ "Toggle,"
    end

    test "imports locale.js and Select when lang is on" do
      out = Templates.site_js(@lang_assigns)
      assert out =~ ~S[import "./locale.js"]
      assert out =~ ~S[import {Select} from "corex/select"]
      assert out =~ "Select,"
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
      assert out =~ "header_id_prefix"
      refute out =~ "header_ids:"
      assert out =~ "Tableau.TagExtension"
      assert out =~ "MyBlog.TagLayout"
    end

    test "includes corex_design config when design is on" do
      out = Templates.config_exs(@base_assigns)
      assert out =~ "config :corex_design"
    end

    test "omits TagExtension when lang is on" do
      out = Templates.config_exs(@lang_assigns)
      refute out =~ "Tableau.TagExtension"
      refute out =~ "TagLayout"
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
      assert out =~ "usage_rules"
      assert out =~ "package_skills: [:corex]"
      assert out =~ ~s({:mdex, "~> 0.13.5", override: true})
      assert out =~ ~s({:makeup, "~> 1.2"})
      assert out =~ "makeup_syntect"
      refute out =~ "json_polyfill"
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

    test "omits usage_rules when usage_rules is off" do
      out = Templates.mix_exs(Keyword.put(@base_assigns, :usage_rules, false))
      refute out =~ "usage_rules"
      refute out =~ "package_skills"
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

    test "uses locale-prefixed permalink when lang is on" do
      out = Templates.sample_post(Keyword.merge(@lang_assigns, locale: "fr"))
      assert out =~ "permalink: /fr/blog/welcome/"
      assert out =~ "Bienvenue sur votre nouveau blog"
      assert out =~ "permalink: /fr/blog/mon-article/"
      refute out =~ "tags:"
    end

    test "uses Arabic title and body for ar locale" do
      out = Templates.sample_post(Keyword.merge(@lang_assigns, locale: "ar"))
      assert out =~ "permalink: /ar/blog/welcome/"
      assert out =~ "مرحبًا بك في مدونتك الجديدة"
      refute out =~ "tags:"
    end

    test "includes tags when lang is off" do
      out = Templates.sample_post(@base_assigns)
      assert out =~ "tags:"
      assert out =~ "Elixir"
    end
  end

  describe "md_ex_converter/1" do
    test "pipes markdown HTML through CodeBlocks.transform" do
      out = Templates.md_ex_converter(@base_assigns)
      assert out =~ "defmodule MyBlog.MDExConverter do"
      assert out =~ "alias MyBlog.Markdown.CodeBlocks"
      assert out =~ "CodeBlocks.transform()"
    end
  end

  describe "code_blocks/1" do
    test "renders markdown code block transformer" do
      out = Templates.code_blocks(@base_assigns)
      assert out =~ "defmodule MyBlog.Markdown.CodeBlocks do"
      assert out =~ "my_blog-md-"
      assert out =~ "BlockRenderer.render_fence_html"
    end
  end

  describe "block_renderer/1" do
    test "renders Corex code and clipboard fence" do
      out = Templates.block_renderer(@base_assigns)
      assert out =~ "defmodule MyBlog.Markdown.BlockRenderer do"
      assert out =~ "<.code"
      assert out =~ "<.clipboard"
      refute out =~ "GettextSigil"
      assert out =~ ~s(trigger_aria_label={"Copy code"})
    end

    test "uses gettext for copy label when lang is on" do
      out = Templates.block_renderer(@lang_assigns)
      assert out =~ "GettextSigil"
      assert out =~ ~S[~t"Copy code"]
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
      refute out =~ "GettextSigil"
      refute out =~ "~t\""
      assert out =~ "Theme"
    end

    test "theme module uses gettext when lang is on" do
      out = Templates.theme_module(@lang_assigns)
      assert out =~ "GettextSigil"
      assert out =~ ~S[~t"Theme"]
    end

    test "mode module renders head script and toggle" do
      out = Templates.mode_module(@base_assigns)
      assert out =~ "defmodule MyBlog.Mode do"
      assert out =~ "head_script"
      assert out =~ "mode_toggle"
      assert out =~ "prefers-color-scheme"
      assert out =~ "ui-trigger--circle"
      assert out =~ "ui-ghost"
      refute out =~ "GettextSigil"
      refute out =~ "~t\""
    end

    test "mode module uses gettext when lang is on" do
      out = Templates.mode_module(@lang_assigns)
      assert out =~ "GettextSigil"
      assert out =~ ~S[~t"Dark mode"]
      assert out =~ ~S[~t"Light mode"]
    end

    test "accessibility module derives bridge from Accessibility and localizes with lang" do
      out = Templates.accessibility_module(Keyword.put(@base_assigns, :a11y, true))
      assert out =~ "defmodule MyBlog.Accessibility do"
      assert out =~ "Accessibility.axes()"
      assert out =~ "Jason.encode!"
      assert out =~ "accessibility_panel"
      assert out =~ "accessibility_open_button"
      assert out =~ ~s(viewBox="0 0 512 512")
      assert out =~ "[--ctl-text:calc(var(--spacing-size-sm)*0.65)]"
      refute out =~ "fixed bottom-space end-space"
      refute out =~ "h-size-md"
      refute out =~ "hero-adjustments-horizontal"
      refute out =~ ~s(const a11yAxes = ["text")

      lang_out =
        Templates.accessibility_module(Keyword.merge(@base_assigns, a11y: true, lang: true))

      assert lang_out =~ "GettextSigil"
      assert lang_out =~ ~s(~t"Zoom")
      assert lang_out =~ ~s(~t"Reset")
    end

    test "config.exs uses assigns for theme list and modes" do
      out = Templates.config_exs(@base_assigns)
      assert out =~ "default_theme: :neo"
      assert out =~ "themes: [:neo]"
      assert out =~ "modes: [:light, :dark]"
      refute out =~ "themes: nil"
    end
  end
end
