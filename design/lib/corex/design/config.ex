defmodule Corex.Design.Config do
  @moduledoc """
  Facade for `config :corex_design` host config.

  Validates host config before compile via `validate!/0`. For key reference,
  see `options_docs/0`.
  """

  alias Corex.Design.Config.Options
  alias Corex.Design.Config.Resolved

  @default_output "assets/corex"

  @doc "Default generated CSS entry path relative to the project root."
  def default_output, do: @default_output

  @doc """
  Validates `config :corex_design` and resolves themes. Raises on invalid config.
  """
  def validate!(config \\ Corex.Design.design_config()) do
    config = normalize_config(config)

    case theme_module(config) do
      module when is_atom(module) and module != nil ->
        if Resolved.theme_module_ready?(module) do
          do_validate!(config)
        else
          :ok
        end

      _ ->
        do_validate!(config)
    end
  end

  defp do_validate!(config) do
    Options.validate!(config)
    _ = Corex.Design.Theme.resolved_themes()

    case warn_scale_theme_links() do
      :ok ->
        :ok

      {:warn, messages} ->
        raise ArgumentError, Enum.join(messages, "\n")
    end
  end

  defp normalize_config(config) when is_list(config), do: Map.new(config)
  defp normalize_config(config) when is_map(config), do: config

  defp theme_module(config) do
    case Map.get(config, :theme) do
      module when is_atom(module) and module != nil -> module
      _ -> nil
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
    config = Map.new(config)

    case Map.get(config, :theme) do
      module when is_atom(module) and module != nil ->
        module.output()

      _ ->
        Map.get(config, :output)
    end
  end

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: Options.options_docs()

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
         {:output, "Generated assets/corex directory (relative to project root)"},
         {:default_theme, "Default data-theme id (default :neo)"},
         {:default_mode, "Default data-mode (default :light)"},
         {:themes, "Built-in preset subset list or full theme catalog map"},
         {:theme, "Host Corex.Design.ThemeDefinition module (single-module setup)"},
         {:scales, "Per-axis [step: value] overrides for built-in step names; legacy semantic role list (prefer semantics:)"},
         {:components, "Component css ids to emit (nil = all shipped components)"},
         {:semantics, "Semantic palette roles to emit (nil = all; base is always included)"},
         {:variants, "Surface variant utilities to emit: solid, ghost, outline (nil = all; subtle is default anatomy)"}
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
end

defmodule Corex.Design.Config.Options do
  @moduledoc """
  NimbleOptions schema for `config :corex_design` keys.
  """

  alias Corex.Design.Config.Resolved
  alias Corex.Design.Scales, as: ConfiguredScales
  alias Corex.Design.Theme.Options, as: ThemeOptions

  @scale_axes ~w(space size text radius weight semantic)a

  @schema NimbleOptions.new!(
            output: [
              type: :string,
              doc: "Generated assets/corex directory relative to the project root"
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
              doc: "Per-axis [step: value] overrides for built-in step names; legacy semantic role list (prefer semantics:)"
            ],
            components: [
              doc: "Component css ids to emit (nil = all shipped components)"
            ],
            semantics: [
              doc: "Semantic palette roles to emit (nil = all; base is always included)"
            ],
            variants: [
              doc: "Surface variant utilities to emit: solid, ghost, outline (nil = all; subtle is default anatomy)"
            ],
            theme: [
              type: :atom,
              doc: "Host Corex.Design.ThemeDefinition module"
            ]
          )

  @known_keys ~w(output default_theme default_mode themes scales components semantics variants theme)a

  @doc false
  def schema, do: @schema

  @doc """
  Returns formatted NimbleOptions documentation for `config :corex_design` keys.
  """
  def options_docs, do: NimbleOptions.docs(@schema)

  @doc """
  Validates `config :corex_design` keyword list.
  """
  def validate(config) when is_map(config), do: validate(Map.to_list(config))

  def validate(config) when is_list(config) do
    flat = Resolved.resolved_options(config)
    grouped = Map.new(config) |> Map.take(@known_keys)

    with :ok <- validate_output(grouped),
         :ok <- validate_theme_module(Map.get(grouped, :theme)),
         :ok <- validate_grouped(grouped),
         :ok <- validate_scales(Keyword.get(flat, :scales)),
         :ok <- validate_filter_keys(grouped),
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

  defp validate_output(_grouped), do: :ok

  defp validate_theme_module(nil), do: :ok

  defp validate_theme_module(module) when is_atom(module) do
    :code.ensure_loaded(module)

    if function_exported?(module, :output, 0) and function_exported?(module, :scales, 0) do
      :ok
    else
      {:error, "config :corex_design, theme: #{inspect(module)} must use Corex.Design.ThemeDefinition"}
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
    {:error,
     "config :corex_design, themes: must be a preset id list or a map, got: #{inspect(other)}"}
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
          "config :corex_design, scales: unknown axis #{inspect(axis)} (allowed: #{inspect(@scale_axes)})"}}
      end
    end)
  end

  defp validate_scales(other) do
    {:error,
     "config :corex_design, scales: must be a keyword list or map, got: #{inspect(other)}"}
  end

  defp validate_filter_keys(grouped) do
    with :ok <- validate_components(Map.get(grouped, :components)),
         :ok <- validate_semantics(Map.get(grouped, :semantics)),
         :ok <- validate_variants(Map.get(grouped, :variants)) do
      :ok
    end
  end

  defp validate_components(nil), do: :ok

  defp validate_components(components) when is_list(components) do
    Corex.Design.Filter.validate_component_ids!(
      Enum.map(components, fn
        id when is_atom(id) -> Atom.to_string(id)
        id when is_binary(id) -> id
      end)
    )

    :ok
  end

  defp validate_components(other) do
    {:error, "config :corex_design, components: must be a list of component ids, got: #{inspect(other)}"}
  end

  defp validate_semantics(nil), do: :ok

  defp validate_semantics(semantics) when is_list(semantics) do
    Corex.Design.Filter.validate_semantics!(
      Enum.map(semantics, fn
        role when is_atom(role) -> Atom.to_string(role)
        role when is_binary(role) -> role
      end)
    )

    :ok
  end

  defp validate_semantics(other) do
    {:error, "config :corex_design, semantics: must be a list of role atoms, got: #{inspect(other)}"}
  end

  defp validate_variants(nil), do: :ok

  defp validate_variants(variants) when is_list(variants) do
    Corex.Design.Filter.validate_variants!(
      Enum.map(variants, fn
        name when is_atom(name) -> Atom.to_string(name)
        name when is_binary(name) -> name
      end)
    )

    :ok
  end

  defp validate_variants(other) do
    {:error, "config :corex_design, variants: must be a list of variant names, got: #{inspect(other)}"}
  end

  defp validate_axis_scale(:semantic, spec) when is_list(spec) do
    if Enum.all?(spec, &(is_atom(&1) or is_binary(&1))) do
      :ok
    else
      {:error,
       "config :corex_design, scales: semantic must be a list of role atoms, got: #{inspect(spec)}"}
    end
  end

  defp validate_axis_scale(axis, spec) when is_list(spec) do
    axis = normalize_config_scale_axis(axis)

    cond do
      keyword_with_values?(spec) ->
        cond do
          duplicate_scale_steps?(spec) ->
            {:error,
             "config :corex_design, scales: #{inspect(axis)} has duplicate step names"}

          true ->
            validate_value_map_steps(axis, spec)
        end

      Enum.all?(spec, &(is_atom(&1) or is_binary(&1))) ->
        {:error,
         "config :corex_design, scales: #{inspect(axis)} step lists are not supported; use [step: value] overrides for built-in step names"}

      true ->
        {:error,
         "config :corex_design, scales: #{inspect(axis)} must be a [step: value] keyword list"}
    end
  end

  defp validate_axis_scale(axis, other) do
    {:error,
     "config :corex_design, scales: #{inspect(axis)} must be a list, got: #{inspect(other)}"}
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
         "config :corex_design, scales: #{inspect(axis)} has unknown step names #{inspect(Enum.map(invalid, &elem(&1, 0)))}; allowed: #{inspect(MapSet.to_list(allowed))}"}
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

  defp normalize_config_scale_axis(:space), do: :density
  defp normalize_config_scale_axis(axis) when is_atom(axis), do: axis
  defp normalize_config_scale_axis("space"), do: :density
  defp normalize_config_scale_axis(axis) when is_binary(axis), do: String.to_atom(axis)

end
