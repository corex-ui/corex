defmodule Mix.Corex.Install.LayoutBuilderPatchTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.LayoutBuilder

  defp design_layouts_module(extras \\ "") do
    """
    defmodule MyAppWeb.Layouts do
      use MyAppWeb, :html

      attr :flash, :map, required: true
      slot :inner_block, required: true

      def app(assigns) do
        ~H\"""
        <header class="layout__header">
          <div class="layout__header__content">
            <a href="/" class="ui-link ui-link--brand">Corex</a>
    #{extras}    </div>
        </header>
        <main class="layout__main">
          {render_slot(@inner_block)}
        </main>
        \"""
      end
    end
    """
  end

  defp no_design_layouts_module(extras \\ "") do
    """
    defmodule MyAppWeb.Layouts do
      use MyAppWeb, :html

      def app(assigns) do
        ~H\"""
        <header>
          <div>
            <a href="/">Corex</a>
    #{extras}    </div>
        </header>
        <main>
          {render_slot(@inner_block)}
        </main>
        \"""
      end
    end
    """
  end

  describe "patch_app_def_body/4 - design on" do
    test "no flags: returns content unchanged" do
      src = design_layouts_module()
      assert LayoutBuilder.patch_app_def_body(src, [], [design: true], false) == src
    end

    test "--mode adds <.mode_toggle> via brand anchor (uses @mode form)" do
      src = design_layouts_module()
      out = LayoutBuilder.patch_app_def_body(src, [], [design: true, mode: true], false)

      assert is_binary(out)
      assert out =~ "<.mode_toggle mode={@mode} />"
      refute out =~ ~s|assigns[:mode]|
      assert out =~ ~s|<div class="layout__row">|
    end

    test "--theme adds <.theme_toggle theme={@theme} />" do
      src = design_layouts_module()
      out = LayoutBuilder.patch_app_def_body(src, ["neo"], [design: true], false)

      assert out =~ "<.theme_toggle theme={@theme} />"
    end

    test "--lang adds <.language_switch path={@path} />" do
      src = design_layouts_module()
      out = LayoutBuilder.patch_app_def_body(src, [], [design: true], true)

      assert out =~ "<.language_switch path={@path} />"
    end

    test "rerun adds new flag without removing existing switcher" do
      src = design_layouts_module()
      one = LayoutBuilder.patch_app_def_body(src, [], [design: true, mode: true], false)
      two = LayoutBuilder.patch_app_def_body(one, ["neo"], [design: true, mode: true], false)

      assert two =~ "<.mode_toggle mode={@mode} />"
      assert two =~ "<.theme_toggle theme={@theme} />"
    end

    test "applying same flag twice is idempotent" do
      src = design_layouts_module()
      one = LayoutBuilder.patch_app_def_body(src, [], [design: true, mode: true], false)
      two = LayoutBuilder.patch_app_def_body(one, [], [design: true, mode: true], false)

      assert one == two
      assert Regex.scan(~r/<\.mode_toggle\b/, two) |> length() == 1
    end
  end

  describe "patch_app_def_body/4 - no design" do
    test "--mode adds <.mode_toggle> via no-design brand anchor" do
      src = no_design_layouts_module()
      out = LayoutBuilder.patch_app_def_body(src, [], [design: false, mode: true], false)

      assert is_binary(out)
      assert out =~ "<.mode_toggle mode={@mode} />"
      refute out =~ ~s|class="layout__row"|
    end
  end

  describe "patch_app_def_body/4 - missing anchor" do
    test "without brand link: emits {:notice, _}" do
      src = """
      defmodule MyAppWeb.Layouts do
        def app(assigns) do
          ~H\"""
          <main>
            {render_slot(@inner_block)}
          </main>
          \"""
        end
      end
      """

      assert {:notice, msg} =
               LayoutBuilder.patch_app_def_body(src, [], [design: true, mode: true], false)

      assert msg =~ "language/theme/mode" or msg =~ "manually"
    end

    test "without def app: emits {:notice, _}" do
      src = "defmodule X do\nend\n"

      assert {:notice, msg} =
               LayoutBuilder.patch_app_def_body(src, [], [design: true, mode: true], false)

      assert msg =~ "def app"
    end
  end

  describe "patch_home_attrs/4" do
    test "no flags: ensures flash attr is present" do
      src = ~s(<Layouts.app flash={@flash}>\n  <p>hello</p>\n</Layouts.app>\n)
      assert {:ok, out} = LayoutBuilder.patch_home_attrs(src, [], [], false)

      assert out =~ ~s(flash={@flash})
    end

    test "additively inserts mode={@mode} when --mode is on" do
      src = ~s(<Layouts.app flash={@flash}>\n  <p>hello</p>\n</Layouts.app>\n)

      assert {:ok, out} = LayoutBuilder.patch_home_attrs(src, [], [mode: true], false)

      assert out =~ "flash={@flash}"
      assert out =~ "mode={@mode}"
      refute out =~ ~s|assigns[:mode]|
    end

    test "additively inserts path/theme/mode" do
      src = ~s(<Layouts.app flash={@flash}>\n  <p>hello</p>\n</Layouts.app>\n)

      assert {:ok, out} =
               LayoutBuilder.patch_home_attrs(src, ["neo"], [mode: true], true)

      assert out =~ "flash={@flash}"
      assert out =~ "mode={@mode}"
      assert out =~ "theme={@theme}"
      assert out =~ "path={@path}"
    end

    test "preserves existing custom attrs (current_scope, etc.)" do
      src =
        ~s(<Layouts.app flash={@flash} current_scope={@current_scope}>\n  <p>hello</p>\n</Layouts.app>\n)

      assert {:ok, out} = LayoutBuilder.patch_home_attrs(src, [], [mode: true], false)

      assert out =~ "current_scope={@current_scope}"
      assert out =~ "mode={@mode}"
    end

    test "does not duplicate existing flag attr (idempotent)" do
      src = ~s(<Layouts.app flash={@flash} mode={@mode}>\n  <p>hello</p>\n</Layouts.app>\n)

      assert {:ok, out} = LayoutBuilder.patch_home_attrs(src, [], [mode: true], false)

      assert Regex.scan(~r/\bmode\s*=/m, out) |> length() == 1
    end

    test "missing anchor: emits {:notice, _}" do
      src = "<p>no Layouts.app here</p>\n"

      assert {:notice, msg} = LayoutBuilder.patch_home_attrs(src, [], [mode: true], false)
      assert msg =~ "Layouts.app"
    end
  end
end
