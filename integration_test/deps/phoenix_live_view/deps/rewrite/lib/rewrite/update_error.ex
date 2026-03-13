defmodule Rewrite.UpdateError do
  @moduledoc """
  An exception for when a function can not handle a source.
  """

  alias Rewrite.UpdateError

  @type reason :: :nopath | :overwrites | :filetype

  @type t :: %UpdateError{
          reason: reason,
          source: Path.t(),
          path: Path.t() | nil
        }

  @enforce_keys [:reason]
  defexception [:reason, :source, :path]

  @impl true
  def exception(value) do
    struct!(UpdateError, value)
  end

  @impl true
  def message(%UpdateError{reason: :nopath, source: source}) do
    "#{format(source)}: no path in updated source"
  end

  def message(%UpdateError{reason: :overwrites, source: source, path: path}) do
    "#{format(source)}: updated source overwrites #{inspect(path)}"
  end

  defp format(source), do: "can't update source #{inspect(source)}"
end
