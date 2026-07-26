defmodule Corex.Design.Filter do
  @moduledoc false

  alias Corex.Design.Components

  @default_semantics ~w(base accent brand alert info success)a

  @palette_roles ~w(accent brand alert info success)

  @semantic_atoms Map.new(@default_semantics, &{Atom.to_string(&1), &1})

  def default_semantics, do: @default_semantics

  def default_semantic_strings, do: Enum.map(@default_semantics, &Atom.to_string/1)

  @doc """
  Maps a semantic role name to its atom through an allowlist.

  Role names reach this from `config :corex_design, semantics:`, so the lookup is
  a fixed map rather than `String.to_atom/1`: an unknown role is a config typo,
  not a new role to intern.
  """
  def semantic_atom(role) when is_atom(role), do: role

  def semantic_atom(role) when is_binary(role) do
    case Map.fetch(@semantic_atoms, role) do
      {:ok, atom} -> atom
      :error -> raise ArgumentError, semantic_atom_error(role)
    end
  end

  defp semantic_atom_error(role) do
    "unknown semantic role #{inspect(role)}, expected one of #{inspect(default_semantic_strings())}"
  end

  def components do
    Corex.Design.design_config()
    |> Map.get(:components)
    |> normalize_component_list()
  end

  @doc """
  The configured semantic roles as strings.

  Strings, not atoms, because every consumer matches them against the role names
  parsed out of CSS. `default_semantics/0` is the atom-typed counterpart, used
  where roles index a scale.
  """
  def semantic_strings do
    Corex.Design.design_config()
    |> resolved_semantics()
    |> Enum.uniq()
  end

  def all_components?, do: is_nil(components())
  def all_semantics?, do: semantic_strings() == default_semantic_strings()

  @doc """
  Validates configured component ids, returning the message a caller reports.
  """
  @spec validate_component_ids([term()]) :: :ok | {:error, String.t()}
  def validate_component_ids(ids) when is_list(ids) do
    case unknown_entries(ids, Components.ids()) do
      [] ->
        :ok

      invalid ->
        {:error,
         "config :corex_design, components: unknown ids #{inspect(invalid)}; allowed: #{inspect(Components.ids())}"}
    end
  end

  @spec validate_component_ids!([term()]) :: :ok
  def validate_component_ids!(ids) when is_list(ids) do
    raise_on_error(validate_component_ids(ids))
  end

  @doc """
  Validates configured semantic roles, returning the message a caller reports.
  """
  @spec validate_semantics([term()]) :: :ok | {:error, String.t()}
  def validate_semantics(roles) when is_list(roles) do
    allowed = default_semantic_strings()

    case unknown_entries(roles, allowed) do
      [] ->
        :ok

      invalid ->
        {:error,
         "config :corex_design, semantics: unknown roles #{inspect(invalid)}; allowed: #{inspect(allowed)}"}
    end
  end

  @spec validate_semantics!([term()]) :: :ok
  def validate_semantics!(roles) when is_list(roles) do
    raise_on_error(validate_semantics(roles))
  end

  @doc """
  Removes the `@utility ui-<role>` blocks for roles the config does not emit.

  Returns `css` unchanged when every default role is configured, so a project
  that has not narrowed `semantics:` gets the file as authored.
  """
  @spec apply_utilities_semantics(String.t(), [atom() | String.t()]) :: String.t()
  def apply_utilities_semantics(css, roles) do
    if semantics_filtered?(roles) do
      allowed =
        roles
        |> Enum.map(&to_string/1)
        |> MapSet.new()

      @palette_roles
      |> Enum.reject(&MapSet.member?(allowed, &1))
      |> Enum.reduce(css, fn role, acc ->
        remove_matching_utility_blocks(acc, ~r/^ui-#{role}$/)
      end)
    else
      css
    end
  end

  defp unknown_entries(entries, allowed) do
    allowed = MapSet.new(allowed)

    entries
    |> Enum.map(&to_string/1)
    |> Enum.reject(&MapSet.member?(allowed, &1))
  end

  defp raise_on_error(:ok), do: :ok
  defp raise_on_error({:error, message}), do: raise(ArgumentError, message)

  defp semantics_filtered?(roles) do
    Enum.sort(roles) != Enum.sort(default_semantic_strings())
  end

  defp remove_matching_utility_blocks(css, name_pattern) do
    Regex.scan(~r/@utility\s+([\w-]+)\s*\{/s, css)
    |> Enum.reduce(css, fn [full, name], acc ->
      if Regex.match?(name_pattern, name) do
        case extract_block(acc, full) do
          nil -> acc
          %{full: block_full} -> String.replace(acc, block_full, "", global: false)
        end
      else
        acc
      end
    end)
  end

  defp extract_block(css, header) do
    case :binary.match(css, header) do
      {start, _} ->
        rest =
          binary_part(css, start + byte_size(header), byte_size(css) - start - byte_size(header))

        {body, _} = take_brace_body(rest, 1)

        %{
          full: header <> body <> "}",
          body: body
        }

      :nomatch ->
        nil
    end
  end

  defp take_brace_body(content, depth) do
    do_take_brace_body(content, depth, "")
  end

  defp do_take_brace_body(<<>>, _depth, acc), do: {acc, 0}

  defp do_take_brace_body(<<char, rest::binary>>, depth, acc) do
    case char do
      ?{ ->
        do_take_brace_body(rest, depth + 1, acc <> <<char>>)

      ?} ->
        if depth == 1 do
          {acc, byte_size(rest)}
        else
          do_take_brace_body(rest, depth - 1, acc <> <<char>>)
        end

      _ ->
        do_take_brace_body(rest, depth, acc <> <<char>>)
    end
  end

  defp normalize_component_list(nil), do: nil

  defp normalize_component_list(list) when is_list(list) do
    list
    |> Enum.map(&to_string/1)
    |> Enum.uniq()
  end

  defp resolved_semantics(config) when is_map(config) do
    resolve_semantic_roles(Map.get(config, :semantics) || scales_semantic(config))
  end

  defp resolve_semantic_roles(roles) when is_list(roles),
    do: roles |> normalize_semantic_list() |> ensure_base()

  defp resolve_semantic_roles(_roles), do: default_semantic_strings()

  defp scales_semantic(config) do
    config
    |> Map.get(:scales, [])
    |> normalize_scales()
    |> Keyword.get(:semantic)
  end

  defp normalize_scales(list) when is_list(list), do: list
  defp normalize_scales(map) when is_map(map), do: Map.to_list(map)
  defp normalize_scales(_), do: []

  defp normalize_semantic_list(list) when is_list(list) do
    Enum.map(list, fn
      role when is_atom(role) -> Atom.to_string(role)
      role when is_binary(role) -> role
    end)
  end

  defp ensure_base(roles) do
    if "base" in roles, do: roles, else: ["base" | roles]
  end
end
