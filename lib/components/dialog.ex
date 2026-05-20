defmodule Corex.Dialog do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Dialog](https://zagjs.com/components/react/dialog).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.dialog class="dialog">
    <:trigger>Open</:trigger>
    <:content>
      <p>Minimal content.</p>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  ### Title and description

  ```heex
  <.dialog class="dialog">
    <:trigger>Open Dialog</:trigger>
    <:title>Dialog Title</:title>
    <:description>
      Short description of what this dialog is for.
    </:description>
    <:content>
      <p>Body content.</p>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  ### Actions in content

  ```heex
  <.dialog id="dialog-anatomy-actions" class="dialog">
    <:trigger>Open Dialog</:trigger>
    <:title>Confirm</:title>
    <:description>Choose an action to continue.</:description>
    <:content>
      <p>Are you sure you want to continue?</p>
      <div class="flex flex-wrap justify-end gap-2 mt-4">
        <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)} class="button button--sm button--ghost">
          Cancel
        </.action>
        <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)} class="button button--sm">
          Continue
        </.action>
      </div>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.dialog>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  <!-- tabs-open -->

  ### set_open

  ```heex
  <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} class="button button--sm">
    Open Dialog
  </.action>
  <.dialog id="dialog-api" class="dialog">
    <:trigger>Open Dialog</:trigger>
    <:title>Dialog Title</:title>
    <:description>Dialog description.</:description>
    <:content>
      <p>Dialog content</p>
      <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button button--sm">
        Close
      </.action>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  ```elixir
  def handle_event("open_dialog", _, socket) do
    {:noreply, Corex.Dialog.set_open(socket, "dialog-api", true)}
  end
  ```

  <!-- tabs-close -->

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="dialog_open_changed"` | Open state changes | `%{"id" => id, "open" => open, "previousOpen" => previous}` |

  <!-- tabs-open -->

  ### on_open_change

  ```heex
  <.dialog class="dialog" on_open_change="dialog_open_changed">
    <:trigger>Open Dialog</:trigger>
    <:title>Dialog Title</:title>
    <:content>
      <p>Dialog content</p>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  ```elixir
  def handle_event("dialog_open_changed", %{"id" => id, "open" => open}, socket) do
    {:noreply, assign(socket, :dialog_open, open)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="dialog-open-changed"` | Open state changes | `id`, `open`, `previousOpen` |

  <!-- tabs-open -->

  ### on_open_change_client

  ```heex
  <.dialog id="dialog-events-client" class="dialog" on_open_change_client="dialog-open-changed">
    <:trigger>Open</:trigger>
    <:content><p>Content</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ```javascript
  document.getElementById("dialog-events-client")?.addEventListener("dialog-open-changed", (e) => {
    console.log(e.detail);
  });
  ```

  <!-- tabs-close -->

  ## Animation

  Set `animation` on `<.dialog>` (`instant`, `js`, or `custom`).

  <!-- tabs-open -->

  ### Instant

  ```heex
  <.dialog class="dialog" modal animation="instant">
    <:trigger>Open</:trigger>
    <:title>Instant</:title>
    <:content>
      <p>Native show and hide without JS transitions.</p>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  ### JS

  Web Animations API via `animation_options` (`Corex.Animation.Scale`).

  ```heex
  <.dialog
    class="dialog"
    modal
    animation="js"
    animation_options={%Corex.Animation.Scale{duration: 0.3, easing: "ease-out"}}
  >
    <:trigger>Open</:trigger>
    <:title>JS</:title>
    <:content><p>Scaled open and close.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ### Custom

  Set `animation="custom"` and `on_open_change_client`. The hook does not toggle `hidden`; listen for:

      // event.detail — DialogOpenChangedDetail
      { id, open, previousOpen }

  ```heex
  <.dialog
    class="dialog"
    animation="custom"
    on_open_change_client="my-dialog-open-changed"
  >
    <:trigger>Open</:trigger>
    <:title>Custom</:title>
    <:content>
      <p>Motion animates open and close.</p>
    </:content>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
    </:close_trigger>
  </.dialog>
  ```

  ```javascript
  import { animate } from "motion"
  import {
    findDialogBackdrop,
    findDialogContent,
    animateScaleOpen,
    animateScaleClose,
  } from "corex"

  document.addEventListener("my-dialog-open-changed", (e) => {
    const { id, open } = e.detail
    const root = document.getElementById(id)
    if (!root) return
    const backdrop = findDialogBackdrop(root)
    const content = findDialogContent(root)
    if (open) {
      if (backdrop) animateScaleOpen(backdrop, { animator: animate, duration: 0.5, easing: "ease-out" })
      if (content) animateScaleOpen(content, { animator: animate, duration: 0.7, easing: [0.16, 1, 0.3, 1] })
    } else {
      if (backdrop) animateScaleClose(backdrop, { animator: animate, duration: 0.4, easing: "ease-in" })
      if (content) animateScaleClose(content, { animator: animate, duration: 0.35, easing: "ease-in" })
    }
  })
  ```

  <!-- tabs-close -->

  ## Style

  Stack modifiers on the host (`class` on `<.dialog>`).

  <!-- tabs-open -->

  ### Default

  ```heex
  <.dialog class="dialog">
    <:trigger>Open</:trigger>
    <:title>Default</:title>
    <:content><p>Default size.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ### Small

  ```heex
  <.dialog class="dialog dialog--sm">
    <:trigger>Open</:trigger>
    <:title>Small</:title>
    <:content><p>Compact dialog.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ### Large

  ```heex
  <.dialog class="dialog dialog--lg">
    <:trigger>Open</:trigger>
    <:title>Large</:title>
    <:content><p>Spacious dialog.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ### Text

  ```heex
  <.dialog class="dialog dialog--text-xl">
    <:trigger>Open</:trigger>
    <:title>Larger type</:title>
    <:content><p>Title, description, and body scale with the modifier.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ### Radius

  ```heex
  <.dialog class="dialog dialog--rounded-xl">
    <:trigger>Open</:trigger>
    <:title>Rounded panel</:title>
    <:content><p>Corner radius on the content panel and close trigger.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ### Side

  ```heex
  <.dialog class="dialog dialog--side" modal>
    <:trigger>Open</:trigger>
    <:title>Side panel</:title>
    <:content><p>Slides in from the edge.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  <!-- tabs-close -->

  '''

  defmodule Translation do
    @moduledoc """
    Translatable strings for the dialog.

    Pass `translation={%Corex.Dialog.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

    | Field | Default | Used for |
    | ----- | ------- | -------- |
    | `close` | Close | Close trigger `aria-label` |
    """

    alias Corex.Gettext

    defstruct [:close]

    @type t :: %__MODULE__{close: String.t()}

    @doc false
    def resolve(nil), do: default()

    def resolve(%__MODULE__{} = partial), do: merge(partial, default())

    defp default do
      %__MODULE__{close: Gettext.gettext("Close")}
    end

    defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
      %__MODULE__{close: Corex.Translation.take(partial.close, default.close)}
    end
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
    doc: "Whether the dialog is controlled. In LiveView, pair with on_open_change when true"
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
    translation = Translation.resolve(assigns.translation)

    assigns =
      assigns
      |> assign_new(:id, fn -> "dialog-#{System.unique_integer([:positive])}" end)
      |> assign(:translation, translation)

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
  @doc ~S"""
  Set open state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Dialog.set_open("my-dialog", true)}>Open</.action>
  <.dialog id="my-dialog" class="dialog">
    <:trigger>Open</:trigger>
    <:content><p>Content.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ```javascript
  document.getElementById("my-dialog")?.dispatchEvent(
    new CustomEvent("corex:dialog:set-open", {
      bubbles: false,
      detail: { open: true },
    })
  );
  ```
  """
  def set_open(dialog_id, open) when is_binary(dialog_id) and is_boolean(open) do
    JS.dispatch("corex:dialog:set-open",
      to: "##{dialog_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc ~S"""
  Set open state from `handle_event`.

  ```heex
  <.action phx-click="open_dialog">Open</.action>
  <.dialog id="my-dialog" class="dialog">
    <:trigger>Open</:trigger>
    <:content><p>Content.</p></:content>
    <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
  </.dialog>
  ```

  ```elixir
  def handle_event("open_dialog", _, socket) do
    {:noreply, Corex.Dialog.set_open(socket, "my-dialog", true)}
  end
  ```
  """
  def set_open(socket, dialog_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(dialog_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "dialog_set_open", %{
      dialog_id: dialog_id,
      open: open
    })
  end
end
