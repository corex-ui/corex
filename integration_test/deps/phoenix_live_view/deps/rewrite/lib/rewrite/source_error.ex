defmodule Rewrite.SourceError do
  @moduledoc """
  An exception for when a function can not handle a source.
  """

  alias Rewrite.SourceError

  @type reason :: :nopath | :changed | File.posix()
  @type action :: :rm
  @type path :: nil | Path.t()

  @type t :: %SourceError{reason: reason, action: action, path: path}

  @enforce_keys [:reason, :action]
  defexception [:reason, :path, :action]

  @impl true
  def exception(value) do
    struct!(SourceError, value)
  end

  @impl true
  def message(%SourceError{reason: :nopath, action: action}) do
    "could not #{format(action)}: no path found"
  end

  def message(%SourceError{reason: :changed, action: action, path: path}) do
    "could not #{format(action)} #{inspect(path)}: file changed since reading"
  end

  def message(%SourceError{reason: posix, action: action, path: path}) do
    """
    could not #{format(action)} #{inspect(path)}\
    : #{IO.iodata_to_binary(:file.format_error(posix))}\
    """
  end

  def format(action) do
    case action do
      :rm -> "remove file"
      :write -> "write to file"
    end
  end
end
