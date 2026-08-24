defmodule CorexAdmin.Attrs do
  @moduledoc false

  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Resource.Spec

  @doc """
  Copies only writable field values from params (string or atom keys).

  Never introduces new atoms from user keys.
  """
  @spec take_writable(Spec.t(), map()) :: %{String.t() => term()}
  def take_writable(%Spec{fields: fields}, params) when is_map(params) do
    allowed =
      MapSet.new(for %Field{writable: true} = field <- fields, do: Atom.to_string(field.name))

    params
    |> stringify_keys()
    |> Map.take(MapSet.to_list(allowed))
    |> drop_blank_passwords(fields)
  end

  defp stringify_keys(params) do
    Map.new(params, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} when is_binary(key) -> {key, value}
      {key, value} -> {to_string(key), value}
    end)
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
