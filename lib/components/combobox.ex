defmodule Corex.Combobox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Combobox](https://zagjs.com/components/react/combobox).

  <!-- tabs-open -->

  ### Minimal

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", disabled: true},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
      </.combobox>
  ```

  ### Grouped

  ```heex
  <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Netherlands", id: "nld", group: "Europe"},
          %{label: "Switzerland", id: "che", group: "Europe"},
          %{label: "Austria", id: "aut", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"},
          %{label: "South Korea", id: "kor", group: "Asia"},
          %{label: "Thailand", id: "tha", group: "Asia"},
          %{label: "USA", id: "usa", group: "North America"},
          %{label: "Canada", id: "can", group: "North America"},
          %{label: "Mexico", id: "mex", group: "North America"}
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
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
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

  ### Extended Grouped

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"},
          %{label: "South Korea", id: "kor", group: "Asia"}
        ]}
      >
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
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
  - `[data-scope="combobox"][data-part="item-group"]` - Group container
  - `[data-scope="combobox"][data-part="item-group-label"]` - Group label
  - `[data-scope="combobox"][data-part="item"]` - Item wrapper
  - `[data-scope="combobox"][data-part="item-text"]` - Item text
  - `[data-scope="combobox"][data-part="item-indicator"]` - Optional indicator
  '''

  @doc type: :component
  use Phoenix.Component
  alias Corex.Combobox.Connect
  alias Corex.Combobox.Anatomy.{Props, Root, Label, Control, Input, Positioner, Content}

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

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name to trigger on open change"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on open change"
  )

  attr(:bubble, :boolean, default: false, doc: "Whether the client events are bubbled")
  attr(:disabled, :boolean, default: false, doc: "Whether the combobox is disabled")
  attr(:open, :boolean, default: false, doc: "Whether the combobox is open")
  attr(:value, :list, default: [], doc: "The value of the combobox")

  attr(:placeholder, :string, default: nil, doc: "The placeholder of the combobox")

  attr(:always_submit_on_enter, :boolean,
    default: false,
    doc: "Whether to always submit on enter"
  )

  attr(:auto_focus, :boolean, default: false, doc: "Whether to auto focus the combobox")
  attr(:close_on_select, :boolean, default: true, doc: "Whether to close the combobox on select")
  attr(:dir, :string, default: "ltr", doc: "The direction of the combobox")

  attr(:input_behavior, :string,
    default: "autohighlight",
    doc: "The input behavior of the combobox"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus the combobox")
  attr(:multiple, :boolean, default: false, doc: "Whether to allow multiple selection")
  attr(:invalid, :boolean, default: false, doc: "Whether the combobox is invalid")
  attr(:name, :string, doc: "The name of the combobox")
  attr(:read_only, :boolean, default: false, doc: "Whether the combobox is read only")
  attr(:required, :boolean, default: false, doc: "Whether the combobox is required")

  attr(:on_input_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on input value change"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on value change"
  )

  attr(:same_width, :boolean,
    default: true,
    doc: "Whether the combobox is the same width as the trigger"
  )

  attr(:fit_viewport, :boolean,
    default: false,
    doc: "Whether the combobox is the same width as the trigger"
  )

  attr(:flip, :boolean, default: true, doc: "Whether the combobox is flipped")

  attr(:hide_when_detached, :boolean,
    default: true,
    doc: "Whether the combobox is hidden when detached"
  )

  attr(:strategy, :string, default: "absolute", doc: "The strategy of the combobox")
  attr(:placement, :string, default: "bottom", doc: "The placement of the combobox")
  attr(:offset_main_axis, :integer, default: 0, doc: "The offset main axis of the combobox")
  attr(:offset_cross_axis, :integer, default: 0, doc: "The offset cross axis of the combobox")
  attr(:gutter, :integer, default: 0, doc: "The gutter of the combobox")
  attr(:shift, :integer, default: 0, doc: "The shift of the combobox")
  attr(:overflow_padding, :integer, default: 0, doc: "The overflow padding of the combobox")
  attr(:rest, :global)

  slot(:label, required: false, doc: "The label content")
  slot(:trigger, required: true, doc: "The trigger button content")
  slot(:clear_trigger, required: false, doc: "The clear button content")
  slot(:item_indicator, required: false, doc: "Optional indicator for selected items")

  slot(:item,
    required: false,
    doc: "Custom content for each item. Receives the item as :let binding"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:country]. Automatically sets id, name, value, and errors from the form field"
  )

  def combobox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = field.errors || []

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign(
      :value,
      if field.value do
        [field.value]
      else
        []
      end
    )
    |> combobox()
  end

  def combobox(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "combobox-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)

    # Group items by their group field
    grouped_items = Enum.group_by(assigns.collection, &Map.get(&1, :group))
    has_groups = Map.has_key?(grouped_items, nil) == false or map_size(grouped_items) > 1

    assigns = assign(assigns, :grouped_items, grouped_items)
    assigns = assign(assigns, :has_groups, has_groups)

    ~H"""
    <div id={@id} phx-hook="Combobox" {@rest} {Connect.props(%Props{
      id: @id, collection: @collection, controlled: @controlled, placeholder: @placeholder, value: @value,
      always_submit_on_enter: @always_submit_on_enter, auto_focus: @auto_focus, close_on_select: @close_on_select,
      dir: @dir, input_behavior: @input_behavior, loop_focus: @loop_focus, multiple: @multiple, invalid: @invalid,
     name: @name, read_only: @read_only, required: @required,
      on_open_change: @on_open_change, on_open_change_client: @on_open_change_client, on_input_value_change: @on_input_value_change, on_value_change: @on_value_change,
      open: @open, same_width: @same_width, fit_viewport: @fit_viewport, flip: @flip, hide_when_detached: @hide_when_detached,
      bubble: @bubble, disabled: @disabled
    })}>
      <div {Connect.root(%Root{id: @id, changed: if(@__changed__, do: true, else: false), invalid: @invalid, read_only: @read_only})}>
      <div :if={!Enum.empty?(@label)} {Connect.label(%Label{id: @id, changed: if(@__changed__, do: true, else: false), invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir})}>
        {render_slot(@label)}
      </div>
      <div {Connect.control(%Control{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, invalid: @invalid, open: @open, dir: @dir, disabled: @disabled})}>
          <input {Connect.input(%Input{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, invalid: @invalid, open: @open, dir: @dir, disabled: @disabled, required: @required, placeholder: @placeholder, name: @name, auto_focus: @auto_focus})} />
          <button :if={!Enum.empty?(@clear_trigger)} data-scope="combobox" data-part="clear-trigger">
            {render_slot(@clear_trigger)}
          </button>
          <button data-scope="combobox" data-part="trigger">
            {render_slot(@trigger)}
          </button>
        </div>

        <div {Connect.positioner(%Positioner{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, dir: @dir})}>
          <ul {Connect.content(%Content{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, dir: @dir, open: @open})}>
                <div :if={@has_groups} :for={{group, items} <- @grouped_items} data-scope="combobox" data-part="item-group" data-id={group || "default"}>
                  <div :if={group} data-scope="combobox" data-part="item-group-label" data-id={group}>
                    {group}
                  </div>
                  <li :for={item <- items} data-scope="combobox" data-part="item" data-value={item.id}>
                    <span :if={!Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                      {render_slot(@item, item)}
                    </span>
                    <span :if={Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                      {item.label}
                    </span>
                    <span :if={!Enum.empty?(@item_indicator)} data-scope="combobox" data-part="item-indicator">
                      {render_slot(@item_indicator)}
                    </span>
                  </li>
                </div>

              <li :if={!@has_groups} :for={item <- @collection} data-scope="combobox" data-part="item" data-value={item.id}>
                <span :if={!Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                  {render_slot(@item, item)}
                </span>
                <span :if={Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                  {item.label}
                </span>
                <span :if={!Enum.empty?(@item_indicator)} data-scope="combobox" data-part="item-indicator">
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
