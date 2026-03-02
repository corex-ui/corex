defmodule Rewrite.MixProject do
  use Mix.Project

  @version "1.2.0"
  @source_url "https://github.com/hrzndhrn/rewrite"

  def project do
    [
      aliases: aliases(),
      app: :rewrite,
      version: @version,
      deps: deps(),
      description: description(),
      dialyzer: dialyzer(),
      docs: docs(),
      elixir: "~> 1.14",
      package: package(),
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      test_ignore_filters: [~r'test/support/.*', ~r'test/fixtures/.*'],
      xref: [exclude: [FreedomFormatter.Formatter]]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Rewrite.Application, []}
    ]
  end

  def cli do
    [
      preferred_envs: [
        carp: :test,
        cover: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.github": :test
      ]
    ]
  end

  defp description do
    "An API for rewriting sources in an Elixir project. Powered by sourceror."
  end

  defp docs do
    [
      main: Rewrite,
      source_ref: "v#{@version}",
      formatters: ["html"],
      api_reference: false,
      groups_for_modules: [
        Hooks: [
          Rewrite.Hook,
          Rewrite.Hook.DotFormatterUpdater
        ]
      ]
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_add_apps: [:mix],
      plt_file: {:no_warn, "test/support/plts/dialyzer.plt"},
      flags: [:unmatched_returns]
    ]
  end

  defp aliases do
    [
      carp: "test --trace --seed 0 --max-failures 1",
      cover: "coveralls.html"
    ]
  end

  defp deps do
    [
      {:glob_ex, "~> 0.1"},
      {:sourceror, "~> 1.0"},
      {:text_diff, "~> 0.1"},
      # dev/test
      {:benchee_dsl, "~> 0.5", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Marcus Kruse"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
