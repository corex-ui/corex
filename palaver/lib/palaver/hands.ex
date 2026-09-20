defmodule Palaver.Hands do
  @moduledoc """
  Where tools actually run.

  `:local` runs a tool in a throwaway process on the same node as the
  conversation. `{:node, node}` runs it on another node entirely, which is the
  whole point: the conversation keeps the history and the credentials, and
  something else does the work.

  This is coordination, not containment. Moving execution to another node says
  nothing about what that code is allowed to do once it arrives; a tool can
  still open a port or shell out. A real boundary is an operating system
  concern and deliberately not in scope here.
  """

  @type t :: :local | {:node, node()}

  @doc false
  @spec valid?(term()) :: boolean()
  def valid?(:local), do: true
  def valid?({:node, node}) when is_atom(node), do: true
  def valid?(_other), do: false

  @doc false
  @spec describe(t()) :: node()
  def describe(:local), do: node()
  def describe({:node, node}), do: node

  @doc """
  Run a plugin and normalize every possible outcome into a tuple.

  Public because remote hands reach it through `:erpc`, so it has to be callable
  on the far node. A plugin that raises, throws, or exits becomes an `:error`
  result rather than a crash, so a bad tool costs the turn a step and not the
  conversation.
  """
  @spec invoke(module(), map(), Palaver.Plugin.context()) :: {:ok, term()} | {:error, term()}
  def invoke(plugin, args, context) when is_atom(plugin) and is_map(args) do
    case plugin.call(args, %{context | node: node()}) do
      {:ok, result} -> {:ok, result}
      {:error, reason} -> {:error, reason}
      other -> {:error, {:bad_return, other}}
    end
  rescue
    exception -> {:error, {:exception, Exception.message(exception)}}
  catch
    :throw, value -> {:error, {:throw, value}}
    :exit, reason -> {:error, {:exit, reason}}
  end

  @doc false
  @spec run(t(), module(), map(), Palaver.Plugin.context(), timeout()) ::
          {:ok, term()} | {:error, term()}
  def run(:local, plugin, args, context, _timeout) do
    invoke(plugin, args, context)
  end

  def run({:node, node}, plugin, args, context, timeout) do
    :erpc.call(node, __MODULE__, :invoke, [plugin, args, context], timeout)
  catch
    :error, {:erpc, reason} -> {:error, {:hands_unreachable, reason}}
    :error, reason -> {:error, {:hands_failed, reason}}
    :exit, reason -> {:error, {:hands_failed, reason}}
  end
end
