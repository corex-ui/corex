defmodule Corex.Collapsible do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Collapsible](https://zagjs.com/components/react/collapsible).

  ## Examples

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.collapsible id="my-collapsible">
    <:trigger>Toggle Content</:trigger>
    <:content>
      This content can be collapsed and expanded.
    </:content>
  </.collapsible>
  ```

  ### With indicator

  Use the optional `:indicator` slot to add an icon after the trigger. Use CSS classes `state-open` and `state-closed` to target the indicator by `data-state`.

  ```heex
  <.collapsible id="my-collapsible">
    <:trigger>Toggle Content</:trigger>
    <:indicator>
      <.heroicon name="hero-chevron-down" class="state-closed" />
      <.heroicon name="hero-chevron-up" class="state-open" />
    </:indicator>
    <:content>
      This content can be collapsed and expanded.
    </:content>
  </.collapsible>
  ```

  ### Custom with :let

  Use `:let={collapsible}` on `:trigger`, `:content`, or `:indicator` to access `collapsible.open` and `collapsible.disabled`.

  ```heex
  <.collapsible id="my-collapsible">
    <:trigger :let={collapsible}>
      <%= if collapsible.open, do: "Collapse", else: "Expand" %>
    </:trigger>
    <:content :let={_c}>Panel body</:content>
    <:indicator :let={collapsible}>
      <.heroicon name={if collapsible.open, do: "hero-minus", else: "hero-plus"} />
    </:indicator>
  </.collapsible>
  ```

  ### Controlled

  ```heex
  <.collapsible
    id="my-collapsible"
    controlled
    open={@collapsible_open}
    on_open_change="collapsible_changed">
    <:trigger>Toggle Content</:trigger>
    <:content>
      This content can be collapsed and expanded.
    </:content>
  </.collapsible>
  ```

  ```elixir
  def handle_event("collapsible_changed", %{"open" => open}, socket) do
    {:noreply, assign(socket, :collapsible_open, open)}
  end
  ```

  <!-- tabs-close -->

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Collapsible.set_open("my-collapsible", true)}>
    Open
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("open_collapsible", _, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "my-collapsible", true)}
  end
  ```

  ## Styling

  Target parts with `data-scope="collapsible"` and `data-part`:

  ```css
  [data-scope="collapsible"][data-part="root"] {}
  [data-scope="collapsible"][data-part="trigger"] {}
  [data-scope="collapsible"][data-part="content"] {}
  [data-scope="collapsible"][data-part="indicator"] {}
  ```

  Root, trigger, and content have `data-state="open"` or `data-state="closed"`. When the trigger is focused, `data-focus` is set on root, trigger, and content.

  The content part exposes `--height`, `--width`, `--collapsed-height`, and `--collapsed-width` for animations. Example:

  ```css
  [data-scope="collapsible"][data-part="content"] {
    overflow: hidden;
  }
  [data-scope="collapsible"][data-part="content"][data-state="open"] {
    animation: expand 110ms cubic-bezier(0, 0, 0.38, 0.9);
  }
  [data-scope="collapsible"][data-part="content"][data-state="closed"] {
    animation: collapse 110ms cubic-bezier(0, 0, 0.38, 0.9);
  }
  @keyframes expand {
    from { height: var(--collapsed-height, 0); }
    to { height: var(--height); }
  }
  @keyframes collapse {
    from { height: var(--height); }
    to { height: var(--collapsed-height, 0); }
  }
  ```

  If you wish to use the default Corex styling, you can use the class `collapsible` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/collapsible.css";
  ```

  You can then use modifiers

  ```heex
  <.collapsible class="collapsible collapsible--accent collapsible--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/collapsible#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Collapsible.Anatomy.{Content, Indicator, Props, Root, Trigger}
  alias Corex.Collapsible.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a collapsible component.

  Requires `:trigger` and `:content` slots. Use the optional `:indicator` slot to add content after the trigger. Use `:let={collapsible}` on any slot to access `collapsible.open` and `collapsible.disabled`.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the collapsible, useful for API to identify the collapsible"
  )

  attr(:open, :boolean,
    default: false,
    doc: "The initial open state or the controlled open state"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the collapsible is controlled. Only in LiveView, the on_open_change event is required"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the collapsible is disabled"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the collapsible. When nil, derived from document (html lang + config :rtl_locales)"
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

  slot :trigger,
    required: true,
    doc: "Trigger button content. Use :let={collapsible} to access open and disabled state." do
    attr(:class, :string, required: false)
  end

  slot :content,
    required: true,
    doc: "Expandable content. Use :let={collapsible} to access open and disabled state." do
    attr(:class, :string, required: false)
  end

  slot :indicator,
    required: false,
    doc:
      "Optional content after the trigger (e.g. chevron). Use :let={collapsible} for state. Target data-state with .state-open and .state-closed in CSS." do
    attr(:class, :string, required: false)
  end

  def collapsible(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "collapsible-#{System.unique_integer([:positive])}" end)
      |> assign(:slot_assigns, %{open: assigns.open, disabled: assigns.disabled})

    ~H"""
    <div
      id={@id}
      phx-hook="Collapsible"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        open: @open,
        disabled: @disabled,
        dir: @dir,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client
      })}
    >
      <div {Connect.root(%Root{id: @id, dir: @dir, open: @open})}>
        <button {Connect.trigger(%Trigger{id: @id, dir: @dir, open: @open, disabled: @disabled})}>
          {render_slot(@trigger, @slot_assigns)}
          <span :if={@indicator != []} {Connect.indicator(%Indicator{id: @id, dir: @dir, open: @open, disabled: @disabled})}>
            {render_slot(@indicator, @slot_assigns)}
          </span>
        </button>
        <div {Connect.content(%Content{id: @id, dir: @dir, open: @open, disabled: @disabled})}>
          {render_slot(@content, @slot_assigns)}
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the collapsible open state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Collapsible.set_open("my-collapsible", true)}>
        Open
      </button>
  """
  def set_open(collapsible_id, open) when is_binary(collapsible_id) and is_boolean(open) do
    JS.dispatch("phx:collapsible:set-open",
      to: "##{collapsible_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the collapsible open state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_collapsible", _params, socket) do
        socket = Corex.Collapsible.set_open(socket, "my-collapsible", true)
        {:noreply, socket}
      end
  """
  def set_open(socket, collapsible_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(collapsible_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "collapsible_set_open", %{
      collapsible_id: collapsible_id,
      open: open
    })
  end
end
