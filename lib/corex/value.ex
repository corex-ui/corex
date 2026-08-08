defmodule Corex.Value do
  @moduledoc false

  @typedoc """
  A value an imperative API accepts without narrowing it first.

  Any term, because the guard is deliberately absent: these functions coerce and
  warn, so a spec that named only the useful shapes would claim a check the
  function does not perform.
  """
  @type coercible :: term()

  @doc """
  Coerces a value to a list of strings, warning and returning `[]` otherwise.
  """
  @spec coerce_string_list(term(), String.t()) :: [String.t()]
  def coerce_string_list(value, context) when is_list(value) do
    if Enum.all?(value, &is_binary/1) do
      value
    else
      warn_bad_value(context, value)
    end
  end

  def coerce_string_list(value, context), do: warn_bad_value(context, value)

  @doc """
  Coerces a value to a list of strings silently, for internal callers that
  already reported the problem or have no context to report it with.
  """
  @spec coerce_string_list(term()) :: [String.t()]
  def coerce_string_list(value) when is_list(value) do
    if Enum.all?(value, &is_binary/1), do: value, else: []
  end

  def coerce_string_list(_value), do: []

  @doc """
  Parses an imperative API value that may arrive as a list or a delimited string.

  With `graphemes: true` a string without commas is split per grapheme, which is
  what pin input expects. Anything unparseable is coerced to `[]` with a warning.
  """
  @spec parse_string_list(term(), String.t(), keyword()) :: [String.t()]
  def parse_string_list(value, context, opts \\ [])

  def parse_string_list(value, context, _opts) when is_list(value) do
    coerce_string_list(value, context)
  end

  def parse_string_list(value, context, opts) when is_binary(value) do
    value |> String.trim() |> parse_trimmed(context, opts)
  end

  def parse_string_list(value, context, _opts), do: coerce_string_list(value, context)

  defp parse_trimmed("", _context, _opts), do: []

  defp parse_trimmed(trimmed, context, opts) do
    cond do
      String.contains?(trimmed, ",") -> split_csv(trimmed, context)
      Keyword.get(opts, :graphemes, false) -> String.graphemes(trimmed)
      true -> split_csv(trimmed, context)
    end
  end

  defp split_csv(trimmed, context) do
    trimmed
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> coerce_string_list(context)
  end

  @doc """
  Coerces a single-selection value to a string or `nil`, warning on anything else.
  """
  @spec coerce_string_value(term(), String.t()) :: String.t() | nil
  def coerce_string_value(nil, _context), do: nil
  def coerce_string_value(value, _context) when is_binary(value), do: value

  def coerce_string_value(value, context) do
    Corex.Dev.warn(
      "#{context}: value must be a string or nil, got: #{inspect(value)}; ignoring it"
    )

    nil
  end

  @spec value_error(term()) :: String.t()
  def value_error(value), do: "value must be a list of strings, got: #{inspect(value)}"

  defp warn_bad_value(context, value) do
    Corex.Dev.warn("#{context}: #{value_error(value)}; ignoring it")
    []
  end
end
