defmodule Corex.Positioning do
  @moduledoc """
  Positioning options for floating elements (popovers, dropdowns, etc.)

  Maps to Zag.js `PositioningOptions` interface. Use `to_dataset/1` to merge
  flat `data-position-*` attributes for hooks and `readPositioningOptions/1` in
  the TypeScript client.
  """

  defstruct hide_when_detached: true,
            strategy: "fixed",
            placement: "bottom",
            gutter: 8,
            shift: 0,
            overflow_padding: 0,
            arrow_padding: 4,
            flip: true,
            slide: true,
            overlap: false,
            same_width: false,
            fit_viewport: true

  @type t :: %__MODULE__{
          hide_when_detached: boolean(),
          strategy: String.t(),
          placement: String.t(),
          gutter: integer(),
          shift: integer(),
          overflow_padding: integer(),
          arrow_padding: integer(),
          flip: boolean() | list(String.t()),
          slide: boolean(),
          overlap: boolean(),
          same_width: boolean(),
          fit_viewport: boolean()
        }

  @spec to_dataset(t() | nil) :: %{String.t() => String.t() | nil}
  def to_dataset(nil), do: %{}

  def to_dataset(%__MODULE__{} = p) do
    %{
      "data-position-strategy" => p.strategy,
      "data-position-placement" => p.placement,
      "data-position-gutter" => to_string(p.gutter),
      "data-position-shift" => to_string(p.shift),
      "data-position-overflow-padding" => to_string(p.overflow_padding),
      "data-position-arrow-padding" => to_string(p.arrow_padding),
      "data-position-flip" => encode_flip(p.flip),
      "data-position-slide" => bool_str(p.slide),
      "data-position-overlap" => bool_str(p.overlap),
      "data-position-same-width" => bool_str(p.same_width),
      "data-position-fit-viewport" => bool_str(p.fit_viewport),
      "data-position-hide-when-detached" => bool_str(p.hide_when_detached)
    }
  end

  defp bool_str(true), do: "true"
  defp bool_str(false), do: "false"
  defp bool_str(_), do: nil

  defp encode_flip(value) when is_boolean(value), do: bool_str(value)
  defp encode_flip(value) when is_list(value), do: Enum.join(value, ",")
  defp encode_flip(_), do: nil
end
