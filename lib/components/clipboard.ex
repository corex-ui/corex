defmodule Corex.Clipboard do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Clipboard](https://zagjs.com/components/react/clipboard).

  Set `value` for the initial string to copy. Use `Corex.Clipboard.set_value/2` or `corex:clipboard:set-value` to change it on the client.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.clipboard value="hello@example.com">
    <:label>Email</:label>
    <:copy>
      <.heroicon name="hero-clipboard" />
    </:copy>
    <:copied>
      <.heroicon name="hero-check" />
    </:copied>
  </.clipboard>
  ```

  ### Trigger only

  ```heex
  <.clipboard
    value="https://example.com/share"
    input={false}
    trigger_aria_label="Copy link"
  >
    <:copy>
      <.heroicon name="hero-clipboard" />
    </:copy>
    <:copied>
      <.heroicon name="hero-check" />
    </:copied>
  </.clipboard>
  ```

  <!-- tabs-close -->

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `size`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.clipboard size="md" class="clipboard" value="hello@example.com">
    <:label>Email</:label>
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  ### With classes

  ```heex
  <.clipboard class="clipboard clipboard--size-md" value="hello@example.com">
    <:label>Email</:label>
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.clipboard>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`copy/1`](#copy/1) | Copy current value (client) | `%Phoenix.LiveView.JS{}` |
  | [`copy/2`](#copy/2) | Copy current value (server) | `socket` |
  | [`set_value/2`](#set_value/2) | Set value to copy (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set value to copy (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.clipboard>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_copy="clipboard_copied"` | User copies | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_copy

  ```heex
  <.clipboard
    value="info@netoum.com"
    on_copy="clipboard_copied"
  >
    <:label>Copy</:label>
    <:copy>
      <.heroicon name="hero-clipboard" />
    </:copy>
    <:copied>
      <.heroicon name="hero-check" />
    </:copied>
  </.clipboard>
  ```

  ```elixir
  def handle_event("clipboard_copied", %{"value" => value, "id" => _id}, socket) do
    {:noreply, assign(socket, :last_copied, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_copy_client="clipboard-copied"` | User copies | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="clipboard"][data-part="root"] {}
  [data-scope="clipboard"][data-part="trigger"] {}
  [data-scope="clipboard"][data-part="control"] {}
  [data-scope="clipboard"][data-part="input"] {}
  [data-scope="clipboard"][data-part="copy"] {}
  [data-scope="clipboard"][data-part="copied"] {}
  ```

  Stack modifiers on the host (`class` on `<.clipboard>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `clipboard` |
  | Accent | `clipboard clipboard--semantic-accent` |
  | Brand | `clipboard clipboard--semantic-brand` |
  | Alert | `clipboard clipboard--semantic-alert` |
  | Info | `clipboard clipboard--semantic-info` |
  | Success | `clipboard clipboard--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `clipboard clipboard--size-sm` |
  | MD | `clipboard clipboard--size-md` |
  | LG | `clipboard clipboard--size-lg` |
  | XL | `clipboard clipboard--size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "clipboard",
    axes: [:width, :max_width, :height, :max_height, :size]

  import Corex.Api.Doc

  alias Corex.Clipboard.Anatomy.{Control, Copied, Copy, Input, Label, Props, Root, Trigger}
  alias Corex.Clipboard.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a clipboard component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the clipboard, useful for API to identify the clipboard"
  )

  attr(:value, :string,
    default: nil,
    doc: "The value shown in the input and copied (initial or after client set_value)"
  )

  attr(:timeout, :integer,
    default: nil,
    doc: "The timeout in milliseconds before resetting the copied state"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the clipboard. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS."
  )

  attr(:on_copy, :string,
    default: nil,
    doc: "The server event name when the value is copied"
  )

  attr(:on_copy_client, :string,
    default: nil,
    doc: "The client event name when the value is copied"
  )

  attr(:trigger_aria_label, :string,
    default: nil,
    doc:
      "Accessible name for the trigger button when it contains only an icon (e.g. \"Copy to clipboard\")"
  )

  attr(:input_aria_label, :string,
    default: nil,
    doc:
      "Accessible name for the input when it's not associated with a visible label (e.g. \"Value to copy\")"
  )

  attr(:input, :boolean,
    default: true,
    doc: "Whether to render the input element. Set to false when using only the trigger to copy."
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :copy, required: false do
    attr(:class, :string, required: false)
  end

  slot :copied, required: false do
    attr(:class, :string, required: false)
  end

  slot :trigger, required: false do
    attr(:class, :string, required: false)
  end

  attr(:input_class, :string, default: nil)
  attr(:control_class, :string, default: nil)
  attr(:root_class, :string, default: nil)

  def clipboard(assigns) do
    if assigns.copy == [] and assigns.copied == [] and assigns.trigger == [] do
      raise ArgumentError,
            "clipboard requires at least one of :copy, :copied, or :trigger"
    end

    assigns =
      assigns
      |> assign_new(:id, fn -> "clipboard-#{System.unique_integer([:positive])}" end)

    trigger_button_class =
      case assigns.trigger do
        [first | _] -> Map.get(first, :class)
        _ -> nil
      end

    assigns = assign(assigns, :trigger_button_class, trigger_button_class)

    ~H"""
    <div
      id={@id}
      phx-hook="Clipboard"
      class={corex_style_class(assigns)}
     
      data-loading  
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}    
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        timeout: @timeout,
        dir: @dir,
        orientation: @orientation,
        on_copy: @on_copy,
        on_copy_client: @on_copy_client,
        trigger_aria_label: @trigger_aria_label,
        input_aria_label: @input_aria_label
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})} class={@root_class}>
        <label
          :for={label <- @label}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})}
          {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}
          class={Map.get(label, :class, nil)}
        >
          {render_slot(label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})} class={@control_class}>
          <input
            :if={@input}
            class={@input_class}
            phx-mounted={Connect.ignore_input(%Input{id: @id, dir: @dir, value: @value, orientation: @orientation})}
            {Connect.input(%Input{id: @id, dir: @dir, value: @value, orientation: @orientation})}
            aria-label="Text to copy"
          />
          <button
            phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}
            {Connect.trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}
            aria-label="Copy"
            class={@trigger_button_class}
          >
            <span
              :if={@copy != []}
              phx-mounted={Connect.ignore_copy_part(%Copy{id: @id, dir: @dir, orientation: @orientation})}
              {Connect.copy_part(%Copy{id: @id, dir: @dir, orientation: @orientation})}
            >
              {render_slot(@copy)}
            </span>
            <span
              :if={@copied != []}
              phx-mounted={Connect.ignore_copied_part(%Copied{id: @id, dir: @dir, orientation: @orientation})}
              {Connect.copied_part(%Copied{id: @id, dir: @dir, orientation: @orientation})}
            >
              {render_slot(@copied)}
            </span>
            {render_slot(@trigger)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Copy the component's current value from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Clipboard.copy("my-clipboard")}>Copy</.action>
  <.clipboard id="my-clipboard" class="clipboard" value="hello@example.com">
    <:label>Email</:label>
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  ```javascript
  document.getElementById("my-clipboard")?.dispatchEvent(
    new CustomEvent("corex:clipboard:copy", { bubbles: false })
  );
  ```
  """)

  def copy(clipboard_id) when is_binary(clipboard_id) do
    JS.dispatch("corex:clipboard:copy",
      to: "##{clipboard_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Copy the current value from `handle_event`.

  ```heex
  <.action phx-click="copy_email">Copy</.action>
  <.clipboard id="my-clipboard" class="clipboard" value="hello@example.com">
    <:label>Email</:label>
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  ```elixir
  def handle_event("copy_email", _, socket) do
    {:noreply, Corex.Clipboard.copy(socket, "my-clipboard")}
  end
  ```
  """)

  def copy(socket, clipboard_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(clipboard_id) do
    LiveView.push_event(socket, "clipboard_copy", %{
      clipboard_id: clipboard_id
    })
  end

  api_doc(~S"""
  Set the string to copy from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Clipboard.set_value("my-clipboard", "next@example.com")}>Load</.action>
  <.clipboard id="my-clipboard" class="clipboard" value="hello@example.com">
    <:label>Email</:label>
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  ```javascript
  document.getElementById("my-clipboard")?.dispatchEvent(
    new CustomEvent("corex:clipboard:set-value", {
      bubbles: false,
      detail: { value: "next@example.com" },
    })
  );
  ```
  """)

  def set_value(clipboard_id, value) when is_binary(clipboard_id) and is_binary(value) do
    JS.dispatch("corex:clipboard:set-value",
      to: "##{clipboard_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the value to copy from `handle_event`.

  ```heex
  <.action phx-click="load_clipboard" phx-value-value="next@example.com">Load</.action>
  <.clipboard id="my-clipboard" class="clipboard" value="hello@example.com">
    <:label>Email</:label>
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  ```elixir
  def handle_event("load_clipboard", %{"value" => value}, socket) do
    {:noreply, Corex.Clipboard.set_value(socket, "my-clipboard", value)}
  end
  ```
  """)

  def set_value(socket, clipboard_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(clipboard_id) and
             is_binary(value) do
    LiveView.push_event(socket, "clipboard_set_value", %{
      clipboard_id: clipboard_id,
      value: value
    })
  end
end
