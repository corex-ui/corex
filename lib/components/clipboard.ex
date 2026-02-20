defmodule Corex.Clipboard do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Clipboard](https://zagjs.com/components/react/clipboard).

  ## Examples

  <!-- tabs-open -->

  ### Basic Usage

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.clipboard id="my-clipboard" value="Text to copy">
    <:label>Copy to clipboard</:label>
     <:trigger>
          <.icon name="hero-clipboard" class="icon data-copy" />
          <.icon name="hero-check" class="icon data-copied" />
      </:trigger>
  </.clipboard>
  ```

  ### With Callback

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.clipboard
    id="my-clipboard"
    value="Text to copy"
    on_copy="clipboard_copied">
    <:label>Copy to clipboard</:label>
            <:trigger>
          <.icon name="hero-clipboard" class="icon data-copy" />
          <.icon name="hero-check" class="icon data-copied" />
        </:trigger>
  </.clipboard>
  ```

  ```elixir
  def handle_event("clipboard_copied", %{"value" => value}, socket) do
    {:noreply, put_flash(socket, :info, "Copied: #{value}")}
  end
  ```

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

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/clipboard#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Clipboard.Anatomy.{Props, Root, Label, Control, Input, Trigger}
  alias Corex.Clipboard.Connect

  @doc """
  Renders a clipboard component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the clipboard, useful for API to identify the clipboard"
  )

  attr(:value, :string,
    default: nil,
    doc: "The initial value or the controlled value to copy to clipboard"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the clipboard is controlled. Only in LiveView, the on_value_change event is required"
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

  attr(:on_copy, :string,
    default: nil,
    doc: "The server event name when the value is copied"
  )

  attr(:on_copy_client, :string,
    default: nil,
    doc: "The client event name when the value is copied"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name when the value changes (for controlled mode)"
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

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :trigger, required: false do
    attr(:class, :string, required: false)
  end

  def clipboard(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "clipboard-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="Clipboard"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        value: @value,
        timeout: @timeout,
        dir: @dir,
        on_copy: @on_copy,
        on_copy_client: @on_copy_client,
        on_value_change: @on_value_change,
        trigger_aria_label: @trigger_aria_label,
        input_aria_label: @input_aria_label
      })}
    >
      <div {Connect.root(%Root{id: @id, dir: @dir})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <input
            {Connect.input(%Input{id: @id, dir: @dir, value: @value})}
            aria-label={@input_aria_label}
          />
          <button
            :if={@trigger != []}
            {Connect.trigger(%Trigger{id: @id, dir: @dir})}
            aria-label={@trigger_aria_label}
          >
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
    Phoenix.LiveView.JS.dispatch("phx:clipboard:copy",
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
    Phoenix.LiveView.push_event(socket, "clipboard_copy", %{
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
    Phoenix.LiveView.JS.dispatch("phx:clipboard:set-value",
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
    Phoenix.LiveView.push_event(socket, "clipboard_set_value", %{
      clipboard_id: clipboard_id,
      value: value
    })
  end
end
