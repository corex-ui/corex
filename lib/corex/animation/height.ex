defmodule Corex.Animation.Height do
  @moduledoc """
  Web Animations config for **accordion** and **tree-view** panel open/close:
  **opacity** and **height** (scrollHeight) keyframes, no scale.

  `to_dataset/1` is merged on the host only for `js`. Custom `animation` does not use this on the server; the hook may still apply an optional root pointer lock with client defaults when the `data-anim-height-*` attributes are absent.

  Set `block_interaction` to `false` to allow pointer input on the component root while a panel animates; default `true` blocks until the built-in WAAPI transition finishes.
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
