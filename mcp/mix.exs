defmodule CorexMcp.MixProject do
  use Mix.Project

  @version "0.2.0"
  @scm_url "https://github.com/corex-ui/corex"

  def project do
    [
      app: :corex_mcp,
      version: @version,
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      name: "Corex MCP",
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @scm_url,
      homepage_url: "https://corex.gigalixirapp.com/en",
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs, lint: :test]]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Dev-only Model Context Protocol (MCP) server for Corex: component and design discovery tools for AI agents."
  end

  defp deps do
    [
      {:plug, "~> 1.14"},
      {:corex, path: "..", only: :test},
      {:corex_design, path: "../design", only: :test, runtime: false},
      {:ex_doc, "~> 0.40", only: :docs, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.6.3", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false}
    ] ++ maybe_json_polyfill()
  end

  defp maybe_json_polyfill do
    if Code.ensure_loaded?(:json) do
      []
    else
      [{:json_polyfill, "~> 0.2 or ~> 1.0"}]
    end
  end

  defp aliases do
    [
      test: ["test"],
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "credo --strict",
        "sobelow --exit"
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @scm_url,
        "Website" => "https://corex.gigalixirapp.com/en"
      },
      files: ~w(lib mix.exs README.md LICENSE .formatter.exs guides)
    ]
  end

  defp docs do
    [
      main: "mcp",
      source_url: @scm_url,
      source_ref: "v#{@version}",
      extras: ["README.md", "guides/MCP.md"],
      filter_modules: fn
        Corex.MCP, _ -> true
        mod, _ ->
          raise "you forgot to add \"@moduledoc false\" to #{inspect(mod)}"
      end
    ]
  end
end
