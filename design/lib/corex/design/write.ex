defmodule Corex.Design.Write do
  @moduledoc false

  @doc """
  Writes `content` through a temporary file in the same directory, so a reader
  never sees a partially written file. Accepts iodata, which the emitters build.
  """
  @spec atomic!(Path.t(), iodata()) :: :ok
  def atomic!(path, content) when is_binary(path) and (is_binary(content) or is_list(content)) do
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
