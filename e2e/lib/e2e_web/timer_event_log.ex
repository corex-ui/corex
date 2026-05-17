defmodule E2eWeb.TimerEventLog do
  @moduledoc false

  def format_value(params) when is_map(params) do
    case Map.get(params, "formattedTime") do
      ft when is_map(ft) -> format_formatted_time(ft)
      ft when is_binary(ft) -> ft
      _ -> format_raw_value(Map.get(params, "value"))
    end
  end

  def format_value(_), do: ""

  defp format_formatted_time(ft) do
    parts =
      for key <- ["hours", "minutes", "seconds"] do
        ft |> Map.get(key, "00") |> to_string()
      end

    Enum.join(parts, ":")
  end

  defp format_raw_value(value) when is_integer(value), do: Integer.to_string(value)
  defp format_raw_value(value) when is_binary(value), do: value
  defp format_raw_value(_), do: ""
end
