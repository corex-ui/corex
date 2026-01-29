defmodule Corex.MixProject do
  use Mix.Project

  def project do
    [
      app: :corex,
      version: "0.1.0-alpha.1",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      name: "Corex",
      source_url: "https://github.com/corex-ui/corex",
      homepage_url: "https://corex-ui.com",
      docs: &docs/0
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:gettext, "~> 1.0"},
      {:esbuild, "~> 0.8", only: :dev},
      {:ex_doc, "~> 0.34", only: :docs},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1", only: :docs},
      {:makeup_eex, "~> 2.0", only: :docs}
    ]
  end

  defp aliases do
    [
      "assets.build": ["esbuild module", "esbuild cdn", "esbuild cdn_min", "esbuild main"],
      "assets.watch": "esbuild module --watch"
    ]
  end

  defp docs do
    [
      main: "Corex",
      extras: ["README.md", "guides/installation.md"],
      groups_for_modules: groups_for_modules(),
      groups_for_docs: [
        Components: &(&1[:type] == :component),
        API: &(&1[:type] == :api),
        Helpers: &(&1[:type] == :helpers)
      ]
    ]
  end

  defp groups_for_modules do
    [
      Components: [
        Corex.Accordion,
        Corex.Switch,
        Corex.Toast
      ]
    ]
  end
end
