defmodule Palaver.Test.Plugins do
  @moduledoc false

  defmodule Fast do
    @moduledoc false
    @behaviour Palaver.Plugin

    @impl true
    def name, do: "fast"

    @impl true
    def schema, do: %{type: "object", properties: %{}}

    @impl true
    def call(_args, _context), do: {:ok, "fast"}
  end

  defmodule Burn do
    @moduledoc false
    @behaviour Palaver.Plugin

    @impl true
    def name, do: "burn"

    @impl true
    def schema, do: %{type: "object", properties: %{"ms" => %{type: "integer"}}}

    @impl true
    def call(args, _context) do
      ms = Map.get(args, "ms", 100)
      burn_until(System.monotonic_time(:millisecond) + ms)
      {:ok, "burned #{ms}ms"}
    end

    # Real CPU, not a sleep: a sleeping process proves nothing about whether the
    # conversation can keep streaming while work is happening.
    defp burn_until(deadline) do
      if System.monotonic_time(:millisecond) < deadline do
        :erlang.phash2(:crypto.strong_rand_bytes(64))
        burn_until(deadline)
      else
        :ok
      end
    end
  end

  defmodule WhichNode do
    @moduledoc false
    @behaviour Palaver.Plugin

    @impl true
    def name, do: "which_node"

    @impl true
    def schema, do: %{type: "object", properties: %{}}

    @impl true
    def call(_args, context), do: {:ok, to_string(context.node)}
  end

  defmodule Boom do
    @moduledoc false
    @behaviour Palaver.Plugin

    @impl true
    def name, do: "boom"

    @impl true
    def schema, do: %{type: "object", properties: %{}}

    @impl true
    def call(_args, _context), do: raise("boom")
  end
end
