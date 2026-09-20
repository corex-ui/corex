defmodule Palaver.Mind.Stub do
  @moduledoc """
  A mind that says exactly what you told it to say.

  This is the only mind Palaver ships, and it is not a placeholder for a real
  one. Every claim this library makes is about the conversation, so the tests
  must not depend on buying intelligence. The stub lets the whole runtime be
  exercised offline, on any machine, with no key and no GPU.

  The script is a list of steps. Each step is either a list of chunks to push,
  or `{:error, reason}` to fail the way a provider fails:

      script = [
        [{:token, "checking"}, {:tool_calls, [%{name: "echo", args: %{"text" => "hi"}}]}],
        [{:token, "it said hi"}]
      ]

  Which step to play is derived from the conversation itself, by counting the
  assistant messages already in the history, so the stub needs no state of its
  own and can be shared by any number of conversations.

  ## Options

    * `:script` - the steps, as above. Defaults to a single plain-text reply.
    * `:delay` - milliseconds to wait before each chunk, so streaming looks like
      streaming. Defaults to `0`.
    * `:repeat_last` - when the script runs out, replay the final step forever.
      Useful for provoking the `:max_turns` guard. Defaults to `false`.
  """

  @behaviour Palaver.Mind

  @default_script [[{:token, "(stub)"}]]

  @impl true
  def stream(%{messages: messages}, opts, sink) do
    script = Keyword.get(opts, :script, @default_script)
    delay = Keyword.get(opts, :delay, 0)
    step = Enum.count(messages, &(&1.role == :assistant))

    case step_at(script, step, Keyword.get(opts, :repeat_last, false)) do
      {:error, reason} ->
        {:error, reason}

      chunks when is_list(chunks) ->
        Enum.each(chunks, fn chunk ->
          if delay > 0, do: Process.sleep(delay)
          sink.(chunk)
        end)

        :ok
    end
  end

  defp step_at(script, step, repeat_last) do
    case Enum.at(script, step) do
      nil -> if repeat_last, do: List.last(script) || [], else: []
      found -> found
    end
  end
end
