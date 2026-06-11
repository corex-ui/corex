defmodule CorexDesign.MixProject do
  use Mix.Project

  @version "0.2.0"
  @scm_url "https://github.com/corex-ui/corex"

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
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @scm_url,
      homepage_url: "https://corex.gigalixirapp.com/en"
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs, lint: :test]]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(:docs), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    """
    Token and recipe design pipeline for Corex. Compiles Tailwind CSS at build time from theme config and component recipes. Requires OTP 27+.
    """
  end

  defp deps do
    [
      corex_dep(),
      {:jason, "~> 1.0"},
      {:color, "~> 0.11"},
      {:nimble_options, "~> 1.1"},
      {:ex_doc, "~> 0.40", only: :docs, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.6.3", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false}
    ]
  end

  defp corex_dep do
    if System.get_env("COREX_DESIGN_PUBLISH") == "1" do
      {:corex, "~> 0.2.0"}
    else
      {:corex, path: ".."}
    end
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @scm_url,
        "Website" => "https://corex.gigalixirapp.com/en",
        "Corex" => "https://hexdocs.pm/corex"
      },
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE .formatter.exs)
    ]
  end

  defp docs do
    [
      main: "Corex.Design",
      source_url_pattern: "#{@scm_url}/blob/v#{@version}/design/%{path}#L%{line}",
      groups_for_modules: [
        Pipeline: [
          Corex.Design,
          Corex.Design.Compiler,
          Corex.Design.Config,
          Corex.Design.Recipe,
          Corex.Design.Emit,
          Corex.Design.Emit.TailwindCss,
          Corex.Design.Theme,
          Corex.Design.Tokens.Colors,
          Corex.Design.Tokens.Scales,
          Corex.Design.Fragment,
          Corex.Design.Bem
        ],
        Recipes: [
          Corex.Design.Recipes,
          Corex.Design.RecipePresets,
          Corex.Design.Palette,
          Corex.Design.Taxonomy
        ],
        "Mix tasks": [
          Mix.Tasks.Compile.CorexDesign,
          Mix.Tasks.Corex.Design.Build,
          Mix.Tasks.Corex.Design.Config,
          Mix.Tasks.Corex.Design.List,
          Mix.Tasks.Corex.Design.Validate
        ]
      ]
    ]
  end

  defp aliases do
    [
      docs: ["docs"],
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "credo --strict",
        "sobelow --exit"
      ],
      precommit: [
        "compile --warnings-as-errors",
        "format",
        "lint",
        "test"
      ]
    ]
  end
end
