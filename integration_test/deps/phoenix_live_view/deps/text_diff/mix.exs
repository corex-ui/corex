defmodule TextDiff.MixProject do
  use Mix.Project

  @description "TextDiff returns a formatted diff between two strings."
  @github "https://github.com/hrzndhrn/text_diff"

  def project do
    [
      app: :text_diff,
      name: "TextDiff",
      version: "0.1.0",
      elixir: "~> 1.13",
      description: @description,
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
      main: "TextDiff"
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
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false}
    ]
  end
end
