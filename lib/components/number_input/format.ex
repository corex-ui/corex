defmodule Corex.NumberInput.Format do
  @moduledoc false

  @max_fraction_digits 10

  @spec format_display(term(), number()) :: String.t()
  def format_display(value, step \\ 1.0)

  def format_display(nil, _step), do: ""
  def format_display("", _step), do: ""

  def format_display(value, step) when is_binary(value) do
    trimmed = String.trim(value)

    if trimmed == "" do
      ""
    else
      case parse_number(trimmed) do
        {:ok, n} -> format_display(n, step)
        :error -> trimmed
      end
    end
  end

  def format_display(value, step) when is_integer(value), do: format_display(value * 1.0, step)

  def format_display(value, step) when is_float(value), do: format_numeric(value, step)

  def format_display(value, step), do: format_display(to_string(value), step)

  @spec format_submit(term(), number()) :: String.t()
  def format_submit(value, step \\ 1.0)

  def format_submit(nil, _step), do: ""
  def format_submit("", _step), do: ""

  def format_submit(value, step) when is_binary(value) do
    trimmed = String.trim(value)

    if trimmed == "" do
      ""
    else
      case parse_number(trimmed) do
        {:ok, n} -> format_submit(n, step)
        :error -> trimmed
      end
    end
  end

  def format_submit(value, step) when is_integer(value), do: format_submit(value * 1.0, step)

  def format_submit(value, step) when is_float(value), do: format_submit_numeric(value, step)

  def format_submit(value, step), do: format_submit(to_string(value), step)

  defp format_numeric(n, step) do
    case fraction_digits_for_step(step) do
      nil -> format_whole_step(n)
      digits -> format_fractional_step(n, digits)
    end
  end

  defp format_submit_numeric(n, step) do
    case fraction_digits_for_step(step) do
      nil -> format_submit_whole_step(n)
      digits -> format_submit_fractional_step(n, digits)
    end
  end

  defp format_whole_step(n) when n == trunc(n) do
    n |> trunc() |> Integer.to_string() |> add_grouping()
  end

  defp format_whole_step(n) do
    n
    |> float_to_compact_string()
    |> trim_trailing_zeros()
    |> apply_grouping_to_decimal_string()
  end

  defp format_submit_whole_step(n) when n == trunc(n) do
    n |> trunc() |> Integer.to_string()
  end

  defp format_submit_whole_step(n) do
    n |> float_to_compact_string() |> trim_trailing_zeros()
  end

  defp format_fractional_step(n, digits) do
    n
    |> Float.round(digits)
    |> :erlang.float_to_binary(decimals: digits)
    |> trim_trailing_zeros()
    |> apply_grouping_to_decimal_string()
  end

  defp format_submit_fractional_step(n, digits) do
    n
    |> Float.round(digits)
    |> :erlang.float_to_binary(decimals: digits)
    |> trim_trailing_zeros()
  end

  defp apply_grouping_to_decimal_string(str) do
    case String.split(str, ".") do
      [int, frac] -> add_grouping(int) <> "." <> frac
      [int] -> add_grouping(int)
    end
  end

  defp add_grouping(int_str) do
    {sign, digits} =
      case int_str do
        "-" <> rest -> {"-", rest}
        "+" <> rest -> {"", rest}
        other -> {"", other}
      end

    sign <> group_digits(digits)
  end

  defp group_digits(digits) do
    digits
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
    |> Enum.map_join(",", &Enum.join/1)
  end

  defp fraction_digits_for_step(step) when is_number(step) do
    if step == trunc(step) do
      nil
    else
      step
      |> float_to_compact_string()
      |> fraction_digits_from_string()
    end
  end

  defp fraction_digits_from_string(str) do
    case String.split(str, ".") do
      [_int, frac] -> min(String.length(frac), @max_fraction_digits)
      _ -> 0
    end
  end

  defp float_to_compact_string(float) do
    :erlang.float_to_binary(float, [:compact, decimals: @max_fraction_digits])
  end

  defp trim_trailing_zeros(str) do
    str
    |> String.replace(~r/\.0+$/, "")
    |> String.replace(~r/(\.\d*?)0+$/, "\\1")
    |> String.trim_trailing(".")
  end

  defp parse_number(str) do
    normalized =
      str
      |> String.replace(",", "")
      |> String.trim()

    case Float.parse(normalized) do
      {n, ""} -> {:ok, n}
      _ -> :error
    end
  end
end
