defmodule Mix.Corex.Install.ConfigDesignexTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Config

  defp fixture_mix_exs do
    """
    defmodule MyApp.MixProject do
      use Mix.Project

      def project do
        [
          app: :my_app,
          version: "0.1.0",
          elixir: "~> 1.17",
          start_permanent: Mix.env() == :prod,
          aliases: aliases(),
          deps: deps()
        ]
      end

      def application do
        [extra_applications: [:logger]]
      end

      defp deps do
        [
          {:phoenix, "~> 1.8.0"},
          {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
          {:esbuild, "~> 0.10", runtime: Mix.env() == :dev}
        ]
      end

      defp aliases do
        [
          setup: ["deps.get"],
          "assets.build": ["compile", "tailwind my_app", "esbuild my_app"],
          "assets.deploy": [
            "tailwind my_app --minify",
            "esbuild my_app --minify",
            "phx.digest"
          ]
        ]
      end
    end
    """
  end

  defp project(opts \\ []) do
    Igniter.Test.test_project(
      app_name: :my_app,
      files: Map.merge(%{"mix.exs" => fixture_mix_exs()}, opts[:extra_files] || %{})
    )
  end

  defp final_mix_exs(igniter) do
    igniter.rewrite
    |> Rewrite.source!("mix.exs")
    |> Rewrite.Source.get(:content)
  end

  describe "maybe_add_designex_dep/2" do
    test "no-op when --designex is not set" do
      mix = project() |> Config.maybe_add_designex_dep([]) |> final_mix_exs()
      refute mix =~ ":designex"
    end

    test "adds dep with runtime: Mix.env() == :dev when --designex is set" do
      mix = project() |> Config.maybe_add_designex_dep(designex: true) |> final_mix_exs()

      assert mix =~ ~r/\{:designex,\s*"~> 1.0",\s*runtime:\s*Mix\.env\(\)\s*==\s*:dev\}/
    end
  end

  describe "maybe_add_designex_alias/2" do
    test "no-op when --designex is not set" do
      mix = project() |> Config.maybe_add_designex_alias([]) |> final_mix_exs()
      refute mix =~ "designex corex"
    end

    test ~s(inserts "designex corex" before "tailwind …" in assets.build and assets.deploy) do
      mix = project() |> Config.maybe_add_designex_alias(designex: true) |> final_mix_exs()

      assert mix =~ ~r/"assets\.build":\s*\[\s*"compile",\s*"designex corex",\s*"tailwind my_app"/

      assert mix =~
               ~r/"assets\.deploy":\s*\[\s*"designex corex",\s*"tailwind my_app --minify"/
    end

    test "is idempotent when run twice" do
      mix =
        project()
        |> Config.maybe_add_designex_alias(designex: true)
        |> Config.maybe_add_designex_alias(designex: true)
        |> final_mix_exs()

      assert Regex.scan(~r/"designex corex"/, mix) |> length() == 2
    end
  end
end
