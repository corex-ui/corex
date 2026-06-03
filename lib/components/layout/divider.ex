defmodule Corex.Layout.Divider do
  @moduledoc ~S'''
  A horizontal or vertical separator line using the border token.

  ```heex
  <.divider />
  <.divider orientation="vertical" />
  ```

  Defaults to a semantic `<hr>` host for horizontal dividers. Pass an explicit
  `tag` and `aria-orientation` when rendering a vertical divider inside a row.
  The `orientation` vocabulary and default come from the `:divider` layout recipe.
  '''
  use Phoenix.Component

  use Corex.Variants,
    kind: :layout,
    base: "divider",
    axes: [orientation: :orientation],
    defaults: [orientation: "horizontal"]

  attr(:tag, :string, default: "hr", doc: "The host HTML element.")

  @doc type: :component
  def divider(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest} />
    """
  end
end
