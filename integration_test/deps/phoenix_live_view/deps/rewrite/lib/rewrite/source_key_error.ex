defmodule Rewrite.SourceKeyError do
  @moduledoc """
  An exception for when a key can't be found in a source.
  """

  alias Rewrite.SourceKeyError

  @enforce_keys [:key]
  defexception [:key]

  @impl true
  def exception(value) do
    struct!(SourceKeyError, value)
  end

  @impl true
  def message(%SourceKeyError{key: key}) do
    """
    key #{inspect(key)} not found in source. This function is just definded for \
    the keys :content, :path and keys provided by filetype.\
    """
  end
end
