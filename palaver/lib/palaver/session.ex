defmodule Palaver.Session do
  @moduledoc """
  The talk itself.

  One process owns an ordered history, a sequence counter, a bounded journal of
  everything that has happened, the set of tools currently in the room, and where
  those tools run. It owns none of the work. The mind streams in a process the
  session monitors but does not run in, and every tool call gets its own process,
  so this `GenServer` answers its clients for the entire length of a turn.

  Tools start the moment the mind asks for them, not after the mind stops
  talking, which is why tokens keep arriving while something expensive is
  running somewhere else.

  ## State versions

  The state is a plain map carrying `:state_vsn`, and `@vsn` is bumped alongside
  it, so a running conversation can be migrated in place with `:sys.change_code/4`
  rather than restarted. Version 1 kept `:history` newest-first and had no
  journal; version 2 keeps history oldest-first and journals events for clients
  that went away. This is in-node reload, not an appup release upgrade.
  """

  use GenServer

  @vsn 2

  alias Palaver.Event
  alias Palaver.Hands
  alias Palaver.Message

  @journal_limit 200
  @default_max_turns 8
  @default_tool_timeout 30_000

  @type option ::
          {:session_id, String.t()}
          | {:mind, module() | {module(), term()}}
          | {:plugins, [module()]}
          | {:hands, Hands.t()}
          | {:max_turns, pos_integer()}
          | {:tool_timeout, timeout()}
          | {:journal_limit, pos_integer()}

  @doc false
  @spec start_link([option()]) :: GenServer.on_start()
  def start_link(opts) do
    session_id = Keyword.get_lazy(opts, :session_id, &generate_id/0)
    opts = Keyword.put(opts, :session_id, session_id)
    GenServer.start_link(__MODULE__, opts, name: via(session_id))
  end

  @doc false
  @spec via(String.t()) :: GenServer.name()
  def via(session_id), do: {:via, Registry, {Palaver.Registry, session_id}}

  @impl true
  def init(opts) do
    hands = Keyword.get(opts, :hands, :local)

    unless Hands.valid?(hands) do
      raise ArgumentError, "invalid :hands #{inspect(hands)}, expected :local or {:node, node}"
    end

    watch_hands(nil, hands)

    plugins =
      opts
      |> Keyword.get(:plugins, [])
      |> Map.new(fn module -> {module.name(), module} end)

    {:ok,
     %{
       state_vsn: 2,
       session_id: Keyword.fetch!(opts, :session_id),
       history: [],
       seq: 0,
       # newest-first so appending an event stays cheap
       journal: [],
       journal_limit: Keyword.get(opts, :journal_limit, @journal_limit),
       subscribers: %{},
       mind: normalize_mind(Keyword.get(opts, :mind, Palaver.Mind.Stub)),
       plugins: plugins,
       hands: hands,
       max_turns: Keyword.get(opts, :max_turns, @default_max_turns),
       tool_timeout: Keyword.get(opts, :tool_timeout, @default_tool_timeout),
       turn: nil,
       mind_worker: nil,
       tool_workers: %{}
     }}
  end

  @impl true
  def handle_call({:subscribe, from_seq}, {pid, _tag}, state) do
    state =
      if Map.has_key?(state.subscribers, pid) do
        state
      else
        put_in(state.subscribers[pid], Process.monitor(pid))
      end

    # Replaying inside the call is what makes this safe: the session is busy
    # here, so no live event can slip between the replay and the subscription.
    Enum.each(replay(state, from_seq), &send(pid, {:palaver, &1}))

    {:reply, {:ok, info(state)}, state}
  end

  @impl true
  def handle_call(:unsubscribe, {pid, _tag}, state) do
    {:reply, :ok, drop_subscriber(state, pid)}
  end

  @impl true
  def handle_call(:info, _from, state), do: {:reply, info(state), state}

  @impl true
  def handle_call(:history, _from, state), do: {:reply, state.history, state}

  @impl true
  def handle_call({:prompt, text}, _from, %{turn: nil} = state) do
    state = %{state | history: state.history ++ [Message.user(text)]}
    state = emit(state, :turn_started, %{prompt: text})
    {:reply, :ok, start_step(%{state | turn: new_turn()})}
  end

  @impl true
  def handle_call({:prompt, _text}, _from, state), do: {:reply, {:error, :busy}, state}

  @impl true
  def handle_call({:load_plugin, module}, _from, state) do
    name = module.name()
    state = %{state | plugins: Map.put(state.plugins, name, module)}
    state = emit(state, :plugin_changed, %{loaded: name, schema: module.schema(), tools: tool_names(state)})
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:unload_plugin, name}, _from, state) do
    state = %{state | plugins: Map.delete(state.plugins, name)}
    {:reply, :ok, emit(state, :plugin_changed, %{unloaded: name, tools: tool_names(state)})}
  end

  @impl true
  def handle_call({:set_hands, hands}, _from, state) do
    if Hands.valid?(hands) do
      watch_hands(state.hands, hands)
      state = %{state | hands: hands}
      {:reply, :ok, emit(state, :hands_changed, %{status: :up, hands: hands, reason: nil})}
    else
      {:reply, {:error, {:invalid_hands, hands}}, state}
    end
  end

  @impl true
  def handle_info({:mind_chunk, pid, chunk}, %{mind_worker: %{pid: pid}, turn: turn} = state)
      when turn != nil do
    {:noreply, apply_chunk(state, chunk)}
  end

  @impl true
  def handle_info({:mind_result, pid, result}, %{mind_worker: %{pid: pid, mon: mon}} = state) do
    Process.demonitor(mon, [:flush])
    {:noreply, close_mind_step(%{state | mind_worker: nil}, result)}
  end

  @impl true
  def handle_info({:tool_result, pid, result}, state) do
    case Map.pop(state.tool_workers, pid) do
      {nil, _workers} ->
        {:noreply, state}

      {%{mon: mon, call: call}, workers} ->
        Process.demonitor(mon, [:flush])
        {:noreply, record_result(%{state | tool_workers: workers}, call, result)}
    end
  end

  @impl true
  def handle_info({:DOWN, _mon, :process, pid, reason}, state) do
    cond do
      Map.has_key?(state.tool_workers, pid) ->
        {%{call: call}, workers} = Map.pop(state.tool_workers, pid)
        state = %{state | tool_workers: workers}
        {:noreply, record_result(state, call, {:error, {:tool_crashed, reason}})}

      match?(%{pid: ^pid}, state.mind_worker) ->
        {:noreply, close_mind_step(%{state | mind_worker: nil}, {:error, {:mind_crashed, reason}})}

      Map.has_key?(state.subscribers, pid) ->
        {:noreply, drop_subscriber(state, pid)}

      true ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_info({:nodedown, node}, %{hands: {:node, node}} = state) do
    {:noreply,
     emit(state, :hands_changed, %{status: :down, hands: {:node, node}, reason: :nodedown})}
  end

  @impl true
  def handle_info(_message, state), do: {:noreply, state}

  @impl true
  def code_change(1, state, _extra) do
    {:ok,
     state
     |> Map.put(:state_vsn, 2)
     |> Map.update!(:history, &Enum.reverse/1)
     |> Map.put_new(:journal, [])
     |> Map.put_new(:journal_limit, @journal_limit)}
  end

  @impl true
  def code_change(_old_vsn, state, _extra), do: {:ok, state}

  ## Turn machinery

  defp new_turn do
    %{step: 1, tokens: [], calls: [], results: %{}, awaiting_mind: false, mind_error: nil, pending: 0}
  end

  defp start_step(state) do
    {module, opts} = state.mind
    request = %{messages: state.history, tools: tools(state)}
    parent = self()

    {pid, mon} =
      spawn_monitor(fn ->
        sink = fn chunk ->
          send(parent, {:mind_chunk, self(), chunk})
          :ok
        end

        send(parent, {:mind_result, self(), module.stream(request, opts, sink)})
      end)

    %{state | mind_worker: %{pid: pid, mon: mon}, turn: %{state.turn | awaiting_mind: true}}
  end

  defp apply_chunk(state, {:token, text}) when is_binary(text) do
    state = %{state | turn: %{state.turn | tokens: [text | state.turn.tokens]}}
    emit(state, :token, %{text: text})
  end

  defp apply_chunk(state, {:tool_calls, calls}) when is_list(calls) do
    calls = Enum.map(calls, &normalize_call/1)

    turn = %{
      state.turn
      | calls: state.turn.calls ++ calls,
        pending: state.turn.pending + length(calls)
    }

    Enum.reduce(calls, %{state | turn: turn}, fn call, acc ->
      acc
      |> emit(:tool_call, %{id: call.id, name: call.name, args: call.args, hands: acc.hands})
      |> start_tool(call)
    end)
  end

  defp apply_chunk(state, _unknown), do: state

  defp start_tool(state, call) do
    parent = self()
    hands = state.hands
    timeout = state.tool_timeout
    plugin = Map.get(state.plugins, call.name)
    context = %{session_id: state.session_id, tool_call_id: call.id, node: node()}

    {pid, mon} =
      spawn_monitor(fn ->
        result =
          if plugin do
            Hands.run(hands, plugin, call.args, context, timeout)
          else
            {:error, {:unknown_tool, call.name}}
          end

        send(parent, {:tool_result, self(), result})
      end)

    put_in(state.tool_workers[pid], %{mon: mon, call: call})
  end

  defp record_result(%{turn: nil} = state, _call, _result), do: state

  defp record_result(state, call, result) do
    turn = state.turn

    turn = %{
      turn
      | results: Map.put(turn.results, call.id, result),
        pending: max(turn.pending - 1, 0)
    }

    %{state | turn: turn}
    |> emit(:tool_result, %{
      id: call.id,
      name: call.name,
      result: result,
      hands: Hands.describe(state.hands)
    })
    |> maybe_advance()
  end

  defp close_mind_step(%{turn: nil} = state, _result), do: state

  defp close_mind_step(state, result) do
    turn = state.turn
    text = turn.tokens |> Enum.reverse() |> Enum.join()
    content = if text == "", do: nil, else: text

    state =
      if content == nil and turn.calls == [] do
        state
      else
        %{state | history: state.history ++ [Message.assistant(content, turn.calls)]}
      end

    state = %{state | turn: %{turn | awaiting_mind: false, tokens: []}}

    state
    |> note_mind_result(result)
    |> maybe_advance()
  end

  defp note_mind_result(state, :ok), do: state

  defp note_mind_result(state, {:error, reason}) do
    state
    |> emit(:mind_error, %{reason: reason})
    |> then(&%{&1 | turn: %{&1.turn | mind_error: reason}})
  end

  defp note_mind_result(state, other), do: note_mind_result(state, {:error, {:bad_return, other}})

  defp maybe_advance(%{turn: nil} = state), do: state
  defp maybe_advance(%{turn: %{awaiting_mind: true}} = state), do: state
  defp maybe_advance(%{turn: %{pending: pending}} = state) when pending > 0, do: state

  defp maybe_advance(state) do
    turn = state.turn

    cond do
      turn.mind_error != nil ->
        finish(state, :turn_halted, %{reason: {:mind_error, turn.mind_error}, steps: turn.step})

      turn.calls == [] ->
        finish(state, :turn_done, %{steps: turn.step})

      true ->
        advance_step(state, turn)
    end
  end

  defp advance_step(state, turn) do
    messages =
      Enum.map(turn.calls, fn call ->
        Message.tool(call.id, render_result(Map.get(turn.results, call.id)))
      end)

    state = %{state | history: state.history ++ messages}
    next = %{turn | step: turn.step + 1, calls: [], results: %{}, tokens: []}

    if next.step > state.max_turns do
      finish(%{state | turn: next}, :turn_halted, %{reason: :max_turns, steps: turn.step})
    else
      start_step(%{state | turn: next})
    end
  end

  defp finish(state, type, payload) do
    %{emit(state, type, payload) | turn: nil}
  end

  ## Events

  defp emit(state, type, payload) do
    seq = state.seq + 1
    event = Event.new(seq, state.session_id, type, payload)

    Enum.each(Map.keys(state.subscribers), &send(&1, {:palaver, event}))

    %{state | seq: seq, journal: Enum.take([event | state.journal], state.journal_limit)}
  end

  defp replay(_state, :none), do: []

  defp replay(state, from_seq) when is_integer(from_seq) do
    state.journal
    |> Enum.reverse()
    |> Enum.filter(&(&1.seq > from_seq))
  end

  defp drop_subscriber(state, pid) do
    case Map.pop(state.subscribers, pid) do
      {nil, _subscribers} ->
        state

      {mon, subscribers} ->
        Process.demonitor(mon, [:flush])
        %{state | subscribers: subscribers}
    end
  end

  ## Helpers

  defp info(state) do
    %{
      session_id: state.session_id,
      seq: state.seq,
      history_length: length(state.history),
      turn: if(state.turn, do: %{step: state.turn.step, pending: state.turn.pending}),
      tools: tool_names(state),
      hands: state.hands,
      subscribers: map_size(state.subscribers),
      state_vsn: state.state_vsn
    }
  end

  defp tools(state) do
    state.plugins
    |> Enum.sort_by(fn {name, _module} -> name end)
    |> Enum.map(fn {name, module} -> %{name: name, schema: module.schema()} end)
  end

  defp tool_names(state), do: state.plugins |> Map.keys() |> Enum.sort()

  defp normalize_mind({module, opts}) when is_atom(module), do: {module, opts}
  defp normalize_mind(module) when is_atom(module), do: {module, []}

  defp normalize_call(%{name: name} = call) do
    %{
      id: Map.get_lazy(call, :id, &generate_id/0),
      name: to_string(name),
      args: Map.get(call, :args, %{})
    }
  end

  defp render_result({:ok, value}) when is_binary(value), do: value
  defp render_result({:ok, value}), do: inspect(value)
  defp render_result({:error, reason}), do: "error: " <> inspect(reason)
  defp render_result(nil), do: "error: :no_result"

  defp watch_hands(same, same), do: :ok

  defp watch_hands(old, new) do
    case old do
      {:node, node} -> Node.monitor(node, false)
      _other -> :ok
    end

    case new do
      {:node, node} -> Node.monitor(node, true)
      _other -> :ok
    end

    :ok
  end

  defp generate_id, do: 8 |> :crypto.strong_rand_bytes() |> Base.url_encode64(padding: false)
end
