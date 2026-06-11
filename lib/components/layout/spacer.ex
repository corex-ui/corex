defmodule Corex.Layout.Spacer do
  @moduledoc ~S'''
  A flexible spacer that pushes siblings apart inside a flex container.

  ```heex
  <.row>
    <div>Left</div>
    <.spacer />
    <div>Right</div>
  </.row>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    kind: :layout,
    base: "spacer",
    axes: []

  attr(:tag, :string, default: "div", doc: "The host HTML element.")

  @doc type: :component
  def spacer(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest} />
    """
  end
end
