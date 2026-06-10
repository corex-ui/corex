defmodule Corex.Design.Config do
  @moduledoc """
  Facade for `:corex_design` and related customization config.

  Validates host config before compile via `validate!/0`. For the full key
  reference (types, defaults, descriptions), see `options_docs/0`.
  """

  alias Corex.Design.Config.Options
  alias Corex.Scales

  @doc """
  Validates `config :corex_design` and resolves themes. Raises on invalid config.
  """
  def validate!(config \\ Corex.Design.design_config()) do
    Options.validate!(config)
    _ = Corex.Design.Theme.resolved_themes()
    :ok
  end

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: Options.options_docs()

  @doc """
  Returns a keyword list describing the split customization map for docs and tooling.
  """
  def customization_map do
    [
      corex: [
        {:scales, "Axis step names accepted by components"},
        {:semantics, "Semantic role names for `semantic=` attrs"},
        {:recipe_looks, "Reusable looks for action/navigate (`as=` attr)"}
      ],
      corex_design: [
        {:themes, "Colors and dimensions for token generation"},
        {:default_theme, "Default data-theme"},
        {:default_mode, "Default data-mode"},
        {:recipes, "Host RecipeSource overrides"},
        {:role_aliases, "Semantic role alias map for token resolution"},
        {:include_recipes, "Recipe id allowlist for smaller CSS bundles"}
      ]
    ]
  end

  @doc """
  Warns when `:corex` scale steps lack obvious theme dimension coverage.
  Returns `:ok` or `{:warn, messages}`.
  """
  def warn_scale_theme_links do
    themes = Corex.Design.Theme.resolved_themes()

    warnings =
      for {theme_id, spec} <- themes,
          dims = Map.get(spec, :dimensions, %{}),
          radius = Map.get(dims, :radius, %{}),
          {step, _val} <- radius,
          step not in Scales.radius_atoms() do
        "theme #{theme_id} dimensions.radius.#{step} is not in Corex.Scales radius steps"
      end

    case warnings do
      [] -> :ok
      msgs -> {:warn, msgs}
    end
  end
end
defmodule Corex.Design.Config.Options do
  @moduledoc """
  NimbleOptions schema for top-level `config :corex_design` keys.
  """

  alias Corex.Design.Accessibility.Level
  alias Corex.Design.Theme.Options, as: ThemeOptions

  @schema NimbleOptions.new!(
    default_theme: [
      type: :atom,
      default: :neo,
      doc: "Default data-theme id"
    ],
    default_mode: [
      type: {:in, [:light, :dark]},
      default: :light,
      doc: "Default data-mode"
    ],
    accessibility_level: [
      type: {:in, ~w(a aa aaa)a},
      default: :aa,
      doc: "Default text contrast floor"
    ],
    themes: [
      type: :map,
      doc: "Theme id → spec map"
    ],
    include_recipes: [
      type: {:list, :atom},
      doc: "Allowlist of recipe ids to emit"
    ],
    recipes: [
      type: {:list, :atom},
      default: [],
      doc: "Host RecipeSource modules"
    ],
    role_aliases: [
      type: :map,
      doc: "Semantic role aliases (template name -> token role)"
    ]
  )

  @known_keys ~w(default_theme default_mode accessibility_level themes include_recipes recipes role_aliases)a

  @doc false
  def schema, do: @schema

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: NimbleOptions.docs(@schema)

  @doc """
  Validates resolved `:corex_design` config keyword list.
  Profile keys (atoms like `:my_app`) are ignored.
  """
  def validate(config) when is_list(config) do
    config_map = Map.new(config)
    known = Map.take(config_map, @known_keys)

    with {:ok, parsed} <- NimbleOptions.validate(known, @schema),
         :ok <- validate_recipe_sources(parsed.recipes),
         {:ok, _themes} <- validate_themes(known, parsed),
         :ok <- validate_default_theme(parsed.default_theme, Map.get(known, :themes)) do
      {:ok, config}
    end
  end

  @doc false
  def validate!(config) when is_list(config) do
    case validate(config) do
      {:ok, _} -> :ok
      {:error, message} -> raise ArgumentError, message
    end
  end

  defp validate_themes(known, parsed) do
    case Map.get(known, :themes) || Map.get(parsed, :themes) do
      nil ->
        {:ok, nil}

      themes when is_map(themes) ->
        case ThemeOptions.validate(themes) do
          {:ok, normalized} -> {:ok, normalized}
          {:error, message} -> {:error, message}
        end

      other ->
        {:error, "themes must be a map, got: #{inspect(other)}"}
    end
  end

  defp validate_default_theme(default_theme, nil) do
    if default_theme in ThemeOptions.preset_ids() do
      :ok
    else
      {:error,
       "default_theme #{inspect(default_theme)} not in built-in presets #{inspect(ThemeOptions.preset_ids())}"}
    end
  end

  defp validate_default_theme(default_theme, themes) when is_map(themes) do
    if Map.has_key?(themes, default_theme) do
      :ok
    else
      {:error,
       "default_theme #{inspect(default_theme)} not in themes (got #{inspect(Map.keys(themes) |> Enum.sort())})"}
    end
  end

  defp validate_recipe_sources(modules) when is_list(modules) do
    Enum.reduce_while(modules, :ok, fn module, :ok ->
      :code.ensure_loaded(module)

      if function_exported?(module, :recipes, 0) do
        {:cont, :ok}
      else
        {:halt,
         {:error,
          "config :corex_design, recipes: #{inspect(module)} must implement Corex.Design.RecipeSource (recipes/0)"}}
      end
    end)
  end

  @doc false
  def normalize_accessibility_level(level) do
    Level.normalize(level)
  end
end
