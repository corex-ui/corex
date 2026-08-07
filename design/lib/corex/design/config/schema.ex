defmodule Corex.Design.Config.Schema do
  @moduledoc """
  NimbleOptions schema for `config :corex_design` keys.
  """

  alias Corex.Design.Config.Resolved
  alias Corex.Design.Scales, as: ConfiguredScales
  alias Corex.Design.Theme.Validator, as: ThemeValidator
  alias Corex.Design.Accessibility

  @schema NimbleOptions.new!(
            output: [
              type: :string,
              doc: "Generated assets/corex directory relative to the project root"
            ],
            default_theme: [
              type: :atom,
              default: :uno,
              doc: "Default data-theme id"
            ],
            default_mode: [
              type: {:in, [:light, :dark]},
              default: :light,
              doc: "Default data-mode"
            ],
            themes: [
              doc: "Preset id list (~w(uno leo)a) or theme id to spec map; omit for all presets"
            ],
            modes: [
              doc: "Color modes to emit; default [:light, :dark]. Use [:light] to drop dark packs"
            ],
            scales: [
              type: :keyword_list,
              doc: "Per-axis [step: value] overrides for built-in step names"
            ],
            components: [
              doc: "Component css ids to emit (nil = all shipped components)"
            ],
            semantics: [
              doc:
                "Semantic palette roles to emit (nil = all; structural root/surface/ui/ink always included)"
            ],
            accessibility: [
              doc:
                "false (default), true (all six axes), or axis list: :text :contrast :motion :cursor :focus :links"
            ]
          )

  @known_keys ~w(output default_theme default_mode themes modes scales components semantics accessibility)a

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
    flat = Resolved.new(config)
    grouped = Map.new(config) |> Map.take(@known_keys)

    with :ok <- validate_output(grouped),
         :ok <- validate_grouped(grouped),
         :ok <- validate_scales(flat.scales),
         :ok <- validate_filter_keys(grouped),
         :ok <- validate_modes(Map.get(grouped, :modes)),
         :ok <- validate_accessibility(Map.get(grouped, :accessibility)),
         :ok <- validate_themes(flat.themes),
         :ok <- validate_default_theme(flat.default_theme, flat.themes) do
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

  defp validate_grouped(grouped) do
    case NimbleOptions.validate(grouped, @schema) do
      {:ok, _} -> :ok
      {:error, %NimbleOptions.ValidationError{} = err} -> {:error, Exception.message(err)}
    end
  end

  defp validate_modes(nil), do: :ok

  defp validate_modes(modes) when is_list(modes) do
    allowed = [:light, :dark]

    invalid =
      Enum.reject(modes, fn
        mode when is_atom(mode) -> mode in allowed
        mode when is_binary(mode) -> mode in Enum.map(allowed, &Atom.to_string/1)
        _ -> false
      end)

    case invalid do
      [] ->
        :ok

      _ ->
        {:error,
         "config :corex_design, modes: must be a subset of [:light, :dark], got #{inspect(invalid)}"}
    end
  end

  defp validate_modes(other) do
    {:error, "config :corex_design, modes: must be a list, got: #{inspect(other)}"}
  end

  defp validate_accessibility(nil), do: :ok
  defp validate_accessibility(false), do: :ok
  defp validate_accessibility(true), do: :ok

  defp validate_accessibility(axes) when is_list(axes) do
    allowed = Accessibility.known_axes()
    allowed_strings = Enum.map(allowed, &Atom.to_string/1)

    invalid =
      Enum.reject(axes, fn
        axis when is_atom(axis) -> axis in allowed
        axis when is_binary(axis) -> axis in allowed_strings
        _ -> false
      end)

    case invalid do
      [] ->
        :ok

      _ ->
        {:error,
         "config :corex_design, accessibility: must be false, true, or a subset of #{inspect(allowed)}, got invalid #{inspect(invalid)}"}
    end
  end

  defp validate_accessibility(other) do
    {:error,
     "config :corex_design, accessibility: must be false, true, or an axis list, got: #{inspect(other)}"}
  end

  defp validate_themes(nil), do: :ok

  defp validate_themes(themes) when is_map(themes) do
    case ThemeValidator.validate(themes) do
      {:ok, _} -> :ok
      {:error, _} = err -> err
    end
  end

  defp validate_themes(themes) when is_list(themes) do
    themes |> theme_ids() |> validate_theme_ids()
  end

  defp validate_themes(other) do
    {:error,
     "config :corex_design, themes: must be a preset id list or a map, got: #{inspect(other)}"}
  end

  defp theme_ids(themes) do
    if Keyword.keyword?(themes), do: Keyword.keys(themes), else: themes
  end

  defp validate_theme_ids(ids) do
    preset_ids = ThemeValidator.preset_ids()

    case Enum.reject(ids, &(&1 in preset_ids)) do
      [] ->
        :ok

      invalid ->
        {:error,
         "config :corex_design, themes: preset ids must be one of #{inspect(preset_ids)}, got invalid #{inspect(invalid)}"}
    end
  end

  defp validate_default_theme(default_theme, nil) do
    if default_theme in ThemeValidator.preset_ids() do
      :ok
    else
      {:error,
       "config :corex_design, default_theme: #{inspect(default_theme)} not in built-in presets #{inspect(ThemeValidator.preset_ids())}"}
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

  defp validate_scales(scales) when is_list(scales) do
    allowed = ConfiguredScales.config_axes()

    scales
    |> Enum.reduce_while(:ok, fn {axis, spec}, :ok ->
      if axis in allowed do
        case validate_axis_scale(axis, spec) do
          :ok -> {:cont, :ok}
          {:error, message} -> {:halt, {:error, message}}
        end
      else
        {:halt, {:error, unknown_axis_message(axis)}}
      end
    end)
  end

  defp validate_filter_keys(grouped) do
    with :ok <- validate_components(Map.get(grouped, :components)),
         :ok <- validate_semantics(Map.get(grouped, :semantics)) do
      :ok
    end
  end

  defp validate_components(nil), do: :ok

  defp validate_components(components) when is_list(components) do
    Corex.Design.Filter.validate_component_ids(Enum.map(components, &config_entry_string/1))
  end

  defp validate_components(other) do
    {:error,
     "config :corex_design, components: must be a list of component ids, got: #{inspect(other)}"}
  end

  defp validate_semantics(nil), do: :ok

  defp validate_semantics(semantics) when is_list(semantics) do
    Corex.Design.Filter.validate_semantics(Enum.map(semantics, &config_entry_string/1))
  end

  defp validate_semantics(other) do
    {:error,
     "config :corex_design, semantics: must be a list of role atoms, got: #{inspect(other)}"}
  end

  defp config_entry_string(entry) when is_atom(entry), do: Atom.to_string(entry)
  defp config_entry_string(entry) when is_binary(entry), do: entry

  defp validate_axis_scale(:semantic, _spec) do
    {:error, "config :corex_design, scales: :semantic is removed; use semantics: [...]"}
  end

  defp validate_axis_scale(axis, spec) when is_list(spec) do
    case ConfiguredScales.config_axis(axis) do
      {:ok, resolved} -> validate_scale_shape(resolved, spec, scale_shape(spec))
      :error -> {:error, unknown_axis_message(axis)}
    end
  end

  defp validate_axis_scale(axis, other) do
    {:error,
     "config :corex_design, scales: #{inspect(axis)} must be a list, got: #{inspect(other)}"}
  end

  defp scale_shape(spec) do
    cond do
      keyword_with_values?(spec) -> :overrides
      Enum.all?(spec, &(is_atom(&1) or is_binary(&1))) -> :step_names
      true -> :unknown
    end
  end

  defp validate_scale_shape(axis, spec, :overrides) do
    if duplicate_scale_steps?(spec) do
      {:error, "config :corex_design, scales: #{inspect(axis)} has duplicate step names"}
    else
      validate_value_map_steps(axis, spec)
    end
  end

  defp validate_scale_shape(axis, _spec, :step_names) do
    {:error,
     "config :corex_design, scales: #{inspect(axis)} step lists are not supported; use [step: value] overrides for built-in step names"}
  end

  defp validate_scale_shape(axis, _spec, :unknown) do
    {:error,
     "config :corex_design, scales: #{inspect(axis)} must be a [step: value] keyword list"}
  end

  defp validate_value_map_steps(axis, spec) do
    allowed = ConfiguredScales.builtin_step_strings(axis) |> MapSet.new()

    invalid =
      Enum.reject(spec, fn {step, _} ->
        MapSet.member?(allowed, scale_step_string(step))
      end)

    case invalid do
      [] ->
        :ok

      _ ->
        {:error,
         "config :corex_design, scales: #{inspect(axis)} has unknown step names #{inspect(Enum.map(invalid, &elem(&1, 0)))}; allowed: #{inspect(MapSet.to_list(allowed))}"}
    end
  end

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
    steps = scale_steps(list)
    length(steps) != length(Enum.uniq(steps))
  end

  defp scale_steps(list) do
    if keyword_with_values?(list) do
      Enum.map(list, fn {step, _value} -> scale_step_string(step) end)
    else
      Enum.map(list, &scale_step_string/1)
    end
  end

  defp scale_step_string(step) when is_atom(step), do: Atom.to_string(step)
  defp scale_step_string(step) when is_binary(step), do: step

  defp unknown_axis_message(axis) do
    "config :corex_design, scales: unknown axis #{inspect(axis)}; allowed: #{inspect(ConfiguredScales.config_axes())}"
  end
end
