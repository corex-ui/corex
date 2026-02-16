defmodule Corex.RadioGroup do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Radio Group](https://zagjs.com/components/react/radio-group).

  ## Examples

  ### Basic

  ```heex
  <.radio_group id="rg" name="choice" items={[["1", "Option A"], ["2", "Option B"]]} class="radio-group">
    <:label>Choose one</:label>
  </.radio_group>
  ```

  Items can be a list of `{value, label}` tuples or a list of maps with `:value`, `:label`, and optional `:disabled`, `:invalid`.

  Optional `:item_control` slot renders the check indicator for each item (e.g. `<.icon name="hero-check" class="data-checked" />`). When omitted, no indicator is shown.

  ## Styling

  Use data attributes: `[data-scope="radio-group"][data-part="root"]`, `label`, `indicator`, `item`, `item-text`, `item-control`, `item-hidden-input`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.RadioGroup.Anatomy.{
    Props,
    Root,
    Label,
    Indicator,
    Item,
    ItemText,
    ItemControl,
    ItemHiddenInput
  }

  alias Corex.RadioGroup.Connect

  attr(:id, :string, required: false)
  attr(:value, :string, default: nil)
  attr(:default_value, :string, default: nil)
  attr(:controlled, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:form, :string, default: nil)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)

  attr(:items, :list,
    required: true,
    doc: "List of [value, label] or %{value: ..., label: ..., disabled: ..., invalid: ...}"
  )

  attr(:rest, :global)

  slot(:label, required: false)
  slot(:item_control, required: false)
  slot(:item, required: false)

  def radio_group(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "radio-group-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:items, normalize_items(assigns.items))

    ~H"""
    <div
      id={@id}
      phx-hook="RadioGroup"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        controlled: @controlled,
        name: @name,
        form: @form,
        disabled: @disabled,
        invalid: @invalid,
        required: @required,
        read_only: @read_only,
        dir: @dir,
        orientation: @orientation,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, has_label: @label != []})}>
        <div :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </div>
        <div {Connect.indicator(%Indicator{id: @id, dir: @dir})} />
        <label :if={@item == []} :for={entry <- @items} {Connect.item(%Item{
          id: @id,
          value: entry.value,
          disabled: entry.disabled,
          invalid: entry.invalid,
          checked: @value == entry.value
        })}>
          <span {Connect.item_text(%ItemText{id: @id, value: entry.value, disabled: entry.disabled, invalid: entry.invalid})}>{entry.label}</span>
          <div {Connect.item_control(%ItemControl{id: @id, value: entry.value, disabled: entry.disabled, invalid: entry.invalid, checked: @value == entry.value})}>
            {render_slot(@item_control)}
          </div>
          <input {Connect.item_hidden_input(%ItemHiddenInput{
            id: @id,
            value: entry.value,
            disabled: entry.disabled,
            invalid: entry.invalid,
            name: @name,
            form: @form,
            checked: @value == entry.value
          })} />
        </label>
        <label :if={@item != []} :for={entry <- @items} {Connect.item(%Item{
          id: @id,
          value: entry.value,
          disabled: entry.disabled,
          invalid: entry.invalid,
          checked: @value == entry.value
        })}>
          <%= for item_slot <- @item || [] do %>
            <%= render_slot(item_slot, %{
              value: entry.value,
              label: entry.label,
              disabled: entry.disabled,
              invalid: entry.invalid,
              checked: @value == entry.value
            }) %>
          <% end %>
        </label>
      </div>
    </div>
    """
  end

  defp normalize_items(items) when is_list(items) do
    Enum.map(items, fn
      {value, label} ->
        %{value: to_string(value), label: to_string(label), disabled: false, invalid: false}

      [value, label] ->
        %{value: to_string(value), label: to_string(label), disabled: false, invalid: false}

      %{value: v, label: l} = m ->
        %{
          value: to_string(v),
          label: to_string(l),
          disabled: !!Map.get(m, :disabled),
          invalid: !!Map.get(m, :invalid)
        }

      other ->
        raise ArgumentError,
              "radio_group items must be {value, label}, [value, label], or %{value: ..., label: ...}, got: #{inspect(other)}"
    end)
  end
end
