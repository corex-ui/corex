defmodule Corex.New.GenerateTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias Corex.New.{Generate, ScaffoldHelper}

  test "bundled_design_root points at installer priv when snapshot exists" do
    root = Generate.bundled_design_root()
    assert File.dir?(Path.join(root, "corex"))
    assert String.ends_with?(root, "priv/corex_design")
  end

  test "archive_priv_design_root resolves from compiled module beam path" do
    beam = :code.which(Corex.New.Generate)

    if is_binary(beam) or is_list(beam) do
      beam = if is_list(beam), do: List.to_string(beam), else: beam
      expected = beam |> Path.dirname() |> Path.join("../priv/corex_design") |> Path.expand()

      if File.dir?(Path.join(expected, "corex")) do
        assert Generate.bundled_design_root() == expected
      end
    end
  end

  test "run/2 writes layouts, assets, and copies bundled design" do
    Corex.New.MixHelper.in_tmp("generate bundled", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      capture_io(fn ->
        assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      end)

      assert File.exists?(Path.join("lib/my_app_web/components", "layouts.ex"))
      assert File.exists?(Path.join("assets/corex", "main.css"))

      assert File.read!(Path.join("assets/corex", "VERSION")) =~
               to_string(Mix.Project.config()[:version])

      assert File.read!(Path.join("assets/css", "app.css")) =~ "../corex/main.css"
    end)
  end

  test "run/2 with mode, theme, and lang writes plugs, locale, and hooks" do
    Corex.New.MixHelper.in_tmp("generate flags", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      opts = ScaffoldHelper.base_generate_opts(mode: true, theme: true, lang: true)

      assert :ok == Generate.run(File.cwd!(), opts)

      assert File.exists?(Path.join("lib/my_app_web/plugs", "mode.ex"))
      assert File.exists?(Path.join("lib/my_app_web/plugs", "theme.ex"))
      assert File.exists?(Path.join("lib/my_app_web", "locale.ex"))
      assert File.exists?(Path.join("lib/my_app_web/hooks", "layout.ex"))
      assert File.read!(Path.join("lib/my_app_web/components", "layouts.ex")) =~ "mode_toggle"

      web_ex = File.read!(Path.join("lib", "my_app_web.ex"))

      assert web_ex =~ "path_prefixes: [{MyAppWeb.Locale, :current, []}]"

      locale_ex = File.read!(Path.join("lib/my_app_web", "locale.ex"))
      assert locale_ex =~ "def current do"
    end)
  end

  test "run/2 with designex copies token tree under assets/corex/design" do
    Corex.New.MixHelper.in_tmp("generate designex", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(designex: true)
               )

      assert File.dir?(Path.join(["assets", "corex", "design", "tokens"]))
    end)
  end

  test "run/2 without design skips corex css imports and design tree" do
    Corex.New.MixHelper.in_tmp("generate no design", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(design: false)
               )

      refute File.exists?(Path.join("assets/corex", "main.css"))
      refute File.read!(Path.join("assets/css", "app.css")) =~ "../corex/main.css"
    end)
  end

  test "run/2 with --dev uses checkout design and relative corex.mjs import" do
    Corex.New.MixHelper.in_tmp("generate dev", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())
      corex_root = ScaffoldHelper.corex_repo_root()
      mjs = Path.join([corex_root, "priv/static/corex.mjs"])

      if File.exists?(mjs) do
        assert :ok ==
                 Generate.run(
                   File.cwd!(),
                   ScaffoldHelper.base_generate_opts(dev: corex_root)
                 )

        assert File.exists?(Path.join("assets/corex", "main.css"))
        assert File.read!(Path.join("assets/js", "app.js")) =~ "corex.mjs"
        refute File.read!(Path.join("assets/js", "app.js")) =~ ~s(import corex from "corex")
      else
        assert_raise Mix.Error, ~r/Expected Corex bundle/, fn ->
          Generate.run(
            File.cwd!(),
            ScaffoldHelper.base_generate_opts(dev: corex_root)
          )
        end
      end
    end)
  end

  test "run/2 raises when dev path lacks corex.mjs" do
    Corex.New.MixHelper.in_tmp("generate bad dev", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())
      empty = Path.join(File.cwd!(), "empty_corex")
      File.mkdir_p!(empty)

      assert_raise Mix.Error, ~r/Expected Corex bundle/, fn ->
        Generate.run(
          File.cwd!(),
          ScaffoldHelper.base_generate_opts(dev: empty)
        )
      end
    end)
  end

  test "run/2 copies design from a dev checkout when priv/design/corex exists" do
    corex_root = ScaffoldHelper.corex_repo_root()
    corex_src = Path.join([corex_root, "priv", "design", "corex"])
    mjs = Path.join([corex_root, "priv", "static", "corex.mjs"])

    if File.dir?(corex_src) and File.exists?(mjs) do
      Corex.New.MixHelper.in_tmp("generate dev checkout", fn ->
        ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

        assert :ok ==
                 Generate.run(
                   File.cwd!(),
                   ScaffoldHelper.base_generate_opts(dev: corex_root)
                 )

        assert File.exists?(Path.join("assets/corex", "main.css"))
        assert File.read!(Path.join("assets/js", "app.js")) =~ "corex.mjs"
      end)
    end
  end

  test "run/2 removes stale assets/corex/design before copying designex sources" do
    Corex.New.MixHelper.in_tmp("generate rm nested design", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      File.mkdir_p!("assets/corex/design/stale")
      File.write!("assets/corex/design/stale/keep.txt", "old\n")

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(designex: true)
               )

      refute File.exists?(Path.join(["assets", "corex", "design", "stale", "keep.txt"]))
      assert File.dir?(Path.join(["assets", "corex", "design", "tokens"]))
    end)
  end

  test "run/2 without dev option keeps npm corex import" do
    Corex.New.MixHelper.in_tmp("generate default import", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      assert File.read!(Path.join("assets/js", "app.js")) =~ ~s(from "corex")
    end)
  end

  test "run/2 with blank dev path keeps npm corex import" do
    Corex.New.MixHelper.in_tmp("generate blank dev", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(dev: "   ")
               )

      assert File.read!(Path.join("assets/js", "app.js")) =~ ~s(from "corex")
    end)
  end

  test "run/2 raises when bundled design snapshot is missing" do
    root = Generate.bundled_design_root()

    if File.dir?(root) do
      backup = root <> ".test_bak"

      try do
        File.rename!(root, backup)

        Corex.New.MixHelper.in_tmp("generate missing design", fn ->
          ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

          assert_raise Mix.Error, ~r/design snapshot is missing/, fn ->
            Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
          end
        end)
      after
        if File.exists?(backup) do
          File.rename!(backup, root)
        end
      end
    end
  end

  test "run/2 with mcp false skips endpoint MCP plug patch side effects" do
    Corex.New.MixHelper.in_tmp("generate no mcp", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(mcp: false)
               )

      refute File.read!(Path.join("lib/my_app_web", "endpoint.ex")) =~ "plug Corex.MCP"
    end)
  end

  test "run/2 honors custom themes list when theme is enabled" do
    Corex.New.MixHelper.in_tmp("generate custom themes", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(theme: true, themes: ["neo", "duo"])
               )

      css = File.read!(Path.join("assets/css", "app.css"))
      assert css =~ "theme/neo.css"
      assert css =~ "theme/duo.css"
      refute css =~ "theme/leo.css"
    end)
  end

  test "run/2 omits home page when stock home template is absent" do
    Corex.New.MixHelper.in_tmp("generate no home", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      home = Path.join("lib/my_app_web/controllers/page_html", "home.html.heex")

      File.rm!(home)

      assert :ok == Generate.run(File.cwd!(), ScaffoldHelper.base_generate_opts())
      refute File.exists?(home)
      assert File.exists?(Path.join("lib/my_app_web/components/layouts", "root.html.heex"))
    end)
  end

  test "normalize_opts uses default theme list when theme is enabled" do
    Corex.New.MixHelper.in_tmp("generate themes", fn ->
      ScaffoldHelper.write_phoenix_scaffold!(File.cwd!())

      assert :ok ==
               Generate.run(
                 File.cwd!(),
                 ScaffoldHelper.base_generate_opts(theme: true)
               )

      css = File.read!(Path.join("assets/css", "app.css"))
      assert css =~ "theme/neo.css"
      assert css =~ "theme/leo.css"
    end)
  end
end
