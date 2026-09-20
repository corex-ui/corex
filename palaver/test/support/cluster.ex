defmodule Palaver.Test.Cluster do
  @moduledoc false

  @host ~c"127.0.0.1"

  @doc """
  Bring this node up as a distributed node, starting epmd if nobody else has.

  Returns `{:error, reason}` rather than raising, so a sandbox without working
  distribution degrades into skipped tests with a loud reason instead of a wall
  of failures.
  """
  @spec ensure_distribution() :: {:ok, node()} | {:error, term()}
  def ensure_distribution do
    if Node.alive?() do
      {:ok, node()}
    else
      ensure_epmd()
      start_node()
    end
  end

  @doc "Start a peer node that can load this project's modules."
  @spec start_peer(String.t()) :: {:ok, pid(), node()} | {:error, term()}
  def start_peer(name) do
    args = Enum.flat_map(:code.get_path(), &[~c"-pa", &1])

    case :peer.start_link(%{
           name: String.to_charlist(name),
           host: @host,
           args: args,
           longnames: true,
           wait_boot: 20_000
         }) do
      {:ok, pid, node} ->
        {:ok, _apps} = :erpc.call(node, Application, :ensure_all_started, [:palaver])
        {:ok, pid, node}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc "Stop a peer node the way a machine going away looks to its callers."
  @spec stop_peer(pid()) :: :ok
  def stop_peer(pid) when is_pid(pid) do
    :peer.stop(pid)
  catch
    :exit, _reason -> :ok
  end

  @doc "A peer name unique to this run."
  @spec unique_name(String.t()) :: String.t()
  def unique_name(prefix) do
    "#{prefix}_#{System.unique_integer([:positive])}"
  end

  defp ensure_epmd do
    System.cmd("epmd", ["-daemon"])
    Process.sleep(100)
    :ok
  rescue
    _error -> :ok
  end

  defp start_node do
    case Node.start(:"palaver_test@127.0.0.1", :longnames) do
      {:ok, _pid} -> {:ok, node()}
      {:error, {:already_started, _pid}} -> {:ok, node()}
      {:error, reason} -> {:error, reason}
    end
  end
end
