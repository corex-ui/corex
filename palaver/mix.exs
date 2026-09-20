defmodule Palaver.MixProject do
  use Mix.Project

  @version "0.1.0"
  @scm_url "https://github.com/corex-ui/corex"

  def project do
    [
      app: :palaver,
      version: @version,
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      name: "Palaver",
      description: description(),
      package: package(),
      source_url: @scm_url
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Palaver.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "A conversation runtime for the BEAM: a talk that outlives its thinker, its tools, and its clients."
  end

  # Deliberately empty. Registry, DynamicSupervisor, and distribution ship with
  # the runtime, which is the entire argument this library exists to make.
  defp deps, do: []

  defp aliases do
    [
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test"
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url},
      files: ~w(lib mix.exs README.md .formatter.exs)
    ]
  end
end
