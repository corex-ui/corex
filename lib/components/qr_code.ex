defmodule Corex.QrCode do
  @moduledoc ~S'''
  QR Code for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/qr-code).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.qr_code class="qr-code" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.qr_code>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="qr_code_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.qr_code class="qr-code" />
    ```

    ```elixir
    def handle_event("qr_code_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="qr-code-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="qr-code"`.

    ```css
    [data-scope="qr-code"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `qr-code` |
  | Accent | `qr-code ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.QrCode.Anatomy.{Props, Root}
  alias Corex.QrCode.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:value, :string, default: "https://zagjs.com")
  attr(:pixel_size, :integer, default: 4)

  attr(:rest, :global)

  def qr_code(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "qr-code")

    ~H"""
    <div
      id={@id}
      phx-hook="QrCode"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        value: @value,
        pixel_size: @pixel_size,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <svg data-scope="qr-code" data-part="frame">
          <path data-scope="qr-code" data-part="pattern"></path>
        </svg>
      </div>
    </div>
    """
  end
end
