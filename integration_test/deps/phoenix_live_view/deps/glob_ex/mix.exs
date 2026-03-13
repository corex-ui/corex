defmodule GlobEx.MixProject do
  use Mix.Project

  @github "https://github.com/hrzndhrn/glob_ex"
  @version "0.1.11"

  def project do
    [
      app: :glob_ex,
      version: @version,
      elixir: "~> 1.13",
      description: description(),
      source_url: @github,
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      docs: docs(),
      package: package(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def description do
    "A library for glob expressions."
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp preferred_cli_env do
    [
      carp: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.github": :test,
      "coveralls.html": :test
    ]
  end

  def docs do
    [
      main: "GlobEx",
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp package do
    [
      maintainers: ["Marcus Kruse"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github}
    ]
  end

  defp aliases do
    [
      carp: ["test --seed 0 --max-failures 1"]
    ]
  end

  defp deps do
    [
      # only dev/test
      {:benchee_dsl, "~> 0.3", only: :dev, runtime: false},
      {:benchee_markdown, "~> 0.1", only: :dev},
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:path_glob, "~> 0.2", only: :dev},
      {:prove, "~> 0.1.3", only: [:dev, :test]}
    ]
  end
end
