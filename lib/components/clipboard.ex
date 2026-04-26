defmodule Corex.Clipboard do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Clipboard](https://zagjs.com/components/react/clipboard).

  Value is **uncontrolled** from the server’s perspective: set `value` for the initial string to copy; use `Corex.Clipboard.set_value/2` or the hook’s `corex:clipboard:set-value` event to change it on the client.

  ## Examples

  <!-- tabs-open -->

  ### Basic Usage

  ```heex
  <.clipboard id="my-clipboard" value="Text to copy">
    <:label>Copy to clipboard</:label>
    <:copy>
      <.heroicon name="hero-clipboard" />
    </:copy>
    <:copied>
      <.heroicon name="hero-check" />
    </:copied>
  </.clipboard>
  ```

  ### With Callback

  ```heex
  <.clipboard
    id="my-clipboard"
    value="Text to copy"
    on_copy="clipboard_copied">
    <:label>Copy to clipboard</:label>
    <:copy>
      <.heroicon name="hero-clipboard" />
    </:copy>
    <:copied>
      <.heroicon name="hero-check" />
    </:copied>
  </.clipboard>
  ```

  ```elixir
  def handle_event("clipboard_copied", %{"value" => value}, socket) do
    {:noreply, put_flash(socket, :info, "Copied: #{value}")}
  end
  ```

  ### Trigger only (`input={false}`)

  ```heex
  <.clipboard id="share-link" value={@url} input={false} trigger_aria_label="Copy link">
    <:copy><.heroicon name="hero-clipboard" /></:copy>
    <:copied><.heroicon name="hero-check" /></:copied>
  </.clipboard>
  ```

  ### Custom trigger body

  You can still use **`<:trigger>`** for extra markup after the copy/copied surfaces (or alone if you style idle/copied yourself).

  <!-- tabs-close -->

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Clipboard.copy("my-clipboard", "Text to copy")}>
    Copy Text
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("copy_text", _, socket) do
    {:noreply, Corex.Clipboard.copy(socket, "my-clipboard", "Text to copy")}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="clipboard"][data-part="root"] {}
  [data-scope="clipboard"][data-part="trigger"] {}
  [data-scope="clipboard"][data-part="control"] {}
  [data-scope="clipboard"][data-part="input"] {}
  [data-scope="clipboard"][data-part="copy"] {}
  [data-scope="clipboard"][data-part="copied"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `clipboard` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/clipboard.css";
  ```

  You can then use modifiers

  ```heex
  <.clipboard class="clipboard clipboard--accent clipboard--lg">
  ```

  '''

  @doc type: :component
  use Phoenix.Component

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
    default: "ltr",
    values: ["ltr", "rtl"],
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
            aria-label={@input_aria_label}
          />
          <button
            phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}
            {Connect.trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}
            aria-label={@trigger_aria_label}
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

  @doc type: :api
  @doc """
  Copies the current clipboard value to clipboard from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Clipboard.copy("my-clipboard")}>
        Copy
      </button>
  """
  def copy(clipboard_id) when is_binary(clipboard_id) do
    JS.dispatch("corex:clipboard:copy",
      to: "##{clipboard_id}",
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Copies the current clipboard value to clipboard from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("copy_clipboard", _params, socket) do
        socket = Corex.Clipboard.copy(socket, "my-clipboard")
        {:noreply, socket}
      end
  """
  def copy(socket, clipboard_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(clipboard_id) do
    LiveView.push_event(socket, "clipboard_copy", %{
      clipboard_id: clipboard_id
    })
  end

  @doc type: :api
  @doc """
  Sets the clipboard value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Clipboard.set_value("my-clipboard", "New value")}>
        Set Value
      </button>
  """
  def set_value(clipboard_id, value) when is_binary(clipboard_id) and is_binary(value) do
    JS.dispatch("corex:clipboard:set-value",
      to: "##{clipboard_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the clipboard value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("set_clipboard_value", _params, socket) do
        socket = Corex.Clipboard.set_value(socket, "my-clipboard", "New value")
        {:noreply, socket}
      end
  """
  def set_value(socket, clipboard_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(clipboard_id) and
             is_binary(value) do
    LiveView.push_event(socket, "clipboard_set_value", %{
      clipboard_id: clipboard_id,
      value: value
    })
  end
end
