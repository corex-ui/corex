defmodule CorexDesign.MixProject do
  use Mix.Project

  @version "0.2.0"
  @scm_url "https://github.com/corex-ui/corex"

  def project do
    [
      app: :corex_design,
      version: @version,
      elixir: "~> 1.17",
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
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(:docs), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Optional config-driven token generation and static component CSS for Corex."
  end

  defp deps do
    [
      {:color, "~> 0.11"},
      {:nimble_options, "~> 1.1"},
      {:ex_doc, "~> 0.40", only: :docs, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:castore, "~> 1.0", only: :test},
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
      "bundle.build": ["compile", &build_bundle/1],
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

  @bundle_dir "dist"

  defp build_bundle(_) do
    priv_css = Path.join(__DIR__, "priv/css")
    output = Path.join(__DIR__, @bundle_dir)

    Mix.Task.run("app.start")
    Corex.Design.Config.validate!()
    Corex.Design.Tokens.Publish.write_theme_tokens!(priv_css)
    Mix.Task.run("corex.design.build", ["--output", output])
    :ok
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @scm_url,
        "Website" => "https://corex.gigalixirapp.com/en"
      },
      files: ~w(lib priv mix.exs README.md .formatter.exs guides)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @scm_url,
      source_ref: "v#{@version}",
      extras: ["README.md", "guides/modifiers.md"],
      filter_modules: &docs_filter_modules/2,
      groups_for_modules: [
        Design: [
          Corex.Design,
          Corex.Design.Config,
          Corex.Design.Config.Options,
          Corex.Design.ThemeDefinition,
          Mix.Tasks.Corex.Design.Build,
          Mix.Tasks.Corex.Design.Options,
          Mix.Tasks.Corex.Design.Validate,
          Mix.Tasks.Compile.CorexDesign
        ]
      ]
    ]
  end

  defp docs_filter_modules(mod, _metadata) do
    allowed =
      MapSet.new([
        Corex.Design,
        Corex.Design.Config,
        Corex.Design.Config.Options,
        Corex.Design.ThemeDefinition,
        Mix.Tasks.Corex.Design.Build,
        Mix.Tasks.Corex.Design.Options,
        Mix.Tasks.Corex.Design.Validate,
        Mix.Tasks.Compile.CorexDesign
      ])

    if MapSet.member?(allowed, mod) do
      true
    else
      raise "you forgot to add \"@moduledoc false\" or allowlist #{inspect(mod)} in design/mix.exs docs"
    end
  end
end
