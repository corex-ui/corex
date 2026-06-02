defmodule Corex.MCP.Config do
  @moduledoc false

  @enforce_keys [:allow_remote_access]
  defstruct allow_remote_access: false

  @type t :: %__MODULE__{
          allow_remote_access: boolean()
        }

  def build(opts) when is_list(opts) do
    %__MODULE__{
      allow_remote_access: Keyword.get(opts, :allow_remote_access, false)
    }
  end

  def build(%__MODULE__{} = config), do: config

  def build(%{} = config) do
    struct!(__MODULE__, config)
  end
end
