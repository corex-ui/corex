defmodule Corex.RatingGroup do
  @moduledoc ~S'''
  RatingGroup for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/rating-group).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.rating_group class="rating-group" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.rating_group>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="rating_group_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.rating_group class="rating-group" />
    ```

    ```elixir
    def handle_event("rating_group_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="rating-group-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="rating-group"`.

    ```css
    [data-scope="rating-group"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `rating-group` |
  | Accent | `rating-group ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.RatingGroup.Anatomy.{Props, Root}
  alias Corex.RatingGroup.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:count, :integer, default: 5)
  attr(:value, :integer, default: 0)
  attr(:allow_half, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:read_only, :boolean, default: false)

  attr(:rest, :global)

  def rating_group(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "rating-group")

    ~H"""
    <div
      id={@id}
      phx-hook="RatingGroup"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        count: @count,
        value: @value,
        allow_half: @allow_half,
        disabled: @disabled,
        read_only: @read_only,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <div data-scope="rating-group" data-part="control">
          <span :for={i <- 1..@count} data-scope="rating-group" data-part="item" data-index={i}>★</span>
        </div>
        <input type="hidden" data-scope="rating-group" data-part="hidden-input" />
      </div>
    </div>
    """
  end
end
