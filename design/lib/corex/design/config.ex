defmodule Corex.Design.Config do
  @moduledoc """
  Facade for `config :corex, Corex.Design` host config.

  Validates host config before compile via `validate!/0`. For key reference,
  see `options_docs/0`.
  """

  alias Corex.Design.Config.Options
  alias Corex.Design.Config.Resolved
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Vocabulary

  @doc """
  Validates `config :corex, Corex.Design` and resolves themes. Raises on invalid config.
  """
  def validate!(config \\ Corex.Design.design_config()) do
    Options.validate!(config)
    _ = Corex.Design.Theme.resolved_themes()

    case warn_scale_theme_links() do
      :ok ->
        :ok

      {:warn, messages} ->
        raise ArgumentError, Enum.join(messages, "\n")
    end
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
  Returns formatted NimbleOptions documentation for `config :corex, Corex.Design` keys.
  """
  def options_docs, do: Options.options_docs()

  @doc """
  Exports resolved design config, vocabulary, themes, and colors for tooling.
  """
  def export do
    %{
      config: sanitize(Corex.Design.design_config()),
      resolved: sanitize(Map.new(resolved_options())),
      vocabulary: %{
        semantic_roles: Vocabulary.semantic_strings()
      },
      themes: theme_export(),
      colors: color_export()
    }
  end

  @doc """
  Returns a keyword list describing the customization map for docs and tooling.
  """
  def customization_map do
    Map.new([
      {:corex,
       [
         {:debug, "Enable Corex debug output"},
         {:generators, "mix corex.new generator options"},
         {:emit_style_classes,
          "Emit BEM modifiers from style attrs (default false; auto on when Corex.Design is configured)"}
       ]},
      {Corex.Design,
       [
         {:output, "Generated corex.tailwind.css path (relative to project root, required)"},
         {:default_theme, "Default data-theme id (default :neo)"},
         {:default_mode, "Default data-mode (default :light)"},
         {:themes, "Built-in preset subset list or full theme catalog map"},
         {:scales, "Per-axis [step: value] overrides for built-in step names; optional semantic role subset"},
         {:recipes, "Recipe allowlist and host RecipeSource modules"},
         {:aliases, "Semantic role alias map for token resolution"}
       ]}
    ])
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

  defp theme_export do
    Theme.resolved_themes()
    |> Map.new(fn {id, spec} ->
      {Atom.to_string(id), sanitize(spec)}
    end)
  end

  defp color_export do
    Colors.generate()
    |> Map.new(fn {{theme, mode}, tokens} ->
      {"#{theme}-#{mode}", tokens}
    end)
  end

  defp sanitize(term), do: Jason.decode!(Jason.encode!(term))
end

defmodule Corex.Design.Config.Options do
  @moduledoc """
  NimbleOptions schema for `config :corex, Corex.Design` keys.
  """

  alias Corex.Design.Config.Resolved
  alias Corex.Design.Scales, as: ConfiguredScales
  alias Corex.Design.Theme.Options, as: ThemeOptions

  @scale_axes ~w(space size text radius weight visual shape semantic)a

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
              doc: "Per-axis [step: value] overrides for built-in step names; semantic as optional role atom list"
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
  Returns formatted NimbleOptions documentation for `config :corex, Corex.Design` keys.
  """
  def options_docs, do: NimbleOptions.docs(@schema)

  @doc """
  Validates `config :corex, Corex.Design` keyword list.
  """
  def validate(config) when is_map(config), do: validate(Map.to_list(config))

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
  def validate!(config) when is_map(config), do: validate!(Map.to_list(config))

  def validate!(config) when is_list(config) do
    case validate(config) do
      {:ok, _} -> :ok
      {:error, message} -> raise ArgumentError, message
    end
  end

  defp validate_output(grouped) do
    case Map.get(grouped, :output) do
      path when is_binary(path) and path != "" -> :ok
      _ ->
        {:error, "config :corex, Corex.Design requires output: \"assets/css/corex.tailwind.css\""}
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
       "config :corex, Corex.Design, themes: preset ids must be one of #{inspect(preset_ids)}, got invalid #{inspect(invalid)}"}
    end
  end

  defp validate_themes(other) do
    {:error,
     "config :corex, Corex.Design, themes: must be a preset id list or a map, got: #{inspect(other)}"}
  end

  defp validate_default_theme(default_theme, nil) do
    if default_theme in ThemeOptions.preset_ids() do
      :ok
    else
      {:error,
       "config :corex, Corex.Design, default_theme: #{inspect(default_theme)} not in built-in presets #{inspect(ThemeOptions.preset_ids())}"}
    end
  end

  defp validate_default_theme(default_theme, themes) when is_list(themes) do
    ids = if Keyword.keyword?(themes), do: Keyword.keys(themes), else: themes

    if default_theme in ids do
      :ok
    else
      {:error,
       "config :corex, Corex.Design, default_theme: #{inspect(default_theme)} not in themes list #{inspect(ids)}"}
    end
  end

  defp validate_default_theme(default_theme, themes) when is_map(themes) do
    if Map.has_key?(themes, default_theme) do
      :ok
    else
      {:error,
       "config :corex, Corex.Design, default_theme: #{inspect(default_theme)} not in theme catalog (got #{inspect(Map.keys(themes) |> Enum.sort())})"}
    end
  end

  defp validate_scales(nil), do: :ok

  defp validate_scales(scales) when is_list(scales) or is_map(scales) do
    scales
    |> normalize_scale_overrides()
    |> Enum.reduce_while(:ok, fn {axis, spec}, :ok ->
      if axis in @scale_axes do
        case validate_axis_scale(axis, spec) do
          :ok -> {:cont, :ok}
          {:error, message} -> {:halt, {:error, message}}
        end
      else
        {:halt,
         {:error,
          "config :corex, Corex.Design, scales: unknown axis #{inspect(axis)} (allowed: #{inspect(@scale_axes)})"}}
      end
    end)
  end

  defp validate_scales(other) do
    {:error,
     "config :corex, Corex.Design, scales: must be a keyword list or map, got: #{inspect(other)}"}
  end

  defp validate_axis_scale(:semantic, spec) when is_list(spec) do
    if Enum.all?(spec, &(is_atom(&1) or is_binary(&1))) do
      :ok
    else
      {:error,
       "config :corex, Corex.Design, scales: semantic must be a list of role atoms, got: #{inspect(spec)}"}
    end
  end

  defp validate_axis_scale(axis, spec) when is_list(spec) do
    cond do
      keyword_with_values?(spec) ->
        cond do
          duplicate_scale_steps?(spec) ->
            {:error,
             "config :corex, Corex.Design, scales: #{inspect(axis)} has duplicate step names"}

          true ->
            validate_value_map_steps(axis, spec)
        end

      Enum.all?(spec, &(is_atom(&1) or is_binary(&1))) ->
        {:error,
         "config :corex, Corex.Design, scales: #{inspect(axis)} step lists are not supported; use [step: value] overrides for built-in step names"}

      true ->
        {:error,
         "config :corex, Corex.Design, scales: #{inspect(axis)} must be a [step: value] keyword list"}
    end
  end

  defp validate_axis_scale(axis, other) do
    {:error,
     "config :corex, Corex.Design, scales: #{inspect(axis)} must be a list, got: #{inspect(other)}"}
  end

  defp validate_value_map_steps(axis, spec) do
    allowed = ConfiguredScales.builtin_step_strings(axis) |> MapSet.new()

    invalid =
      Enum.reject(spec, fn {step, _} ->
        step
        |> normalize_scale_step()
        |> Atom.to_string()
        |> then(&MapSet.member?(allowed, &1))
      end)

    case invalid do
      [] ->
        :ok

      _ ->
        {:error,
         "config :corex, Corex.Design, scales: #{inspect(axis)} has unknown step names #{inspect(Enum.map(invalid, &elem(&1, 0)))}; allowed: #{inspect(MapSet.to_list(allowed))}"}
    end
  end

  defp normalize_scale_overrides(list) when is_list(list), do: list
  defp normalize_scale_overrides(map) when is_map(map), do: Map.to_list(map)

  defp keyword_with_values?(list) do
    Keyword.keyword?(list) and
      Enum.all?(list, fn
        {_step, value} when is_number(value) -> true
        {_step, :zero} -> true
        {_step, :full} -> true
        _ -> false
      end)
  end

  defp duplicate_scale_steps?(list) do
    steps =
      if keyword_with_values?(list) do
        Enum.map(list, fn {step, _} -> normalize_scale_step(step) end)
      else
        Enum.map(list, &normalize_scale_step/1)
      end

    length(steps) != length(Enum.uniq(steps))
  end

  defp normalize_scale_step(step) when is_atom(step), do: step
  defp normalize_scale_step(step) when is_binary(step), do: String.to_atom(step)

  defp validate_recipe_sources(modules) when is_list(modules) do
    Enum.reduce_while(modules, :ok, fn module, :ok ->
      :code.ensure_loaded(module)

      if function_exported?(module, :recipes, 0) do
        {:cont, :ok}
      else
        {:halt,
         {:error,
          "config :corex, Corex.Design, recipes: [sources: #{inspect(module)}] must implement Corex.Design.RecipeSource (recipes/0)"}}
      end
    end)
  end
end
