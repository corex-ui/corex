defmodule Palaver.Event do
  @moduledoc """
  One observable thing that happened inside a conversation.

  Every event carries a per-session monotonic `:seq`. That number is what makes
  "the talk outlived you" checkable rather than rhetorical: a client that went
  away at sequence 12 can come back and ask for everything after 12.
  """

  @type type ::
          :turn_started
          | :token
          | :tool_call
          | :tool_result
          | :plugin_changed
          | :hands_changed
          | :mind_error
          | :turn_done
          | :turn_halted

  @type t :: %__MODULE__{
          seq: pos_integer(),
          session_id: String.t(),
          at: integer(),
          type: type(),
          payload: map()
        }

  @enforce_keys [:seq, :session_id, :at, :type, :payload]
  defstruct [:seq, :session_id, :at, :type, :payload]

  @doc false
  @spec new(pos_integer(), String.t(), type(), map()) :: t()
  def new(seq, session_id, type, payload) do
    %__MODULE__{
      seq: seq,
      session_id: session_id,
      at: System.monotonic_time(:microsecond),
      type: type,
      payload: payload
    }
  end
end
