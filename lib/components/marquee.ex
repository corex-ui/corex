defmodule Corex.Marquee do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Marquee](https://zagjs.com/components/react/marquee).

  ## Examples

  ```heex
  <.marquee
    id="logos"
    items={[%{name: "Apple", logo: "🍎"}, %{name: "Banana", logo: "🍌"}]}
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

  ## Styling

  Target elements via data attributes:

  ```css
  [data-scope="marquee"][data-part="root"] {}
  [data-scope="marquee"][data-part="viewport"] {}
  [data-scope="marquee"][data-part="content"] {}
  [data-scope="marquee"][data-part="item"] {}
  [data-scope="marquee"][data-part="edge"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `marquee` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/marquee.css";
  ```

  You can then use modifiers

  ```heex
  <.marquee class="marquee marquee--accent marquee--lg">
  ```

  ## API Control

  Use an id on the component for programmatic control.

  **Client-side**

  ```heex
  <.action phx-click={Corex.Marquee.pause("my-marquee")}>Pause</.action>
  <.action phx-click={Corex.Marquee.resume("my-marquee")}>Resume</.action>
  <.action phx-click={Corex.Marquee.toggle_pause("my-marquee")}>Toggle</.action>
  ```

  **Server-side**

  ```elixir
  def handle_event("pause_marquee", _, socket) do
    {:noreply, Corex.Marquee.pause(socket, "my-marquee")}
  end
  ```

  ## Events

  - `on_pause_change` / `on_pause_change_client` - when pause status changes (detail: `%{paused: boolean}`)
  - `on_loop_complete` / `on_loop_complete_client` - when one loop completes
  - `on_complete` / `on_complete_client` - when all loops complete (finite loops only, `loop_count > 0`)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Marquee.Anatomy.{Content, Edge, Item, Props, Root, Viewport}
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

  attr(:default_paused, :boolean, default: false, doc: "Whether the marquee is paused by default")
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
    translate = marquee_translate(assigns.side, dir)

    assigns =
      assigns
      |> assign_new(:id, fn -> "marquee-#{System.unique_integer([:positive])}" end)
      |> assign(:items, items)
      |> assign(:items_count, items_count)
      |> assign(:orientation, orient)
      |> assign(:dir, dir)
      |> assign(:translate, translate)

    connect_props = %Props{
      id: assigns.id,
      aria_label: assigns.aria_label,
      duration: assigns.duration,
      items_count: items_count,
      content_count: 2,
      side: assigns.side,
      speed: assigns.speed,
      spacing: assigns.spacing,
      pause_on_interaction: assigns.pause_on_interaction,
      default_paused: assigns.default_paused,
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

    root_attrs = %Root{
      id: assigns.id,
      aria_label: assigns.aria_label,
      dir: dir,
      orientation: orient,
      duration: assigns.duration,
      spacing: assigns.spacing,
      delay: assigns.delay,
      loop_count: assigns.loop_count,
      translate: translate,
      respect_reduced_motion: assigns.respect_reduced_motion,
      default_paused: assigns.default_paused
    }

    assigns =
      assigns
      |> assign(:connect_props, connect_props)
      |> assign(:marquee_root, root_attrs)

    ~H"""
    <div
      id={@id}
      phx-hook="Marquee"
      phx-mounted={Connect.ignore_hook(@id)}
      data-loading
      {@rest}
      {Connect.props(@connect_props)}
    >
      <template data-part="items-template" style="display:none" aria-hidden="true">
        <div :for={item <- @items} {Connect.item(%Item{orientation: @orientation, dir: @dir})}>
          {render_slot(@item, item)}
        </div>
      </template>
      <div {Connect.root(@marquee_root)}>
        <div {Connect.edge(%Edge{side: "start", orientation: @orientation})}></div>
        <div {Connect.viewport(%Viewport{id: @id, orientation: @orientation, side: @side})}>
          <div
            :for={i <- 0..(@connect_props.content_count - 1)}
            {Connect.content(%Content{
              root_id: @id,
              index: i,
              orientation: @orientation,
              side: @side,
              reverse: @reverse,
              dir: @dir
            })}
          >
            <div :for={item <- @items} {Connect.item(%Item{orientation: @orientation, dir: @dir})}>
              {render_slot(@item, item)}
            </div>
          </div>
        </div>
        <div {Connect.edge(%Edge{side: "end", orientation: @orientation})}></div>
      </div>
    </div>
    """
  end

  defp orientation(side), do: if(side in ["top", "bottom"], do: "vertical", else: "horizontal")

  defp marquee_translate(side, dir) do
    case side do
      "top" -> "-100%"
      "bottom" -> "100%"
      "start" -> if(dir == "rtl", do: "-100%", else: "100%")
      _ -> if(dir == "rtl", do: "100%", else: "-100%")
    end
  end

  @doc """
  Pauses the marquee from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def pause(marquee_id) when is_binary(marquee_id) do
    JS.dispatch("corex:marquee:pause", to: "##{marquee_id}", bubbles: false)
  end

  @doc """
  Pauses the marquee from server-side. Pushes a LiveView event.
  """
  def pause(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    LiveView.push_event(socket, "marquee_pause", %{marquee_id: marquee_id})
  end

  @doc """
  Resumes the marquee from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def resume(marquee_id) when is_binary(marquee_id) do
    JS.dispatch("corex:marquee:resume", to: "##{marquee_id}", bubbles: false)
  end

  @doc """
  Resumes the marquee from server-side. Pushes a LiveView event.
  """
  def resume(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    LiveView.push_event(socket, "marquee_resume", %{marquee_id: marquee_id})
  end

  @doc """
  Toggles the pause state from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def toggle_pause(marquee_id) when is_binary(marquee_id) do
    JS.dispatch("corex:marquee:toggle-pause", to: "##{marquee_id}", bubbles: false)
  end

  @doc """
  Toggles the pause state from server-side. Pushes a LiveView event.
  """
  def toggle_pause(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    LiveView.push_event(socket, "marquee_toggle_pause", %{marquee_id: marquee_id})
  end
end
