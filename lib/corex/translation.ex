defmodule Corex.Translation do
  @moduledoc false

  defmacro __using__(opts) do
    caller = __CALLER__.module
    fields = Keyword.fetch!(opts, :fields)
    map_merge? = Keyword.get(opts, :map_merge, false)
    camel_keys = Keyword.get(opts, :camel_keys, [])

    field_atoms = Keyword.keys(fields)

    default_map_ast =
      {:%, [],
       [caller, {:%{}, [], Enum.map(fields, fn {field, text} -> {field, gettext_ast(text)} end)}]}

    merge_map_ast =
      {:%, [],
       [
         caller,
         {:%{}, [],
          Enum.map(field_atoms, fn field ->
            {field,
             quote do
               Corex.Translation.take(partial.unquote(field), default.unquote(field))
             end}
          end)}
       ]}

    type_ast =
      {:%, [],
       [
         caller,
         {:%{}, [], Enum.map(field_atoms, fn field -> {field, quote(do: String.t())} end)}
       ]}

    resolve_map =
      if map_merge? do
        quote do
          def resolve(map) when is_map(map) do
            sm = Map.new(map, fn {k, v} -> {to_string(k), v} end)

            partial =
              struct!(
                unquote(caller),
                Enum.map(unquote(field_atoms), fn field ->
                  {field, Map.get(sm, Atom.to_string(field))}
                end)
              )

            merge(partial, default())
          end
        end
      else
        []
      end

    camel_ast =
      if camel_keys == [] do
        []
      else
        entries =
          Enum.map(camel_keys, fn {field, camel_key} ->
            {camel_key, quote(do: t.unquote(field))}
          end)

        [
          quote do
            def to_camel_map(%unquote(caller){} = t) do
              %{unquote_splicing(entries)}
            end
          end
        ]
      end

    quote do
      defstruct unquote(Enum.map(field_atoms, &{&1, nil}))

      @type t :: unquote(type_ast)

      def resolve(nil), do: default()

      def resolve(%unquote(caller){} = partial), do: merge(partial, default())

      unquote(resolve_map)

      defp default do
        unquote(default_map_ast)
      end

      defp merge(%unquote(caller){} = partial, %unquote(caller){} = default) do
        unquote(merge_map_ast)
      end

      unquote(camel_ast)
    end
  end

  defp gettext_ast({:gettext, _, [text]}), do: gettext_ast(text)

  defp gettext_ast(text) when is_binary(text) do
    bindings = placeholder_bindings(text)

    if bindings == %{} do
      quote(do: Corex.Gettext.gettext(unquote(text)))
    else
      quote(do: Corex.Gettext.gettext(unquote(text), unquote(Macro.escape(bindings))))
    end
  end

  defp placeholder_bindings(text) when is_binary(text) do
    ~r/%\{([a-zA-Z0-9_]+)\}/
    |> Regex.scan(text)
    |> Map.new(fn [_, name] -> {name, "%{" <> name <> "}"} end)
  end

  def take(nil, default), do: default
  def take("", default), do: default
  def take(value, _default), do: value

  @doc "Merges optional legacy attribute overrides into a resolved translation struct."
  def resolve_with_overrides(module, partial, overrides \\ %{})

  def resolve_with_overrides(module, partial, overrides) when is_map(overrides) do
    partial
    |> module.resolve()
    |> apply_overrides(overrides)
  end

  defp apply_overrides(struct, overrides) do
    Enum.reduce(overrides, struct, &apply_override/2)
  end

  defp apply_override({_key, value}, acc) when value in [nil, ""], do: acc

  defp apply_override({key, value}, acc) do
    field = override_field_key(key)

    case Map.fetch(acc, field) do
      {:ok, _} -> %{acc | field => value}
      :error -> acc
    end
  end

  defp override_field_key(key) when is_atom(key), do: key

  defp override_field_key(key) when is_binary(key) do
    String.to_existing_atom(key)
  end
end
