defmodule PalaverDemo.Mind.Http do
  @moduledoc """
  A reference mind for any OpenAI-compatible endpoint, meant to be copied.

  This lives in the demo rather than in the library on purpose. Palaver owns the
  conversation; it does not own provider wire formats, because those change on
  somebody else's schedule and absorbing that churn is a recurring tax rather
  than a runtime property. The whole adapter is short enough to read in one
  sitting, which is the point: bring your own mind.

  Streamed tool-call arguments are read from a single delta here. Real providers
  fragment them across deltas and reassembling that is exactly the sort of
  provider-specific work a mind is responsible for.

  ## Options

    * `:base_url` - required, for example `http://localhost:8100`.
    * `:model` - sent through as the model name.
    * `:api_key` - sent as a bearer token when present.
  """

  @behaviour Palaver.Mind

  @impl true
  def stream(%{messages: messages, tools: tools}, opts, sink) do
    base_url = Keyword.fetch!(opts, :base_url)

    body = %{
      "model" => Keyword.get(opts, :model, "palaver-demo"),
      "stream" => true,
      "messages" => Enum.map(messages, &wire_message/1),
      "tools" => Enum.map(tools, &wire_tool/1)
    }

    Process.put(:palaver_sse_buffer, "")

    request =
      Req.post(base_url <> "/v1/chat/completions",
        json: body,
        headers: headers(opts),
        receive_timeout: 120_000,
        into: fn {:data, data}, acc ->
          consume(data, sink)
          {:cont, acc}
        end
      )

    case request do
      {:ok, %Req.Response{status: 200}} -> :ok
      {:ok, %Req.Response{status: status}} -> {:error, {:provider_status, status}}
      {:error, reason} -> {:error, {:provider_unreachable, reason}}
    end
  end

  defp headers(opts) do
    case Keyword.get(opts, :api_key) do
      nil -> []
      key -> [{"authorization", "Bearer " <> key}]
    end
  end

  ## Palaver history to provider wire

  defp wire_message(%{role: :user, content: content}) do
    %{"role" => "user", "content" => content}
  end

  defp wire_message(%{role: :tool, content: content, tool_call_id: id}) do
    %{"role" => "tool", "tool_call_id" => id, "content" => content}
  end

  defp wire_message(%{role: :assistant, content: content, tool_calls: nil}) do
    %{"role" => "assistant", "content" => content || ""}
  end

  defp wire_message(%{role: :assistant, content: content, tool_calls: calls}) do
    %{
      "role" => "assistant",
      "content" => content || "",
      "tool_calls" =>
        Enum.map(calls, fn call ->
          %{
            "id" => call.id,
            "type" => "function",
            "function" => %{"name" => call.name, "arguments" => encode(call.args)}
          }
        end)
    }
  end

  defp wire_tool(%{name: name, schema: schema}) do
    %{"type" => "function", "function" => %{"name" => name, "parameters" => schema}}
  end

  ## Server-sent events

  # Chunk boundaries are not event boundaries, so whatever is left over after the
  # last blank line has to wait for the next chunk.
  defp consume(data, sink) do
    buffer = Process.get(:palaver_sse_buffer, "") <> data
    parts = String.split(buffer, "\n\n")
    {complete, [rest]} = Enum.split(parts, -1)
    Process.put(:palaver_sse_buffer, rest)

    Enum.each(complete, &dispatch(&1, sink))
  end

  defp dispatch(block, sink) do
    block
    |> String.split("\n")
    |> Enum.each(fn
      "data: [DONE]" -> :ok
      "data: " <> payload -> payload |> decode() |> handle(sink)
      _other -> :ok
    end)
  end

  defp handle(%{"choices" => [%{"delta" => delta} | _rest]}, sink) do
    case delta do
      %{"content" => content} when is_binary(content) and content != "" ->
        sink.({:token, content})

      %{"tool_calls" => calls} when is_list(calls) ->
        sink.({:tool_calls, Enum.map(calls, &to_call/1)})

      _other ->
        :ok
    end
  end

  defp handle(_payload, _sink), do: :ok

  defp to_call(%{"id" => id, "function" => %{"name" => name} = function}) do
    %{id: id, name: name, args: decode_args(Map.get(function, "arguments"))}
  end

  defp decode_args(nil), do: %{}
  defp decode_args(""), do: %{}

  defp decode_args(json) when is_binary(json) do
    case decode(json) do
      map when is_map(map) -> map
      other -> %{"value" => other}
    end
  end

  defp encode(term), do: term |> :json.encode() |> IO.iodata_to_binary()

  defp decode(binary) do
    :json.decode(binary)
  rescue
    _error -> %{}
  end
end
