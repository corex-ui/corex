defmodule Corex.Connect.Mounted do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      @before_compile Corex.Connect.Mounted
    end
  end

  defmacro __before_compile__(env) do
    definitions = Module.definitions_in(env.module, :def)
    defined = MapSet.new(definitions)

    for {name, 1} <- definitions,
        not ignore_function?(name),
        ignore = ignore_name(name),
        MapSet.member?(defined, {ignore, 1}) do
      quote do
        @doc false
        def unquote(mounted_name(name))(assigns) do
          Map.put(
            unquote(name)(assigns),
            "phx-mounted",
            unquote(ignore)(assigns)
          )
        end
      end
    end
  end

  defp ignore_function?(name), do: String.starts_with?(Atom.to_string(name), "ignore_")

  defp ignore_name(name), do: String.to_atom("ignore_" <> Atom.to_string(name))

  defp mounted_name(name), do: String.to_atom("mounted_" <> Atom.to_string(name))
end
