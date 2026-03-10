defmodule Corex.Layout.Heading do
  use Phoenix.Component

  attr(:rest, :global)

  slot :title
  slot :subtitle
  slot :actions

  def layout_heading(assigns) do
    ~H"""
    <div data-scope="layout-heading" data-part="root" {@rest}>
      <div :if={@title != [] or @subtitle != []} data-scope="layout-heading" data-part="content">
        <h1 :if={@title != []} data-scope="layout-heading" data-part="title">{render_slot(@title)}</h1>
        <h2 :if={@subtitle != []} data-scope="layout-heading" data-part="subtitle">{render_slot(@subtitle)}</h2>
      </div>
      <div :if={@actions != []} data-scope="layout-heading" data-part="actions">
        {render_slot(@actions)}
      </div>
    </div>
    """
  end
end
