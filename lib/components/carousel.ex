defmodule Corex.Carousel do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Carousel](https://zagjs.com/components/react/carousel).

  ## Examples

  ### Basic with image URLs

  ```heex
  <.carousel id="car" items={["/images/beach.jpg", "/images/fall.jpg", "/images/sand.jpg"]} class="carousel">
    <:prev_trigger>
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" /></svg>
    </:prev_trigger>
    <:next_trigger>
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" /></svg>
    </:next_trigger>
  </.carousel>
  ```

  Items can be URLs (strings) or maps with `:url` and optional `:alt` keys.

  ## API

  Imperative helpers target the carousel by DOM `id` on the hook root (the same `id` you pass to `carousel/1`).

  - **Client** — `play/1`, `pause/1`, `scroll_next/1`, `scroll_prev/1`, and `scroll_next/2`, `scroll_prev/2` with optional `instant` (`JS.dispatch` to `corex:carousel:*`).
  - **Server** — `play/2`, `pause/2`, `scroll_next/2`, `scroll_prev/2`, and `scroll_next/3`, `scroll_prev/3` with optional `instant` (`push_event` consumed by the hook).

  ## Events

  **From the client**, dispatch `CustomEvent`s on the hook root (`#your-id`):

  | Type | Purpose |
  |------|---------|
  | `corex:carousel:play` | Start or resume autoplay |
  | `corex:carousel:pause` | Pause autoplay |
  | `corex:carousel:scroll-next` | Next page; optional `detail.instant` boolean |
  | `corex:carousel:scroll-prev` | Previous page; optional `detail.instant` boolean |

  **From LiveView**, `push_event` names: `carousel_play`, `carousel_pause`, `carousel_scroll_next`, `carousel_scroll_prev` with payload `%{"id" => ...}` and optional `"instant"` for scroll events.

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="carousel"][data-part="root"] {}
  [data-scope="carousel"][data-part="control"] {}
  [data-scope="carousel"][data-part="item-group"] {}
  [data-scope="carousel"][data-part="item"] {}
  [data-scope="carousel"][data-part="prev-trigger"] {}
  [data-scope="carousel"][data-part="next-trigger"] {}
  [data-scope="carousel"][data-part="indicator-group"] {}
  [data-scope="carousel"][data-part="indicator"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `carousel` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/carousel.css";
  ```

  You can then use modifiers

  ```heex
  <.carousel class="carousel carousel--accent carousel--lg" items={[]}>
  </.carousel>
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Carousel.Anatomy.{
    Control,
    Indicator,
    IndicatorGroup,
    Item,
    ItemGroup,
    NextTrigger,
    PrevTrigger,
    Props,
    Root
  }

  alias Corex.Carousel.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:aria_label, :string, default: nil)

  attr(:items, :list,
    required: true,
    doc: "List of image URLs (strings) or maps with :url and optional :alt"
  )

  attr(:page, :integer, default: 0)
  attr(:controlled, :boolean, default: false)
  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"])
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])
  attr(:slides_per_page, :integer, default: 1)

  attr(:slides_per_move, :any,
    default: nil,
    doc: "Number of slides to move per step, or \"auto\""
  )

  attr(:loop, :boolean, default: false)
  attr(:autoplay, :boolean, default: false)
  attr(:autoplay_delay, :integer, default: 4000)
  attr(:allow_mouse_drag, :boolean, default: false)
  attr(:spacing, :string, default: "0px")
  attr(:padding, :string, default: nil)
  attr(:in_view_threshold, :float, default: 0.6)
  attr(:snap_type, :string, default: "mandatory", values: ["proximity", "mandatory"])
  attr(:auto_size, :boolean, default: false)
  attr(:on_page_change, :string, default: nil)
  attr(:on_page_change_client, :string, default: nil)

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode with :let={ctx} and carousel_root, carousel_item_group, carousel_item, carousel_control, carousel_prev_trigger, carousel_next_trigger, carousel_indicator_group, carousel_indicator."
  )

  attr(:rest, :global)

  slot(:inner_block,
    required: false,
    doc: "Compound mode. Use compound and :let={ctx}."
  )

  slot :prev_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :next_trigger, required: false do
    attr(:class, :string, required: false)
  end

  def carousel(assigns) do
    items = List.wrap(assigns.items)
    slide_count = length(items)
    slides_per_page = assigns.slides_per_page || 1

    total_pages =
      if slide_count == 0 do
        0
      else
        div(slide_count + slides_per_page - 1, slides_per_page)
      end

    page = assigns.page || 0
    loop = assigns.loop || false
    prev_disabled = !loop and page <= 0
    next_disabled = !loop and (total_pages == 0 or page >= total_pages - 1)

    assigns =
      assigns
      |> assign_new(:id, fn -> "carousel-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:items, items)
      |> assign(:slide_count, slide_count)
      |> assign(:total_pages, total_pages)
      |> assign(:prev_disabled, prev_disabled)
      |> assign(:next_disabled, next_disabled)

    ctx = %{
      id: assigns.id,
      items: assigns.items,
      slide_count: assigns.slide_count,
      total_pages: assigns.total_pages,
      page: assigns.page,
      prev_disabled: assigns.prev_disabled,
      next_disabled: assigns.next_disabled,
      orientation: assigns.orientation,
      dir: assigns.dir,
      slides_per_page: assigns.slides_per_page,
      spacing: assigns.spacing,
      aria_label: assigns.aria_label
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div
      id={@id}
      phx-hook="Carousel"
      data-loading      
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      data-slide-count={@slide_count}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        slide_count: @slide_count,
        page: @page,
        controlled: @controlled,
        dir: @dir,
        orientation: @orientation,
        slides_per_page: @slides_per_page,
        slides_per_move: @slides_per_move,
        loop: @loop,
        autoplay: @autoplay,
        autoplay_delay: @autoplay_delay,
        allow_mouse_drag: @allow_mouse_drag,
        spacing: @spacing,
        padding: @padding,
        in_view_threshold: @in_view_threshold,
        snap_type: @snap_type,
        auto_size: @auto_size,
        on_page_change: @on_page_change,
        on_page_change_client: @on_page_change_client
      })}
    >
      {if @compound do
        render_slot(@inner_block, @ctx)
      end}
      <div :if={not @compound}
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation, slides_per_page: @slides_per_page, spacing: @spacing, aria_label: @aria_label})}
        {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, slides_per_page: @slides_per_page, spacing: @spacing, aria_label: @aria_label})}
      >
        <div
          phx-mounted={Connect.ignore_item_group(%ItemGroup{id: @id, orientation: @orientation, dir: @dir})}
          {Connect.item_group(%ItemGroup{id: @id, orientation: @orientation, dir: @dir})}
        >
          <div
            :for={{item, i} <- Enum.with_index(@items)}
            phx-mounted={Connect.ignore_item(%Item{id: @id, index: i, orientation: @orientation, slide_count: @slide_count})}
            {Connect.item(%Item{id: @id, index: i, orientation: @orientation, slide_count: @slide_count})}
            data-index={i}
          >
            <img :if={is_binary(item)} src={item} alt="" />
            <img :if={!is_binary(item)} src={Map.get(item, :url) || Map.get(item, "url") || ""} alt={Map.get(item, :alt) || Map.get(item, "alt") || "Slide #{i + 1}"} />
          </div>
        </div>
        <div
          phx-mounted={Connect.ignore_control(%Control{id: @id, orientation: @orientation})}
          {Connect.control(%Control{id: @id, orientation: @orientation})}
        >
          <button
            type="button"
            phx-mounted={Connect.ignore_prev_trigger(%PrevTrigger{id: @id, disabled: @prev_disabled})}
            {Connect.prev_trigger(%PrevTrigger{id: @id, disabled: @prev_disabled})}
          >
            {render_slot(@prev_trigger)}
          </button>
          <div
            phx-mounted={Connect.ignore_indicator_group(%IndicatorGroup{id: @id, orientation: @orientation, dir: @dir})}
            {Connect.indicator_group(%IndicatorGroup{id: @id, orientation: @orientation, dir: @dir})}
          >
            <button
              :for={i <- 0..(max(0, @total_pages - 1))}
              type="button"
              phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, index: i, orientation: @orientation, dir: @dir, page: @page})}
              {Connect.indicator(%Indicator{id: @id, index: i, orientation: @orientation, dir: @dir, page: @page})}
              data-index={i}
              aria-label={"Go to page #{i + 1}"}
            ></button>
          </div>
          <button
            type="button"
            phx-mounted={Connect.ignore_next_trigger(%NextTrigger{id: @id, disabled: @next_disabled})}
            {Connect.next_trigger(%NextTrigger{id: @id, disabled: @next_disabled})}
          >
            {render_slot(@next_trigger)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_root(assigns) do
    root = %Root{
      id: assigns.ctx.id,
      dir: assigns.ctx.dir,
      orientation: assigns.ctx.orientation,
      slides_per_page: assigns.ctx.slides_per_page,
      spacing: assigns.ctx.spacing || "0px",
      aria_label: assigns.ctx.aria_label
    }

    assigns = assign(assigns, :root, root)

    ~H"""
    <div phx-mounted={Connect.ignore_root(@root)} {Connect.root(@root)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_item_group(assigns) do
    ig = %ItemGroup{
      id: assigns.ctx.id,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :ig, ig)

    ~H"""
    <div phx-mounted={Connect.ignore_item_group(@ig)} {Connect.item_group(@ig)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:index, :integer, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_item(assigns) do
    item = %Item{
      id: assigns.ctx.id,
      index: assigns.index,
      orientation: assigns.ctx.orientation,
      slide_count: assigns.ctx.slide_count
    }

    assigns = assign(assigns, :item, item)

    ~H"""
    <div
      phx-mounted={Connect.ignore_item(@item)}
      {Connect.item(@item)}
      data-index={@index}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_control(assigns) do
    ctl = %Control{id: assigns.ctx.id, orientation: assigns.ctx.orientation}
    assigns = assign(assigns, :ctl, ctl)

    ~H"""
    <div phx-mounted={Connect.ignore_control(@ctl)} {Connect.control(@ctl)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_prev_trigger(assigns) do
    pt = %PrevTrigger{id: assigns.ctx.id, disabled: assigns.ctx.prev_disabled}
    assigns = assign(assigns, :pt, pt)

    ~H"""
    <button type="button" phx-mounted={Connect.ignore_prev_trigger(@pt)} {Connect.prev_trigger(@pt)} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_next_trigger(assigns) do
    nt = %NextTrigger{id: assigns.ctx.id, disabled: assigns.ctx.next_disabled}
    assigns = assign(assigns, :nt, nt)

    ~H"""
    <button type="button" phx-mounted={Connect.ignore_next_trigger(@nt)} {Connect.next_trigger(@nt)} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_indicator_group(assigns) do
    g = %IndicatorGroup{
      id: assigns.ctx.id,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :g, g)

    ~H"""
    <div phx-mounted={Connect.ignore_indicator_group(@g)} {Connect.indicator_group(@g)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:index, :integer, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def carousel_indicator(assigns) do
    ind = %Indicator{
      id: assigns.ctx.id,
      index: assigns.index,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir,
      page: assigns.ctx.page
    }

    assigns = assign(assigns, :ind, ind)

    ~H"""
    <button
      type="button"
      phx-mounted={Connect.ignore_indicator(@ind)}
      {Connect.indicator(@ind)}
      data-index={@index}
      aria-label={"Go to page #{@index + 1}"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc type: :api
  @doc """
  Starts or resumes carousel autoplay from the client. Returns a `Phoenix.LiveView.JS` command.
  """
  def play(carousel_id) when is_binary(carousel_id) do
    JS.dispatch("corex:carousel:play", to: "##{carousel_id}", detail: %{}, bubbles: false)
  end

  @doc type: :api
  @doc """
  Pauses carousel autoplay from the client.
  """
  def pause(carousel_id) when is_binary(carousel_id) do
    JS.dispatch("corex:carousel:pause", to: "##{carousel_id}", detail: %{}, bubbles: false)
  end

  @doc type: :api
  def play(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    LiveView.push_event(socket, "carousel_play", %{"id" => carousel_id})
  end

  @doc type: :api
  def pause(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    LiveView.push_event(socket, "carousel_pause", %{"id" => carousel_id})
  end

  @doc type: :api
  @doc """
  Scrolls to the next page from the client.
  """
  def scroll_next(carousel_id) when is_binary(carousel_id), do: scroll_next(carousel_id, false)

  @doc type: :api
  @doc """
  Scrolls to the next page from the client. Pass `true` for `instant` to skip animation.
  """
  def scroll_next(carousel_id, instant) when is_binary(carousel_id) and is_boolean(instant) do
    JS.dispatch("corex:carousel:scroll-next",
      to: "##{carousel_id}",
      detail: scroll_detail(instant),
      bubbles: false
    )
  end

  @doc type: :api
  def scroll_next(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    scroll_next(socket, carousel_id, false)
  end

  @doc type: :api
  def scroll_next(socket, carousel_id, instant)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) and
             is_boolean(instant) do
    LiveView.push_event(socket, "carousel_scroll_next", scroll_payload(carousel_id, instant))
  end

  @doc type: :api
  @doc """
  Scrolls to the previous page from the client.
  """
  def scroll_prev(carousel_id) when is_binary(carousel_id), do: scroll_prev(carousel_id, false)

  @doc type: :api
  def scroll_prev(carousel_id, instant) when is_binary(carousel_id) and is_boolean(instant) do
    JS.dispatch("corex:carousel:scroll-prev",
      to: "##{carousel_id}",
      detail: scroll_detail(instant),
      bubbles: false
    )
  end

  @doc type: :api
  def scroll_prev(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    scroll_prev(socket, carousel_id, false)
  end

  @doc type: :api
  def scroll_prev(socket, carousel_id, instant)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) and
             is_boolean(instant) do
    LiveView.push_event(socket, "carousel_scroll_prev", scroll_payload(carousel_id, instant))
  end

  defp scroll_detail(false), do: %{}
  defp scroll_detail(true), do: %{instant: true}

  defp scroll_payload(carousel_id, instant) do
    base = %{"id" => carousel_id}
    if instant, do: Map.put(base, "instant", true), else: base
  end
end
