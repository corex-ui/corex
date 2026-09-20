defmodule Palaver.Test.Client do
  @moduledoc false

  @doc """
  A client process that joins a conversation and forwards what it hears.

  Deliberately unlinked: these clients get killed on purpose, and a link would
  take the test down with them.
  """
  @spec start(Palaver.talk(), pid(), term(), keyword()) :: pid()
  def start(talk, owner, label, opts \\ []) do
    spawn(fn ->
      {:ok, info} = Palaver.subscribe(talk, opts)
      send(owner, {:subscribed, label, info})
      loop(owner, label)
    end)
  end

  defp loop(owner, label) do
    receive do
      {:palaver, event} ->
        send(owner, {:client, label, event})
        loop(owner, label)
    end
  end
end
