defmodule Corex.Animation.Height do
  @moduledoc """
  Accordion and tree-view panel animation when `animation` is `js` (opacity + height).

      <.accordion
        id="faq"
        animation={:js}
        animation_config={%Corex.Animation.Height{duration: 0.25}}
      >

  Set `block_interaction` to `false` to allow pointer input while a panel animates.
  """

  defstruct duration: 0.3,
            easing: "ease",
            opacity_start: 0.0,
            opacity_end: 1.0,
            block_interaction: false

  @type t :: %__MODULE__{
          duration: float(),
          easing: String.t(),
          opacity_start: float(),
          opacity_end: float(),
          block_interaction: boolean()
        }

  @doc false
  @spec to_dataset(t()) :: %{String.t() => term()}
  def to_dataset(%__MODULE__{} = a) do
    base = %{
      "data-anim-height-duration" => a.duration,
      "data-anim-height-easing" => a.easing,
      "data-anim-height-opacity-start" => a.opacity_start,
      "data-anim-height-opacity-end" => a.opacity_end
    }

    if a.block_interaction,
      do: base,
      else: Map.put(base, "data-anim-height-block-interaction", "false")
  end
end
