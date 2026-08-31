defmodule Corex.CascadeSelect do
  @moduledoc ~S'''
  Cascade select for Phoenix LiveView. Behavior follows [Zag.js Cascade Select](https://zagjs.com/components/react/cascade-select).
  This Zag machine is marked **beta**. The Corex API tracks Zag 1.43.x.

  Overlay content is always rendered **closed** on the server. Open it with
  `set_open/2` after JavaScript is available — there is no `open` attribute.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.cascade_select class="cascade-select" show_indicator={false} />
    ```

  ### With indicator

    ```heex
    <.cascade_select class="cascade-select">
      <:indicator>▾</:indicator>
    </.cascade_select>
    ```

  ### With label

    ```heex
    <.cascade_select class="cascade-select">
      <:label>Category</:label>
      <:indicator>▾</:indicator>
    </.cascade_select>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.cascade_select>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="cascade_select_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.cascade_select class="cascade-select" on_value_change="cascade_select_changed">
      <:indicator>▾</:indicator>
    </.cascade_select>
    ```

    ```elixir
    def handle_event("cascade_select_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="cascade-select-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="cascade-select"`.

    ```css
    [data-scope="cascade-select"][data-part="root"] {}
    [data-scope="cascade-select"][data-part="trigger"] {}
    [data-scope="cascade-select"][data-part="content"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `cascade-select` |
  | Accent | `cascade-select ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Selectors

  alias Corex.CascadeSelect.Anatomy.{
    ClearTrigger,
    Content,
    Control,
    HiddenInput,
    Indicator,
    Label,
    Positioner,
    Props,
    Root,
    Trigger,
    ValueText
  }

  alias Corex.CascadeSelect.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @default_tree %{
    "value" => "root",
    "label" => "root",
    "children" => [
      %{
        "value" => "electronics",
        "label" => "Electronics",
        "children" => [
          %{
            "value" => "computers",
            "label" => "Computers",
            "children" => [
              %{"value" => "laptops", "label" => "Laptops"},
              %{"value" => "desktops", "label" => "Desktops"},
              %{"value" => "tablets", "label" => "Tablets"}
            ]
          },
          %{
            "value" => "phones",
            "label" => "Phones",
            "children" => [
              %{"value" => "android", "label" => "Android"},
              %{"value" => "ios", "label" => "iOS"}
            ]
          }
        ]
      },
      %{
        "value" => "clothing",
        "label" => "Clothing",
        "children" => [
          %{
            "value" => "men",
            "label" => "Men",
            "children" => [
              %{"value" => "shirts", "label" => "Shirts"},
              %{"value" => "pants", "label" => "Pants"}
            ]
          },
          %{
            "value" => "women",
            "label" => "Women",
            "children" => [
              %{"value" => "dresses", "label" => "Dresses"},
              %{"value" => "shoes", "label" => "Shoes"}
            ]
          }
        ]
      },
      %{
        "value" => "home",
        "label" => "Home",
        "children" => [
          %{
            "value" => "kitchen",
            "label" => "Kitchen",
            "children" => [
              %{"value" => "cookware", "label" => "Cookware"},
              %{"value" => "appliances", "label" => "Appliances"}
            ]
          },
          %{
            "value" => "garden",
            "label" => "Garden",
            "children" => [
              %{"value" => "plants", "label" => "Plants"},
              %{"value" => "tools", "label" => "Tools"}
            ]
          }
        ]
      }
    ]
  }

  @spec default_tree() :: map()
  def default_tree, do: @default_tree

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:tree, :map, default: nil)
  attr(:disabled, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:placeholder, :string, default: "Select")
  attr(:show_indicator, :boolean, default: true)
  attr(:positioning, Corex.Positioning, default: %Corex.Positioning{placement: "bottom-start"})
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:rest, :global)

  slot(:label, required: false)
  slot(:indicator, required: false)
  slot(:clear_trigger, required: false)

  def cascade_select(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "cascade-select")

    ~H"""
    <div
      id={@id}
      phx-hook="CascadeSelect"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        tree: @tree,
        disabled: @disabled,
        name: @name,
        placeholder: @placeholder,
        positioning: @positioning,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir, disabled: @disabled})}>
        <div :if={@label != []} {Connect.mounted_label(%Label{id: @id, dir: @dir, disabled: @disabled})}>
          {render_slot(Enum.at(@label, 0))}
        </div>
        <div {Connect.mounted_control(%Control{id: @id, dir: @dir, disabled: @disabled})}>
          <button {Connect.mounted_trigger(%Trigger{id: @id, dir: @dir, disabled: @disabled})}>
            <span {Connect.mounted_value_text(%ValueText{id: @id, dir: @dir})}>{@placeholder}</span>
            <span
              :if={@show_indicator}
              {Connect.mounted_indicator(%Indicator{id: @id, dir: @dir})}
            >
              {if @indicator != [], do: render_slot(Enum.at(@indicator, 0)), else: "▾"}
            </span>
          </button>
          <button :if={@clear_trigger != []} {Connect.mounted_clear_trigger(%ClearTrigger{id: @id, dir: @dir})}>
            {render_slot(Enum.at(@clear_trigger, 0))}
          </button>
        </div>
        <div {Connect.mounted_positioner(%Positioner{id: @id, dir: @dir})}>
          <div {Connect.mounted_content(%Content{id: @id, dir: @dir})}></div>
        </div>
        <input {Connect.mounted_hidden_input(%HiddenInput{id: @id, dir: @dir})} name={@name} />
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set cascade select open state from a control (`phx-click`). Overlay stays closed until JS is available.
  """)

  @spec set_open(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec set_open(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def set_open(cascade_select_id, open)
      when is_binary(cascade_select_id) and is_boolean(open) do
    JS.dispatch("corex:cascade-select:set-open",
      to: Selectors.css_id(cascade_select_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`.
  """)

  def set_open(socket, cascade_select_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(cascade_select_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "cascade_select_set_open", %{
      id: cascade_select_id,
      open: open
    })
  end
end
