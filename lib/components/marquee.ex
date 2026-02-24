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
    <:item :let={%{item: item}}>
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

  alias Corex.Marquee.Anatomy.{Props, Root, Edge, Viewport, Content, Item}
  alias Corex.Marquee.Connect

  attr(:id, :string, required: false)

  attr(:aria_label, :string,
    default: nil,
    doc: "Accessible name for the marquee region. Defaults to \"Marquee: {id}\" when omitted."
  )

  attr(:items, :list, required: true, doc: "List of maps for each marquee item")
  attr(:duration, :integer, required: true, doc: "Animation duration in seconds")
  attr(:side, :string, default: "end", values: ["start", "end", "top", "bottom"])
  attr(:speed, :integer, default: 50)
  attr(:spacing, :string, default: "1rem")
  attr(:auto_fill, :boolean, default: true)
  attr(:pause_on_interaction, :boolean, default: false)
  attr(:default_paused, :boolean, default: false)
  attr(:delay, :integer, default: 0)
  attr(:loop_count, :integer, default: 0)
  attr(:reverse, :boolean, default: false)

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

  slot(:item, required: true)
  slot(:edge_start, required: false)
  slot(:edge_end, required: false)

  def marquee(assigns) do
    items = List.wrap(assigns.items)
    items_count = length(items)
    content_count = if(assigns.auto_fill, do: 2, else: 1)
    orient = orientation(assigns.side)
    dir = assigns.dir || "ltr"
    translate = marquee_translate(assigns.side, dir)

    assigns =
      assigns
      |> assign_new(:id, fn -> "marquee-#{System.unique_integer([:positive])}" end)
      |> assign(:items, items)
      |> assign(:items_count, items_count)
      |> assign(:content_count, content_count)
      |> assign(:orientation, orient)
      |> assign(:dir, dir)
      |> assign(:translate, translate)

    ~H"""
    <div
      id={@id}
      phx-hook="Marquee"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        aria_label: @aria_label,
        duration: @duration,
        items_count: @items_count,
        content_count: @content_count,
        side: @side,
        speed: @speed,
        spacing: @spacing,
        auto_fill: @auto_fill,
        pause_on_interaction: @pause_on_interaction,
        default_paused: @default_paused,
        delay: @delay,
        loop_count: @loop_count,
        reverse: @reverse,
        respect_reduced_motion: @respect_reduced_motion,
        dir: @dir,
        orientation: @orientation,
        on_pause_change: @on_pause_change,
        on_pause_change_client: @on_pause_change_client,
        on_loop_complete: @on_loop_complete,
        on_loop_complete_client: @on_loop_complete_client,
        on_complete: @on_complete,
        on_complete_client: @on_complete_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, aria_label: @aria_label, dir: @dir, orientation: @orientation, duration: @duration, spacing: @spacing, delay: @delay, loop_count: @loop_count, translate: @translate, respect_reduced_motion: @respect_reduced_motion})}>
        <div :if={!Enum.empty?(@edge_start)} {Connect.edge(%Edge{side: "start", orientation: @orientation})}>
          {render_slot(@edge_start)}
        </div>
        <div {Connect.viewport(%Viewport{id: @id, orientation: @orientation, side: @side})}>
          <div :for={idx <- 0..(@content_count - 1)} {Connect.content(%Content{root_id: @id, index: idx, clone: idx > 0, orientation: @orientation, side: @side, reverse: @reverse})}>
            <div :for={item <- @items} {Connect.item(%Item{orientation: @orientation})}>
              {render_slot(@item, %{item: item})}
            </div>
          </div>
        </div>
        <div :if={!Enum.empty?(@edge_end)} {Connect.edge(%Edge{side: "end", orientation: @orientation})}>
          {render_slot(@edge_end)}
        </div>
      </div>
    </div>
    """
  end

  defp orientation(side), do: if(side in ["top", "bottom"], do: "vertical", else: "horizontal")

  defp marquee_translate(side, dir) do
    case side do
      "top" -> "-100%"
      "bottom" -> "100%"
      "start" -> if(dir == "rtl", do: "100%", else: "-100%")
      _ -> if(dir == "rtl", do: "-100%", else: "100%")
    end
  end

  @doc """
  Pauses the marquee from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def pause(marquee_id) when is_binary(marquee_id) do
    Phoenix.LiveView.JS.dispatch("phx:marquee:pause", to: "##{marquee_id}", bubbles: false)
  end

  @doc """
  Pauses the marquee from server-side. Pushes a LiveView event.
  """
  def pause(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    Phoenix.LiveView.push_event(socket, "marquee_pause", %{marquee_id: marquee_id})
  end

  @doc """
  Resumes the marquee from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def resume(marquee_id) when is_binary(marquee_id) do
    Phoenix.LiveView.JS.dispatch("phx:marquee:resume", to: "##{marquee_id}", bubbles: false)
  end

  @doc """
  Resumes the marquee from server-side. Pushes a LiveView event.
  """
  def resume(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    Phoenix.LiveView.push_event(socket, "marquee_resume", %{marquee_id: marquee_id})
  end

  @doc """
  Toggles the pause state from client-side. Returns a `Phoenix.LiveView.JS` command.
  """
  def toggle_pause(marquee_id) when is_binary(marquee_id) do
    Phoenix.LiveView.JS.dispatch("phx:marquee:toggle-pause", to: "##{marquee_id}", bubbles: false)
  end

  @doc """
  Toggles the pause state from server-side. Pushes a LiveView event.
  """
  def toggle_pause(socket, marquee_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(marquee_id) do
    Phoenix.LiveView.push_event(socket, "marquee_toggle_pause", %{marquee_id: marquee_id})
  end
end
