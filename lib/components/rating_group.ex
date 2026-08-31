defmodule Corex.RatingGroup do
  @moduledoc ~S'''
  RatingGroup for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/rating-group).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.rating_group class="rating-group" value={3} />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.rating_group>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set value (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set value (server) | `socket` |

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

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

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

  import Corex.Api.Doc

  alias Corex.RatingGroup.Anatomy.{Props, Root}
  alias Corex.RatingGroup.Connect
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:name, :string, default: nil)
  attr(:count, :integer, default: 5)
  attr(:value, :float, default: 0.0)
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
        name: @name,
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
          <span :for={i <- 1..@count} data-scope="rating-group" data-part="item" data-index={i}>
            <svg
              data-scope="rating-group"
              data-part="item-preview"
              viewBox="0 0 24 24"
              aria-hidden="true"
            >
              <path
                data-scope="rating-group"
                data-part="star-bg"
                d="M12 2.5l2.9 5.88 6.5.95-4.7 4.58 1.11 6.47L12 17.77 6.19 20.38l1.11-6.47-4.7-4.58 6.5-.95L12 2.5z"
              />
              <path
                data-scope="rating-group"
                data-part="star-fg"
                d="M12 2.5l2.9 5.88 6.5.95-4.7 4.58 1.11 6.47L12 17.77 6.19 20.38l1.11-6.47-4.7-4.58 6.5-.95L12 2.5z"
              />
            </svg>
          </span>
        </div>
        <input type="hidden" data-scope="rating-group" data-part="hidden-input" name={@name} />
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set the rating from a control (`phx-click`).
  """)

  @spec set_value(String.t(), number()) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), number()) ::
          Phoenix.LiveView.Socket.t()
  def set_value(rating_group_id, value) when is_binary(rating_group_id) and is_number(value) do
    JS.dispatch("corex:rating-group:set-value",
      to: Selectors.css_id(rating_group_id),
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the rating from `handle_event`.
  """)

  def set_value(socket, rating_group_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(rating_group_id) and
             is_number(value) do
    LiveView.push_event(socket, "rating_group_set_value", %{
      id: rating_group_id,
      value: value
    })
  end
end
