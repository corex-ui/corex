defmodule Corex.Icon do
  @moduledoc ~S'''
  Sizing wrapper for inline icons (heroicons, images, or SVG).

  Sets a text scale on the host; children `[data-icon]`, `svg`, and `img` fill a
  matching 1em box.

  ```heex
  <.icon text="xs">
    <.heroicon name="hero-link" />
  </.icon>

  <.icon text="xs">
    <img src={~p"/images/tech/zag.webp"} alt="" decoding="async" />
  </.icon>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    kind: :layout,
    base: "icon",
    axes: [:text]

  slot(:inner_block, required: true)

  @doc type: :component
  def icon(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <span class={@design.class} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end
end
