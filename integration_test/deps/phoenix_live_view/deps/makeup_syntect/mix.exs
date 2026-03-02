defmodule MakeupSyntect.MixProject do
  use Mix.Project

  @version "0.1.4"

  def project do
    [
      app: :makeup_syntect,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: Path.wildcard("examples/*.md") ++ ["README.md", "CHANGELOG.md"],
        source_url: "https://github.com/elixir-makeup/makeup_syntect"
      ],
      package: package(),
      description: description(),
      source_url: "https://github.com/elixir-makeup/makeup_syntect"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MakeupSyntect.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler_precompiled, "~> 0.8.2"},
      {:rustler, "~> 0.37.1", runtime: false, optional: true},
      {:makeup, "~> 1.2"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Language lexers for Makeup using the syntect Rust library"
  end

  defp package() do
    [
      files: [
        "lib",
        "priv/extra_syntaxes",
        "README.md",
        "CHANGELOG.md",
        "LICENSE",
        "native/makeup_syntect/src",
        "native/makeup_syntect/*.toml",
        "checksum-*.exs",
        "mix.exs"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/elixir-makeup/makeup_syntect"}
    ]
  end
end
