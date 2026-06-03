defmodule Corex.Animation do
  @moduledoc """
  Namespace for Web Animations API tuning.

  - `Corex.Animation.Scale`  -  dialog: opacity and scale.
  - `Corex.Animation.Height`  -  accordion and tree-view: opacity and height.
  """

  defmodule Height do
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

    @spec closed_style(t()) :: String.t()
    def closed_style(%__MODULE__{} = a) do
      "height:0;overflow:hidden;opacity:#{a.opacity_start}"
    end

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

  defmodule Scale do
    @moduledoc """
    Web Animations config for **dialog** when `animation` is `js`:
    **opacity** and **transform scale** on the `content` node; **opacity only** on the **backdrop** (handled in the hook).
    No height keyframes, no translate.

    `to_dataset/1` is merged on the host only for `js`. Custom `animation` does not use this on the server; the hook may still apply an optional lock using client defaults when the `data-anim-scale-*` attributes are absent.

    Set `block_interaction` to `false` to allow pointer input on the dialog shell during the built-in WAAPI transition.
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

    @spec closed_style(t(), keyword()) :: String.t()
    def closed_style(%__MODULE__{} = a, scale: scale?) do
      opacity = "opacity:#{a.opacity_start}"

      if scale? do
        "#{opacity};transform:scale(#{a.scale_start})"
      else
        opacity
      end
    end

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
end
