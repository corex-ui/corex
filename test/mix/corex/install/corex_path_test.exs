defmodule Corex.Mix.Corex.Install.AssetsPathImportTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Assets

  test "path dep: import line points at priv/static/corex.mjs" do
    root = Path.join(System.tmp_dir!(), "corex_path_" <> id())
    app = Path.join(root, "my_app")
    src = Path.join(root, "corex_source")
    File.mkdir_p!(Path.join(app, "assets/js"))
    File.mkdir_p!(Path.join(src, "priv/static"))

    File.write!(Path.join(app, "mix.exs"), """
    defmodule MyApp.MixProject do
      def project, do: [app: :my_app, deps: [{:corex, path: "../corex_source"}]]
    end
    """)

    File.write!(Path.join(src, "mix.exs"), """
    defmodule Corex.MixProject do
      def project, do: [app: :corex, version: "0.0.1"]
    end
    """)

    File.write!(Path.join(src, "priv/static/corex.mjs"), "export{}")

    prev = File.cwd!()

    try do
      File.cd!(app, fn ->
        assert [import_line: line] = Assets.js_patch_opts()
        assert line =~ "corex.mjs"
        assert line =~ "corex_source"
        assert line =~ ~s(import corex from ")
      end)
    after
      File.cd!(prev)
      File.rm_rf!(root)
    end
  end

  defp id do
    8 |> :crypto.strong_rand_bytes() |> Base.encode16(case: :lower)
  end
end
