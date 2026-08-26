defmodule CorexAdmin.Attrs do
  @moduledoc false

  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Resource.Spec

  @doc """
  Copies only writable field values from params (string or atom keys).

  Nested `:embeds_many` maps keep only allowlisted child keys, plus `{name}_sort`
  and `{name}_drop` for Phoenix nested forms. Never introduces new atoms from
  user keys.
  """
  @spec take_writable(Spec.t(), map()) :: %{String.t() => term()}
  def take_writable(%Spec{fields: fields}, params) when is_map(params) do
    params = stringify_keys(params)

    fields
    |> Enum.filter(& &1.writable)
    |> Enum.reduce(%{}, fn field, acc -> take_field(acc, params, field) end)
    |> drop_blank_passwords(fields)
  end

  defp take_field(acc, params, %Field{type: :embeds_many, name: name, fields: children}) do
    key = Atom.to_string(name)
    sort_key = key <> "_sort"
    drop_key = key <> "_drop"

    acc
    |> maybe_put(key, sanitize_embed(Map.get(params, key), children))
    |> maybe_put(sort_key, Map.get(params, sort_key))
    |> maybe_put(drop_key, Map.get(params, drop_key))
  end

  defp take_field(acc, params, %Field{name: name}) do
    key = Atom.to_string(name)
    maybe_put(acc, key, Map.get(params, key))
  end

  defp maybe_put(acc, _key, nil), do: acc
  defp maybe_put(acc, key, value), do: Map.put(acc, key, value)

  defp sanitize_embed(nil, _children), do: nil

  defp sanitize_embed(rows, children) when is_list(rows) do
    Enum.map(rows, &take_child(&1, children))
  end

  defp sanitize_embed(rows, children) when is_map(rows) do
    Map.new(rows, fn {idx, row} -> {to_string(idx), take_child(row, children)} end)
  end

  defp sanitize_embed(_other, _children), do: nil

  defp take_child(row, children) when is_map(row) do
    allowed =
      MapSet.new(for %Field{writable: true} = field <- children, do: Atom.to_string(field.name))

    row
    |> stringify_keys()
    |> Map.take(MapSet.to_list(allowed))
  end

  defp take_child(_row, _children), do: %{}

  defp stringify_keys(params) when is_map(params) do
    Map.new(params, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} when is_binary(key) -> {key, value}
      {key, value} -> {to_string(key), value}
    end)
  end

  defp stringify_keys(_), do: %{}

  # Empty password on edit means "leave unchanged" — do not send "" to the context.
  defp drop_blank_passwords(attrs, fields) do
    password_names =
      for %Field{type: :password, writable: true} = field <- fields,
          do: Atom.to_string(field.name)

    Enum.reduce(password_names, attrs, fn name, acc ->
      case Map.get(acc, name) do
        value when value in [nil, ""] -> Map.delete(acc, name)
        _ -> acc
      end
    end)
  end
end
