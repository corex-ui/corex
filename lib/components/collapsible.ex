defmodule Corex.Collapsible do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Collapsible](https://zagjs.com/components/react/collapsible).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.collapsible class="collapsible">
    <:trigger>Toggle</:trigger>
    <:content>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    </:content>
  </.collapsible>
  ```

  ### With indicator

  Optional **`:closed`** and **`:opened`** slots render after the trigger label. Use one chevron in **`:closed`** and default CSS rotates it when open.

  ```heex
  <.collapsible class="collapsible">
    <:trigger>Toggle</:trigger>
    <:closed>
      <.heroicon name="hero-chevron-right" />
    </:closed>
    <:content>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    </:content>
  </.collapsible>
  ```

  ### Custom slots

  Use `:let={collapsible}` on slots to read `collapsible.open` and `collapsible.disabled`.

  ```heex
  <.collapsible class="collapsible">
    <:trigger :let={c}>
      {if c.open, do: "Collapse", else: "Expand"}
    </:trigger>
    <:closed>
      <.heroicon name="hero-chevron-down" />
    </:closed>
    <:opened>
      <.heroicon name="hero-chevron-up" />
    </:opened>
    <:content :let={_c}>
      Panel body with custom opened/closed adornments.
    </:content>
  </.collapsible>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.collapsible>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  <!-- tabs-open -->

  ### set_open

  ```heex
  <.action phx-click={Corex.Collapsible.set_open("collapsible-api", true)} class="button ui-size-sm">
    Open
  </.action>
  <.collapsible id="collapsible-api" class="collapsible">
    <:trigger>Toggle</:trigger>
    <:closed>
      <.heroicon name="hero-chevron-right" />
    </:closed>
    <:content>Lorem ipsum dolor sit amet.</:content>
  </.collapsible>
  ```

  ```elixir
  def handle_event("open_collapsible", _, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "collapsible-api", true)}
  end
  ```

  <!-- tabs-close -->

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="collapsible_open_changed"` | Open state changes | `%{"id" => id, "open" => open}` |

  <!-- tabs-open -->

  ### on_open_change

  ```heex
  <.collapsible
    class="collapsible"
    on_open_change="collapsible_open_changed"
  >
    <:trigger>Toggle</:trigger>
    <:closed>
      <.heroicon name="hero-chevron-right" />
    </:closed>
    <:content>Lorem ipsum dolor sit amet.</:content>
  </.collapsible>
  ```

  ```elixir
  def handle_event("collapsible_open_changed", %{"id" => id, "open" => open}, socket) do
    {:noreply, assign(socket, :open, open)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="collapsible-open-changed"` | Open state changes | `id`, `open`, `previousOpen` |

  <!-- tabs-open -->

  ### on_open_change_client

  ```heex
  <.collapsible
    id="collapsible-events-client"
    class="collapsible"
    on_open_change_client="collapsible-open-changed"
  >
    <:trigger>Toggle</:trigger>
    <:closed>
      <.heroicon name="hero-chevron-right" />
    </:closed>
    <:content>Lorem ipsum dolor sit amet.</:content>
  </.collapsible>
  ```

  ```javascript
  document.getElementById("collapsible-events-client")?.addEventListener("collapsible-open-changed", (e) => {
    console.log(e.detail);
  });
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Async

  ```heex
  <.async_result :let={panel} assign={@collapsible}>
    <:loading>
      <.collapsible_skeleton class="collapsible" />
    </:loading>
    <.collapsible class="collapsible" open={panel.open}>
      <:trigger>Details</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>{panel.body}</:content>
    </.collapsible>
  </.async_result>
  ```

  ```elixir
  socket =
    assign_async(socket, :collapsible, fn ->
      {:ok, %{collapsible: %{open: false, body: "Loaded after async."}}}
    end)
  ```

  ### Controlled

  ```heex
  <.collapsible
    class="collapsible"
    controlled
    open={@open}
    on_open_change="patterns_collapsible_changed"
  >
    <:trigger>Controlled</:trigger>
    <:closed>
      <.heroicon name="hero-chevron-right" />
    </:closed>
    <:content>LiveView owns open.</:content>
  </.collapsible>
  ```

  ```elixir
  def handle_event("patterns_collapsible_changed", %{"open" => open}, socket) do
    {:noreply, assign(socket, :open, open)}
  end
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`. Content exposes `--height`, `--collapsed-height`, and related CSS variables for height animations.

  ```css
  [data-scope="collapsible"][data-part="root"] {}
  [data-scope="collapsible"][data-part="trigger"] {}
  [data-scope="collapsible"][data-part="content"] {}
  [data-scope="collapsible"][data-part="closed"] {}
  [data-scope="collapsible"][data-part="opened"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.collapsible>`). Combine axes, for example `collapsible ui-accent ui-size-lg` or `collapsible ui-info`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on triggers. Variant modifiers control surface treatment. Default open triggers use a neutral selected surface with semantic text ink; add `ui-solid` for a filled open trigger.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for trigger ink and fill. Does not change open trigger treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `collapsible ui-size-md` |
  | Accent | `collapsible ui-size-md ui-accent` |
  | Brand | `collapsible ui-size-md ui-brand` |
  | Alert | `collapsible ui-size-md ui-alert` |
  | Info | `collapsible ui-size-md ui-info` |
  | Success | `collapsible ui-size-md ui-success` |

  ### Variant

  Visual treatment of the trigger. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `collapsible ui-size-md` or `collapsible ui-size-md ui-accent` |
  | Solid | `collapsible ui-size-md ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `collapsible ui-size-sm` |
  | MD | `collapsible ui-size-md` |
  | LG | `collapsible ui-size-lg` |

  <!-- tabs-close -->
  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Api.RespondTo
  alias Corex.Collapsible.Anatomy.{Closed, Content, Opened, Props, Root, Trigger}
  alias Corex.Collapsible.Connect

  @doc """
  Renders a collapsible component.

  Requires `:trigger` and `:content` slots. Optional **`:closed`** and **`:opened`** slots add visual surfaces after the trigger label (Connect `data-part` only, no Zag props). Use `:let={collapsible}` on slots to access `collapsible.open` and `collapsible.disabled`.
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

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS."
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

  slot :closed,
    required: false,
    doc:
      "Optional surface after the trigger, visible when closed (or use with `:opened` to swap content by state)." do
    attr(:class, :string, required: false)
  end

  slot :opened,
    required: false,
    doc:
      "Optional surface after the trigger, visible when open (use with `:closed` to swap content by state)." do
    attr(:class, :string, required: false)
  end

  def collapsible(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "collapsible-#{System.unique_integer([:positive])}" end)
      |> assign(:slot_assigns, %{open: assigns.open, disabled: assigns.disabled})

    closed_part = %Closed{
      id: assigns.id,
      dir: assigns.dir,
      disabled: assigns.disabled,
      orientation: assigns.orientation
    }

    opened_part = %Opened{
      id: assigns.id,
      dir: assigns.dir,
      disabled: assigns.disabled,
      orientation: assigns.orientation
    }

    assigns =
      assigns
      |> assign(:closed_part, closed_part)
      |> assign(:opened_part, opened_part)

    ~H"""
    <div
      id={@id}
      phx-hook="Collapsible"
      data-loading 
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}     
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        open: @open,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, open: @open, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, open: @open, orientation: @orientation})}>
        <button phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir, open: @open, disabled: @disabled, orientation: @orientation})} {Connect.trigger(%Trigger{id: @id, dir: @dir, open: @open, disabled: @disabled, orientation: @orientation})}>
          {render_slot(@trigger, @slot_assigns)}
          <span
            :if={@closed != []}
            phx-mounted={Connect.ignore_closed_part(@closed_part)}
            {Connect.closed_part(@closed_part)}
            class={@closed |> List.first() |> Map.get(:class)}
          >
            {render_slot(@closed, @slot_assigns)}
          </span>
          <span
            :if={@opened != []}
            phx-mounted={Connect.ignore_opened_part(@opened_part)}
            {Connect.opened_part(@opened_part)}
            class={@opened |> List.first() |> Map.get(:class)}
          >
            {render_slot(@opened, @slot_assigns)}
          </span>
        </button>
        <div phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, open: @open, disabled: @disabled, orientation: @orientation})} {Connect.content(%Content{id: @id, dir: @dir, open: @open, disabled: @disabled, orientation: @orientation})}>
          {render_slot(@content, @slot_assigns)}
        </div>
      </div>
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the collapsible component.
  """

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Same as collapsible: logical direction for the skeleton root."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Same as collapsible: layout orientation for CSS."
  )

  attr(:rest, :global)

  def collapsible_skeleton(assigns) do
    ~H"""
    <div data-dir={@dir} data-orientation={@orientation} {@rest}>
      <div
        data-scope="collapsible"
        data-part="root"
        data-loading
        dir={@dir}
        data-orientation={@orientation}
      >
        <button
          type="button"
          data-scope="collapsible"
          data-part="trigger"
          aria-hidden="true"
          tabindex="-1"
        >
        </button>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set expanded or collapsed state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Collapsible.set_open("my-collapsible", true)}>Expand</.action>
  <.collapsible id="my-collapsible" class="collapsible ui-size-md">
    <:trigger :let={c}>{if c.open, do: "Hide", else: "Show"}</:trigger>
    <:content>Details.</:content>
  </.collapsible>
  ```

  ```javascript
  document.getElementById("my-collapsible")?.dispatchEvent(
    new CustomEvent("corex:collapsible:set-open", {
      bubbles: false,
      detail: { open: true },
    })
  );
  ```
  """)

  def set_open(collapsible_id, open) when is_binary(collapsible_id) and is_boolean(open) do
    RespondTo.dispatch_set_open(collapsible_id, open, "corex:collapsible:set-open")
  end

  api_doc(~S"""
  Set open state from `handle_event`.

  ```heex
  <.action phx-click="expand_collapsible">Expand</.action>
  <.collapsible id="my-collapsible" class="collapsible ui-size-md">
    <:trigger :let={c}>{if c.open, do: "Hide", else: "Show"}</:trigger>
    <:content>Details.</:content>
  </.collapsible>
  ```

  ```elixir
  def handle_event("expand_collapsible", _, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "my-collapsible", true)}
  end
  ```
  """)

  def set_open(socket, collapsible_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(collapsible_id) and
             is_boolean(open) do
    RespondTo.push_set_open(socket, "collapsible_set_open", collapsible_id, open)
  end
end
