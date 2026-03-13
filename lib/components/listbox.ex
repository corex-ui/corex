defmodule Corex.Listbox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Listbox](https://zagjs.com/components/react/listbox).

  ## Examples

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.listbox
    id="my-listbox"
    class="listbox"
    items={[
      %{label: "France", id: "fra", disabled: true},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ]}
  >
    <:label>Choose a country</:label>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.listbox>
  ```

  ### Grouped

  ```heex
  <.listbox
    class="listbox"
    items={[
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
    <:label>Choose a country</:label>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.listbox>
  ```

  ### Custom

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack).
  Use the `:item` slot with `:let={%{item: entry}}` to access the entry map.

  ```heex
  <.listbox
    class="listbox"
    items={[
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ]}
  >
    <:label>
      Country of residence
    </:label>
    <:item :let={%{item: entry}}>
      <Flagpack.flag name={String.to_atom(entry.id)} />
      {entry.label}
    </:item>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.listbox>
  ```

  ### Custom Grouped

  ```heex
  <.listbox
    class="listbox"
    items={[
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "South Korea", id: "kor", group: "Asia"}
    ]}
  >
    <:item :let={%{item: entry}}>
      <Flagpack.flag name={String.to_atom(entry.id)} />
      {entry.label}
    </:item>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.listbox>
  ```

  ### Stream

  Use with `Phoenix.LiveView.stream/3` to add or remove items dynamically. Keep a list in sync with the stream and pass it as `items`. The listbox uses `phx-update="ignore"` and updates via `data-items`; the JS hook rebuilds the list when items change.

  For actions inside the `:item` slot (e.g. a remove button), use `data-phx-push` and `data-phx-push-id` so the listbox hook can delegate clicks to LiveView:

  ```heex
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:items, dom_id: &"listbox:my-listbox:item:#{&1.id}")
     |> stream(:items, @initial_items)
     |> assign(:items_list, @initial_items)}
  end

  def render(assigns) do
    ~H"""
    <.listbox id="my-listbox" class="listbox" items={@items_list}>
      <:label>Choose an item</:label>
      <:empty>No items</:empty>
      <:item :let={%{item: entry}}>
        <span class="flex items-center justify-between gap-2 w-full">
          <span class="flex items-center gap-2">
            <.action
              phx-click={JS.push("remove_item", value: %{id: entry.id})}
              data-phx-push="remove_item"
              data-phx-push-id={entry.id}
              class="button button--sm"
            >
              <.heroicon name="hero-trash" />
            </.action>
            <span>{entry.label}</span>
          </span>
        </span>
      </:item>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.listbox>
    """
  end

  def handle_event("remove_item", %{"id" => id}, socket) do
    item = Enum.find(socket.assigns.items_list, &(&1.id == id))
    if item do
      {:noreply,
       socket
       |> stream_delete(:items, item)
       |> assign(:items_list, List.delete(socket.assigns.items_list, item))}
    else
      {:noreply, socket}
    end
  end
  ```

  <!-- tabs-close -->

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="listbox"][data-part="root"] {}
  [data-scope="listbox"][data-part="content"] {}
  [data-scope="listbox"][data-part="item"] {}
  [data-scope="listbox"][data-part="item-text"] {}
  [data-scope="listbox"][data-part="item-indicator"] {}
  [data-scope="listbox"][data-part="item-group"] {}
  [data-scope="listbox"][data-part="item-group-label"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `listbox` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/listbox.css";
  ```

  You can then use modifiers

  ```heex
  <.listbox class="listbox listbox--accent listbox--lg" items={[]}>
  </.listbox>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/listbox#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Listbox.Anatomy.{
    Content,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    Props,
    Root,
    ValueText
  }

  alias Corex.Listbox.Connect

  import Corex.Helpers,
    only: [
      validate_value!: 1,
      normalize_items: 1,
      normalize_groups: 1,
      has_groups?: 1,
      entry_value: 1,
      entry_selected?: 2
    ]

  attr(:id, :string, required: false, doc: "The id of the listbox")

  attr(:items, :list,
    required: true,
    doc: "List of Corex.List.Item or maps with id/value, label, disabled, group"
  )

  attr(:value, :list, default: [], doc: "Selected value(s)")
  attr(:controlled, :boolean, default: false, doc: "Whether the listbox is controlled")
  attr(:disabled, :boolean, default: false, doc: "Whether the listbox is disabled")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Text direction")

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation of items"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus within the listbox")

  attr(:selection_mode, :string,
    default: "single",
    values: ["single", "multiple", "extended"],
    doc: "How items can be selected"
  )

  attr(:select_on_highlight, :boolean,
    default: false,
    doc: "Select item when highlighted via keyboard"
  )

  attr(:deselectable, :boolean, default: false, doc: "Whether selection can be cleared")
  attr(:typeahead, :boolean, default: false, doc: "Enable typeahead search")
  attr(:on_value_change, :string, default: nil, doc: "Server event name on value change")
  attr(:on_value_change_client, :string, default: nil, doc: "Client event name on value change")
  attr(:aria_label, :string, default: nil, doc: "Accessible name when no label slot is provided")
  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :item, required: false do
    attr(:class, :string, required: false)
  end

  slot :item_indicator, required: false do
    attr(:class, :string, required: false)
  end

  slot :empty, required: false do
    attr(:class, :string, required: false)
  end

  def listbox(assigns) do
    items = normalize_items(assigns.items)
    has_groups = has_groups?(items)
    groups = normalize_groups(items)

    assigns =
      assigns
      |> assign_new(:id, fn -> "listbox-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:value, validate_value!(assigns[:value] || []))
      |> assign(:items, items)
      |> assign(:has_groups, has_groups)
      |> assign(:groups, groups)

    ~H"""
    <div
      id={@id}
      phx-hook="Listbox"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        items: @items,
        value: @value,
        controlled: @controlled,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
        loop_focus: @loop_focus,
        selection_mode: @selection_mode,
        select_on_highlight: @select_on_highlight,
        deselectable: @deselectable,
        typeahead: @typeahead,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
         <label {Connect.label(%Label{id: @id, dir: @dir})}>
          <%= if @label != [] do %>
            {render_slot(@label)}
          <% else %>
            {@aria_label}
          <% end %>
        </label>
        <span {Connect.value_text(%ValueText{id: @id})} />
        <div {content_attrs(@id, @dir, @orientation, @label != [] || @aria_label != nil)}>
          <div :if={@items == [] && @empty != []} data-scope="listbox" data-part="empty">
            <%= render_slot(@empty) %>
          </div>
          <div :for={group_id <- @groups} {Connect.item_group(%ItemGroup{id: @id, group_id: group_id})}>
            <div {Connect.item_group_label(%ItemGroupLabel{id: @id, html_for: group_id})}>{group_id}</div>
            <div :for={entry <- Enum.filter(@items, &(&1.group == group_id))} {item_attrs(@id, entry)}>
              <span :if={@item == []} {Connect.item_text(%ItemText{id: @id, item: entry})}>{entry[:label]}</span>
              <%= for item_slot <- @item || [] do %>
                <%= render_slot(item_slot, %{item: entry, value: entry_value(entry), label: entry[:label]}) %>
              <% end %>
              <span
                {Connect.item_indicator(%ItemIndicator{id: @id, item: entry})}
                hidden={!entry_selected?(entry, @value)}
              >
                <%= if @item_indicator != [] do %>
                  <%= render_slot(@item_indicator) %>
                <% end %>
              </span>
            </div>
          </div>
          <div :for={entry <- if(@has_groups, do: [], else: @items)} {item_attrs(@id, entry)}>
            <span :if={@item == []} {Connect.item_text(%ItemText{id: @id, item: entry})}>{entry[:label]}</span>
            <%= for item_slot <- @item || [] do %>
              <%= render_slot(item_slot, %{item: entry, value: entry_value(entry), label: entry[:label]}) %>
            <% end %>
            <span
              {Connect.item_indicator(%ItemIndicator{id: @id, item: entry})}
              hidden={!entry_selected?(entry, @value)}
            >
              <%= if @item_indicator != [] do %>
                <%= render_slot(@item_indicator) %>
              <% end %>
            </span>
          </div>
        </div>
      </div>
      <div style="display: none;" data-templates="listbox">
        <div :if={@empty != []} data-scope="listbox" data-part="empty" data-template="true">
          <%= render_slot(@empty) %>
        </div>
        <div :for={group_id <- @groups} {Connect.item_group(%ItemGroup{id: @id, group_id: group_id})} data-template="true">
          <div {Connect.item_group_label(%ItemGroupLabel{id: @id, html_for: group_id})}>{group_id}</div>
          <div :for={entry <- Enum.filter(@items, &(&1.group == group_id))} {item_attrs(@id, entry)} data-template="true">
            <span :if={@item == []} {Connect.item_text(%ItemText{id: @id, item: entry})}>{entry[:label]}</span>
            <%= for item_slot <- @item || [] do %>
              <%= render_slot(item_slot, %{item: entry, value: entry_value(entry), label: entry[:label]}) %>
            <% end %>
            <span
              {Connect.item_indicator(%ItemIndicator{id: @id, item: entry})}
              hidden={!entry_selected?(entry, @value)}
            >
              <%= if @item_indicator != [] do %>
                <%= render_slot(@item_indicator) %>
              <% end %>
            </span>
          </div>
        </div>
        <div :for={entry <- if(@has_groups, do: [], else: @items)} {item_attrs(@id, entry)} data-template="true">
          <span :if={@item == []} {Connect.item_text(%ItemText{id: @id, item: entry})}>{entry[:label]}</span>
          <%= for item_slot <- @item || [] do %>
            <%= render_slot(item_slot, %{item: entry, value: entry_value(entry), label: entry[:label]}) %>
          <% end %>
          <span
            {Connect.item_indicator(%ItemIndicator{id: @id, item: entry})}
            hidden={!entry_selected?(entry, @value)}
          >
            <%= if @item_indicator != [] do %>
              <%= render_slot(@item_indicator) %>
            <% end %>
          </span>
        </div>
      </div>
    </div>
    """
  end

  defp content_attrs(id, dir, orientation, has_label) do
    Connect.content(%Content{id: id, dir: dir})
    |> Map.put("data-layout", "list")
    |> Map.put("data-orientation", orientation)
    |> then(fn attrs ->
      if has_label, do: Map.put(attrs, "aria-labelledby", "listbox:#{id}:label"), else: attrs
    end)
  end

  defp item_attrs(id, entry) do
    base = Connect.item(%Item{id: id, item: entry, value: entry_value(entry)})

    if Map.get(entry, :disabled) do
      base
      |> Map.put("data-disabled", "")
      |> Map.put("aria-disabled", "true")
    else
      base
    end
  end
end
