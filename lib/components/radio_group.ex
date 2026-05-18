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
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
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
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
    ]}
  >
    <:label>Choose one</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
  ```

  ### Invalid

  ```heex
  <.radio_group
    id="radio-group-anatomy-invalid"
    name="rg-invalid"
    class="radio-group"
    invalid
    errors={["Required"]}
    items={[
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
    ]}
  >
    <:label>Choose one</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.radio_group>
  ```

  ### Read-only

  ```heex
  <.radio_group
    id="radio-group-anatomy-readonly"
    name="rg-readonly"
    class="radio-group"
    read_only
    value="lorem"
    items={[
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
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
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
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
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
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

  ## API

  Requires a stable `id` on `<.radio_group>`. Imperative helpers set the selected value.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set value (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set value (server) | `socket` |
  | [`clear_value/1`](#clear_value/1) | Clear selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear_value/2`](#clear_value/2) | Clear selection (server) | `socket` |
  | [`focus/1`](#focus/1) | Focus the group (client) | `%Phoenix.LiveView.JS{}` |
  | [`focus/2`](#focus/2) | Focus the group (server) | `socket` |
  | [`value/1`](#value/1) | Read current value (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/2`](#value/2) | Read current value (client, options) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read current value (server) | `socket` |

  <!-- tabs-open -->

  ### set_value

  ```heex
  <.action phx-click={Corex.RadioGroup.set_value("radio-group-api-server", "duis")} class="button button--sm">
    Set Duis
  </.action>
  <.radio_group
    id="radio-group-api-server"
    name="rg-api-server"
    class="radio-group"
    value="lorem"
    items={[
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
    ]}
  >
    <:label>Pick</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
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
      %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
      %{value: "donec", label: "Donec condimentum ex mi"}
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

  ### Stream

  Use `Phoenix.LiveView.stream/3` to add or remove items at runtime. Keep `@items_list` in sync with the stream and pass it as `items`. Configure `dom_id` to match each item (`radio-group:stream-radio-group:item:#{value}`).

  ```heex
  <.radio_group
    id="stream-radio-group"
    name="stream-rg"
    class="radio-group"
    items={@items_list}
    value={@stream_value}
    controlled
    on_value_change="patterns_stream_value"
  >
    <:label>Choose one</:label>
    <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  </.radio_group>
  ```

  <!-- tabs-close -->

  ## Form

  Use `field={@form[:choice]}` inside `<.form>` so the hidden input name and validation align with Phoenix forms. Pass `invalid` only when you want invalid styling.

  ```heex
  <.form for={@form} id={@form.id} phx-change="validate">
    <.radio_group
      field={@form[:choice]}
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
      ]}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
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

  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [respond_to_fields: 1]

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

  @doc type: :api
  @doc """
  Sets radio group selection from the client. Dispatches `corex:radio-group:set-value` on the hook root.
  """
  def set_value(radio_group_id, value) when is_binary(radio_group_id) and is_binary(value) do
    JS.dispatch("corex:radio-group:set-value",
      to: "##{radio_group_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets radio group selection from the server via `push_event` (`radio_group_set_value`).
  """
  def set_value(socket, radio_group_id, value)
      when is_struct(socket, LiveView.Socket) and is_binary(radio_group_id) and is_binary(value) do
    LiveView.push_event(socket, "radio_group_set_value", %{id: radio_group_id, value: value})
  end

  @doc type: :api
  @doc """
  Clears radio group selection from the client. Dispatches `corex:radio-group:clear-value` on the hook root.
  """
  def clear_value(radio_group_id) when is_binary(radio_group_id) do
    JS.dispatch("corex:radio-group:clear-value",
      to: "##{radio_group_id}",
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Clears radio group selection from the server via `push_event` (`radio_group_clear_value`).
  """
  def clear_value(socket, radio_group_id)
      when is_struct(socket, LiveView.Socket) and is_binary(radio_group_id) do
    LiveView.push_event(socket, "radio_group_clear_value", %{id: radio_group_id})
  end

  @doc type: :api
  @doc """
  Focuses the radio group from the client. Dispatches `corex:radio-group:focus` on the hook root.
  """
  def focus(radio_group_id) when is_binary(radio_group_id) do
    JS.dispatch("corex:radio-group:focus", to: "##{radio_group_id}", bubbles: false)
  end

  @doc type: :api
  @doc """
  Focuses the radio group from the server via `push_event` (`radio_group_focus`).
  """
  def focus(socket, radio_group_id)
      when is_struct(socket, LiveView.Socket) and is_binary(radio_group_id) do
    LiveView.push_event(socket, "radio_group_focus", %{id: radio_group_id})
  end

  @doc type: :api
  @doc """
  Requests the radio group's current value from the client. See `value/3` for `:respond_to`.
  """
  def value(radio_group_id) when is_binary(radio_group_id), do: value(radio_group_id, [])

  def value(radio_group_id, opts) when is_binary(radio_group_id) and is_list(opts) do
    JS.dispatch("corex:radio-group:value",
      to: "##{radio_group_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the radio group's current value from the client via `push_event` (`radio_group_value`).

  The hook responds with `radio_group_value_response` and/or dispatches `radio-group-value` depending on `:respond_to`.
  """
  def value(socket, radio_group_id)
      when is_struct(socket, LiveView.Socket) and is_binary(radio_group_id) do
    value(socket, radio_group_id, [])
  end

  def value(socket, radio_group_id, opts)
      when is_struct(socket, LiveView.Socket) and is_binary(radio_group_id) and is_list(opts) do
    LiveView.push_event(
      socket,
      "radio_group_value",
      Map.merge(%{id: radio_group_id}, respond_to_fields(opts))
    )
  end
end
