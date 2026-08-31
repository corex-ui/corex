defmodule Corex.Progress do
  @moduledoc ~S'''
  Progress for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/linear-progress).
  One machine covers linear and circular anatomies (`variant`).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.progress class="progress" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.progress>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="progress_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.progress class="progress" />
    ```

    ```elixir
    def handle_event("progress_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="progress-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="progress"`.

    ```css
    [data-scope="progress"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `progress` |
  | Accent | `progress ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Progress.Anatomy.{Props, Root}
  alias Corex.Progress.Connect
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:value, :integer, default: 40)
  attr(:min, :integer, default: 0)
  attr(:max, :integer, default: 100)
  attr(:variant, :string, default: "linear", values: ["linear", "circular"])
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])

  attr(:rest, :global)

  def progress(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "progress")

    ~H"""
    <div
      id={@id}
      phx-hook="Progress"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        value: @value,
        min: @min,
        max: @max,
        variant: @variant,
        orientation: @orientation,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <div :if={@variant == "linear"} data-scope="progress" data-part="track">
          <div data-scope="progress" data-part="range"></div>
        </div>
        <svg :if={@variant == "circular"} data-scope="progress" data-part="circle" viewBox="0 0 44 44">
          <circle data-scope="progress" data-part="circle-track" cx="22" cy="22" r="20" fill="none" />
          <circle data-scope="progress" data-part="circle-range" cx="22" cy="22" r="20" fill="none" />
        </svg>
        <span data-scope="progress" data-part="value-text"></span>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set progress value from a control (`phx-click`).
  """)

  @spec set_value(String.t(), number() | nil) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), number() | nil) ::
          Phoenix.LiveView.Socket.t()
  def set_value(progress_id, value) when is_binary(progress_id) do
    JS.dispatch("corex:progress:set-value",
      to: Selectors.css_id(progress_id),
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set progress value from `handle_event`.
  """)

  def set_value(socket, progress_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(progress_id) do
    LiveView.push_event(socket, "progress_set_value", %{id: progress_id, value: value})
  end
end
