defmodule Rewrite.Filetype do
  @moduledoc """
  The behaviour for filetypes.

  An implementation of the filetype behaviour extends a source. For an example,
  see `Rewrite.Source.Ex`.
  """

  alias Rewrite.Source

  @type t :: map()
  @type updates :: keyword()
  @type key :: atom()
  @type value :: term()
  @type updater :: (term() -> term())
  @type extension :: String.t()
  @type opts :: keyword()

  @doc """
  Returns a list of file type extensions for which the module is responsible.
  """
  @callback extensions :: [extension] | :any

  @doc """
  Returns the default path for the `filetype`.
  """
  @callback default_path :: Path.t()

  @doc """
  Returns a `Rewrite.Source` with a `filetype` from the given `string`.
  """
  @callback from_string(string :: Source.content()) :: Source.t()
  @doc """
  Returns a `Rewrite.Source` with a `filetype` form the given, `string` and `options`.
  """
  @callback from_string(string :: Source.content(), opts()) :: Source.t()

  @doc """
  Returns a `Rewrite.Source` with a `filetype` from a file.
  """
  @callback read!(path :: Path.t()) :: Source.t()
  @doc """
  Returns a `Rewrite.Source` with a `filetype` from a file.
  """
  @callback read!(path :: Path.t(), opts()) :: Source.t()

  @doc """
  This function is called after an undo of the `source`.
  """
  @callback undo(source :: Source.t()) :: Source.t()

  @doc """
  This function is called when the content or path of the `source` is updated.

  Returns a `%Source{}` with an updated `filetype`.
  """
  @callback handle_update(source :: Source.t(), key(), opts()) :: t()

  @doc """
  This function is called when the `source` is updated by a `key` that is
  handled by the current `filetype`.

  Returns a keyword with the keys `:content` and `:filetype` to update the
  `source`.
  """
  @callback handle_update(source :: Source.t(), key(), value() | updater(), opts()) :: updates()

  @doc """
  Fetches the value for a specific `key` for the given `source`.

  If `source` contains the given `key` then its value is returned in the shape
  of {:ok, value}. If `source` doesn't contain key, :error is returned.
  """
  @callback fetch(source :: Source.t(), key()) :: value()

  @doc """
  Fetches the value for a specific `key` in a `source` for the given `version`.

  If `source` contains the given `key` then its value is returned in the shape
  of {:ok, value}. If `source` doesn't contain key, :error is returned.
  """
  @callback fetch(source :: Source.t(), key(), version :: Source.version()) :: value()
end
