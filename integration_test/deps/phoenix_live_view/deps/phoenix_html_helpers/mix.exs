defmodule PhoenixHTMLHelpers.Mixfile do
  use Mix.Project

  @source_url "https://github.com/phoenixframework/phoenix_html_helpers"
  @version "1.0.1"

  def project do
    [
      app: :phoenix_html_helpers,
      version: @version,
      elixir: "~> 1.7",
      deps: deps(),
      name: "PhoenixHTMLHelpers",
      description: "Collection of helpers to generate and manipulate HTML contents",
      package: package(),
      docs: [
        source_url: @source_url,
        source_ref: "v#{@version}",
        main: "PhoenixHTMLHelpers"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      env: [csrf_token_reader: {Plug.CSRFProtection, :get_csrf_token_for, []}]
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 4.0"},
      {:plug, "~> 1.5", optional: true},
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["Chris McCord", "José Valim"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url}
    ]
  end
end
