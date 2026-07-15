defmodule Corex.Animation do
  @moduledoc """
  Web Animations tuning for Corex components when `animation` is `js`.

  ### Dialog (scale)

      <.dialog
        id="confirm"
        animation={:js}
        animation_config={%Corex.Animation.Scale{duration: 0.2}}
        ...
      >

  ### Accordion / tree-view (height)

      <.accordion
        id="faq"
        animation={:js}
        animation_config={%Corex.Animation.Height{duration: 0.25}}
        ...
      >

  See `Corex.Animation.Scale` and `Corex.Animation.Height` for fields.
  """
end
