defmodule Corex.MCP.Config do
  @moduledoc false

  @enforce_keys [:allow_remote_access, :verbose_errors]
  defstruct allow_remote_access: false, verbose_errors: false

  @type t :: %__MODULE__{
          allow_remote_access: boolean(),
          verbose_errors: boolean()
        }

  def build(opts) when is_list(opts) do
    %__MODULE__{
      allow_remote_access: Keyword.get(opts, :allow_remote_access, false),
      verbose_errors: verbose_errors_from(Keyword.get(opts, :verbose_errors, nil))
    }
  end

  def build(%__MODULE__{} = config), do: config

  def build(%{} = config) do
    %__MODULE__{
      allow_remote_access: Map.get(config, :allow_remote_access, false),
      verbose_errors: verbose_errors_from(Map.get(config, :verbose_errors, nil))
    }
  end

  defp verbose_errors_from(nil),
    do: Application.get_env(:corex, :mcp_verbose_errors, false)

  defp verbose_errors_from(value) when is_boolean(value), do: value
end
