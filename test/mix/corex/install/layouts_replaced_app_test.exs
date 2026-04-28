defmodule Mix.Corex.Install.LayoutsReplacedAppTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.LayoutBuilder

  defp unique_layouts_module do
    Module.concat(__MODULE__, :"Layouts#{System.unique_integer([:positive])}")
  end

  defp stock_phoenix_layouts(mod) do
    """
    defmodule #{inspect(mod)} do
      use Phoenix.Component

      attr :flash, :map, required: true, doc: "the map of flash messages"

      attr :current_scope, :map,
        default: nil,
        doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

      slot :inner_block, required: true

      def app(assigns) do
        ~H"<header>stock</header>"
      end
    end
    """
  end

  describe "build_layout_def/3" do
    test "no flags: bare def app with Corex header/footer/toast and no switchers" do
      out = LayoutBuilder.build_layout_def([], [], false)

      assert out =~ ~r/def\s+app\(assigns\)\s+do/
      assert out =~ "Powered by Corex"
      assert out =~ ~s(id="layout-toast")
      assert out =~ ~s(toast_group_id="layout-toast")
      refute out =~ "language_switch"
      refute out =~ "theme_toggle"
      refute out =~ "mode_toggle"
      refute out =~ "Get Started"
      refute out =~ "GitHub"
    end

    test "--lang adds <.language_switch path={@path} /> in header" do
      out = LayoutBuilder.build_layout_def([], [], true)

      assert out =~ "<.language_switch path={@path} />"
      refute out =~ "theme_toggle"
      refute out =~ "mode_toggle"
    end

    test "--mode adds <.mode_toggle mode={@mode} /> in header" do
      out = LayoutBuilder.build_layout_def([], [mode: true], false)

      assert out =~ "<.mode_toggle mode={@mode} />"
      refute out =~ "theme_toggle"
      refute out =~ "language_switch"
    end

    test "--theme (themes != []) adds <.theme_toggle theme={@theme} />" do
      out = LayoutBuilder.build_layout_def(["neo"], [], false)

      assert out =~ "<.theme_toggle theme={@theme} />"
      refute out =~ "mode_toggle"
      refute out =~ "language_switch"
    end

    test "--no-design uses bare header/main/footer (no layout__* classes)" do
      out = LayoutBuilder.build_layout_def([], [design: false], false)

      refute out =~ "layout__header"
      refute out =~ "layout__main"
      refute out =~ "layout__footer"
      assert out =~ "Powered by Corex"
    end

    test "design on uses Corex layout classes" do
      out = LayoutBuilder.build_layout_def([], [design: true], false)

      assert out =~ "layout__header"
      assert out =~ "layout__main"
      assert out =~ "layout__footer"
    end

    test "toast id is always 'layout-toast' (no per-fn variant)" do
      assert LayoutBuilder.build_layout_def([], [], false) =~ ~s(id="layout-toast")
      assert LayoutBuilder.build_layout_def(["neo"], [mode: true], true) =~ ~s(id="layout-toast")
    end
  end

  describe "merge_layout_declarations/4" do
    test "no flags: only flash + current_scope + inner_block declared" do
      mod = unique_layouts_module()
      src = stock_phoenix_layouts(mod)

      merged = LayoutBuilder.merge_layout_declarations(src, [], [], false)

      assert merged =~ "attr :flash"
      assert merged =~ "attr :current_scope"
      assert merged =~ "slot :inner_block"
      refute merged =~ "attr :path"
      refute merged =~ "attr :mode"
      refute merged =~ "attr :theme"
    end

    test "--lang adds attr :path declaration" do
      mod = unique_layouts_module()
      src = stock_phoenix_layouts(mod)

      merged = LayoutBuilder.merge_layout_declarations(src, [], [], true)

      assert merged =~ "attr :path"
      refute merged =~ "attr :mode"
      refute merged =~ "attr :theme"
    end

    test "--mode adds attr :mode declaration" do
      mod = unique_layouts_module()
      src = stock_phoenix_layouts(mod)

      merged = LayoutBuilder.merge_layout_declarations(src, [], [mode: true], false)

      assert merged =~ "attr :mode"
      refute merged =~ "attr :path"
      refute merged =~ "attr :theme"
    end

    test "--theme adds attr :theme declaration" do
      mod = unique_layouts_module()
      src = stock_phoenix_layouts(mod)

      merged = LayoutBuilder.merge_layout_declarations(src, ["neo"], [], false)

      assert merged =~ "attr :theme"
      refute merged =~ "attr :path"
      refute merged =~ "attr :mode"
    end

    test "is idempotent when applied twice" do
      mod = unique_layouts_module()
      src = stock_phoenix_layouts(mod)

      once = LayoutBuilder.merge_layout_declarations(src, ["neo"], [mode: true], true)
      twice = LayoutBuilder.merge_layout_declarations(once, ["neo"], [mode: true], true)

      assert once == twice
    end

    test "result still parses as valid Elixir" do
      mod = unique_layouts_module()
      src = stock_phoenix_layouts(mod)

      merged = LayoutBuilder.merge_layout_declarations(src, ["neo"], [mode: true], true)

      assert {:ok, _} = Code.string_to_quoted(merged)
    end
  end
end
