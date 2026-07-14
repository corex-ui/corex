defmodule Corex.Marquee do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Marquee](https://zagjs.com/components/react/marquee).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.marquee
    class="marquee"
    items={[
      %{name: "Apple", logo: "🍎"},
      %{name: "Banana", logo: "🍌"},
      %{name: "Cherry", logo: "🍒"}
    ]}
    duration={20}
    spacing="2rem"
    pause_on_interaction
  >
    <:item :let={item}>
      <span>{item.logo}</span>
      <span>{item.name}</span>
    </:item>
  </.marquee>
  ```

  ### Custom slots

  ```heex
  <.marquee
    class="marquee"
    items={[
      %{name: "Home", icon: "hero-home"},
      %{name: "User", icon: "hero-user"},
      %{name: "Cog", icon: "hero-cog-6-tooth"}
    ]}
    duration={25}
    spacing="2rem"
    pause_on_interaction
  >
    <:item :let={item}>
      <.heroicon name={item.icon} />
      <span>{item.name}</span>
    </:item>
  </.marquee>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.marquee>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`pause/1`](#pause/1) | Pause animation (client) | `%Phoenix.LiveView.JS{}` |
  | [`pause/2`](#pause/2) | Pause animation (server) | `socket` |
  | [`resume/1`](#resume/1) | Resume animation (client) | `%Phoenix.LiveView.JS{}` |
  | [`resume/2`](#resume/2) | Resume animation (server) | `socket` |
  | [`toggle_pause/1`](#toggle_pause/1) | Toggle pause (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_pause/2`](#toggle_pause/2) | Toggle pause (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.marquee>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_pause_change="marquee_pause_changed"` | Pause state changes | `%{"id" => id, "paused" => boolean}` |
  | `on_loop_complete="marquee_loop_complete"` | One loop finishes | `%{"id" => id}` |
  | `on_complete="marquee_complete"` | All loops finish (`loop_count > 0`) | `%{"id" => id}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_pause_change_client="marquee-pause-changed"` | Pause state changes | `id`, `paused` |
  | `on_loop_complete_client="marquee-loop-complete"` | One loop finishes | `id` |
  | `on_complete_client="marquee-complete"` | All loops finish | `id` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `marquee.css`, then set `class="marquee"` on `<.marquee>`.

  ```css
  [data-scope="marquee"][data-part="root"] {}
  [data-scope="marquee"][data-part="viewport"] {}
  [data-scope="marquee"][data-part="content"] {}
  [data-scope="marquee"][data-part="item"] {}
  [data-scope="marquee"][data-part="edge"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.marquee>`).

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `marquee` |
  | Accent | `marquee marquee ui-accent` |
  | Brand | `marquee marquee ui-brand` |
  | Alert | `marquee marquee ui-alert` |
  | Info | `marquee marquee ui-info` |
  | Success | `marquee marquee ui-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `marquee marquee ui-size-sm` |
  | MD | `marquee marquee ui-size-md` |
  | LG | `marquee marquee ui-size-lg` |
  | XL | `marquee marquee ui-size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Marquee.Anatomy.{Item, Props}
  alias Corex.Marquee.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)

  attr(:aria_label, :string,
    default: nil,
    doc: "Accessible name for the marquee region. Defaults to \"Marquee: {id}\" when omitted."
  )

  attr(:items, :list, required: true, doc: "List of maps for each marquee item")
  attr(:duration, :integer, default: 20, doc: "Animation duration in seconds")
  attr(:side, :string, default: "end", values: ["start", "end", "top", "bottom"])
  attr(:speed, :integer, default: 100, doc: "Animation speed in pixels per second")
  attr(:spacing, :string, default: "1rem", doc: "Spacing between items")

  attr(:pause_on_interaction, :boolean,
    default: false,
    doc: "Whether to pause the animation on interaction"
  )

  attr(:paused, :boolean, default: false, doc: "Whether the marquee starts paused")
  attr(:delay, :integer, default: 0, doc: "Delay before starting the animation in seconds")

  attr(:loop_count, :integer,
    default: 0,
    doc: "Number of times to loop the animation, setting to 0 creates an infinite loop"
  )

  attr(:reverse, :boolean, default: false, doc: "Whether to reverse the animation")

  attr(:respect_reduced_motion, :boolean,
    default: true,
    doc: "When false, animation runs even when user has prefers-reduced-motion"
  )

  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_pause_change, :string, default: nil, doc: "Server event when pause status changes")

  attr(:on_pause_change_client, :string,
    default: nil,
    doc: "Client event when pause status changes"
  )

  attr(:on_loop_complete, :string, default: nil, doc: "Server event when one loop completes")

  attr(:on_loop_complete_client, :string,
    default: nil,
    doc: "Client event when one loop completes"
  )

  attr(:on_complete, :string,
    default: nil,
    doc: "Server event when all loops complete (finite loops only)"
  )

  attr(:on_complete_client, :string,
    default: nil,
    doc: "Client event when all loops complete (finite loops only)"
  )

  attr(:rest, :global)

  slot :item, required: true do
    attr(:class, :string, required: false)
  end

  def marquee(assigns) do
    items = List.wrap(assigns.items)
    items_count = length(items)
    orient = orientation(assigns.side)
    dir = assigns.dir || "ltr"

    assigns =
      assigns
      |> assign_new(:id, fn -> "marquee-#{System.unique_integer([:positive])}" end)
      |> assign(:items, items)
      |> assign(:items_count, items_count)
      |> assign(:orientation, orient)
      |> assign(:dir, dir)

    connect_props = %Props{
      id: assigns.id,
      aria_label: assigns.aria_label,
      duration: assigns.duration,
      items_count: items_count,
      side: assigns.side,
      speed: assigns.speed,
      spacing: assigns.spacing,
      pause_on_interaction: assigns.pause_on_interaction,
      paused: assigns.paused,
      delay: assigns.delay,
      loop_count: assigns.loop_count,
      reverse: assigns.reverse,
      respect_reduced_motion: assigns.respect_reduced_motion,
      dir: dir,
      orientation: orient,
      on_pause_change: assigns.on_pause_change,
      on_pause_change_client: assigns.on_pause_change_client,
      on_loop_complete: assigns.on_loop_complete,
      on_loop_complete_client: assigns.on_loop_complete_client,
      on_complete: assigns.on_complete,
      on_complete_client: assigns.on_complete_client
    }

    assigns = assign(assigns, :connect_props, connect_props)

    ~H"""
    <div
      id={@id}
      phx-hook="Marquee"
      phx-mounted={Connect.ignore_hook(@id)}
      data-loading
      {@rest}
      {Connect.props(@connect_props)}
    >
      <div data-part="ssr-preview" data-orientation={@orientation} aria-hidden="true">
        <div :for={item <- @items} {Connect.item(%Item{orientation: @orientation, dir: @dir})}>
          {render_slot(@item, item)}
        </div>
      </div>
      <template data-part="items-template" style="display:none" aria-hidden="true">
        <div :for={item <- @items} {Connect.item(%Item{orientation: @orientation, dir: @dir})}>
          {render_slot(@item, item)}
        </div>
      </template>
    </div>
    """
  end

  defp orientation(side), do: if(side in ["top", "bottom"], do: "vertical", else: "horizontal")

  api_doc(~S"""
  Pause the marquee from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Marquee.pause("my-marquee")}>Pause</.action>
  <.marquee
    id="my-marquee"
    class="marquee"
    items={[%{name: "A"}, %{name: "B"}]}
    duration={20}
    spacing="2rem"
  >
    <:item :let={item}><span>{item.name}</span></:item>
  </.marquee>
  ```

  ```javascript
  document.getElementById("my-marquee")?.dispatchEvent(
    new CustomEvent("corex:marquee:pause", { bubbles: false })
  );
  ```
  """)

  def pause(marquee_id) when is_binary(marquee_id) do
    JS.dispatch("corex:marquee:pause", to: "##{marquee_id}", bubbles: false)
  end

  api_doc(~S"""
  Pause from `handle_event`. Pushes `marquee_pause`.

  ```heex
  <.action phx-click="pause_marquee">Pause</.action>
  <.marquee
    id="my-marquee"
    class="marquee"
    items={[%{name: "A"}, %{name: "B"}]}
    duration={20}
    spacing="2rem"
  >
    <:item :let={item}><span>{item.name}</span></:item>
  </.marquee>
  ```

  ```elixir
  def handle_event("pause_marquee", _, socket) do
    {:noreply, Corex.Marquee.pause(socket, "my-marquee")}
  end
  ```
  """)

  def pause(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    LiveView.push_event(socket, "marquee_pause", %{marquee_id: marquee_id})
  end

  api_doc(~S"""
  Resume the marquee from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Marquee.resume("my-marquee")}>Resume</.action>
  <.marquee
    id="my-marquee"
    class="marquee"
    items={[%{name: "A"}, %{name: "B"}]}
    duration={20}
    spacing="2rem"
    paused
  >
    <:item :let={item}><span>{item.name}</span></:item>
  </.marquee>
  ```

  ```javascript
  document.getElementById("my-marquee")?.dispatchEvent(
    new CustomEvent("corex:marquee:resume", { bubbles: false })
  );
  ```
  """)

  def resume(marquee_id) when is_binary(marquee_id) do
    JS.dispatch("corex:marquee:resume", to: "##{marquee_id}", bubbles: false)
  end

  api_doc(~S"""
  Resume from `handle_event`. Pushes `marquee_resume`.

  ```heex
  <.action phx-click="resume_marquee">Resume</.action>
  <.marquee
    id="my-marquee"
    class="marquee"
    items={[%{name: "A"}, %{name: "B"}]}
    duration={20}
    spacing="2rem"
    paused
  >
    <:item :let={item}><span>{item.name}</span></:item>
  </.marquee>
  ```

  ```elixir
  def handle_event("resume_marquee", _, socket) do
    {:noreply, Corex.Marquee.resume(socket, "my-marquee")}
  end
  ```
  """)

  def resume(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    LiveView.push_event(socket, "marquee_resume", %{marquee_id: marquee_id})
  end

  api_doc(~S"""
  Toggle paused state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Marquee.toggle_pause("my-marquee")}>Toggle</.action>
  <.marquee
    id="my-marquee"
    class="marquee"
    items={[%{name: "A"}, %{name: "B"}]}
    duration={20}
    spacing="2rem"
  >
    <:item :let={item}><span>{item.name}</span></:item>
  </.marquee>
  ```

  ```javascript
  document.getElementById("my-marquee")?.dispatchEvent(
    new CustomEvent("corex:marquee:toggle-pause", { bubbles: false })
  );
  ```
  """)

  def toggle_pause(marquee_id) when is_binary(marquee_id) do
    JS.dispatch("corex:marquee:toggle-pause", to: "##{marquee_id}", bubbles: false)
  end

  api_doc(~S"""
  Toggle pause from `handle_event`. Pushes `marquee_toggle_pause`.

  ```heex
  <.action phx-click="toggle_marquee">Toggle</.action>
  <.marquee
    id="my-marquee"
    class="marquee"
    items={[%{name: "A"}, %{name: "B"}]}
    duration={20}
    spacing="2rem"
  >
    <:item :let={item}><span>{item.name}</span></:item>
  </.marquee>
  ```

  ```elixir
  def handle_event("toggle_marquee", _, socket) do
    {:noreply, Corex.Marquee.toggle_pause(socket, "my-marquee")}
  end
  ```
  """)

  def toggle_pause(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    LiveView.push_event(socket, "marquee_toggle_pause", %{marquee_id: marquee_id})
  end
end
