defmodule Mix.Tasks.Palaver.Demo do
  @shortdoc "Watch one conversation refuse to die"

  @moduledoc """
  A narrated walkthrough of a single conversation.

  Five steps, one session id. A provider-shaped HTTP server starts on a local
  port and streams real server-sent events, a tool is recompiled underneath the
  running talk, the work moves to a second machine, and then that machine is
  taken away mid-turn. The session id is printed throughout; it never changes.

      mix palaver.demo

  Nothing is downloaded, no key is needed, and no model is involved.
  """

  use Mix.Task

  alias PalaverDemo.Cluster
  alias PalaverDemo.FakeProvider
  alias PalaverDemo.Narrator
  alias PalaverDemo.Tools

  @requirements ["app.start"]

  @impl Mix.Task
  def run(_args) do
    Code.put_compiler_option(:ignore_module_conflict, true)

    distribution = Cluster.ensure_distribution()
    port = start_provider()
    talk = open_talk(port)
    {:ok, _info} = Palaver.subscribe(talk)

    banner(port)

    first_turn(talk)
    talk_while_working(talk)
    swap_the_tool(talk)

    case distribution do
      {:ok, _node} ->
        peer = move_the_work(talk)
        take_the_machine_away(talk, peer)

      {:error, reason} ->
        Narrator.heading(4, "Move the work to another machine")
        Narrator.note("skipped: distribution could not start (#{inspect(reason)})")
    end

    closing(talk)
  end

  defp banner(port) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "A palaver"]))

    Narrator.note(
      "a provider-shaped server is streaming on http://localhost:#{port}; no model, no key"
    )

    Narrator.note("this conversation lives on #{node()}")
  end

  defp first_turn(talk) do
    Narrator.heading(1, "A turn, streaming over HTTP")
    Narrator.note("the mind asks for a tool, the tool answers, the mind sums up")
    Narrator.standing(talk)

    :ok = Palaver.prompt(talk, "please use greeting to say hello")
    Narrator.follow()
    Narrator.standing(talk)
  end

  defp talk_while_working(talk) do
    Narrator.heading(2, "Keep talking while the work happens")
    Narrator.note("the tool burns real CPU; watch tokens arrive before it answers")

    :ok = Palaver.prompt(talk, "please burn while you keep talking")
    Narrator.follow()
    Narrator.standing(talk)
  end

  defp swap_the_tool(talk) do
    Narrator.heading(3, "Swap the tool underneath the talk")
    Narrator.note("recompiling PalaverDemo.Tools.Greeting in place, mid-conversation")

    Code.compile_string("""
    defmodule PalaverDemo.Tools.Greeting do
      @behaviour Palaver.Plugin
      def name, do: "greeting"
      def schema, do: %{"type" => "object", "properties" => %{"text" => %{"type" => "string"}}, "version" => 2}
      def call(args, _context), do: {:ok, "GOOD DAY (v2): " <> String.upcase(Map.get(args, "text", ""))}
    end
    """)

    :ok = Palaver.load_plugin(talk, Tools.Greeting)

    :ok = Palaver.prompt(talk, "please use greeting to say hello again")
    Narrator.follow()
    Narrator.standing(talk)
    Narrator.note("same session, same history, different code")
  end

  defp move_the_work(talk) do
    Narrator.heading(4, "Move the work to another machine")

    {:ok, peer, peer_node} = Cluster.start_peer("palaver_hands")
    Narrator.note("started #{peer_node}, and pointing hands at it")

    :ok = Palaver.set_hands(talk, {:node, peer_node})

    :ok = Palaver.prompt(talk, "please use which_node")
    Narrator.follow()
    Narrator.standing(talk)
    Narrator.note("the conversation stayed on #{node()}; the tool did not")

    peer
  end

  defp take_the_machine_away(talk, peer) do
    Narrator.heading(5, "Take the machine away mid-turn")
    Narrator.note("asking for a slow tool, then killing the machine while it runs")

    :ok = Palaver.prompt(talk, "please burn for a while")
    Narrator.follow_until([:tool_call])

    Cluster.stop_peer(peer)
    Narrator.follow()

    Narrator.note("the talk is still here, so give it new hands")
    {:ok, _replacement, replacement_node} = Cluster.start_peer("palaver_hands_again")
    :ok = Palaver.set_hands(talk, {:node, replacement_node})

    :ok = Palaver.prompt(talk, "please use which_node")
    Narrator.follow()
    Narrator.standing(talk)
  end

  defp closing(talk) do
    info = Palaver.info(talk)

    Narrator.heading(6, "What survived")
    Narrator.note("session id #{info.session_id}, unchanged from the first line of output")
    Narrator.note("#{info.history_length} messages, #{info.seq} events, never restarted")
    IO.puts("")
  end

  defp open_talk(port) do
    {:ok, talk} =
      Palaver.open(
        mind: {PalaverDemo.Mind.Http, base_url: "http://localhost:#{port}"},
        plugins: [Tools.Greeting, Tools.WhichNode, Tools.Burn],
        tool_timeout: 60_000
      )

    talk
  end

  defp start_provider do
    port = free_port()

    {:ok, _pid} =
      Bandit.start_link(
        plug: {FakeProvider, token_delay: 45},
        scheme: :http,
        port: port,
        startup_log: false
      )

    port
  end

  defp free_port do
    {:ok, socket} = :gen_tcp.listen(0, [:binary, active: false])
    {:ok, port} = :inet.port(socket)
    :gen_tcp.close(socket)
    port
  end
end
