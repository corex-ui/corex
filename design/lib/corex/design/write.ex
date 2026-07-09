defmodule Corex.Design.Write do
  @moduledoc false

  @doc false
  def atomic!(path, content) when is_binary(path) and is_binary(content) do
    dir = Path.dirname(path)
    File.mkdir_p!(dir)

    tmp =
      Path.join(
        dir,
        ".#{Path.basename(path)}.#{System.system_time(:millisecond)}.#{:erlang.unique_integer([:positive])}.tmp"
      )

    File.write!(tmp, content)
    File.rename!(tmp, path)
    :ok
  end

  @doc false
  def copy_tree!(source, dest) do
    File.mkdir_p!(dest)

    source
    |> Path.expand()
    |> then(fn root ->
      root
      |> Path.join("**/*")
      |> Path.wildcard()
      |> Enum.sort()
      |> Enum.each(fn path ->
        rel = Path.relative_to(path, root)
        target = Path.join(dest, rel)

        if File.dir?(path) do
          File.mkdir_p!(target)
        else
          File.mkdir_p!(Path.dirname(target))
          File.cp!(path, target)
        end
      end)
    end)

    :ok
  end
end
