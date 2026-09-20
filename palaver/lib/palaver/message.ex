defmodule Palaver.Message do
  @moduledoc """
  The shape of one entry in a conversation's history.

  Plain maps on purpose: history is data that crosses process and node
  boundaries, gets serialized by callers, and is read by `Palaver.Mind`
  implementations this library will never see.
  """

  @type tool_call :: %{id: String.t(), name: String.t(), args: map()}

  @type t :: %{
          role: :user | :assistant | :tool,
          content: String.t() | nil,
          tool_calls: [tool_call()] | nil,
          tool_call_id: String.t() | nil
        }

  @spec user(String.t()) :: t()
  def user(content) when is_binary(content) do
    %{role: :user, content: content, tool_calls: nil, tool_call_id: nil}
  end

  @spec assistant(String.t() | nil, [tool_call()]) :: t()
  def assistant(content, tool_calls \\ []) do
    %{
      role: :assistant,
      content: content,
      tool_calls: if(tool_calls == [], do: nil, else: tool_calls),
      tool_call_id: nil
    }
  end

  @spec tool(String.t(), String.t()) :: t()
  def tool(tool_call_id, content) when is_binary(tool_call_id) and is_binary(content) do
    %{role: :tool, content: content, tool_calls: nil, tool_call_id: tool_call_id}
  end
end
