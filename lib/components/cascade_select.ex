defmodule Corex.CascadeSelect do
  @moduledoc ~S'''
  CascadeSelect for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/cascade-select).
  This Zag machine is marked **beta**. The Corex API tracks Zag 1.43.x.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.cascade_select class="cascade-select" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.cascade_select>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="cascade_select_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.cascade_select class="cascade-select" />
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

  alias Corex.CascadeSelect.Anatomy.{Props, Root}
  alias Corex.CascadeSelect.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)

  attr(:rest, :global)

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
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <button data-scope="cascade-select" data-part="trigger" type="button">Select</button>
        <div data-scope="cascade-select" data-part="positioner">
          <div data-scope="cascade-select" data-part="content"></div>
        </div>
        <input type="hidden" data-scope="cascade-select" data-part="hidden-input" />
      </div>
    </div>
    """
  end
end
