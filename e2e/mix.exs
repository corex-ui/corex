defmodule E2e.MixProject do
  use Mix.Project

  def project do
    [
      app: :corex_web,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {E2e.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.8.3"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.13"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:live_capture, "~> 0.2"},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.16"},
      {:req, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.2.0"},
      {:bandit, "~> 1.5"},
      {:corex, "~> 0.1.0-alpha.28"},
      {:makeup, "~> 1.2"},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1"},
      {:makeup_html, "~> 0.2"},
      {:makeup_css, "~> 0.2"},
      {:makeup_js, "~> 0.1.0"},
      {:wallaby, "~> 0.30", only: :test},
      {:a11y_audit, "~> 0.3.1", only: :test},
      {:flagpack, "~> 0.6.0"},
      {:ex_cldr, "~> 2.47"},
      {:ex_cldr_territories, "~> 2.10.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      compile: ["compile"],
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        &clean_static_assets/1,
        &copy_static_images/1,
        "assets.deploy",
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.digest.clean": ["phx.digest.clean", "--no-compile"],
      "assets.digest.clean.all": ["phx.digest.clean", "--all", "--no-compile"],
      "assets.build": [
        &clean_static_assets/1,
        &copy_static_images/1,
        "compile",
        "tailwind e2e --minify",
        "esbuild e2e"
      ],
      "assets.deploy": [
        &clean_static_assets/1,
        &copy_static_images/1,
        "compile",
        "tailwind e2e --minify",
        "esbuild e2e --minify",
        "phx.digest"
      ],
      precommit: ["compile --warnings-as-errors", "deps.unlock --unused", "format", "test"]
    ]
  end

  defp clean_static_assets(_) do
    static = Path.join([__DIR__, "priv", "static"])
    File.rm_rf(Path.join(static, "assets"))
    File.rm_rf(Path.join(static, "cache_manifest.json"))
    File.rm_rf(Path.join(static, "images"))
  end

  defp copy_static_images(_) do
    source = Path.join([__DIR__, "images"])
    destination = Path.join([__DIR__, "priv", "static", "images"])

    if File.exists?(source) and File.dir?(source) do
      File.mkdir_p!(Path.dirname(destination))
      File.cp_r!(source, destination, force: true)
    end
  end
end
