defmodule PalaverDemo.Cluster do
  @moduledoc """
  Enough distribution to hand work to another machine and take it away again.

  Deliberately not part of the library: starting nodes is the operator's job, and
  Palaver only needs to be told which node to use.
  """

  @host ~c"127.0.0.1"

  @spec ensure_distribution() :: {:ok, node()} | {:error, term()}
  def ensure_distribution do
    if Node.alive?() do
      {:ok, node()}
    else
      ensure_epmd()

      case Node.start(:"palaver_demo@127.0.0.1", :longnames) do
        {:ok, _pid} -> {:ok, node()}
        {:error, {:already_started, _pid}} -> {:ok, node()}
        {:error, reason} -> {:error, reason}
      end
    end
  end

  @spec start_peer(String.t()) :: {:ok, pid(), node()} | {:error, term()}
  def start_peer(prefix) do
    name = "#{prefix}_#{System.unique_integer([:positive])}"
    args = Enum.flat_map(:code.get_path(), &[~c"-pa", &1])

    case :peer.start(%{
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

  @spec stop_peer(pid()) :: :ok
  def stop_peer(pid) do
    :peer.stop(pid)
  catch
    :exit, _reason -> :ok
  end

  defp ensure_epmd do
    System.cmd("epmd", ["-daemon"])
    Process.sleep(100)
    :ok
  rescue
    _error -> :ok
  end
end
