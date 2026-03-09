defmodule Corex.DataList do
  @moduledoc ~S'''
  Renders a list with data based on Phoenix Core Components.
  '''

  @doc type: :component
  use Phoenix.Component

  attr(:rest, :global, doc: "Additional attributes for the root element")

  @doc """
  Renders a list with data.

  ## Examples

      <.data_list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Views">{@post.views}</:item>
      </.data_list>
  """
  slot :item, required: true do
    attr(:title, :string, required: true)
    attr(:class, :string, required: false)
  end

  def data_list(assigns) do
    ~H"""
    <div {@rest}>
      <ul data-scope="data-list" data-part="root">
        <li :for={item <- @item} data-scope="data-list" data-part="item">
          <div data-scope="data-list" data-part="content">
            <div data-scope="data-list" data-part="title">{item.title}</div>
            <div>{render_slot(item)}</div>
          </div>
        </li>
      </ul>
    </div>
    """
  end
end
