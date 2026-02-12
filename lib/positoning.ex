defmodule Corex.Positioning do
  @moduledoc """
  Positioning options for floating elements (popovers, dropdowns, etc.)

  Maps to Zag.js PositioningOptions interface.
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
            same_width: true,
            fit_viewport: false

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
end
