defmodule E2eWeb.ComponentEventLog do
  @moduledoc false

  alias Corex.AngleSlider.Connect, as: AngleConnect
  alias Corex.Slider.Connect, as: SliderConnect

  @doc """
  Formats slider/angle-slider event values for display.

  Avoids `inspect/1`, which prints one-element integer lists as charlists
  (e.g. `[75]` becomes ~c"K" when the thumb is at 75).
  """
  @spec format_numeric_value(term()) :: String.t()
  def format_numeric_value(value) when is_list(value) do
    SliderConnect.value_text_string(value)
  end

  def format_numeric_value(value) when is_number(value) do
    SliderConnect.format_number(value)
  end

  def format_numeric_value(value) when is_binary(value) do
    case SliderConnect.value_text_string(SliderConnect.effective_values(value)) do
      text when text != "" -> text
      _ -> value
    end
  end

  def format_numeric_value(value) do
    inspect(value, charlists: :as_lists)
  end

  @doc false
  @spec format_angle_value(term()) :: String.t()
  def format_angle_value(value) when is_number(value) do
    AngleConnect.format_number(value)
  end

  def format_angle_value(value) when is_list(value) do
    value
    |> List.first()
    |> case do
      n when is_number(n) -> AngleConnect.format_number(n)
      _ -> format_numeric_value(value)
    end
  end

  def format_angle_value(value), do: format_numeric_value(value)
end
