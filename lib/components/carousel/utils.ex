defmodule Corex.Carousel.Utils do
  @moduledoc false

  def merge_attr_defaults(assigns) when is_map(assigns) do
    defaults = %{
      aria_label: nil,
      items: nil,
      item_count: nil,
      page: 0,
      controlled: false,
      dir: "ltr",
      orientation: "horizontal",
      slides_per_page: 1,
      slides_per_move: nil,
      loop: false,
      autoplay: false,
      autoplay_delay: 4000,
      allow_mouse_drag: false,
      spacing: "0px",
      padding: nil,
      in_view_threshold: 0.6,
      snap_type: "mandatory",
      auto_size: false,
      on_page_change: nil,
      on_page_change_client: nil,
      compound: false
    }

    Map.merge(defaults, assigns)
  end

  def compute_slide_metrics(assigns) when is_map(assigns) do
    items = assigns |> Map.get(:items) |> List.wrap()
    slide_count = resolved_slide_count(assigns, items)
    slides_per_page = Map.get(assigns, :slides_per_page) || 1
    total_pages = total_pages_for(slide_count, slides_per_page)
    page = Map.get(assigns, :page) || 0
    loop = Map.get(assigns, :loop, false)

    prev_disabled = prev_nav_disabled?(loop, page)
    next_disabled = next_nav_disabled?(loop, page, total_pages)

    {items, slide_count, total_pages, prev_disabled, next_disabled, slides_per_page}
  end

  defp resolved_slide_count(assigns, items) do
    case Map.get(assigns, :item_count) do
      n when is_integer(n) and n >= 0 -> n
      _ -> length(items)
    end
  end

  defp total_pages_for(0, _slides_per_page), do: 0

  defp total_pages_for(slide_count, slides_per_page) do
    div(slide_count + slides_per_page - 1, slides_per_page)
  end

  defp prev_nav_disabled?(loop, page), do: !loop and page <= 0

  defp next_nav_disabled?(loop, page, total_pages) do
    !loop and (total_pages == 0 or page >= total_pages - 1)
  end
end
