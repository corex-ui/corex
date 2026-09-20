defmodule Palaver do
  @moduledoc """
  A conversation that outlives its thinker, its tools, and its clients.

  A palaver is a long talk. Here the talk is the product: you open one and get a
  named, ordered conversation with a room around it. Tools sit down and leave.
  Clients attach, walk away, and come back to find out what they missed. The
  guest who thinks may be a local stub or a paid API. The guest who acts may be
  another node. None of them own the talk.

      script = [
        [{:tool_calls, [%{name: "echo", args: %{"text" => "hello"}}]}],
        [{:token, "it said hello"}]
      ]

      {:ok, talk} = Palaver.open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Echo])
      {:ok, _info} = Palaver.subscribe(talk)
      :ok = Palaver.prompt(talk, "say hello")
      :turn_done = Palaver.await(talk)

  What Palaver does not do is own the interesting-looking parts. There are no
  file, shell, or editor tools, no sandbox, no provider catalogue, and no
  evaluation harness. Those are guests you bring.
  """

  alias Palaver.Session

  @type talk :: pid() | String.t()

  @doc """
  Open a conversation under Palaver's own supervisor.

  Use `Palaver.Session.start_link/1` instead when you want it in your own
  supervision tree.
  """
  @spec open([Session.option()]) :: DynamicSupervisor.on_start_child()
  def open(opts \\ []) do
    DynamicSupervisor.start_child(Palaver.SessionSupervisor, {Session, opts})
  end

  @doc "Close a conversation."
  @spec close(talk()) :: :ok
  def close(talk) do
    case resolve(talk) do
      nil -> :ok
      pid -> DynamicSupervisor.terminate_child(Palaver.SessionSupervisor, pid)
    end

    :ok
  end

  @doc "Find the process holding a conversation, by session id."
  @spec whereis(String.t()) :: pid() | nil
  def whereis(session_id) when is_binary(session_id) do
    case Registry.lookup(Palaver.Registry, session_id) do
      [{pid, _value}] -> pid
      [] -> nil
    end
  end

  @doc """
  Say something, and return as soon as the turn has started.

  Returns `{:error, :busy}` while a turn is already in flight. The turn runs in
  processes the conversation monitors, so it keeps progressing whether or not
  anyone is listening.
  """
  @spec prompt(talk(), String.t()) :: :ok | {:error, :busy}
  def prompt(talk, text) when is_binary(text), do: call(talk, {:prompt, text})

  @doc """
  Join the conversation, and receive everything after `:from_seq`.

  Events arrive as `{:palaver, %Palaver.Event{}}`. Pass `from_seq: 0` to replay
  the whole journal, which is how a client that went away catches up on what
  happened while nobody was listening.
  """
  @spec subscribe(talk(), keyword()) :: {:ok, map()}
  def subscribe(talk, opts \\ []) do
    call(talk, {:subscribe, Keyword.get(opts, :from_seq, :none)})
  end

  @doc "Leave the conversation. It carries on without you."
  @spec unsubscribe(talk()) :: :ok
  def unsubscribe(talk), do: call(talk, :unsubscribe)

  @doc "Where the conversation currently stands."
  @spec info(talk()) :: map()
  def info(talk), do: call(talk, :info)

  @doc "The ordered history, oldest first."
  @spec history(talk()) :: [Palaver.Message.t()]
  def history(talk), do: call(talk, :history)

  @doc """
  Put a tool in the room.

  Idempotent, and safe to call again after recompiling the module: the
  conversation only ever holds the module name, so the next turn picks up
  whatever that name now points at.
  """
  @spec load_plugin(talk(), module()) :: :ok
  def load_plugin(talk, module) when is_atom(module), do: call(talk, {:load_plugin, module})

  @doc "Take a tool out of the room."
  @spec unload_plugin(talk(), String.t()) :: :ok
  def unload_plugin(talk, name) when is_binary(name), do: call(talk, {:unload_plugin, name})

  @doc """
  Choose where tools run: `:local`, or `{:node, node}` for another machine.

  Switching hands mid-conversation is allowed and emits `:hands_changed`.
  """
  @spec set_hands(talk(), Palaver.Hands.t()) :: :ok | {:error, term()}
  def set_hands(talk, hands), do: call(talk, {:set_hands, hands})

  @doc """
  Block until the current turn stops, for tests and scripts.

  Requires an active subscription. Returns the terminal event type.
  """
  @spec await(talk(), timeout()) :: :turn_done | :turn_halted | {:error, :timeout}
  def await(_talk, timeout \\ 5_000) do
    receive do
      {:palaver, %Palaver.Event{type: type}} when type in [:turn_done, :turn_halted] -> type
    after
      timeout -> {:error, :timeout}
    end
  end

  defp call(talk, message) do
    case talk do
      pid when is_pid(pid) -> GenServer.call(pid, message)
      id when is_binary(id) -> GenServer.call(Session.via(id), message)
    end
  end

  defp resolve(pid) when is_pid(pid), do: pid
  defp resolve(id) when is_binary(id), do: whereis(id)
end
