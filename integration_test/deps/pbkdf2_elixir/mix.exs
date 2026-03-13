defmodule Pbkdf2Elixir.Mixfile do
  use Mix.Project

  @source_url "https://github.com/riverrun/pbkdf2_elixir"
  @version "2.3.1"

  def project do
    [
      app: :pbkdf2_elixir,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:comeonin, "~> 5.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.3", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description: "Pbkdf2 password hashing algorithm for Elixir.",
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", "CHANGELOG.md"],
      maintainers: ["David Whitlock"],
      licenses: ["BSD-3-Clause"],
      links: %{
        "Changelog" => "https://hexdocs.pm/pbkdf2_elixir/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        {:"LICENSE.md", [title: "License"]},
        "README.md"
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end
end
