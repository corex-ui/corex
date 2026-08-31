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

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set value (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set value (server) | `socket` |

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

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

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

  import Corex.Api.Doc

  alias Corex.DateInput.Anatomy.{Props, Root}
  alias Corex.DateInput.Connect
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:name, :string, default: nil)
  attr(:disabled, :boolean, default: false)
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
        name: @name,
        disabled: @disabled,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <div data-scope="date-input" data-part="control">
          <div data-scope="date-input" data-part="segment-group">
            <span data-scope="date-input" data-part="skeleton" aria-hidden="true"></span>
          </div>
          <input type="hidden" data-scope="date-input" data-part="hidden-input" name={@name} />
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set the date from a control (`phx-click`). Pass an ISO-8601 date string.
  """)

  @spec set_value(String.t(), String.t() | Date.t()) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), String.t() | Date.t()) ::
          Phoenix.LiveView.Socket.t()
  def set_value(date_input_id, value) when is_binary(date_input_id) do
    JS.dispatch("corex:date-input:set-value",
      to: Selectors.css_id(date_input_id),
      detail: %{value: normalize_iso(value)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the date from `handle_event`.
  """)

  def set_value(socket, date_input_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(date_input_id) do
    LiveView.push_event(socket, "date_input_set_value", %{
      id: date_input_id,
      value: normalize_iso(value)
    })
  end

  defp normalize_iso(%Date{} = date), do: Date.to_iso8601(date)
  defp normalize_iso(value) when is_binary(value), do: value
end
