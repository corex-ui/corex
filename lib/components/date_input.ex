defmodule Corex.DateInput do
  @moduledoc ~S'''
  DateInput for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/date-input).
  This Zag machine is marked **beta**. The Corex API tracks Zag 1.43.x.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.date_input class="date-input" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.date_input>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="date_input_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.date_input class="date-input" />
    ```

    ```elixir
    def handle_event("date_input_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="date-input-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="date-input"`.

    ```css
    [data-scope="date-input"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `date-input` |
  | Accent | `date-input ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.DateInput.Anatomy.{Props, Root}
  alias Corex.DateInput.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)

  attr(:rest, :global)

  def date_input(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "date-input")

    ~H"""
    <div
      id={@id}
      phx-hook="DateInput"
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
        <div data-scope="date-input" data-part="control">
          <div data-scope="date-input" data-part="segment-group"></div>
          <input type="hidden" data-scope="date-input" data-part="hidden-input" />
        </div>
      </div>
    </div>
    """
  end
end
