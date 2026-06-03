defmodule Corex.Layout.Box do
  @moduledoc ~S'''
  A primitive block container with optional padding and radius.

  ```heex
  <.box padding="lg" radius="md">Content</.box>
  ```

  The host element is configurable with `tag` (default `div`). Layout attr values
  are Corex design shorthand per axis (for example `padding="lg"`), not Tailwind
  classes. Allowed steps come from your app config; see [Unstyled](unstyled.html).
  '''
  use Phoenix.Component

  use Corex.Variants,
    kind: :layout,
    base: "box",
    axes: [padding: :space, radius: [:none, :sm, :md, :lg, :xl, :"2xl", :full]],
    defaults: [padding: "none"]

  attr(:tag, :string, default: "div", doc: "The host HTML element.")
  slot(:inner_block, required: true)

  @doc type: :component
  def box(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest}>
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end
end
