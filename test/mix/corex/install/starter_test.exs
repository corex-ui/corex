defmodule Mix.Corex.Install.StarterTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Starter

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
end
