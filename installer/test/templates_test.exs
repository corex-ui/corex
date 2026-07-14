defmodule Corex.New.TemplatesTest do
  use ExUnit.Case, async: true

  alias Corex.New.Templates

  test "list_templates/0 returns all bundled template keys" do
    keys = Templates.list_templates()

    assert :layouts_ex in keys
    assert :root_heex in keys
    assert :home_heex in keys
    assert :app_js in keys
    assert :app_css in keys
    assert length(keys) == 9
  end

  @base_assigns [
    web_module: "MyAppWeb",
    app_module: "MyApp",
    otp_app: :my_app,
    mode: false,
    theme: false,
    lang: false,
    design: true,
    tailwind: true,
    themes: ["neo"],
    default_theme: "neo",
    corex_js_import: "corex"
  ]

  describe "layouts_ex/1" do
    test "renders a valid module with def app/1 by default" do
      out = Templates.layouts_ex(@base_assigns)
      assert out =~ "defmodule MyAppWeb.Layouts do"
      assert out =~ "def app(assigns) do"
      assert out =~ "<.toast_group"
      assert out =~ "<.toast_client_error"
      refute out =~ "def mode_toggle"
      refute out =~ "def theme_toggle"
      refute out =~ "def language_switch"
    end

    test "includes mode_toggle/1 and mode attr when mode: true" do
      out = Templates.layouts_ex(Keyword.put(@base_assigns, :mode, true))
      assert out =~ "attr :mode, :string"
      assert out =~ "def mode_toggle(assigns)"
      assert out =~ "<.mode_toggle mode={@mode} />"
    end

    test "includes theme_toggle/1 when theme: true" do
      out = Templates.layouts_ex(Keyword.put(@base_assigns, :theme, true))
      assert out =~ "attr :theme, :string"
      assert out =~ "def theme_toggle(assigns)"
      assert out =~ "<.theme_toggle theme={@theme} />"
      assert out =~ ~s(positioning={%Corex.Positioning{same_width: false}})
    end

    test "includes language_switch/1 when lang: true" do
      out = Templates.layouts_ex(Keyword.put(@base_assigns, :lang, true))
      assert out =~ "def language_switch(assigns)"
      assert out =~ "<.language_switch current_path={@current_path} />"
      assert out =~ "MyAppWeb.Locale.locales()"
      assert out =~ "MyAppWeb.Locale.swap_path"
      assert out =~ "MyAppWeb.Locale.current()"
    end
  end

  describe "root_heex/1" do
    test "renders with type=\"module\" script and mode/theme bridge when enabled" do
      out = Templates.root_heex(Keyword.merge(@base_assigns, mode: true, theme: true))
      assert out =~ ~s(type="module")
      assert out =~ "phx:set-mode"
      assert out =~ "phx:set-theme"
      assert out =~ "data-mode"
      assert out =~ "data-theme"
    end

    test "omits the bridge script when neither mode nor theme is enabled" do
      out = Templates.root_heex(@base_assigns)
      refute out =~ "phx:set-mode"
      refute out =~ "phx:set-theme"
      assert out =~ ~s(data-theme="neo")
      assert out =~ ~s(data-mode="light")
    end

    test "omits data-theme and data-mode on html when design is off" do
      out = Templates.root_heex(Keyword.put(@base_assigns, :design, false))
      refute out =~ ~s(data-theme=)
      refute out =~ ~s(data-mode=)
    end

    test "uses Locale.lang/dir when lang: true" do
      out = Templates.root_heex(Keyword.put(@base_assigns, :lang, true))
      assert out =~ "MyAppWeb.Locale.lang()"
      assert out =~ "MyAppWeb.Locale.dir()"
    end
  end

  describe "home_heex/1" do
    test "renders a Corex demo page in <Layouts.app>" do
      out = Templates.home_heex(@base_assigns)
      assert out =~ "<Layouts.app"
      assert out =~ "<.layout_heading"
      assert out =~ "Corex for Phoenix"
    end

    test "passes current_path from conn when lang: true" do
      out = Templates.home_heex(Keyword.put(@base_assigns, :lang, true))
      assert out =~ "current_path={@conn.request_path}"
    end
  end

  describe "plug_mode/1 and plug_theme/1 and hooks_layout/1" do
    test "plug_mode renders the mode plug module" do
      out = Templates.plug_mode(@base_assigns)
      assert out =~ "defmodule MyAppWeb.Plugs.Mode do"
      assert out =~ "phx_mode"
    end

    test "plug_theme renders the theme plug module using the otp_app" do
      out = Templates.plug_theme(Keyword.put(@base_assigns, :theme, true))
      assert out =~ "defmodule MyAppWeb.Plugs.Theme do"
      assert out =~ ":my_app"
    end

    test "hooks_layout renders LiveView on_mount hook for locale and layout assigns" do
      out = Templates.hooks_layout(@base_assigns)
      assert out =~ "defmodule MyAppWeb.Hooks.Layout do"
      assert out =~ "Localize.Plug.put_locale_from_session"
      assert out =~ "MyAppWeb.Gettext"
      assert out =~ "attach_hook(:layout_current_path, :handle_params"
      assert out =~ "assign_current_path"
    end
  end

  describe "app_js/1" do
    test "imports corex and spreads into LiveSocket hooks" do
      out = Templates.app_js(@base_assigns)
      assert out =~ "import corex from \"corex\""
      assert out =~ "...corex"
      assert out =~ "phoenix-colocated/my_app"
    end

    test "imports relative corex.mjs path when corex_js_import is set" do
      rel = "../../../corex_clone/priv/static/corex.mjs"
      out = Templates.app_js(Keyword.put(@base_assigns, :corex_js_import, rel))
      assert out =~ "import corex from \"#{rel}\""
      refute out =~ "import corex from \"corex\""
      assert out =~ "...corex"
    end
  end

  describe "app_css/1" do
    test "includes layout, generator, and shared design imports when design: true" do
      out = Templates.app_css(@base_assigns)
      assert out =~ "@import \"../corex/corex.css\""
      refute out =~ "@import \"../corex/components/toggle.css\""
      refute out =~ "@import \"../corex/components/toast.css\""
      refute out =~ "toggle-group.css"
      refute out =~ "tags-input.css"
    end

    test "includes corex.css when mode without theme or lang" do
      out =
        Templates.app_css(
          @base_assigns
          |> Keyword.put(:mode, true)
          |> Keyword.put(:themes, ["neo"])
        )

      assert out =~ "@import \"../corex/corex.css\""
      refute out =~ "@import \"../corex/components/toggle.css\""
      refute out =~ "toggle-group.css"
      refute out =~ "tags-input.css"
    end

    test "includes corex.css when theme without mode" do
      out =
        Templates.app_css(
          @base_assigns
          |> Keyword.put(:theme, true)
          |> Keyword.put(:themes, ["neo", "uno", "duo", "leo"])
        )

      assert out =~ "@import \"../corex/corex.css\""
      refute out =~ "@import \"../corex/components/toggle.css\""
      refute out =~ "toggle-group.css"
      refute out =~ "tags-input.css"
    end

    test "includes corex.css when lang without theme" do
      out =
        Templates.app_css(
          @base_assigns
          |> Keyword.put(:lang, true)
          |> Keyword.put(:themes, ["neo"])
        )

      refute out =~ "toggle-group.css"
      assert out =~ "@import \"../corex/corex.css\""
      refute out =~ "@import \"../corex/components/toggle.css\""
      refute out =~ "tags-input.css"
    end

    test "omits design imports when design: false but keeps Tailwind" do
      out = Templates.app_css(Keyword.put(@base_assigns, :design, false))
      refute out =~ "@import \"../corex/main.css\""
      assert out =~ "@import \"tailwindcss\""
    end

    test "minimal css when tailwind: false" do
      out = Templates.app_css(Keyword.put(@base_assigns, :tailwind, false))
      refute out =~ "@import \"tailwindcss\""
      assert out =~ "[data-phx-session]"
    end
  end
end
