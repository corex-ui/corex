defmodule Mix.Corex.Install.StarterTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Starter

  defp unique_layouts_module do
    Module.concat(__MODULE__, :"Layouts#{System.unique_integer([:positive])}")
  end

  defp corex_declarations_without_mode do
    """
    attr :flash, :map, required: true, doc: "the map of flash messages"

    attr :current_scope, :map,
      default: nil,
      doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

    slot :inner_block, required: true
    """
    |> String.trim()
  end

  defp layouts_module_with_corex(mod, declaration_block) do
    """
    defmodule #{inspect(mod)} do
      use Phoenix.Component

    #{declaration_block}

      def corex(assigns) do
        ~H"<span></span>"
      end
    end
    """
  end

  test "build_corex_starter_page_template/3 base case" do
    out = Starter.build_corex_starter_page_template([], [], false)
    assert out =~ ~r/<Layouts\.corex/
    assert out =~ "flash={@flash}"
    assert out =~ "current_scope={assigns[:current_scope]}"
    refute out =~ "conn={@conn}"
    refute out =~ "path={assigns[:path]}"
    refute out =~ "mode="
    refute out =~ "theme="
  end

  test "build_corex_starter_page_template/3 with --lang" do
    out = Starter.build_corex_starter_page_template([], [], true)
    assert out =~ "conn={@conn}"
    assert out =~ "path={assigns[:path]}"
  end

  test "build_corex_starter_page_template/3 with mode and theme" do
    out = Starter.build_corex_starter_page_template([:neo], [mode: true], false)
    assert out =~ "mode={assigns[:mode] || \"light\"}"
    assert out =~ "theme={assigns[:theme] || \"neo\"}"
  end

  test "migrate_corex_action_to_render_only/2 rewrites put_layout+render to render only" do
    layout = MyAppWeb.Layouts

    before = """
    defmodule MyAppWeb.PageController do
      def corex(conn, _params) do
        conn
        |> put_layout({MyAppWeb.Layouts, :corex})
        |> render(:corex)
      end
    end
    """

    after_ = Starter.migrate_corex_action_to_render_only(before, layout)

    assert after_ =~ "def corex(conn, _params) do"
    assert after_ =~ "render(conn, :corex)"
    refute after_ =~ "put_layout"
  end

  test "migrate_corex_action_to_render_only/2 leaves already-normal actions unchanged" do
    layout = MyAppWeb.Layouts
    same = "def corex(conn, _params) do\n  render(conn, :corex)\nend\n"
    assert Starter.migrate_corex_action_to_render_only(same, layout) == same
  end

  test "merge_corex_layout_declarations does not insert attr :mode again when already present before def corex(assigns)" do
    mod = unique_layouts_module()

    decl =
      (corex_declarations_without_mode() <>
         """

           attr :mode, :string, default: "light", doc: "the current mode (dark or light)"
         """)
      |> String.trim()

    src = layouts_module_with_corex(mod, decl)
    out = Starter.merge_corex_layout_declarations(src, [mode: true], [], false)

    assert Regex.scan(~r/\battr\s+:\s*mode\b/m, out) |> length() == 1
  end

  test "merge_corex_layout_declarations does not duplicate attrs when adding --mode on rerun" do
    mod = unique_layouts_module()
    src = layouts_module_with_corex(mod, corex_declarations_without_mode())

    merged = Starter.merge_corex_layout_declarations(src, [mode: true], [], false)

    assert Regex.scan(~r/attr :flash/, merged) |> length() == 1
    assert Regex.scan(~r/attr :current_scope/, merged) |> length() == 1
    assert Regex.scan(~r/slot :inner_block/, merged) |> length() == 1
    assert merged =~ "attr :mode"
  end

  test "merge_corex_layout_declarations is idempotent when applied twice with the same opts" do
    mod = unique_layouts_module()
    src = layouts_module_with_corex(mod, corex_declarations_without_mode())
    once = Starter.merge_corex_layout_declarations(src, [mode: true], [], false)
    twice = Starter.merge_corex_layout_declarations(once, [mode: true], [], false)

    assert once == twice
  end

  test "rerun simulation: merged layouts compile under Phoenix.Component declarative" do
    Application.ensure_all_started(:phoenix_live_view)

    mod = unique_layouts_module()
    src = layouts_module_with_corex(mod, corex_declarations_without_mode())
    merged = Starter.merge_corex_layout_declarations(src, [mode: true], [], false)

    assert {:ok, _} = Code.string_to_quoted(merged)

    assert_raise CompileError, fn ->
      dup = """
      defmodule #{inspect(Module.concat(mod, :Dup))} do
        use Phoenix.Component
        attr :flash, :map, required: true
        attr :flash, :map, required: true
        def corex(assigns), do: ~H"<span></span>"
      end
      """

      Code.compile_string(dup)
    end

    assert [{_m, _bin}] = Code.compile_string(merged)
  end
end
