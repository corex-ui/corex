defmodule Palaver.Test.Wait do
  @moduledoc false

  import ExUnit.Assertions

  @doc """
  Poll until `fun` returns a truthy value, or fail with the last value seen.

  Used where the assertion is about the conversation making progress on its own,
  with no client in the room to receive an event.
  """
  @spec until((-> any()), timeout()) :: any()
  def until(fun, timeout \\ 3_000) do
    deadline = System.monotonic_time(:millisecond) + timeout
    poll(fun, deadline)
  end

  defp poll(fun, deadline) do
    case fun.() do
      falsy when falsy in [false, nil] ->
        if System.monotonic_time(:millisecond) < deadline do
          Process.sleep(20)
          poll(fun, deadline)
        else
          flunk("condition never became true within the deadline")
        end

      truthy ->
        truthy
    end
  end
end
