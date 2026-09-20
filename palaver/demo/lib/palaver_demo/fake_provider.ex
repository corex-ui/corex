defmodule PalaverDemo.FakeProvider do
  @moduledoc """
  A provider-shaped HTTP endpoint, so the walkthrough streams real bytes.

  It speaks enough of the OpenAI chat-completions wire format to be indistinguishable
  from the real thing at the boundary that matters here: server-sent events,
  token deltas, tool calls, and a loop that terminates. Terminating is the part
  naive mocks get wrong, by either always asking for a tool, which spins forever,
  or never asking, which makes tool paths untestable. The rule used here is the
  one real providers follow: tools declared and no tool result in the history
  yet means ask for a tool; a tool result already present means answer in prose.

  Two deliberate simplifications. Tool-call arguments arrive complete in a single
  delta, where real providers fragment them across deltas. And a few text deltas
  follow the tool call, which real providers rarely do, because it makes the
  walkthrough show tokens still arriving while a tool is busy.

  Point `base_url` at a real provider instead and nothing in Palaver changes.
  That is the entire claim being made about providers.
  """

  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Plug.Conn{method: "POST", request_path: "/v1/chat/completions"} = conn, opts) do
    {:ok, body, conn} = read_body(conn)
    request = decode(body)

    reply = decide(request)

    if Map.get(request, "stream", false) do
      stream(conn, reply, Keyword.get(opts, :token_delay, 40))
    else
      whole(conn, reply)
    end
  end

  @impl true
  def call(conn, _opts), do: send_resp(conn, 404, "no such endpoint")

  ## Deciding what to say

  defp decide(request) do
    messages = Map.get(request, "messages", [])
    tools = Map.get(request, "tools", [])

    if tools != [] and not answered_a_tool?(messages) do
      {:tool_call, pick_tool(tools, messages), said(messages)}
    else
      {:text, prose(messages)}
    end
  end

  # Scoped to the current turn, not the whole history. A conversation that has
  # already used a tool once must still be able to use one when asked again.
  defp answered_a_tool?(messages) do
    messages
    |> Enum.reverse()
    |> Enum.take_while(&(Map.get(&1, "role") != "user"))
    |> Enum.any?(&(Map.get(&1, "role") == "tool"))
  end

  # Ask for the tool the user named, so a narrated walkthrough can steer it.
  defp pick_tool(tools, messages) do
    names = Enum.map(tools, &get_in(&1, ["function", "name"]))
    said = said(messages) || ""

    Enum.find(names, hd(names), &String.contains?(said, &1))
  end

  defp said(messages) do
    messages
    |> Enum.reverse()
    |> Enum.find_value(fn message ->
      if Map.get(message, "role") == "user", do: Map.get(message, "content")
    end)
  end

  defp prose(messages) do
    case Enum.reverse(messages) do
      [%{"role" => "tool", "content" => content} | _rest] ->
        "the tool came back with #{content}, so that is settled."

      _other ->
        "nothing left to do, so here is a plain answer."
    end
  end

  ## Wire format

  defp whole(conn, {:text, text}) do
    json(conn, %{
      "choices" => [
        %{
          "index" => 0,
          "message" => %{"role" => "assistant", "content" => text},
          "finish_reason" => "stop"
        }
      ]
    })
  end

  defp whole(conn, {:tool_call, name, argument}) do
    json(conn, %{
      "choices" => [
        %{
          "index" => 0,
          "message" => %{
            "role" => "assistant",
            "content" => nil,
            "tool_calls" => [tool_call(name, argument)]
          },
          "finish_reason" => "tool_calls"
        }
      ]
    })
  end

  defp stream(conn, reply, token_delay) do
    conn =
      conn
      |> put_resp_content_type("text/event-stream")
      |> put_resp_header("cache-control", "no-cache")
      |> send_chunked(200)

    conn
    |> deltas(reply, token_delay)
    |> finish(reply)
  end

  defp deltas(conn, {:text, text}, token_delay) do
    emit_words(conn, text, token_delay)
  end

  defp deltas(conn, {:tool_call, name, argument}, token_delay) do
    conn
    |> emit_words("let me check that", token_delay)
    |> chunk_json(%{
      "choices" => [%{"index" => 0, "delta" => %{"tool_calls" => [tool_call(name, argument)]}}]
    })
    |> emit_words("and I can keep talking meanwhile", token_delay)
  end

  defp emit_words(conn, text, token_delay) do
    text
    |> String.split(" ", trim: true)
    |> Enum.reduce(conn, fn word, conn ->
      if token_delay > 0, do: Process.sleep(token_delay)
      chunk_json(conn, %{"choices" => [%{"index" => 0, "delta" => %{"content" => word <> " "}}]})
    end)
  end

  defp finish(conn, reply) do
    reason = if match?({:tool_call, _name, _argument}, reply), do: "tool_calls", else: "stop"

    conn
    |> chunk_json(%{"choices" => [%{"index" => 0, "delta" => %{}, "finish_reason" => reason}]})
    |> then(fn conn ->
      {:ok, conn} = chunk(conn, "data: [DONE]\n\n")
      conn
    end)
  end

  defp chunk_json(conn, payload) do
    {:ok, conn} = chunk(conn, "data: " <> encode(payload) <> "\n\n")
    conn
  end

  defp tool_call(name, argument) do
    %{
      "index" => 0,
      "id" => "call_" <> Integer.to_string(System.unique_integer([:positive])),
      "type" => "function",
      "function" => %{"name" => name, "arguments" => encode(%{"text" => argument || ""})}
    }
  end

  defp json(conn, payload) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, encode(payload))
  end

  defp encode(term), do: term |> :json.encode() |> IO.iodata_to_binary()
  defp decode(binary), do: :json.decode(binary)
end
