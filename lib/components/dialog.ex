defmodule Corex.Dialog do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Dialog](https://zagjs.com/components/react/dialog).

  ## Examples

  <!-- tabs-open -->

  ### Basic Usage

  With top-level slots:

  ```heex
  <.dialog id="my-dialog" class="dialog">
    <:trigger>Open Dialog</:trigger>
    <:title>Dialog Title</:title>
    <:description>
      This is a dialog description that explains what the dialog is about.
    </:description>
    <:content>
      <p>Dialog content goes here. You can add any content you want inside the dialog.</p>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  With title, description, and close trigger inside content (use the same id as the dialog):

  ```heex
  <.dialog id="my-dialog" class="dialog">
    <:trigger>Open Dialog</:trigger>
    <:content>
      <.dialog_title id="my-dialog">Dialog Title</.dialog_title>
      <.dialog_description id="my-dialog">
        This is a dialog description that explains what the dialog is about.
      </.dialog_description>
      <p>Dialog content goes here. You can add any content you want inside the dialog.</p>
      <.dialog_close_trigger id="my-dialog">
        <.heroicon name="hero-x-mark" class="icon" />
      </.dialog_close_trigger>
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

  ## Animation

  Set `animation` on `dialog` (`instant`, `js`, or `custom`).

  - `instant`  -  Zag toggles the native `hidden` attribute, no animation.
  - `js`  -  Web Animations API drives opacity/scale via `animation_options` (`Corex.Animation.Scale`).
  - `custom`  -  the hook never re-applies `hidden`; the consumer drives the animation by listening to the `CustomEvent` whose **type** is `on_open_change_client`. The `detail` shape is:

        // event.detail (DialogOpenChangedDetail)
        { id, open, previousOpen }

    Closed visibility is provided by CSS baselines on `[data-state="closed"]` (see `e2e/assets/corex/components/dialog.css`), so the consumer only needs to drive the transition itself. Use the Scale helpers exported from `corex` (mirroring how Accordion / Tree view use the Height helpers).

  ```javascript
  import { animate } from "motion"
  import {
    findDialogBackdrop,
    findDialogContent,
    animateScaleOpen,
    animateScaleClose,
  } from "corex"

  const reducedMotion = () =>
    window.matchMedia("(prefers-reduced-motion: reduce)").matches

  document.addEventListener("my-dialog-open-changed", (e) => {
    const { id, open } = e.detail
    const root = document.getElementById(id)
    if (!root) return
    const backdrop = findDialogBackdrop(root)
    const content = findDialogContent(root)
    if (open) {
      if (backdrop)
        animateScaleOpen(backdrop, { animator: animate, duration: 0.5, easing: "ease-out" })
      if (content) {
        animateScaleOpen(content, {
          animator: animate,
          duration: 0.7,
          easing: [0.16, 1, 0.3, 1],
          scaleStart: 0.7,
          scaleEnd: 1,
        })
        if (!reducedMotion())
          animate(
            content,
            { y: [60, 0], filter: ["blur(12px)", "blur(0px)"] },
            { duration: 0.7, easing: [0.16, 1, 0.3, 1] },
          )
      }
    } else {
      if (backdrop)
        animateScaleClose(backdrop, { animator: animate, duration: 0.4, easing: "ease-in" })
      if (content) {
        animateScaleClose(content, {
          animator: animate,
          duration: 0.35,
          easing: "ease-in",
          scaleStart: 0.8,
          scaleEnd: 1,
        })
        if (!reducedMotion())
          animate(
            content,
            { y: [0, 40], filter: ["blur(0px)", "blur(12px)"] },
            { duration: 0.35, easing: "ease-in" },
          )
      }
    }
  })
  ```

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
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/dialog.css";
  ```

  You can then use modifiers

  ```heex
  <.dialog class="dialog dialog--accent dialog--lg">
  ```

  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for Dialog component strings.

    Without gettext: `translation={%Dialog.Translation{ close: "Close" }}`

    With gettext: `translation={%Dialog.Translation{ close: Corex.Gettext.gettext("Close") }}`
    """
    defstruct [:close]
  end

  @doc type: :component
  use Phoenix.Component

  alias Corex.Dialog.Anatomy.{
    Backdrop,
    CloseTrigger,
    Content,
    Description,
    Positioner,
    Props,
    Title,
    Trigger
  }

  alias Corex.Dialog.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

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
    default: false,
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
    doc:
      "Server event name when the open state changes. Payload: `%{id, open, previousOpen}` (TS: `DialogOpenChangedDetail`)."
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc:
      "DOM event name dispatched when the open state changes. `event.detail` matches `DialogOpenChangedDetail`. Required for `animation=\"custom\"`."
  )

  attr(:animation, :string,
    default: "js",
    values: ["instant", "js", "custom"],
    doc:
      "Open and close: native hidden (instant), Web Animations via `Corex.Animation.Scale` (js), or events only (custom)"
  )

  attr(:animation_options, Corex.Animation.Scale,
    default: %Corex.Animation.Scale{scale_start: 0.96, scale_end: 1.0},
    doc:
      "Wired to the host when `animation` is `js` only. Custom transitions ignore this assign. See `Corex.Animation.Scale` (opacity, scale, timing, `block_interaction`)."
  )

  attr(:translation, Corex.Dialog.Translation, default: nil, doc: "Override translatable strings")

  attr(:aria_label, :string,
    default: nil,
    doc:
      "Accessible name when no visible dialog title is rendered; defaults to a translated Dialog label"
  )

  attr(:rest, :global)

  slot :trigger, required: true do
    attr(:class, :string, required: false)
    attr(:aria_label, :string, required: false)
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
    default_translation = %Translation{close: Corex.Gettext.gettext("Close")}

    assigns =
      assigns
      |> assign_new(:id, fn -> "dialog-#{System.unique_integer([:positive])}" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))

    id = assigns.id
    dir = assigns.dir
    open = assigns.open

    assigns =
      assigns
      |> assign(:trigger_struct, %Trigger{id: id, dir: dir, open: open})
      |> assign(:backdrop_struct, %Backdrop{id: id, dir: dir, open: open})
      |> assign(:positioner_struct, %Positioner{id: id, dir: dir, open: open})
      |> assign(:content_struct, %Content{id: id, dir: dir, open: open})
      |> assign(:title_struct, %Title{id: id, dir: dir, open: open})
      |> assign(:description_struct, %Description{id: id, dir: dir, open: open})
      |> assign(:close_trigger_struct, %CloseTrigger{
        id: id,
        dir: dir,
        open: open,
        aria_label: assigns.translation.close
      })

    ~H"""
    <div
      id={@id}
      phx-hook="Dialog"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
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
        on_open_change_client: @on_open_change_client,
        animation: @animation,
        animation_options: @animation_options,
        dialog_default_label: @aria_label
      })}
    >
      <button
        phx-mounted={Connect.ignore_trigger(@trigger_struct)}
        aria-label={Map.get(List.first(@trigger), :aria_label, nil)}
        {Connect.trigger(@trigger_struct)}
        class={Map.get(List.first(@trigger), :class, nil)}
      >
        {render_slot(@trigger)}
      </button>

      <div phx-mounted={Connect.ignore_backdrop(@backdrop_struct)} {Connect.backdrop(@backdrop_struct, @animation)}></div>
      <div phx-mounted={Connect.ignore_positioner(@positioner_struct)} {Connect.positioner(@positioner_struct)}>
        <div phx-mounted={Connect.ignore_content(@content_struct)} {Connect.content(@content_struct, @animation)}>
          <div data-scope="dialog" data-part="header">
            <h2
              :if={@title != []}
              phx-mounted={Connect.ignore_title(@title_struct)}
              {Connect.title(@title_struct)}
            >
              {render_slot(@title)}
            </h2>
            <button
              :if={@close_trigger != []}
              phx-mounted={Connect.ignore_close_trigger(@close_trigger_struct)}
              {Connect.close_trigger(@close_trigger_struct)}
            >
              {render_slot(@close_trigger)}
            </button>
          </div>
          <p
            :if={@description != []}
            phx-mounted={Connect.ignore_description(@description_struct)}
            {Connect.description(@description_struct)}
          >
            {render_slot(@description)}
          </p>
          {render_slot(@content)}
        </div>
      </div>
    </div>
    """
  end

  @doc type: :component
  @doc "Renders the dialog title. Use inside `<:content>` when not using the top-level `<:title>` slot. Pass the same id as the parent dialog."
  attr(:id, :string, required: true)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_title(assigns) do
    assigns =
      assign(assigns, :title_struct, %Title{id: assigns.id, dir: assigns.dir, open: false})

    ~H"""
    <h2
      phx-mounted={Connect.ignore_title(@title_struct)}
      {Connect.title(@title_struct)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc type: :component
  @doc "Renders the dialog description. Use inside `<:content>` when not using the top-level `<:description>` slot. Pass the same id as the parent dialog."
  attr(:id, :string, required: true)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_description(assigns) do
    assigns =
      assign(assigns, :description_struct, %Description{
        id: assigns.id,
        dir: assigns.dir,
        open: false
      })

    ~H"""
    <p
      phx-mounted={Connect.ignore_description(@description_struct)}
      {Connect.description(@description_struct)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc type: :component
  @doc "Renders the dialog close button. Use inside `<:content>` when not using the top-level `<:close_trigger>` slot. Pass the same id as the parent dialog."
  attr(:id, :string, required: true)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:aria_label, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_close_trigger(assigns) do
    assigns = assign_new(assigns, :aria_label, fn -> Corex.Gettext.gettext("Close") end)

    assigns =
      assign(assigns, :close_trigger_struct, %CloseTrigger{
        id: assigns.id,
        dir: assigns.dir,
        open: false,
        aria_label: assigns.aria_label
      })

    ~H"""
    <button
      phx-mounted={Connect.ignore_close_trigger(@close_trigger_struct)}
      {Connect.close_trigger(@close_trigger_struct)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
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
    JS.dispatch("corex:dialog:set-open",
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
    LiveView.push_event(socket, "dialog_set_open", %{
      dialog_id: dialog_id,
      open: open
    })
  end

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      close: partial.close || default.close
    }
  end
end
