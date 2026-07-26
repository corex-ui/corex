defmodule Corex.Design.Config do
  @moduledoc """
  Advanced: read and validate `config :corex_design`.

  Most apps set keyword config in `config/config.exs` and run `mix corex.design.build`.
  Use this module when you need programmatic access or `validate!/0` before a custom build.
  Key reference: `options_docs/0`.
  """

  alias Corex.Design.Config.Schema
  alias Corex.Design.Config.Resolved

  @default_output "assets/corex"

  @doc "Default generated CSS entry path relative to the project root."
  def default_output, do: @default_output

  @doc """
  Validates `config :corex_design` and resolves themes. Raises on invalid config.
  """
  def validate!(config \\ Corex.Design.design_config()) do
    config = normalize_config(config)
    Schema.validate!(config)
    _ = Corex.Design.Theme.resolved_themes()

    case validate_scale_theme_links() do
      :ok ->
        :ok

      {:error, messages} ->
        raise ArgumentError, Enum.join(messages, "\n")
    end
  end

  defp normalize_config(config) when is_list(config), do: Map.new(config)
  defp normalize_config(config) when is_map(config), do: config

  @doc """
  Returns the `config :corex_design` entry as a `Corex.Design.Config.Resolved`.
  """
  @spec resolved(keyword() | map()) :: Resolved.t()
  def resolved(config \\ Corex.Design.design_config()), do: Resolved.new(config)

  @doc """
  Returns the configured CSS output path, or `nil`.
  """
  def output(config \\ Corex.Design.design_config()) do
    config
    |> Map.new()
    |> Map.get(:output)
  end

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: Schema.options_docs()

  @doc false
  def customization_map do
    Map.new([
      {:corex,
       [
         {:debug, "Enable Corex debug output"},
         {:generators, "mix corex.new generator options"}
       ]},
      {Corex.Design,
       [
         {:output, "Generated assets/corex directory (relative to project root)"},
         {:default_theme, "Default data-theme id (default :uno)"},
         {:default_mode, "Default data-mode (default :light)"},
         {:themes, "Built-in preset subset list or full theme catalog map"},
         {:modes, "Color modes to emit (default [:light, :dark]; [:light] drops dark packs)"},
         {:scales,
          "Per-axis [step: value] overrides for built-in step names; legacy semantic role list (prefer semantics:)"},
         {:components, "Component css ids to emit (nil = all shipped components)"},
         {:semantics, "Semantic palette roles to emit (nil = all; base is always included)"}
       ]}
    ])
  end

  @doc false
  def validate_scale_theme_links do
    themes = Corex.Design.Theme.resolved_themes()
    radius_steps = Corex.Design.Axes.radius_atoms()

    errors =
      for {theme_id, spec} <- themes,
          dims = Map.get(spec, :dimensions, %{}),
          radius = Map.get(dims, :radius, %{}),
          {step, _val} <- radius,
          step not in radius_steps do
        "theme #{theme_id} dimensions.radius.#{step} is not in configured radius scale steps"
      end

    case errors do
      [] -> :ok
      msgs -> {:error, msgs}
    end
  end
end
