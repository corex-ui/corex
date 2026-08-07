defmodule Corex.Carousel do
  @moduledoc ~S'''
  Carousel for Phoenix LiveView. Behavior follows [Zag.js Carousel](https://zagjs.com/components/react/carousel).
  ## Anatomy

  | Goal | API |
  | ---- | --- |
  | Image gallery | `items={[Corex.Image.new("/images/a.jpg", alt: "A"), ...]}`: renders `<img>` per slide |
  | Custom slides | `items={@posts}` + `<:item :let={post}>` — your markup per slide |
  | Full structure | `compound` + `carousel_*` subcomponents |

  ## Items

  Pass `items` for simple-mode slides. Image galleries use [`Corex.Image`](Corex.Image.html) — see
  [`Corex.Image.new/2`](Corex.Image.html#new/2). Custom slides use any list plus the `<:item>` slot.

  | `items` | `<:item>` slot | Result |
  | ------- | -------------- | ------ |
  | `[%Corex.Image{}, ...]` | omitted | `<img src alt class>` per slide |
  | any list | `<:item :let={item}>` | your markup via `render_slot/2` |
  | — | — | compound mode: set `item_count` and use `carousel_item` |

  Without `<:item>`, every entry must be `%Corex.Image{}`; other values raise at render time.

  Slides may include links and other controls; off-view slides are marked `inert` on the client so they stay out of the tab order.

  <!-- tabs-open -->

  ### Images

  ```heex
  <.carousel
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall"),
      Corex.Image.new("/images/sand.jpg", alt: "Sand"),
      Corex.Image.new("/images/star.jpg", alt: "Star"),
      Corex.Image.new("/images/winter.jpg", alt: "Winter")
    ]}
    class="carousel"
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ### Custom content

  ```heex
  <.carousel items={@posts} class="carousel">
    <:item :let={post}>
      <article>
        <h3>{post.title}</h3>
        <p>{post.description}</p>
        <.navigate to="#" class="link">Read more</.navigate>
      </article>
    </:item>
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ### Compound

  ```heex
  <.carousel compound :let={ctx} item_count={2} class="carousel">
    <.carousel_root ctx={ctx}>
      <.carousel_item_group ctx={ctx}>
        <.carousel_item ctx={ctx} index={0}>First slide</.carousel_item>
        <.carousel_item ctx={ctx} index={1}>Second slide</.carousel_item>
      </.carousel_item_group>
      <.carousel_control ctx={ctx}>
        <.carousel_prev_trigger ctx={ctx}><.heroicon name="hero-arrow-left" /></.carousel_prev_trigger>
        <.carousel_indicator_group ctx={ctx}>
          <.carousel_indicator ctx={ctx} index={0} />
          <.carousel_indicator ctx={ctx} index={1} />
        </.carousel_indicator_group>
        <.carousel_next_trigger ctx={ctx}><.heroicon name="hero-arrow-right" /></.carousel_next_trigger>
      </.carousel_control>
    </.carousel_root>
  </.carousel>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.carousel>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`play/1`](#play/1) | Start or resume autoplay (client) | `%Phoenix.LiveView.JS{}` |
  | [`play/2`](#play/2) | Start or resume autoplay (server) | `socket` |
  | [`pause/1`](#pause/1) | Pause autoplay (client) | `%Phoenix.LiveView.JS{}` |
  | [`pause/2`](#pause/2) | Pause autoplay (server) | `socket` |
  | [`scroll_next/1`](#scroll_next/1) | Next page (client) | `%Phoenix.LiveView.JS{}` |
  | [`scroll_next/2`](#scroll_next/2) | Next page with `instant` (client) | `%Phoenix.LiveView.JS{}` |
  | [`scroll_next/3`](#scroll_next/3) | Next page (server) | `socket` |
  | [`scroll_prev/1`](#scroll_prev/1) | Previous page (client) | `%Phoenix.LiveView.JS{}` |
  | [`scroll_prev/2`](#scroll_prev/2) | Previous page with `instant` (client) | `%Phoenix.LiveView.JS{}` |
  | [`scroll_prev/3`](#scroll_prev/3) | Previous page (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.carousel>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_page_change="carousel_page_changed"` | Active page changes | `%{"id" => id, "page" => page, "pageSnapPoint" => snap}` |

  <!-- tabs-open -->

  ### on_page_change

  ```heex
  <.carousel
    class="carousel"
    on_page_change="carousel_page_changed"
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ```elixir
  def handle_event("carousel_page_changed", %{"id" => _id, "page" => page}, socket) do
    {:noreply, assign(socket, :carousel_page, page)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_page_change_client="carousel-page-changed"` | Active page changes | `id`, `page`, `pageSnapPoint` |

  <!-- tabs-open -->

  ### on_page_change_client

  ```heex
  <.carousel
    id="carousel-events-client"
    class="carousel"
    on_page_change_client="carousel-page-changed"
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ```javascript
  const el = document.getElementById("carousel-events-client");
  el?.addEventListener("carousel-page-changed", (e) => console.log(e.detail));
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `carousel.css`, then set `class="carousel"` on `<.carousel>`.

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

  ```css
  @import "../corex/corex.css";
  ```

  Stack modifiers on the host (`class` on `<.carousel>`).

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on nav triggers. Variant modifiers control prev/next/autoplay trigger surface treatment. Default is subtle; add `carousel ui-solid` for filled nav controls.

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `carousel` |
  | Accent | `carousel ui-accent` |
  | Brand | `carousel ui-brand` |
  | Alert | `carousel ui-alert` |
  | Info | `carousel ui-info` |
  | Success | `carousel ui-success` |

  ```heex
  <.carousel
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
    class="carousel"
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  <.carousel
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
    class="carousel ui-accent"
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ### Variant

  Visual treatment of prev/next/autoplay triggers only.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `carousel` or `carousel ui-accent` |
  | Solid | `carousel ui-accent ui-solid` |

  ### Size

  Layout density for the root, control bar, prev/next triggers, autoplay control, and indicators.

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `carousel ui-size-sm` |
  | MD | `carousel ui-size-md` |
  | LG | `carousel ui-size-lg` |
  | XL | `carousel ui-size-xl` |

  ```heex
  <.carousel
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
    class="carousel ui-size-sm"
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  <.carousel
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
    class="carousel ui-size-lg"
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ### Radius

  Corner radius for the slide area and prev/next triggers.

  | Modifier | Classes |
  | -------- | ------- |
  | None | `carousel ui-rounded-none` |
  | SM | `carousel ui-rounded-sm` |
  | MD | `carousel ui-rounded-md` |
  | LG | `carousel ui-rounded-lg` |
  | XL | `carousel ui-rounded-xl` |
  | Full | `carousel ui-rounded-full` |

  ```heex
  <.carousel
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
    class="carousel ui-rounded-md"
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Api.Imports, to: Corex.Carousel.Api

  import Corex.Api.Doc

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
  alias Corex.Carousel.Utils

  attr(:id, :string, required: false)
  attr(:aria_label, :string, default: nil)

  attr(:items, :list,
    default: nil,
    doc:
      "List of `%Corex.Image{}` for image slides, or arbitrary data when `<:item>` is set. Omit in compound mode; use `item_count` when children do not pass through `items`."
  )

  attr(:item_count, :integer,
    default: nil,
    doc:
      "When set, overrides the slide count used for the hook and compound context (use in compound mode without `items`)."
  )

  attr(:page, :integer,
    default: 1,
    doc: "Active page (1-based, same as pagination; first page is 1)"
  )

  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
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

  slot :item,
    required: false,
    doc:
      "Custom markup for each slide. Use :let={item} to receive each entry from `items`. Required when `items` are not `%Corex.Image{}` structs." do
    attr(:class, :string, required: false)
  end

  def carousel(assigns) do
    assigns = Utils.merge_attr_defaults(assigns)

    {items, slide_count, total_pages, prev_disabled, next_disabled, slides_per_page} =
      Utils.compute_slide_metrics(assigns)

    has_item_slot = Utils.item_slot?(assigns)
    Utils.validate_items!(items, has_item_slot)

    assigns =
      assigns
      |> Corex.FormField.assign_stable_id("carousel")
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:items, items)
      |> assign(:slide_count, slide_count)
      |> assign(:total_pages, total_pages)
      |> assign(:prev_disabled, prev_disabled)
      |> assign(:next_disabled, next_disabled)
      |> assign(:slides_per_page, slides_per_page)
      |> assign(:has_item_slot, has_item_slot)

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
      {Corex.Hook.loading()}
      data-slide-count={@slide_count}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        slide_count: @slide_count,
        page: @page,
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
        {Connect.mounted_root(%Root{id: @id, dir: @dir, orientation: @orientation, slides_per_page: @slides_per_page, spacing: @spacing, aria_label: @aria_label})}
      >
        <div
          {Connect.mounted_item_group(%ItemGroup{id: @id, orientation: @orientation, dir: @dir})}
        >
          <div
            :for={{item, i} <- Enum.with_index(@items)}
            {Connect.mounted_item(%Item{id: @id, index: i, orientation: @orientation, slide_count: @slide_count})}
            data-index={i}
          >
            <%= if @has_item_slot do %>
              {render_slot(@item, item)}
            <% else %>
              <img src={item.src} alt={item.alt || ""} class={item.class} />
            <% end %>
          </div>
        </div>
        <div
          {Connect.mounted_control(%Control{id: @id, orientation: @orientation})}
        >
          <button
            type="button"
            {Connect.mounted_prev_trigger(%PrevTrigger{id: @id, disabled: @prev_disabled})}
          >
            {render_slot(@prev_trigger)}
          </button>
          <div
            {Connect.mounted_indicator_group(%IndicatorGroup{id: @id, orientation: @orientation, dir: @dir})}
          >
            <button
              :for={i <- 0..(max(0, @total_pages - 1))}
              type="button"
              {Connect.mounted_indicator(%Indicator{id: @id, index: i, orientation: @orientation, dir: @dir, page: @page})}
              data-index={i}
              aria-label={"Go to page #{i + 1}"}
            ></button>
          </div>
          <button
            type="button"
            {Connect.mounted_next_trigger(%NextTrigger{id: @id, disabled: @next_disabled})}
          >
            {render_slot(@next_trigger)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :compound
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
    <div {Connect.mounted_root(@root)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
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
    <div {Connect.mounted_item_group(@ig)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
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
      {Connect.mounted_item(@item)}
      data-index={@index}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_control(assigns) do
    ctl = %Control{id: assigns.ctx.id, orientation: assigns.ctx.orientation}
    assigns = assign(assigns, :ctl, ctl)

    ~H"""
    <div {Connect.mounted_control(@ctl)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_prev_trigger(assigns) do
    pt = %PrevTrigger{id: assigns.ctx.id, disabled: assigns.ctx.prev_disabled}
    assigns = assign(assigns, :pt, pt)

    ~H"""
    <button type="button" {Connect.mounted_prev_trigger(@pt)} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc type: :compound
  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def carousel_next_trigger(assigns) do
    nt = %NextTrigger{id: assigns.ctx.id, disabled: assigns.ctx.next_disabled}
    assigns = assign(assigns, :nt, nt)

    ~H"""
    <button type="button" {Connect.mounted_next_trigger(@nt)} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc type: :compound
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
    <div {Connect.mounted_indicator_group(@g)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
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
      {Connect.mounted_indicator(@ind)}
      data-index={@index}
      aria-label={"Go to page #{@index + 1}"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  api_doc(~S"""
  Start or resume autoplay from the client. Dispatches `corex:carousel:play` on the carousel root.

  ```heex
  <.action phx-click={Corex.Carousel.play("my-carousel")}>Play</.action>
  <.action phx-click={Corex.Carousel.pause("my-carousel")}>Pause</.action>
  <.carousel
    id="my-carousel"
    autoplay
    loop
    class="carousel"
    items={[
      Corex.Image.new("/images/beach.jpg", alt: "Beach"),
      Corex.Image.new("/images/fall.jpg", alt: "Fall")
    ]}
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```

  ```javascript
  document.getElementById("my-carousel")?.dispatchEvent(
    new CustomEvent("corex:carousel:play", { bubbles: false, detail: {} })
  );
  ```
  """)

  @spec play(String.t()) :: Phoenix.LiveView.JS.t()
  @spec play(Phoenix.LiveView.Socket.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  defdelegate play(carousel_id), to: Api

  api_doc(~S"""
  Pause autoplay from the client. Dispatches `corex:carousel:pause` on the carousel root.

  ```heex
  <.action phx-click={Corex.Carousel.pause("my-carousel")}>Pause</.action>
  <.carousel
    id="my-carousel"
    autoplay
    loop
    class="carousel"
    items={[Corex.Image.new("/images/beach.jpg", alt: "Beach")]}
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```
  """)

  @spec pause(String.t()) :: Phoenix.LiveView.JS.t()
  @spec pause(Phoenix.LiveView.Socket.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  defdelegate pause(carousel_id), to: Api

  api_doc(~S"""
  Start or resume autoplay from `handle_event`. Pushes `carousel_play`.

  ```elixir
  def handle_event("carousel_play", _params, socket) do
    {:noreply, Corex.Carousel.play(socket, "my-carousel")}
  end
  ```
  """)

  defdelegate play(socket, carousel_id), to: Api

  api_doc(~S"""
  Pause autoplay from `handle_event`. Pushes `carousel_pause`.

  ```elixir
  def handle_event("carousel_pause", _params, socket) do
    {:noreply, Corex.Carousel.pause(socket, "my-carousel")}
  end
  ```
  """)

  defdelegate pause(socket, carousel_id), to: Api

  api_doc("Same as [`scroll_next/2`](#scroll_next/2) with `instant: false`.")
  @spec scroll_next(String.t()) :: Phoenix.LiveView.JS.t()
  @spec scroll_next(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec scroll_next(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  defdelegate scroll_next(carousel_id), to: Api

  api_doc(~S"""
  Scroll to the next page from the client. Dispatches `corex:carousel:scroll-next`.
  Pass `true` as the second argument for an instant jump (no animation).

  ```heex
  <.action phx-click={Corex.Carousel.scroll_next("my-carousel")}>Next</.action>
  <.action phx-click={Corex.Carousel.scroll_next("my-carousel", true)}>Next (instant)</.action>
  ```

  ```javascript
  document.getElementById("my-carousel")?.dispatchEvent(
    new CustomEvent("corex:carousel:scroll-next", { bubbles: false, detail: { instant: true } })
  );
  ```
  """)

  def scroll_next(carousel_id, instant) when is_binary(carousel_id) and is_boolean(instant),
    do: Api.scroll_next(carousel_id, instant)

  def scroll_next(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id),
      do: Api.scroll_next(socket, carousel_id)

  api_doc(~S"""
  Scroll to the next page from the server. `push_event("carousel_scroll_next", %{"id" => id, "instant" => boolean})`.

  ```elixir
  def handle_event("carousel_next", _params, socket) do
    {:noreply, Corex.Carousel.scroll_next(socket, "my-carousel")}
  end
  ```
  """)

  defdelegate scroll_next(socket, carousel_id, instant), to: Api

  api_doc("Same as [`scroll_prev/2`](#scroll_prev/2) with `instant: false`.")
  @spec scroll_prev(String.t()) :: Phoenix.LiveView.JS.t()
  @spec scroll_prev(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec scroll_prev(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  defdelegate scroll_prev(carousel_id), to: Api

  api_doc(~S"""
  Scroll to the previous page from the client. Dispatches `corex:carousel:scroll-prev`.
  Pass `true` as the second argument for an instant jump (no animation).

  ```heex
  <.action phx-click={Corex.Carousel.scroll_prev("my-carousel")}>Prev</.action>
  <.action phx-click={Corex.Carousel.scroll_prev("my-carousel", true)}>Prev (instant)</.action>
  ```
  """)

  def scroll_prev(carousel_id, instant) when is_binary(carousel_id) and is_boolean(instant),
    do: Api.scroll_prev(carousel_id, instant)

  def scroll_prev(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id),
      do: Api.scroll_prev(socket, carousel_id)

  api_doc(~S"""
  Scroll to the previous page from the server. `push_event("carousel_scroll_prev", %{"id" => id, "instant" => boolean})`.

  ```elixir
  def handle_event("carousel_prev", _params, socket) do
    {:noreply, Corex.Carousel.scroll_prev(socket, "my-carousel")}
  end
  ```
  """)

  defdelegate scroll_prev(socket, carousel_id, instant), to: Api
end
