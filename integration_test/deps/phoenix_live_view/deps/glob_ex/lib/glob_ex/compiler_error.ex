defmodule GlobEx.CompileError do
  @moduledoc """
  An exception raised when the compilation of a glob expression fails.
  """

  alias GlobEx.CompileError

  @type reason :: :emtpy | :invalid

  @type t :: %CompileError{reason: reason(), input: String.t()}

  defexception [:reason, input: ""]

  @impl true
  def message(%CompileError{reason: reason}) do
    case reason do
      :empty -> "invalid empty glob"
      {:missing_delimiter, pos} -> "missing terminator for delimiter opened at #{pos}"
    end
  end
end
