defmodule Corex.Assets.Write do
  @moduledoc false

  @doc """
  Writes `content` to `path` via a temp file in the same directory, then renames.
  """
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
end
