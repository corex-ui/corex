defmodule Palaver.Mind do
  @moduledoc """
  The guest who thinks.

  A mind streams. It is handed the conversation so far and the tools currently
  in the room, and it pushes chunks into a `sink` until it has nothing left to
  say. Streaming is not a convenience here: it is the only way a conversation
  can show progress while work is still happening elsewhere.

  Palaver ships exactly one implementation, `Palaver.Mind.Stub`, because owning
  provider wire formats is not this library's job. A reference implementation
  against a real HTTP provider lives in `demo/`.

      defmodule MyMind do
        @behaviour Palaver.Mind

        @impl true
        def stream(%{messages: _messages, tools: _tools}, _opts, sink) do
          sink.({:token, "hello"})
          :ok
        end
      end
  """

  @type request :: %{messages: [Palaver.Message.t()], tools: [map()]}

  @type chunk ::
          {:token, String.t()}
          | {:tool_calls, [Palaver.Message.tool_call()]}

  @type sink :: (chunk() -> :ok)

  @doc """
  Stream one completion.

  Called in a process the session owns but does not run in, so a slow or
  blocking mind cannot stop the conversation from answering its clients.

  Return `:ok` when the completion is finished, or `{:error, reason}` to make
  the session emit a `:mind_error` event and halt the turn.
  """
  @callback stream(request(), opts :: term(), sink()) :: :ok | {:error, term()}
end
