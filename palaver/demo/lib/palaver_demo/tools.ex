defmodule PalaverDemo.Tools do
  @moduledoc """
  Three tools, chosen for what they prove rather than for being useful.

  There is no file tool, no shell tool, and no editor, because a conversation
  runtime that ships those has quietly become a coding agent.
  """

  defmodule Greeting do
    @moduledoc """
    The tool the walkthrough recompiles while the conversation is open.

    Version 1 is what ships. The walkthrough replaces this module in place and
    the next turn picks up the replacement.
    """

    @behaviour Palaver.Plugin

    @impl true
    def name, do: "greeting"

    @impl true
    def schema do
      %{
        "type" => "object",
        "properties" => %{"text" => %{"type" => "string"}},
        "version" => 1
      }
    end

    @impl true
    def call(args, _context) do
      {:ok, "hello (v1): " <> Map.get(args, "text", "")}
    end
  end

  defmodule WhichNode do
    @moduledoc "Reports the machine it ran on, which is the only honest way to prove it moved."

    @behaviour Palaver.Plugin

    @impl true
    def name, do: "which_node"

    @impl true
    def schema, do: %{"type" => "object", "properties" => %{}}

    @impl true
    def call(_args, context), do: {:ok, to_string(context.node)}
  end

  defmodule Burn do
    @moduledoc "Occupies a scheduler for a while, so the talk has something to keep talking over."

    @behaviour Palaver.Plugin

    @impl true
    def name, do: "burn"

    @impl true
    def schema do
      %{"type" => "object", "properties" => %{"ms" => %{"type" => "integer"}}}
    end

    @impl true
    def call(args, _context) do
      ms = Map.get(args, "ms", 2_500)
      burn_until(System.monotonic_time(:millisecond) + ms)
      {:ok, "burned #{ms}ms"}
    end

    defp burn_until(deadline) do
      if System.monotonic_time(:millisecond) < deadline do
        :erlang.phash2(:crypto.strong_rand_bytes(64))
        burn_until(deadline)
      else
        :ok
      end
    end
  end
end
