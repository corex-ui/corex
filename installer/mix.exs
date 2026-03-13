for path <- :code.get_path(),
    Regex.match?(~r/corex_new-[\w\.\-]+\/ebin$/, List.to_string(path)) do
  Code.delete_path(path)
end

defmodule Corex.New.MixProject do
  use Mix.Project

  @version "0.1.0-alpha.32"
  @phoenix_version "1.8.4"
  @scm_url "https://github.com/corex-ui/corex"

  @elixir_requirement "~> 1.15"

  def project do
    [
      app: :corex_new,
      test_coverage: [summary: [threshold: 84]],
      start_permanent: Mix.env() == :prod,
      version: @version,
      phoenix_version: @phoenix_version,
      elixir: @elixir_requirement,
      deps: deps(),
      aliases: aliases(),
      package: [
        maintainers: ["Karim Semmoud"],
        licenses: ["MIT"],
        links: %{"GitHub" => @scm_url},
        files: ~w(lib templates mix.exs README.md)
      ],
      source_url: @scm_url,
      docs: docs(),
      homepage_url: "https://corex.gigalixirapp.com/en",
      description: """
      Corex project generator.

      Provides a `mix corex.new` task to bootstrap a new Elixir application
      with Phoenix and Corex dependencies.
      """
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs]]
  end

  def application do
    [
      extra_applications: [:eex, :crypto, :public_key]
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.24", only: :docs}
    ]
  end

  defp docs do
    [
      source_url_pattern: "#{@scm_url}/blob/v#{@version}/installer/%{path}#L%{line}"
    ]
  end

  defp copy_agents_md(_) do
    usage_rules = Path.expand("../usage-rules", __DIR__)
    dest = Path.expand("./templates/phoenix-usage-rules", __DIR__)

    if File.exists?(usage_rules) do
      File.cp_r!(usage_rules, dest)
    end
  end

  defp aliases do
    [
      "hex.publish": [
        &copy_agents_md/1,
        "hex.publish"
      ]
    ]
  end

end
