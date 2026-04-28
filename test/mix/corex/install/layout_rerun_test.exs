defmodule Mix.Corex.Install.LayoutRerunTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.{LayoutBuilder, Layouts}

  defp stock_phx_layouts do
    """
    defmodule MyAppWeb.Layouts do
      use MyAppWeb, :html

      embed_templates "layouts/*"

      attr :flash, :map, required: true, doc: "the map of flash messages"

      attr :current_scope, :map,
        default: nil,
        doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

      slot :inner_block, required: true

      def app(assigns) do
        ~H\"""
        <header class="navbar px-4 sm:px-6 lg:px-8">
          <div class="flex-1">
            <a href="/" class="flex-1 flex items-center w-fit gap-2">
              <span>v\#{Application.spec(:phoenix, :vsn)}</span>
            </a>
          </div>
          <div class="flex-none">
            <ul class="flex column gap-4">
              <li><a href="https://phoenixframework.org/">Website</a></li>
              <li><a href="https://github.com/phoenixframework/phoenix">GitHub</a></li>
            </ul>
          </div>
        </header>
        <main>
          {render_slot(@inner_block)}
        </main>
        <.flash_group flash={@flash} />
        \"""
      end
    end
    """
  end

  defp design_touched_layouts do
    """
    defmodule MyAppWeb.Layouts do
      use MyAppWeb, :html

      attr :flash, :map, required: true, doc: "the map of flash messages"

      attr :current_scope, :map,
        default: nil,
        doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

      slot :inner_block, required: true

      def app(assigns) do
        ~H\"""
        <header class="layout__header">
          <div class="layout__header__content">
            <a href="/" class="ui-link ui-link--brand">Corex</a>
          </div>
        </header>
        <main class="layout__main">
          <div class="layout__content">
            {render_slot(@inner_block)}
          </div>
        </main>
        <footer class="layout__footer">
          <div class="layout__footer__content">
            <span>Powered by Corex</span>
          </div>
        </footer>
        <.toast_group id="layout-toast" class="toast" flash={@flash}>
          <:loading>Loading…</:loading>
          <:close>Close</:close>
        </.toast_group>
        \"""
      end
    end
    """
  end

  defp apply_layout_run(content, themes, opts, i18n?) do
    content
    |> LayoutBuilder.merge_layout_declarations(themes, opts, i18n?)
    |> apply_body_patch(themes, opts, i18n?)
  end

  defp apply_body_patch(content, themes, opts, i18n?) do
    case LayoutBuilder.patch_app_def_body(content, themes, opts, i18n?) do
      {:notice, _} -> content
      new -> new
    end
  end

  defp apply_home_run(content, themes, opts, i18n?) do
    case LayoutBuilder.patch_home_attrs(content, themes, opts, i18n?) do
      {:notice, _} -> content
      {:ok, new} -> new
    end
  end

  describe "Case A: idempotent rerun with no flags" do
    test "two no-flag passes on already-touched layout produce identical content" do
      src = design_touched_layouts()
      one = apply_layout_run(src, [], [design: true], false)
      two = apply_layout_run(one, [], [design: true], false)

      assert one == two
    end
  end

  describe "Case B-E: dropping a flag preserves previously installed switchers and decls" do
    test "B: --mode then no-flag rerun keeps mode_toggle line and attr :mode" do
      src = design_touched_layouts()
      with_mode = apply_layout_run(src, [], [design: true, mode: true], false)
      assert with_mode =~ "<.mode_toggle mode={@mode} />"
      assert with_mode =~ "attr :mode"

      after_drop = apply_layout_run(with_mode, [], [design: true], false)
      assert after_drop =~ "<.mode_toggle mode={@mode} />"
      assert after_drop =~ "attr :mode"
    end

    test "C: --theme then no-flag rerun keeps theme_toggle line and attr :theme" do
      src = design_touched_layouts()
      with_theme = apply_layout_run(src, ["neo"], [design: true], false)
      assert with_theme =~ "<.theme_toggle theme={@theme} />"
      assert with_theme =~ "attr :theme"

      after_drop = apply_layout_run(with_theme, [], [design: true], false)
      assert after_drop =~ "<.theme_toggle theme={@theme} />"
      assert after_drop =~ "attr :theme"
    end

    test "D: --lang then no-flag rerun keeps language_switch and attr :path" do
      src = design_touched_layouts()
      with_lang = apply_layout_run(src, [], [design: true], true)
      assert with_lang =~ "<.language_switch path={@path} />"
      assert with_lang =~ "attr :path"

      after_drop = apply_layout_run(with_lang, [], [design: true], false)
      assert after_drop =~ "<.language_switch path={@path} />"
      assert after_drop =~ "attr :path"
    end

    test "E: all flags then no-flag rerun keeps all three switchers and attrs" do
      src = design_touched_layouts()
      all = apply_layout_run(src, ["neo"], [design: true, mode: true], true)

      after_drop = apply_layout_run(all, [], [design: true], false)

      assert after_drop =~ "<.language_switch path={@path} />"
      assert after_drop =~ "<.theme_toggle theme={@theme} />"
      assert after_drop =~ "<.mode_toggle mode={@mode} />"
      assert after_drop =~ "attr :path"
      assert after_drop =~ "attr :mode"
      assert after_drop =~ "attr :theme"
    end
  end

  describe "Case F-G: adding a flag inserts the new piece additively" do
    test "F: no-flags then --mode adds mode_toggle without removing anything" do
      src = design_touched_layouts()
      base = apply_layout_run(src, [], [design: true], false)
      added = apply_layout_run(base, [], [design: true, mode: true], false)

      assert added =~ "<.mode_toggle mode={@mode} />"
      assert added =~ "attr :mode"
    end

    test "G: --mode then --theme adds theme alongside mode" do
      src = design_touched_layouts()
      with_mode = apply_layout_run(src, [], [design: true, mode: true], false)
      with_both = apply_layout_run(with_mode, ["neo"], [design: true, mode: true], false)

      assert with_both =~ "<.mode_toggle mode={@mode} />"
      assert with_both =~ "<.theme_toggle theme={@theme} />"
      assert with_both =~ "attr :mode"
      assert with_both =~ "attr :theme"
    end
  end

  describe "Case H: re-applying same flag is a no-op" do
    test "two --mode passes give exactly one occurrence of each marker" do
      src = design_touched_layouts()
      one = apply_layout_run(src, [], [design: true, mode: true], false)
      two = apply_layout_run(one, [], [design: true, mode: true], false)

      assert one == two
      assert Regex.scan(~r/<\.mode_toggle\b/, two) |> length() == 1
      assert Regex.scan(~r/\battr\s*:mode\b/, two) |> length() == 1
    end
  end

  describe "Case K-L: user-customized def app is preserved" do
    test "K: customized body keeps custom content AND gets new switcher inserted" do
      src = """
      defmodule MyAppWeb.Layouts do
        use MyAppWeb, :html

        attr :flash, :map, required: true
        slot :inner_block, required: true

        def app(assigns) do
          ~H\"""
          <header class="layout__header">
            <div class="layout__header__content">
              <a href="/" class="ui-link ui-link--brand">Corex</a>
              <p>Custom content</p>
            </div>
          </header>
          <main class="layout__main">
            {render_slot(@inner_block)}
          </main>
          \"""
        end
      end
      """

      out = apply_layout_run(src, [], [design: true, mode: true], false)

      assert out =~ "Custom content"
      assert out =~ "<.mode_toggle mode={@mode} />"
    end

    test "L: customized body without brand link emits notice (no body change) but still adds attrs/decls" do
      src = """
      defmodule MyAppWeb.Layouts do
        use MyAppWeb, :html

        attr :flash, :map, required: true
        slot :inner_block, required: true

        def app(assigns) do
          ~H\"""
          <main>
            <p>Just main</p>
            {render_slot(@inner_block)}
          </main>
          \"""
        end
      end
      """

      assert {:notice, _msg} =
               LayoutBuilder.patch_app_def_body(src, [], [design: true, mode: true], false)

      with_decls =
        LayoutBuilder.merge_layout_declarations(src, [], [design: true, mode: true], false)

      assert with_decls =~ "attr :mode"
    end
  end

  describe "Case N: stock Phoenix layouts are detected" do
    test "stock_phx_app_def?/1 returns true on stock fixture" do
      assert LayoutBuilder.stock_phx_app_def?(stock_phx_layouts())
    end
  end

  describe "Home rerun matrix" do
    defp design_touched_home(extras \\ []) do
      attrs = ["flash={@flash}" | extras] |> Enum.join("\n  ")

      "<Layouts.app\n  " <> attrs <> "\n>\n  <p>hi</p>\n</Layouts.app>\n"
    end

    test "Case A (home): two no-flag runs are byte-equal" do
      src = design_touched_home()
      one = apply_home_run(src, [], [], false)
      two = apply_home_run(one, [], [], false)

      assert one == two
    end

    test "Case B (home): --mode then no-flag rerun keeps mode={@mode}" do
      src = design_touched_home()
      with_mode = apply_home_run(src, [], [mode: true], false)
      assert with_mode =~ "mode={@mode}"

      dropped = apply_home_run(with_mode, [], [], false)
      assert dropped =~ "mode={@mode}"
    end

    test "Case G (home): --mode then --theme adds theme={@theme} alongside mode={@mode}" do
      src = design_touched_home()
      one = apply_home_run(src, [], [mode: true], false)
      two = apply_home_run(one, ["neo"], [mode: true], false)

      assert two =~ "mode={@mode}"
      assert two =~ "theme={@theme}"
    end

    test "Case H (home): re-applying --mode is idempotent" do
      src = design_touched_home()
      one = apply_home_run(src, [], [mode: true], false)
      two = apply_home_run(one, [], [mode: true], false)

      assert one == two
      assert Regex.scan(~r/\bmode\s*=/m, two) |> length() == 1
    end

    test "Case M (home): customized home keeps custom content and gets attrs added" do
      src = """
      <Layouts.app flash={@flash}>
        <section>Custom homepage</section>
      </Layouts.app>
      """

      out = apply_home_run(src, [], [mode: true], false)

      assert out =~ "Custom homepage"
      assert out =~ "mode={@mode}"
    end
  end

  describe "Case I-J: design/no-design stickiness through Layouts.build_replaced_home" do
    test "build_replaced_home with --design uses Corex layout markup" do
      home = Layouts.build_replaced_home(["neo"], [design: true, mode: true], true, "my_app_web")

      assert home =~ "mode={@mode}"
      assert home =~ "theme={@theme}"
      assert home =~ "path={@path}"
    end

    test "build_replaced_home with --no-design uses no-design body" do
      home = Layouts.build_replaced_home([], [design: false], false, "my_app_web")
      assert home =~ ~r/<Layouts\.app\b/
    end
  end

  describe "AST validity" do
    test "merge_layout_declarations result still parses" do
      src = stock_phx_layouts()
      out = LayoutBuilder.merge_layout_declarations(src, ["neo"], [mode: true], true)

      assert {:ok, _} = Code.string_to_quoted(out)
    end

    test "patch_app_def_body result on already-touched module still parses" do
      src = design_touched_layouts()

      out = apply_layout_run(src, ["neo"], [design: true, mode: true], true)

      assert {:ok, _} = Code.string_to_quoted(out)
    end
  end
end
