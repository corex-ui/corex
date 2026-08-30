defmodule CorexAdmin.Attrs do
  @moduledoc """
  Turns form params into the attrs a host context receives.

  Only writable fields survive, nested embeds keep only declared child keys, and
  no key from user input is ever converted to an atom. This is the boundary that
  makes a generic form safe to point at a real changeset.
  """

  alias CorexAdmin.Params
  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Resource.Relation
  alias CorexAdmin.Resource.Spec

  @doc """
  Copies only writable field values from params (string or atom keys).

  Nested embeds keep allowlisted child keys plus `{name}_sort` and
  `{name}_drop` for Phoenix nested forms. A `belongs_to` is read from its
  foreign key, since that is what the form submits.
  """
  @spec take_writable(Spec.t(), map()) :: %{String.t() => term()}
  def take_writable(%Spec{fields: fields}, params) when is_map(params) do
    params = Params.stringify_shallow(params)

    fields
    |> Enum.filter(& &1.writable)
    |> Enum.reduce(%{}, fn field, acc -> take_field(acc, params, field) end)
    |> drop_blank_passwords(fields)
  end

  defp take_field(acc, params, %Field{type: type, name: name, fields: children} = field)
       when type in [:embeds_many, :embeds_one] do
    key = Atom.to_string(name)

    acc
    |> maybe_put(key, sanitize_embed(Map.get(params, key), children, field))
    |> maybe_put(key <> "_sort", Map.get(params, key <> "_sort"))
    |> maybe_put(key <> "_drop", Map.get(params, key <> "_drop"))
  end

  defp take_field(acc, params, %Field{relation: %Relation{} = relation} = field) do
    key = relation_key(field, relation)
    maybe_put(acc, key, Map.get(params, key))
  end

  defp take_field(acc, params, %Field{name: name}) do
    key = Atom.to_string(name)
    maybe_put(acc, key, Map.get(params, key))
  end

  defp relation_key(_field, %Relation{owner_key: key}) when not is_nil(key) do
    Atom.to_string(key)
  end

  defp relation_key(%Field{name: name}, _relation), do: Atom.to_string(name)

  defp maybe_put(acc, _key, nil), do: acc
  defp maybe_put(acc, key, value), do: Map.put(acc, key, value)

  defp sanitize_embed(nil, _children, _field), do: nil

  defp sanitize_embed(rows, children, field) when is_list(rows) do
    rows
    |> Enum.map(&take_child(&1, children))
    |> enforce_exclusive(children, field)
  end

  # Nested forms submit rows as an index-keyed map, and the index order is what
  # decides which exclusive row wins.
  defp sanitize_embed(rows, children, field) when is_map(rows) do
    rows
    |> Enum.sort_by(fn {index, _row} -> index_order(index) end)
    |> Enum.map(fn {index, row} -> {to_string(index), take_child(row, children)} end)
    |> enforce_exclusive_pairs(children, field)
    |> Map.new()
  end

  defp sanitize_embed(_other, _children, _field), do: nil

  defp take_child(row, children) when is_map(row) do
    allowed =
      MapSet.new(for %Field{writable: true} = field <- children, do: Atom.to_string(field.name))

    row
    |> Params.stringify_shallow()
    |> Map.take(MapSet.to_list(allowed))
  end

  defp take_child(_row, _children), do: %{}

  # An `exclusive: true` child may be set on at most one row. The UI cannot be
  # trusted for this, and neither can two concurrent tabs, so the last row the
  # user turned on wins and the rest are cleared here as well as in the
  # changeset.
  defp enforce_exclusive(rows, children, _field) do
    case exclusive_names(children) do
      [] -> rows
      names -> Enum.reduce(names, rows, &clear_extra_flags(&2, &1))
    end
  end

  defp enforce_exclusive_pairs(pairs, children, _field) do
    case exclusive_names(children) do
      [] ->
        pairs

      names ->
        Enum.reduce(names, pairs, fn name, acc ->
          rows = clear_extra_flags(Enum.map(acc, &elem(&1, 1)), name)
          Enum.zip(Enum.map(acc, &elem(&1, 0)), rows)
        end)
    end
  end

  defp clear_extra_flags(rows, name) do
    winner =
      rows
      |> Enum.with_index()
      |> Enum.filter(fn {row, _index} -> truthy?(Map.get(row, name)) end)
      |> List.last()

    case winner do
      nil ->
        rows

      {_row, keep} ->
        rows
        |> Enum.with_index()
        |> Enum.map(fn {row, index} ->
          if index == keep, do: row, else: Map.put(row, name, "false")
        end)
    end
  end

  defp exclusive_names(children) do
    for %Field{exclusive: true} = field <- children, do: Atom.to_string(field.name)
  end

  defp truthy?(value), do: value in [true, "true", "on", "1", 1]

  defp index_order(index) do
    case Integer.parse(to_string(index)) do
      {int, ""} -> int
      _ -> :infinity
    end
  end

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
