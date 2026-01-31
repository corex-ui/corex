defmodule Corex.Combobox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Combobox](https://zagjs.com/components/react/combobox).

  <!-- tabs-open -->

  ### Minimal

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.combobox
    class="combobox"
    collection={[
      %{label: "France", code: "fra"},
      %{label: "Belgium", code: "bel"},
      %{label: "Germany", code: "deu"},
      %{label: "Netherlands", code: "nld"},
      %{label: "Switzerland", code: "che"},
      %{label: "Austria", code: "aut"}
    ]}
  >
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
  </.combobox>
  ```

  ### Extended

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
    <.combobox
    class="combobox"
    collection={[
      %{label: "France", code: "fra"},
      %{label: "Belgium", code: "bel"},
      %{label: "Germany", code: "deu"},
      %{label: "Netherlands", code: "nld"},
      %{label: "Switzerland", code: "che"},
      %{label: "Austria", code: "aut"}
    ]}
  >
    <:item :let={item}>
      <Flagpack.flag name={String.to_atom(item.code)} />
      {item.label}
    </:item>
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
    <:clear_trigger>
      <.icon name="hero-backspace" />
    </:clear_trigger>
    <:item_indicator>
      <.icon name="hero-check" />
    </:item_indicator>
  </.combobox>
  ```
  <!-- tabs-close -->

  ## Styling

  Use data attributes to target elements:
  - `[data-scope="combobox"][data-part="root"]` - Container
  - `[data-scope="combobox"][data-part="control"]` - Control wrapper
  - `[data-scope="combobox"][data-part="input"]` - Input field
  - `[data-scope="combobox"][data-part="trigger"]` - Trigger button
  - `[data-scope="combobox"][data-part="clear-trigger"]` - Clear button
  - `[data-scope="combobox"][data-part="content"]` - Dropdown content
  - `[data-scope="combobox"][data-part="item"]` - Item wrapper
  - `[data-scope="combobox"][data-part="item-text"]` - Item text
  - `[data-scope="combobox"][data-part="item-indicator"]` - Optional indicator
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Accordion.Anatomy.{Props, Root, Item}
  alias Corex.Accordion.Connect

  @doc """
  Renders a combobox component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the combobox, useful for API to identify the combobox"
  )

  attr(:collection, :list,
    default: [],
    doc: "The collection of items to display in the combobox"
  )

  attr(:controlled, :boolean, default: false, doc: "Whether the combobox is controlled")

  attr(:rest, :global)

  slot(:trigger, required: true, doc: "The trigger button content")
  slot(:clear_trigger, required: false, doc: "The clear button content")
  slot(:item_indicator, required: false, doc: "Optional indicator for selected items")
  slot(:item, required: false, doc: "Custom content for each item. Receives the item as :let binding")

  def combobox(assigns) do
    assigns =
      assign_new(assigns, :id, fn -> "combobox-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} phx-hook="Combobox" {@rest} data-collection={Jason.encode!(@collection)}>
      <div data-scope="combobox" data-part="root">
        <div data-scope="combobox" data-part="control">
          <input data-scope="combobox" data-part="input" />
          <button :if={!Enum.empty?(@clear_trigger)} data-scope="combobox" data-part="clear-trigger">
            {render_slot(@clear_trigger)}
          </button>
          <button data-scope="combobox" data-part="trigger">
            {render_slot(@trigger)}
          </button>
        </div>

        <div data-scope="combobox" data-part="positioner">
          <ul data-scope="combobox" data-part="content">
            <li :for={item <- @collection} data-scope="combobox" data-part="item" data-value={item.code}>
              <span :if={!Enum.empty?(@item)} data-scope="combobox" data-part="item-text">

                {render_slot(@item, item)}
                </span>
                <span :if={Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                  {item.label}
                </span>
              <span :if={{!Enum.empty?(@item_indicator)}} data-scope="combobox" data-part="item-indicator">
                {render_slot(@item_indicator)}
              </span>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
