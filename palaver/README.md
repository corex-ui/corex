# Palaver

A conversation that outlives its thinker, its tools, and its clients.

A palaver is a long talk. Here the talk is the product. You open one and get a named,
ordered conversation with a room around it. Tools sit down and leave. Clients attach,
walk away, and come back to find out what they missed. The guest who thinks may be a
local stub or a paid API. The guest who acts may be another machine. None of them own
the talk.

Agent products keep rebuilding this conversation and then tying it to a model and a
pile of tools, until you cannot test the conversation without buying intelligence.
Palaver cuts the knot: own the conversation, and treat intelligence and execution as
guests.

## Zero dependencies

```elixir
defp deps, do: []
```

That is the real line from [`mix.exs`](mix.exs). `Registry`, `DynamicSupervisor`,
`:sys`, and distribution all ship with the runtime, so `mix test` needs no network, no
API key, and no GPU. A library making this particular argument should not have to
import anything to make it.

## The talk

```elixir
script = [
  [{:token, "checking"}, {:tool_calls, [%{name: "echo", args: %{"text" => "hi"}}]}],
  [{:token, "it said hi"}]
]

{:ok, talk} = Palaver.open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Echo])
{:ok, _info} = Palaver.subscribe(talk)
:ok = Palaver.prompt(talk, "say hi")
:turn_done = Palaver.await(talk)

Palaver.history(talk)
#=> [%{role: :user, ...}, %{role: :assistant, ...}, %{role: :tool, ...}, %{role: :assistant, ...}]
```

Five ideas, and no more than five:

- **Session** is the talk: an ordered history, a monotonic sequence counter, a bounded
  journal of what happened, the tools currently in the room, and where those tools run.
  It owns none of the work.
- **Mind** is the guest who thinks. It streams chunks into a sink. Palaver ships one
  implementation, a stub, on purpose.
- **Plugin** is a tool that can sit down and leave. The session holds nothing but the
  module name, which is what makes a tool replaceable while the talk is open.
- **Hands** is where tools run: `:local`, or `{:node, node}` for another machine.
- **Event** is one observable thing that happened, carrying the sequence number that
  lets a client work out what it missed.

## The four claims

Each claim is a test that fails if the talk dies. For each one, the weak version is
named too, because the weak version is the one that would have proved nothing.

**A tool can be replaced mid-talk.**
A plugin module is recompiled underneath a live conversation and the next turn uses it.
The stronger test migrates the session's own state shape in place, through
`:sys.suspend/1`, `:sys.change_code/4`, and `:sys.resume/1`, with the history and the
already-attached client surviving the upgrade.
See [`test/claims/reload_test.exs`](test/claims/reload_test.exs).

**The talk outlives its clients.**
Weak version: "two subscribers receive the same events", which is a property of any
pub-sub library. What is asserted instead is that every client leaves mid-turn, the
turn carries on in an empty room, and a client joining later reconstructs the part it
was absent for from the journal.
See [`test/claims/outlives_clients_test.exs`](test/claims/outlives_clients_test.exs).

**The work can live on another machine.**
Weak version: "the session process is still alive", which is true of any `GenServer`
that runs work somewhere else. What is asserted instead is that a machine taken away
mid-turn becomes an error result and a `:hands_changed` event, the turn still reaches
an end, the session id and history are untouched, and a replacement machine picks up
the next tool call.
See [`test/claims/hands_test.exs`](test/claims/hands_test.exs).

**IO and CPU at the same time.**
Tools start the moment the mind asks for them, not after the mind stops talking. So
tokens keep arriving while a tool burns real CPU, two tools asked for together finish
in parallel rather than in sequence, and `Palaver.info/1` still answers mid-turn.
See [`test/claims/concurrency_test.exs`](test/claims/concurrency_test.exs).

## Running it

```console
$ mix test
```

Tests that need a second machine are tagged `:distributed`. When Erlang distribution
cannot start, [`test/test_helper.exs`](test/test_helper.exs) excludes them and says so
loudly, rather than failing a wall of tests or quietly pretending the claim was
checked.

```console
$ cd demo && mix deps.get && mix palaver.demo
```

The walkthrough narrates six steps of one conversation: a turn streamed over real
server-sent events, tokens still arriving while a tool burns CPU, a tool recompiled
mid-talk, the work moved to a second machine, that machine taken away mid-turn, and a
replacement picking up. The session id is printed at every step and never changes.
Nothing is downloaded, no key is needed, and no model is involved.

## What it does not do

There are no file, shell, or editor tools, because a conversation runtime that ships
those has quietly become a coding agent. There is no provider catalogue, no evaluation
harness, and no plugin marketplace. Those are guests you bring.

Two honest limits worth stating plainly:

- **Distribution is coordination, not containment.** Moving a tool to another node says
  nothing about what that code may do once it arrives; it can still open a port or shell
  out. A real boundary is an operating-system concern and deliberately out of scope.
- **Reload here is in-node reload.** The session state migration runs through `:sys`,
  not through an appup release upgrade, and a module recompiled in one VM is not shipped
  to the nodes running your tools.

## Bringing your own mind

```elixir
defmodule MyMind do
  @behaviour Palaver.Mind

  @impl true
  def stream(%{messages: messages, tools: tools}, _opts, sink) do
    # sink.({:token, "some text"})
    # sink.({:tool_calls, [%{id: "1", name: "echo", args: %{"text" => "hi"}}]})
    :ok
  end
end
```

A working adapter for any OpenAI-compatible endpoint lives in
[`demo/lib/palaver_demo/mind/http.ex`](demo/lib/palaver_demo/mind/http.ex). It is short
enough to read in one sitting and meant to be copied. It lives in the demo rather than
in the library because provider wire formats change on somebody else's schedule, and
absorbing that churn is a recurring tax rather than a property of the runtime.
