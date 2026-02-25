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

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/carousel#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Carousel.Anatomy.{
    Props,
    Root,
    Control,
    ItemGroup,
    Item,
    PrevTrigger,
    NextTrigger,
    IndicatorGroup,
    Indicator
  }

  alias Corex.Carousel.Connect

  attr(:id, :string, required: false)
  attr(:aria_label, :string, default: nil)

  attr(:items, :list,
    required: true,
    doc: "List of image URLs (strings) or maps with :url and optional :alt"
  )

  attr(:page, :integer, default: 0)
  attr(:controlled, :boolean, default: false)
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
  attr(:rest, :global)

  slot(:prev_trigger, required: true)
  slot(:next_trigger, required: true)

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

    ~H"""
    <div
      id={@id}
      phx-hook="Carousel"
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
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, slides_per_page: @slides_per_page, spacing: @spacing, aria_label: @aria_label})}>
        <div {Connect.item_group(%ItemGroup{id: @id, orientation: @orientation, dir: @dir})}>
          <div :for={{item, i} <- Enum.with_index(@items)} {Connect.item(%Item{id: @id, index: i, orientation: @orientation, slide_count: @slide_count})} data-index={i}>
            <img :if={is_binary(item)} src={item} alt="" />
            <img :if={!is_binary(item)} src={Map.get(item, :url) || Map.get(item, "url") || ""} alt={Map.get(item, :alt) || Map.get(item, "alt") || "Slide #{i + 1}"} />
          </div>
        </div>
        <div {Connect.control(%Control{id: @id, orientation: @orientation})}>
          <button type="button" {Connect.prev_trigger(%PrevTrigger{id: @id, disabled: @prev_disabled})}>
            <%= render_slot(@prev_trigger) %>
          </button>
          <div {Connect.indicator_group(%IndicatorGroup{id: @id, orientation: @orientation, dir: @dir})}>
            <button :for={i <- 0..(max(0, @total_pages - 1))} type="button" {Connect.indicator(%Indicator{id: @id, index: i, orientation: @orientation, dir: @dir, page: @page})} data-index={i} aria-label={"Go to page #{i + 1}"}></button>
          </div>
          <button type="button" {Connect.next_trigger(%NextTrigger{id: @id, disabled: @next_disabled})}>
            <%= render_slot(@next_trigger) %>
          </button>
        </div>
      </div>
    </div>
    """
  end
end
