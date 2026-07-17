defmodule Corex.Animation.Scale do
  @moduledoc """
  Dialog open/close animation when `animation` is `js` (opacity + scale).

      <.dialog
        id="confirm"
        animation={:js}
        animation_config={%Corex.Animation.Scale{duration: 0.2}}
      >

  Set `block_interaction` to `false` to allow pointer input during the transition.
  """

  defstruct duration: 0.3,
            easing: "ease",
            opacity_start: 0.0,
            opacity_end: 1.0,
            scale_start: 0.96,
            scale_end: 1.0,
            block_interaction: false

  @type t :: %__MODULE__{
          duration: float(),
          easing: String.t(),
          opacity_start: float(),
          opacity_end: float(),
          scale_start: float(),
          scale_end: float(),
          block_interaction: boolean()
        }

  @doc false
  @spec to_dataset(t()) :: %{String.t() => term()}
  def to_dataset(%__MODULE__{} = a) do
    base = %{
      "data-anim-scale-duration" => a.duration,
      "data-anim-scale-easing" => a.easing,
      "data-anim-scale-opacity-start" => a.opacity_start,
      "data-anim-scale-opacity-end" => a.opacity_end,
      "data-anim-transform-scale-start" => a.scale_start,
      "data-anim-transform-scale-end" => a.scale_end
    }

    if a.block_interaction,
      do: base,
      else: Map.put(base, "data-anim-scale-block-interaction", "false")
  end
end
