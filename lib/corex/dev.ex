defmodule Corex.Dev do
  @moduledoc false

  require Logger

  @spec warn(String.t()) :: :ok
  def warn(message) when is_binary(message) do
    Logger.warning("[corex] " <> message)
  end
end
