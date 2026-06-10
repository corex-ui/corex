defmodule CorexDesign.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :corex_design,
      version: @version,
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      name: "Corex Design",
      description:
        "Optional token + recipe design pipeline for Corex. Generates the plain-CSS and Tailwind exports. Requires OTP 27+. Without it, Corex components render unstyled.",
      source_url: "https://github.com/corex-ui/corex"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:corex, path: ".."},
      {:jason, "~> 1.0"},
      {:color, "~> 0.11"},
      {:nimble_options, "~> 1.1"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "credo"
      ]
    ]
  end
end
