defmodule Corex.MCP.ToolError do
  @moduledoc false

  @invalid_params -32_602

  @type protocol_error :: {:error, %{code: integer(), message: String.t(), data: map()}}
  @type tool_error :: {:error, String.t()}

  @spec invalid_arguments(String.t(), String.t()) :: protocol_error()
  def invalid_arguments(tool, expected) when is_binary(tool) and is_binary(expected) do
    {:error,
     %{
       code: @invalid_params,
       message: "Invalid arguments for #{tool}",
       data: %{tool: tool, expected: expected}
     }}
  end

  @spec unknown_value(String.t(), String.t(), [String.t()]) :: protocol_error()
  def unknown_value(tool, param, allowed)
      when is_binary(tool) and is_binary(param) and is_list(allowed) do
    {:error,
     %{
       code: @invalid_params,
       message: "Invalid #{param} for #{tool}",
       data: %{tool: tool, param: param, allowed: allowed}
     }}
  end

  @spec unknown_id(String.t(), String.t(), String.t()) :: tool_error()
  def unknown_id(tool, id, discovery_tool)
      when is_binary(tool) and is_binary(id) and is_binary(discovery_tool) do
    {:error,
     "Unknown component id #{inspect(id)} passed to #{tool}. Call #{discovery_tool} for valid ids."}
  end

  @spec unavailable(String.t(), String.t()) :: tool_error()
  def unavailable(tool, remedy) when is_binary(tool) and is_binary(remedy) do
    {:error, "#{tool} is unavailable. #{remedy}"}
  end
end
