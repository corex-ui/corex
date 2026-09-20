defmodule Palaver.Test.Events do
  @moduledoc false

  import ExUnit.Assertions

  alias Palaver.Event

  @doc """
  Wait for one event of `type`, leaving every other event in the mailbox.

  Selective receive matters here: a test that waits for `:turn_done` must not
  silently eat the `:token` events another assertion is about to check.
  """
  @spec await(Event.type(), timeout()) :: Event.t()
  def await(type, timeout \\ 2_000) do
    receive do
      {:palaver, %Event{type: ^type} = event} -> event
    after
      timeout -> flunk("timed out waiting for #{inspect(type)}")
    end
  end

  @doc "Collect events in arrival order until one of `types` shows up."
  @spec collect_until([Event.type()], timeout()) :: [Event.t()]
  def collect_until(types, timeout \\ 5_000) when is_list(types) do
    collect_until(types, timeout, [])
  end

  defp collect_until(types, timeout, acc) do
    receive do
      {:palaver, %Event{type: type} = event} ->
        acc = [event | acc]

        if type in types do
          Enum.reverse(acc)
        else
          collect_until(types, timeout, acc)
        end
    after
      timeout ->
        flunk("""
        timed out waiting for one of #{inspect(types)}
        collected: #{inspect(acc |> Enum.reverse() |> Enum.map(& &1.type))}
        """)
    end
  end

  @doc "Everything already in the mailbox, in order."
  @spec drain(timeout()) :: [Event.t()]
  def drain(quiet_for \\ 100), do: drain(quiet_for, [])

  defp drain(quiet_for, acc) do
    receive do
      {:palaver, %Event{} = event} -> drain(quiet_for, [event | acc])
    after
      quiet_for -> Enum.reverse(acc)
    end
  end

  @doc "Just the types, for readable assertions."
  @spec types([Event.t()]) :: [Event.type()]
  def types(events), do: Enum.map(events, & &1.type)
end
