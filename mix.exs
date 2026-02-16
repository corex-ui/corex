defmodule Corex.MixProject do
  use Mix.Project

  @version "0.1.0-alpha.22"
  @elixir_requirement "~> 1.15"

  def project do
    [
      app: :corex,
      version: @version,
      elixir: @elixir_requirement,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      name: "Corex",
      description:
        "Accessible and unstyled UI components library written in Elixir and TypeScript that integrates Zag.js state machines into the Phoenix Framework.",
      package: package(),
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
      {:ecto, "~> 3.10"},
      {:esbuild, "~> 0.8", only: :dev},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false, warn_if_outdated: true},
      {:makeup, "~> 1.2", only: :dev},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1", only: :dev},
      {:makeup_eex, "~> 2.0", only: :dev},
      {:makeup_syntect, "~> 0.1.0", only: :dev},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "assets.build": [
        "esbuild module",
        "esbuild cdn",
        "esbuild cdn_min",
        "esbuild main",
        "esbuild hooks"
      ],
      "assets.watch": "esbuild module --watch"
    ]
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/corex-ui/corex",
        "Website" => "https://corex-ui.com"
      },
      files: ~w(
        lib priv mix.exs package.json README.md .formatter.exs
        )
    ]
  end

  defp docs do
    [
      main: "Corex",
      extras: [
        "guides/installation.md",
        "guides/dark_mode.md",
        "guides/locale.md",
        "guides/rtl.md",
        "guides/production.md"
      ],
      main: "installation",
      formatters: ["html", "epub"],
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
        Corex.AngleSlider,
        Corex.Avatar,
        Corex.Carousel,
        Corex.Checkbox,
        Corex.Clipboard,
        Corex.Combobox,
        Corex.Collapsible,
        Corex.DatePicker,
        Corex.Dialog,
        Corex.Editable,
        Corex.FloatingPanel,
        Corex.Listbox,
        Corex.Menu,
        Corex.NumberInput,
        Corex.PasswordInput,
        Corex.PinInput,
        Corex.RadioGroup,
        Corex.Select,
        Corex.SignaturePad,
        Corex.Switch,
        Corex.Tabs,
        Corex.Timer,
        Corex.Toast,
        Corex.ToggleGroup,
        Corex.TreeView
      ],
      Form: [
        Corex.Form
      ],
      Content: [
        Corex.Content,
        Corex.Content.Item
      ],
      List: [
        Corex.List,
        Corex.List.Item
      ],
      Tree: [
        Corex.Tree,
        Corex.Tree.Item
      ],
      Flash: [
        Corex.Flash.Info,
        Corex.Flash.Error
      ],
      Positioning: [
        Corex.Positioning
      ]
    ]
  end
end
