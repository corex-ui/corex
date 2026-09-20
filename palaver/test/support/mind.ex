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
