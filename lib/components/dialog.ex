defmodule Corex.Dialog do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Dialog](https://zagjs.com/components/react/dialog).

  ## Examples

  <!-- tabs-open -->

  ### Basic Usage

  ```heex
  <.dialog id="my-dialog">
    <:trigger>Open Dialog</:trigger>
    <:content>
      <:title>Dialog Title</:title>
      <:description>Dialog description goes here.</:description>
      <p>Dialog content</p>
      <:close_trigger>Close</:close_trigger>
    </:content>
  </.dialog>
  ```

  ### Controlled Mode

  ```heex
  <.dialog
    id="my-dialog"
    controlled
    open={@dialog_open}
    on_open_change="dialog_changed">
    <:trigger>Open Dialog</:trigger>
    <:content>
      <:title>Dialog Title</:title>
      <:description>Dialog description goes here.</:description>
      <p>Dialog content</p>
      <:close_trigger>Close</:close_trigger>
    </:content>
  </.dialog>
  ```

  ```elixir
  def handle_event("dialog_changed", %{"open" => open}, socket) do
    {:noreply, assign(socket, :dialog_open, open)}
  end
  ```

  <!-- tabs-close -->

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Dialog.set_open("my-dialog", true)}>
    Open Dialog
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("open_dialog", _, socket) do
    {:noreply, Corex.Dialog.set_open(socket, "my-dialog", true)}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="dialog"][data-part="root"] {}
  [data-scope="dialog"][data-part="trigger"] {}
  [data-scope="dialog"][data-part="backdrop"] {}
  [data-scope="dialog"][data-part="positioner"] {}
  [data-scope="dialog"][data-part="content"] {}
  [data-scope="dialog"][data-part="title"] {}
  [data-scope="dialog"][data-part="description"] {}
  [data-scope="dialog"][data-part="close-trigger"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `dialog` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/dialog.css";
  ```

  You can then use modifiers

  ```heex
  <.dialog class="dialog dialog--accent dialog--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/dialog#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Dialog.Anatomy.{
    Props,
    Trigger,
    Backdrop,
    Positioner,
    Content,
    Title,
    Description,
    CloseTrigger
  }

  alias Corex.Dialog.Connect

  @doc """
  Renders a dialog component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the dialog, useful for API to identify the dialog"
  )

  attr(:open, :boolean,
    default: false,
    doc: "The initial open state or the controlled open state"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the dialog is controlled. Only in LiveView, the on_open_change event is required"
  )

  attr(:modal, :boolean,
    default: true,
    doc: "Whether the dialog is modal"
  )

  attr(:close_on_interact_outside, :boolean,
    default: true,
    doc: "Whether to close the dialog when clicking outside"
  )

  attr(:close_on_escape, :boolean,
    default: true,
    doc: "Whether to close the dialog when pressing Escape"
  )

  attr(:prevent_scroll, :boolean,
    default: false,
    doc: "Whether to prevent body scroll when dialog is open"
  )

  attr(:restore_focus, :boolean,
    default: true,
    doc: "Whether to restore focus when dialog closes"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the dialog. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name when the open state changes"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name when the open state changes"
  )

  attr(:rest, :global)

  slot :trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :content, required: true do
    attr(:class, :string, required: false)
  end

  slot :title, required: false do
    attr(:class, :string, required: false)
  end

  slot :description, required: false do
    attr(:class, :string, required: false)
  end

  slot :close_trigger, required: false do
    attr(:class, :string, required: false)
  end

  def dialog(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "dialog-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="Dialog"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        open: @open,
        modal: @modal,
        close_on_interact_outside: @close_on_interact_outside,
        close_on_escape: @close_on_escape,
        prevent_scroll: @prevent_scroll,
        restore_focus: @restore_focus,
        dir: @dir,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client
      })}
    >
      <button {Connect.trigger(%Trigger{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}>
        {render_slot(@trigger)}
      </button>

      <div {Connect.backdrop(%Backdrop{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}></div>
      <div {Connect.positioner(%Positioner{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}>
        <div {Connect.content(%Content{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          <h2 :if={@title != []} {Connect.title(%Title{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}>
            {render_slot(@title)}
          </h2>
          <p :if={@description != []} {Connect.description(%Description{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}>
            {render_slot(@description)}
          </p>
          {render_slot(@content)}
          <button :if={@close_trigger != []}  {Connect.close_trigger(%CloseTrigger{id: @id, dir: @dir, open: @open, changed: Map.get(assigns, :__changed__, nil) != nil})}>
            {render_slot(@close_trigger)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the dialog open state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Dialog.set_open("my-dialog", true)}>
        Open Dialog
      </button>
  """
  def set_open(dialog_id, open) when is_binary(dialog_id) and is_boolean(open) do
    Phoenix.LiveView.JS.dispatch("phx:dialog:set-open",
      to: "##{dialog_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the dialog open state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_dialog", _params, socket) do
        socket = Corex.Dialog.set_open(socket, "my-dialog", true)
        {:noreply, socket}
      end
  """
  def set_open(socket, dialog_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(dialog_id) and
             is_boolean(open) do
    Phoenix.LiveView.push_event(socket, "dialog_set_open", %{
      dialog_id: dialog_id,
      open: open
    })
  end
end
