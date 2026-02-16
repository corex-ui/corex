defmodule Corex.Listbox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Listbox](https://zagjs.com/components/react/listbox).

  ## Examples

  ### Basic

  ```heex
  <.listbox
    id="lb"
    collection={Corex.List.new([ [label: "A"], [label: "B"], [label: "C"] ])}
    class="listbox">
    <:label>Choose</:label>
  </.listbox>
  ```

  ## Styling

  Use data attributes: `[data-scope="listbox"][data-part="root"]`, `content`, `item`, `item-text`, `item-indicator`, `item-group`, `item-group-label`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Listbox.Anatomy.{
    Props,
    Root,
    Label,
    ValueText,
    Input,
    Content,
    ItemGroup,
    ItemGroupLabel,
    Item,
    ItemText,
    ItemIndicator
  }

  alias Corex.Listbox.Connect
  import Corex.Helpers, only: [validate_value!: 1]

  attr(:id, :string, required: false)

  attr(:collection, :list,
    required: true,
    doc: "List of Corex.List.Item or maps with id/value, label, disabled, group"
  )

  attr(:value, :list, default: [], doc: "Selected value(s)")
  attr(:controlled, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])
  attr(:loop_focus, :boolean, default: false)
  attr(:selection_mode, :string, default: "single", values: ["single", "multiple", "extended"])
  attr(:select_on_highlight, :boolean, default: false)
  attr(:deselectable, :boolean, default: false)
  attr(:typeahead, :boolean, default: false)
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:rest, :global)

  slot(:label, required: false)
  slot(:item, required: false)

  def listbox(assigns) do
    items = normalize_collection(assigns.collection)
    has_groups = Enum.any?(items, &Map.get(&1, :group))

    groups =
      if has_groups,
        do: items |> Enum.map(& &1.group) |> Enum.uniq() |> Enum.reject(&is_nil/1),
        else: []

    assigns =
      assigns
      |> assign_new(:id, fn -> "listbox-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:value, validate_value!(assigns[:value] || []))
      |> assign(:collection, items)
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
        collection: @collection,
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
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <span {Connect.value_text(%ValueText{id: @id})} />
        <input type="hidden" {Connect.input(%Input{id: @id})} />
        <div {Connect.content(%Content{id: @id, dir: @dir})}>
          <div :for={group_id <- @groups} {Connect.item_group(%ItemGroup{id: @id, group_id: group_id})}>
            <div {Connect.item_group_label(%ItemGroupLabel{id: @id, html_for: group_id})}>{group_id}</div>
            <div :for={entry <- Enum.filter(@items, &(&1.group == group_id))} {Connect.item(%Item{id: @id, item: entry, value: entry_value(entry)})}>
              <span :if={@item == []} {Connect.item_text(%ItemText{id: @id, item: entry})}>{entry[:label]}</span>
              <span :if={@item == []} {Connect.item_indicator(%ItemIndicator{id: @id, item: entry})} />
              <%= for item_slot <- @item || [] do %>
                <%= render_slot(item_slot, %{item: entry, value: entry_value(entry), label: entry[:label]}) %>
              <% end %>
            </div>
          </div>
          <div :for={entry <- if(@has_groups, do: [], else: @items)} {Connect.item(%Item{id: @id, item: entry, value: entry_value(entry)})}>
            <span :if={@item == []} {Connect.item_text(%ItemText{id: @id, item: entry})}>{entry[:label]}</span>
            <span :if={@item == []} {Connect.item_indicator(%ItemIndicator{id: @id, item: entry})} />
            <%= for item_slot <- @item || [] do %>
              <%= render_slot(item_slot, %{item: entry, value: entry_value(entry), label: entry[:label]}) %>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp entry_value(entry) do
    to_string(
      Map.get(entry, :value) || Map.get(entry, :id) || Map.get(entry, "value") ||
        Map.get(entry, "id") || ""
    )
  end

  defp normalize_collection(items) when is_list(items) do
    Enum.map(items, fn
      %Corex.List.Item{} = item ->
        %{
          id: item.id,
          value: item.id,
          label: item.label,
          disabled: item.disabled,
          group: item.group
        }

      m when is_map(m) ->
        %{
          id: Map.get(m, :id),
          value: Map.get(m, :value) || Map.get(m, :id),
          label: Map.get(m, :label),
          disabled: !!Map.get(m, :disabled),
          group: Map.get(m, :group)
        }
    end)
  end
end
