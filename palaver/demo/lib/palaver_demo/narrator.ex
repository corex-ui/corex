defmodule PalaverDemo.Narrator do
  @moduledoc """
  Prints a conversation as it happens.

  Tokens are written inline so streaming looks like streaming; everything else
  gets its own line. The session id is printed at every step because the whole
  point of the walkthrough is that it never changes.
  """

  alias Palaver.Event

  @spec heading(pos_integer(), String.t()) :: :ok
  def heading(number, title) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "#{number}. #{title}"]))
  end

  @spec note(String.t()) :: :ok
  def note(text), do: IO.puts(IO.ANSI.format([:faint, "   " <> text]))

  @spec standing(Palaver.talk()) :: :ok
  def standing(talk) do
    info = Palaver.info(talk)

    note(
      "session #{info.session_id} | events #{info.seq} | history #{info.history_length} | tools #{Enum.join(info.tools, ", ")} | hands #{inspect(info.hands)}"
    )
  end

  @doc "Print events until the turn ends."
  @spec follow(timeout()) :: :ok
  def follow(timeout \\ 60_000), do: follow_until([:turn_done, :turn_halted], timeout)

  @doc """
  Print events until one of `types` shows up, then hand control back.

  Used to interrupt a turn at a precise moment, such as killing a machine while
  a tool is genuinely still running on it.
  """
  @spec follow_until([Event.type()], timeout()) :: :ok
  def follow_until(types, timeout \\ 60_000) do
    receive do
      {:palaver, %Event{} = event} ->
        print(event)

        if event.type in types do
          :ok
        else
          follow_until(types, timeout)
        end
    after
      timeout ->
        line("   ... nothing more arrived")
    end
  end

  defp print(%Event{type: :turn_started, payload: payload}) do
    line(~s(   you: "#{payload.prompt}"))
  end

  defp print(%Event{type: :token, payload: payload}) do
    if Process.get(:narrating_tokens) != true do
      IO.write("   mind: ")
      Process.put(:narrating_tokens, true)
    end

    IO.write(payload.text)
  end

  defp print(%Event{type: :tool_call, payload: payload}) do
    line(
      "   calls #{payload.name}(#{inspect(payload.args)}) with hands #{inspect(payload.hands)}"
    )
  end

  defp print(%Event{type: :tool_result, payload: payload}) do
    line("   #{payload.name} via #{payload.hands} answered #{inspect(payload.result)}")
  end

  defp print(%Event{type: :plugin_changed, payload: payload}) do
    line("   tools are now #{inspect(payload.tools)} (#{inspect(Map.get(payload, :schema))})")
  end

  defp print(%Event{type: :hands_changed, payload: payload}) do
    line("   hands #{payload.status}: #{inspect(payload.hands)} #{inspect(payload.reason)}")
  end

  defp print(%Event{type: :mind_error, payload: payload}) do
    line("   the mind failed: #{inspect(payload.reason)}")
  end

  defp print(%Event{type: :turn_done, payload: payload}) do
    line("   turn finished after #{payload.steps} step(s)")
  end

  defp print(%Event{type: :turn_halted, payload: payload}) do
    line("   turn halted: #{inspect(payload.reason)}")
  end

  # Tokens are written without newlines, so anything else has to close the line
  # they were streaming onto.
  defp line(text) do
    if Process.get(:narrating_tokens) == true do
      IO.write("\n")
      Process.put(:narrating_tokens, false)
    end

    IO.puts(text)
  end
end
