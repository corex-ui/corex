defmodule Palaver.Test.Mind.Scripted do
  @moduledoc false

  @behaviour Palaver.Mind

  @doc """
  Pick a script by matching the most recent user message, then hand over to the
  stub.

  A conversation that spans several turns needs different answers to different
  questions, which a single positional script cannot express.
  """
  @impl true
  def stream(%{messages: messages} = request, opts, sink) do
    routes = Keyword.fetch!(opts, :routes)
    said = last_user_text(messages)

    script =
      Enum.find_value(routes, [], fn {match, script} ->
        if said != nil and String.contains?(said, match), do: script
      end)

    Palaver.Mind.Stub.stream(request, Keyword.put(opts, :script, script), sink)
  end

  defp last_user_text(messages) do
    messages
    |> Enum.reverse()
    |> Enum.find_value(fn
      %{role: :user, content: content} -> content
      _other -> nil
    end)
  end
end

defmodule Palaver.Test.Mind.Spy do
  @moduledoc false

  @behaviour Palaver.Mind

  @doc """
  A stub that first reports exactly what it was asked.

  Needed because "the next turn sees the new tool" is a claim about the request
  the mind receives, not about the answer it gives.
  """
  @impl true
  def stream(request, opts, sink) do
    send(Keyword.fetch!(opts, :owner), {:mind_request, request})
    Palaver.Mind.Stub.stream(request, opts, sink)
  end
end
