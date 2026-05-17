defmodule Corex.RadioGroup do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Radio Group](https://zagjs.com/components/react/radio-group).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.radio_group
    id="radio-group-anatomy-minimal"
    name="rg-minimal"
    class="radio-group"
    items={[
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]}
  >
    <:label>Choose one</:label>
  </.radio_group>
  ```

  ### With indicator

  ```heex
  <.radio_group
    id="radio-group-anatomy-indicator"
    name="rg-indicator"
    class="radio-group"
    items={[
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]}
  >
    <:label>Choose one</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
  ```

  <!-- tabs-close -->

  Items can be `{value, label}` tuples or maps with `:value`, `:label`, and optional `:disabled`, `:invalid`.

  ## Events

  Pick an event name and pass it to `on_*` on `<.radio_group>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="radio_group_changed"` | Selected value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.radio_group
    id="radio-group-events-server"
    name="rg-events"
    class="radio-group"
    on_value_change="radio_group_changed"
    items={[
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]}
  >
    <:label>Choose one</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
  ```

  ```elixir
  def handle_event("radio_group_changed", %{"id" => _id, "value" => value}, socket) do
    {:noreply, assign(socket, :choice, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="radio-group-changed"` | Selected value changes | `id`, `value` |

  <!-- tabs-open -->

  ### on_value_change_client

  ```heex
  <.radio_group
    id="radio-group-events-client"
    name="rg-events-client"
    class="radio-group"
    on_value_change_client="radio-group-changed"
    items={[
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]}
  >
    <:label>Choose one</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
  ```

  ```javascript
  const el = document.getElementById("radio-group-events-client");
  el?.addEventListener("radio-group-changed", (event) => console.log(event.detail));
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Controlled

  For server-owned selection, set `controlled`, bind `value`, and handle `on_value_change` in LiveView.

  ```heex
  <.radio_group
    id="radio-group-api-controlled"
    name="rg-controlled"
    class="radio-group"
    controlled
    value={@api_controlled_value}
    on_value_change="radio_group_api_controlled"
    items={[
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]}
  >
    <:label>Pick</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
  ```

  ```elixir
  def handle_event("radio_group_api_controlled", %{"value" => v}, socket) do
    {:noreply, assign(socket, :api_controlled_value, v)}
  end
  ```

  <!-- tabs-close -->

  ## Form

  Use `field={f[:choice]}` inside `<.form>` so the hidden input name and validation align with Phoenix forms.

  ```heex
  <.form for={@form} id={@form.id} phx-change="validate">
    <.radio_group
      field={@form[:choice]}
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
  </.form>
  ```

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `radio-group.css`, then set `class="radio-group"` on `<.radio_group>`.

  ```css
  [data-scope="radio-group"][data-part="root"] {}
  [data-scope="radio-group"][data-part="label"] {}
  [data-scope="radio-group"][data-part="item"] {}
  [data-scope="radio-group"][data-part="item-text"] {}
  [data-scope="radio-group"][data-part="item-control"] {}
  [data-scope="radio-group"][data-part="item-hidden-input"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/radio-group.css";
  ```

  Stack modifiers on the host (`class` on `<.radio_group>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `radio-group` |
  | Accent | `radio-group radio-group--accent` |
  | Brand | `radio-group radio-group--brand` |
  | Alert | `radio-group radio-group--alert` |
  | Info | `radio-group radio-group--info` |
  | Success | `radio-group radio-group--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `radio-group radio-group--sm` |
  | MD | `radio-group radio-group--md` |
  | LG | `radio-group radio-group--lg` |
  | XL | `radio-group radio-group--xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.RadioGroup.Anatomy.{
    Indicator,
    Item,
    ItemControl,
    ItemHiddenInput,
    ItemText,
    Label,
    Props,
    Root
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

  attr(:errors, :list, default: [], doc: "Error messages to display (non-field API)")
  attr(:field, Phoenix.HTML.FormField, doc: "A form field, e.g. f[:choice] or @form[:choice]")

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :item_control, required: false do
    attr(:class, :string, required: false)
  end

  slot :item, required: false do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def radio_group(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
    v = if field.value in [nil, ""], do: nil, else: to_string(field.value)

    assigns
    |> assign(:field, nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error/1))
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
    |> assign(:value, v)
    |> assign(:invalid, errors != [])
    |> radio_group()
  end

  def radio_group(assigns) do
    assigns =
      assigns
      |> assign_new(:errors, fn -> [] end)
      |> assign_new(:id, fn -> "radio-group-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:items, normalize_items(assigns.items))

    ~H"""
    <div
      id={@id}
      phx-hook="RadioGroup"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
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
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation, has_label: @label != []})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, has_label: @label != []})}>
        <div :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </div>
        <div phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, dir: @dir, orientation: @orientation})} {Connect.indicator(%Indicator{id: @id, dir: @dir, orientation: @orientation})} />
        <label :if={@item == []} :for={entry <- @items} phx-mounted={Connect.ignore_item(%Item{
          id: @id,
          value: entry.value,
          disabled: entry.disabled,
          invalid: entry.invalid,
          checked: @value == entry.value,
          dir: @dir,
          orientation: @orientation
        })} {Connect.item(%Item{
          id: @id,
          value: entry.value,
          disabled: entry.disabled,
          invalid: entry.invalid,
          checked: @value == entry.value,
          dir: @dir,
          orientation: @orientation
        })}>
          <span phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, value: entry.value, disabled: entry.disabled, invalid: entry.invalid, dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, value: entry.value, disabled: entry.disabled, invalid: entry.invalid, dir: @dir, orientation: @orientation})}>{entry.label}</span>
          <div phx-mounted={Connect.ignore_item_control(%ItemControl{id: @id, value: entry.value, disabled: entry.disabled, invalid: entry.invalid, checked: @value == entry.value, dir: @dir, orientation: @orientation})} {Connect.item_control(%ItemControl{id: @id, value: entry.value, disabled: entry.disabled, invalid: entry.invalid, checked: @value == entry.value, dir: @dir, orientation: @orientation})}>
            {render_slot(@item_control)}
          </div>
          <input phx-mounted={Connect.ignore_item_hidden_input(%ItemHiddenInput{
            id: @id,
            value: entry.value,
            disabled: entry.disabled,
            invalid: entry.invalid,
            name: @name,
            form: @form,
            checked: @value == entry.value,
            dir: @dir,
            orientation: @orientation
          })} {Connect.item_hidden_input(%ItemHiddenInput{
            id: @id,
            value: entry.value,
            disabled: entry.disabled,
            invalid: entry.invalid,
            name: @name,
            form: @form,
            checked: @value == entry.value,
            dir: @dir,
            orientation: @orientation
          })} />
        </label>
        <label :if={@item != []} :for={{entry, item_slot} <- Enum.zip(@items, @item || [])} phx-mounted={Connect.ignore_item(%Item{
          id: @id,
          value: entry.value,
          disabled: entry.disabled,
          invalid: entry.invalid,
          checked: @value == entry.value,
          dir: @dir,
          orientation: @orientation
        })} {Connect.item(%Item{
          id: @id,
          value: entry.value,
          disabled: entry.disabled,
          invalid: entry.invalid,
          checked: @value == entry.value,
          dir: @dir,
          orientation: @orientation
        })}>
          {render_slot(item_slot, %{
            value: entry.value,
            label: entry.label,
            disabled: entry.disabled,
            invalid: entry.invalid,
            checked: @value == entry.value
          })}
        </label>
      </div>
      <div :if={@error != []} :for={msg <- @errors} data-scope="radio-group" data-part="error">
        {render_slot(@error, msg)}
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
