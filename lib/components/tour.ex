defmodule Corex.Tour do
  @moduledoc ~S'''
  Tour for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/tour).
  
  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.tour class="tour" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.tour>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="tour_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.tour class="tour" />
    ```

    ```elixir
    def handle_event("tour_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="tour-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="tour"`.

    ```css
    [data-scope="tour"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `tour` |
  | Accent | `tour ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Tour.Anatomy.{Props, Root}
  alias Corex.Tour.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)

  attr(:rest, :global)

  def tour(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "tour")

    ~H"""
    <div
      id={@id}
      phx-hook="Tour"
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
        <div data-scope="tour" data-part="backdrop"></div>
        <div data-scope="tour" data-part="positioner">
          <div data-scope="tour" data-part="content">
            <h3 data-scope="tour" data-part="title">Welcome</h3>
            <p data-scope="tour" data-part="description">Tour step</p>
            <button type="button" data-scope="tour" data-part="close-trigger">Close</button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
