defmodule Corex.Carousel.Connect do
  @moduledoc false
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

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-slide-count" => to_string(assigns.slide_count),
      "data-page" => if(assigns.controlled, do: to_string(assigns.page), else: nil),
      "data-default-page" => if(assigns.controlled, do: nil, else: to_string(assigns.page)),
      "data-controlled" => data_attr(assigns.controlled),
      "data-dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "data-slides-per-page" => to_string(assigns.slides_per_page),
      "data-loop" => data_attr(assigns.loop),
      "data-allow-mouse-drag" => data_attr(assigns.allow_mouse_drag),
      "data-spacing" => assigns.spacing,
      "data-on-page-change" => assigns.on_page_change,
      "data-on-page-change-client" => assigns.on_page_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    slides_per_page = assigns.slides_per_page || 1
    spacing = assigns.spacing || "0px"

    slide_item_size =
      "calc(100% / var(--slides-per-page) - var(--slide-spacing) * (var(--slides-per-page) - 1) / var(--slides-per-page))"

    style =
      "--slides-per-page:#{slides_per_page};--slide-spacing:#{spacing};--slide-item-size:#{slide_item_size};aspect-ratio:4/3"

    %{
      "data-scope" => "carousel",
      "data-part" => "root",
      "data-orientation" => assigns.orientation || "horizontal",
      "dir" => assigns.dir,
      "id" => "carousel:#{assigns.id}",
      "style" => style
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "carousel",
      "data-part" => "control",
      "data-orientation" => assigns.orientation || "horizontal",
      "id" => "carousel:#{assigns.id}:control"
    }
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    horizontal = (assigns.orientation || "horizontal") == "horizontal"

    style =
      if horizontal do
        "display:grid;gap:var(--slide-spacing);scroll-snap-type:x mandatory;grid-auto-flow:column;scrollbar-width:none;overscroll-behavior-x:contain;grid-auto-columns:var(--slide-item-size);overflow-x:auto"
      else
        "display:grid;gap:var(--slide-spacing);scroll-snap-type:y mandatory;grid-auto-flow:row;scrollbar-width:none;overscroll-behavior-y:contain;grid-auto-rows:var(--slide-item-size);overflow-y:auto"
      end

    %{
      "data-scope" => "carousel",
      "data-part" => "item-group",
      "data-orientation" => assigns.orientation || "horizontal",
      "dir" => assigns.dir,
      "id" => "carousel:#{assigns.id}:item-group",
      "aria-live" => "polite",
      "style" => style,
      "tabindex" => "0"
    }
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    horizontal = (assigns.orientation || "horizontal") == "horizontal"
    size_style = if horizontal, do: "max-width:100%", else: "max-height:100%"
    slide_count = assigns.slide_count || 1

    style = "flex:0 0 auto;#{size_style};scroll-snap-align:start"

    %{
      "data-scope" => "carousel",
      "data-part" => "item",
      "data-index" => to_string(assigns.index),
      "data-orientation" => assigns.orientation || "horizontal",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "carousel:#{assigns.id}:item:#{assigns.index}",
      "role" => "group",
      "aria-roledescription" => "slide",
      "aria-label" => "#{assigns.index + 1} of #{slide_count}",
      "style" => style
    }
  end

  @spec prev_trigger(PrevTrigger.t()) :: map()
  def prev_trigger(assigns) do
    %{
      "data-scope" => "carousel",
      "data-part" => "prev-trigger",
      "type" => "button",
      "aria-label" => "Previous slide",
      "id" => "carousel:#{assigns.id}:prev"
    }
  end

  @spec next_trigger(NextTrigger.t()) :: map()
  def next_trigger(assigns) do
    %{
      "data-scope" => "carousel",
      "data-part" => "next-trigger",
      "type" => "button",
      "aria-label" => "Next slide",
      "id" => "carousel:#{assigns.id}:next"
    }
  end

  @spec indicator_group(IndicatorGroup.t()) :: map()
  def indicator_group(assigns) do
    %{
      "data-scope" => "carousel",
      "data-part" => "indicator-group",
      "data-orientation" => assigns.orientation || "horizontal",
      "dir" => assigns.dir || "ltr",
      "id" => "carousel:#{assigns.id}:indicator-group"
    }
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "carousel",
      "data-part" => "indicator",
      "data-index" => to_string(assigns.index),
      "data-orientation" => assigns.orientation || "horizontal",
      "dir" => assigns.dir || "ltr",
      "type" => "button",
      "id" => "carousel:#{assigns.id}:indicator:#{assigns.index}"
    }
  end
end
