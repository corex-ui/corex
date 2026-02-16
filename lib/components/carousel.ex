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

  Use data attributes: `[data-scope="carousel"][data-part="root"]`, `control`, `item-group`, `item`, `prev-trigger`, `next-trigger`, `indicator-group`, `indicator`.
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

  attr(:items, :list,
    required: true,
    doc: "List of image URLs (strings) or maps with :url and optional :alt"
  )

  attr(:page, :integer, default: 0)
  attr(:controlled, :boolean, default: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])
  attr(:slides_per_page, :integer, default: 1)
  attr(:loop, :boolean, default: false)
  attr(:allow_mouse_drag, :boolean, default: false)
  attr(:spacing, :string, default: "0px")
  attr(:on_page_change, :string, default: nil)
  attr(:on_page_change_client, :string, default: nil)
  attr(:rest, :global)

  slot(:prev_trigger, required: true)
  slot(:next_trigger, required: true)

  def carousel(assigns) do
    items = List.wrap(assigns.items)
    slide_count = length(items)

    assigns =
      assigns
      |> assign_new(:id, fn -> "carousel-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:items, items)
      |> assign(:slide_count, slide_count)

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
        loop: @loop,
        autoplay: false,
        allow_mouse_drag: @allow_mouse_drag,
        spacing: @spacing,
        on_page_change: @on_page_change,
        on_page_change_client: @on_page_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, slides_per_page: @slides_per_page, spacing: @spacing})}>
        <div {Connect.item_group(%ItemGroup{id: @id, orientation: @orientation, dir: @dir})}>
          <div :for={{item, i} <- Enum.with_index(@items)} {Connect.item(%Item{id: @id, index: i, orientation: @orientation, slide_count: @slide_count})} data-index={i}>
            <%= if is_binary(item) do %>
              <img src={item} alt="" />
            <% else %>
              <img src={Map.get(item, :url) || Map.get(item, "url") || ""} alt={Map.get(item, :alt) || Map.get(item, "alt") || "Slide #{i + 1}"} />
            <% end %>
          </div>
        </div>
        <div {Connect.control(%Control{id: @id, orientation: @orientation})}>
          <button type="button" {Connect.prev_trigger(%PrevTrigger{id: @id})}>
            <%= render_slot(@prev_trigger) %>
          </button>
          <div {Connect.indicator_group(%IndicatorGroup{id: @id, orientation: @orientation, dir: @dir})}>
            <button :for={i <- 0..(@slide_count - 1)} type="button" {Connect.indicator(%Indicator{id: @id, index: i, orientation: @orientation, dir: @dir, page: @page})} data-index={i} aria-label={"Go to slide #{i + 1}"}></button>
          </div>
          <button type="button" {Connect.next_trigger(%NextTrigger{id: @id})}>
            <%= render_slot(@next_trigger) %>
          </button>
        </div>
      </div>
    </div>
    """
  end
end
