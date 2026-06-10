defmodule Corex.Design.Config do
  @moduledoc """
  Facade for `:corex_design` host config.

  Validates host config before compile via `validate!/0`. For key reference,
  see `options_docs/0`.
  """

  alias Corex.Design.Config.Options
  alias Corex.Design.Config.Resolved

  @doc """
  Validates `config :corex_design` and resolves themes. Raises on invalid config.
  """
  def validate!(config \\ Corex.Design.design_config()) do
    Options.validate!(config)
    _ = Corex.Design.Theme.resolved_themes()
    :ok
  end

  @doc """
  Normalizes flat config keys into a canonical option keyword list for internal readers.
  """
  def resolved_options(config \\ Corex.Design.design_config()) do
    Resolved.resolved_options(config)
  end

  @doc """
  Returns the configured CSS output path, or `nil`.
  """
  def output(config \\ Corex.Design.design_config()) do
    config |> Map.new() |> Map.get(:output)
  end

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: Options.options_docs()

  @doc """
  Returns a keyword list describing the customization map for docs and tooling.
  """
  def customization_map do
    [
      corex_design: [
        {:output, "Generated corex.tailwind.css path (relative to project root, required)"},
        {:default_theme, "Default data-theme id (default :neo)"},
        {:default_mode, "Default data-mode (default :light)"},
        {:themes, "Built-in preset subset list or full theme catalog map"},
        {:scales, "Optional subset of Corex.Scales steps per axis (smaller CSS bundles)"},
        {:recipes, "Recipe allowlist and host RecipeSource modules"},
        {:aliases, "Semantic role alias map for token resolution"}
      ]
    ]
  end

  @doc """
  Warns when theme dimension steps lack obvious scale coverage from configured scale overrides.
  Returns `:ok` or `{:warn, messages}`.
  """
  def warn_scale_theme_links do
    themes = Corex.Design.Theme.resolved_themes()
    radius_steps = Corex.Design.Axes.radius_atoms()

    warnings =
      for {theme_id, spec} <- themes,
          dims = Map.get(spec, :dimensions, %{}),
          radius = Map.get(dims, :radius, %{}),
          {step, _val} <- radius,
          step not in radius_steps do
        "theme #{theme_id} dimensions.radius.#{step} is not in configured radius scale steps"
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

  alias Corex.Design.Config.Resolved
  alias Corex.Design.Theme.Options, as: ThemeOptions

  @schema NimbleOptions.new!(
            output: [
              type: :string,
              doc: "Generated corex.tailwind.css path relative to the project root (required)"
            ],
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
            themes: [
              doc: "Preset id list (~w(neo leo)a) or theme id to spec map; omit for all presets"
            ],
            scales: [
              type: :keyword_list,
              doc: "Optional subset of Corex.Scales steps per axis (smaller CSS bundles)"
            ],
            recipes: [
              type: :keyword_list,
              keys: [
                include: [
                  type: {:list, :atom},
                  doc: "Allowlist of recipe ids to emit; nil emits all"
                ],
                sources: [
                  type: {:list, :atom},
                  default: [],
                  doc: "Host RecipeSource modules"
                ]
              ],
              doc: "Recipe allowlist and host overrides"
            ],
            aliases: [
              type: :map,
              doc: "Semantic role aliases (template name -> token role)"
            ]
          )

  @known_keys ~w(output default_theme default_mode themes scales recipes aliases)a

  @doc false
  def schema, do: @schema

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: NimbleOptions.docs(@schema)

  @doc """
  Validates `:corex_design` config keyword list.
  """
  def validate(config) when is_list(config) do
    flat = Resolved.resolved_options(config)
    grouped = Map.new(config) |> Map.take(@known_keys)

    with :ok <- validate_output(grouped),
         :ok <- validate_grouped(grouped),
         :ok <- validate_scales(Keyword.get(flat, :scales)),
         :ok <- validate_recipe_sources(Keyword.get(flat, :recipes, [])),
         :ok <- validate_themes(Keyword.get(flat, :themes)),
         :ok <- validate_default_theme(Keyword.get(flat, :default_theme), Keyword.get(flat, :themes)) do
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

  defp validate_output(grouped) do
    case Map.get(grouped, :output) do
      path when is_binary(path) and path != "" -> :ok
      _ -> {:error, "config :corex_design requires output: \"assets/css/corex.tailwind.css\""}
    end
  end

  defp validate_grouped(grouped) do
    case NimbleOptions.validate(grouped, @schema) do
      {:ok, _} -> :ok
      {:error, %NimbleOptions.ValidationError{} = err} -> {:error, Exception.message(err)}
    end
  end

  defp validate_themes(nil), do: {:ok, nil}

  defp validate_themes(themes) when is_map(themes) do
    ThemeOptions.validate(themes)
  end

  defp validate_themes(themes) when is_list(themes) do
    ids =
      if Keyword.keyword?(themes) do
        Keyword.keys(themes)
      else
        themes
      end

    preset_ids = ThemeOptions.preset_ids()

    if Enum.all?(ids, &(&1 in preset_ids)) do
      {:ok, themes}
    else
      invalid = Enum.reject(ids, &(&1 in preset_ids))

      {:error,
       "config :corex_design, themes: preset ids must be one of #{inspect(preset_ids)}, got invalid #{inspect(invalid)}"}
    end
  end

  defp validate_themes(other) do
    {:error, "config :corex_design, themes: must be a preset id list or a map, got: #{inspect(other)}"}
  end

  defp validate_default_theme(default_theme, nil) do
    if default_theme in ThemeOptions.preset_ids() do
      :ok
    else
      {:error,
       "config :corex_design, default_theme: #{inspect(default_theme)} not in built-in presets #{inspect(ThemeOptions.preset_ids())}"}
    end
  end

  defp validate_default_theme(default_theme, themes) when is_list(themes) do
    ids = if Keyword.keyword?(themes), do: Keyword.keys(themes), else: themes

    if default_theme in ids do
      :ok
    else
      {:error,
       "config :corex_design, default_theme: #{inspect(default_theme)} not in themes list #{inspect(ids)}"}
    end
  end

  defp validate_default_theme(default_theme, themes) when is_map(themes) do
    if Map.has_key?(themes, default_theme) do
      :ok
    else
      {:error,
       "config :corex_design, default_theme: #{inspect(default_theme)} not in theme catalog (got #{inspect(Map.keys(themes) |> Enum.sort())})"}
    end
  end

  defp validate_scales(nil), do: :ok

  defp validate_scales(scales) when is_list(scales) do
    scales
    |> normalize_scale_overrides()
    |> Enum.reduce_while(:ok, fn {axis, steps}, :ok ->
      case canonical_scale_steps(axis) do
        :error ->
          {:halt,
           {:error,
            "config :corex_design, scales: unknown axis #{inspect(axis)} (must be a Corex.Scales axis)"}}

        canonical ->
          invalid =
            steps
            |> Enum.map(&normalize_scale_step/1)
            |> Enum.reject(&(&1 in canonical))

          if invalid == [] do
            {:cont, :ok}
          else
            {:halt,
             {:error,
              "config :corex_design, scales: #{inspect(axis)} steps #{inspect(invalid)} must be a subset of Corex.Scales #{inspect(canonical)}"}}
          end
      end
    end)
  end

  defp validate_scales(other) do
    {:error, "config :corex_design, scales: must be a keyword list, got: #{inspect(other)}"}
  end

  defp normalize_scale_overrides(list) when is_list(list), do: list
  defp normalize_scale_overrides(map) when is_map(map), do: Map.to_list(map)

  defp normalize_scale_step(step) when is_atom(step), do: step
  defp normalize_scale_step(step) when is_binary(step), do: String.to_atom(step)

  defp canonical_scale_steps(axis) when is_atom(axis) do
    Corex.Scales.steps(axis)
  rescue
    ArgumentError -> :error
  end

  defp validate_recipe_sources(modules) when is_list(modules) do
    Enum.reduce_while(modules, :ok, fn module, :ok ->
      :code.ensure_loaded(module)

      if function_exported?(module, :recipes, 0) do
        {:cont, :ok}
      else
        {:halt,
         {:error,
          "config :corex_design, recipes: [sources: #{inspect(module)}] must implement Corex.Design.RecipeSource (recipes/0)"}}
      end
    end)
  end
end
