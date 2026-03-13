defmodule Rewrite.Error do
  @moduledoc """
  An exception for when a function cannot handle a source.
  """

  alias Rewrite.Error
  alias Rewrite.Source

  @type reason :: :nosource | :nopath | :overwrites | :invalid_sources

  @type t :: %Error{
          reason: reason,
          path: Path.t() | nil,
          missing_paths: [Source.t()] | nil,
          duplicated_paths: [Source.t()] | nil,
          message: String.t() | nil
        }

  @enforce_keys [:reason]
  defexception [:reason, :path, :missing_paths, :duplicated_paths, :message]

  @impl true
  def exception(value) do
    struct!(Error, value)
  end

  @impl true
  def message(%Error{message: message}) when is_binary(message) do
    message
  end

  def message(%Error{reason: :nopath}) do
    "no path found"
  end

  def message(%Error{reason: :nosource, path: path}) do
    "no source found for #{inspect(path)}"
  end

  def message(%Error{reason: :overwrites, path: path}) do
    "overwrites #{inspect(path)}"
  end

  def message(%Error{reason: :invalid_sources}) do
    "invalid sources"
  end
end
