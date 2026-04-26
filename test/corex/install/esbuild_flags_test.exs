defmodule Corex.Install.EsbuildFlagsTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.EsbuildFlags

  @phoenix_like """
  import Config

  config :esbuild,
    version: "0.25.4",
    my_app: [
      args:
        ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js),
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
    ]
  """

  test "inserts only --format=esm and --splitting after first --bundle" do
    out = EsbuildFlags.insert_into_config(@phoenix_like)

    assert out =~ "--bundle --format=esm --splitting"
    assert out =~ "version: \"0.25.4\""
    assert out =~ "NODE_PATH"
    assert out =~ "--target=es2022"
    assert length(String.split(out, "--format=esm")) == 2
  end

  test "no-op when --format=esm already present" do
    already =
      String.replace(@phoenix_like, "--bundle", "--bundle --format=esm --splitting",
        global: false
      )

    assert EsbuildFlags.insert_into_config(already) == already
  end

  test "no-op when no esbuild config" do
    assert EsbuildFlags.insert_into_config("import Config\n") == "import Config\n"
  end
end
