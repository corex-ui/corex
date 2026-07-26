defmodule Corex.Carousel.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

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

  alias Corex.Dataset

  alias Corex.Selectors

  alias Phoenix.LiveView.JS

  defp slides_per_move_value(nil), do: nil
  defp slides_per_move_value("auto"), do: "auto"
  defp slides_per_move_value(:auto), do: "auto"
  defp slides_per_move_value(n) when is_integer(n), do: to_string(n)
  defp slides_per_move_value(n) when is_binary(n), do: n

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base = %{
      "id" => assigns.id,
      "data-slide-count" => to_string(assigns.slide_count),
      "data-default-page" => to_string(assigns.page),
      "data-orientation" => assigns.orientation,
      "data-slides-per-page" => to_string(assigns.slides_per_page),
      "data-loop" => presence_attr(assigns.loop),
      "data-autoplay" => presence_attr(assigns.autoplay),
      "data-autoplay-delay" =>
        if(assigns.autoplay, do: to_string(assigns.autoplay_delay), else: nil),
      "data-allow-mouse-drag" => presence_attr(assigns.allow_mouse_drag),
      "data-spacing" => assigns.spacing,
      "data-in-view-threshold" => to_string(assigns.in_view_threshold),
      "data-snap-type" => assigns.snap_type,
      "data-auto-size" => presence_attr(assigns.auto_size),
      "data-on-page-change" => assigns.on_page_change,
      "data-on-page-change-client" => assigns.on_page_change_client
    }

    base
    |> put_data_dir_attr(assigns.dir)
    |> Dataset.put_string("data-slides-per-move", slides_per_move_value(assigns.slides_per_move))
    |> Dataset.put_string("data-padding", assigns.padding)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    slides_per_page = assigns.slides_per_page || 1
    spacing = assigns.spacing || "0px"

    slide_item_size =
      "calc(100% / var(--slides-per-page) - var(--slide-spacing) * (var(--slides-per-page) - 1) / var(--slides-per-page))"

    style =
      "--slides-per-page:#{slides_per_page};--slide-spacing:#{spacing};--slide-item-size:#{slide_item_size}"

    base =
      %{
        "data-scope" => "carousel",
        "data-part" => "root",
        "data-orientation" => assigns.orientation || "horizontal",
        "id" => "carousel:#{assigns.id}",
        "style" => style
      }
      |> put_dir_attr(assigns.dir)

    case Map.get(assigns, :aria_label) do
      nil -> Map.put(base, "aria-label", "Carousel #{assigns.id}")
      label -> Map.put(base, "aria-label", label)
    end
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}")
    )
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

  def ignore_control(%Control{} = assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:control")
    )
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    horizontal = (assigns.orientation || "horizontal") == "horizontal"

    style =
      if horizontal do
        "min-width:0;display:grid;gap:var(--slide-spacing);scroll-snap-type:x mandatory;grid-auto-flow:column;scrollbar-width:none;overscroll-behavior-x:contain;grid-auto-columns:var(--slide-item-size);overflow-x:auto"
      else
        "min-height:0;display:grid;gap:var(--slide-spacing);scroll-snap-type:y mandatory;grid-auto-flow:row;scrollbar-width:none;overscroll-behavior-y:contain;grid-auto-rows:var(--slide-item-size);overflow-y:auto"
      end

    %{
      "data-scope" => "carousel",
      "data-part" => "item-group",
      "data-orientation" => assigns.orientation || "horizontal",
      "id" => "carousel:#{assigns.id}:item-group",
      "aria-live" => "polite",
      "style" => style,
      "tabindex" => "0"
    }
    |> put_dir_attr(assigns.dir)
  end

  def ignore_item_group(%ItemGroup{} = assigns) do
    JS.ignore_attributes(ItemGroup.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:item-group")
    )
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
      "id" => "carousel:#{assigns.id}:item:#{assigns.index}",
      "role" => "group",
      "aria-roledescription" => "slide",
      "aria-label" => "#{assigns.index + 1} of #{slide_count}",
      "style" => style
    }
    |> put_dir_attr(Map.get(assigns, :dir))
  end

  def ignore_item(%Item{} = assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:item:#{assigns.index}")
    )
  end

  @spec prev_trigger(PrevTrigger.t()) :: map()
  def prev_trigger(assigns) do
    base = %{
      "data-scope" => "carousel",
      "data-part" => "prev-trigger",
      "type" => "button",
      "aria-label" => "Previous slide",
      "id" => "carousel:#{assigns.id}:prev"
    }

    if Map.get(assigns, :disabled, false) do
      Map.put(base, "disabled", "")
    else
      base
    end
  end

  def ignore_prev_trigger(%PrevTrigger{} = assigns) do
    JS.ignore_attributes(PrevTrigger.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:prev")
    )
  end

  @spec next_trigger(NextTrigger.t()) :: map()
  def next_trigger(assigns) do
    base = %{
      "data-scope" => "carousel",
      "data-part" => "next-trigger",
      "type" => "button",
      "aria-label" => "Next slide",
      "id" => "carousel:#{assigns.id}:next"
    }

    if Map.get(assigns, :disabled, false) do
      Map.put(base, "disabled", "")
    else
      base
    end
  end

  def ignore_next_trigger(%NextTrigger{} = assigns) do
    JS.ignore_attributes(NextTrigger.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:next")
    )
  end

  @spec indicator_group(IndicatorGroup.t()) :: map()
  def indicator_group(assigns) do
    %{
      "data-scope" => "carousel",
      "data-part" => "indicator-group",
      "data-orientation" => assigns.orientation || "horizontal",
      "id" => "carousel:#{assigns.id}:indicator-group"
    }
    |> put_dir_attr(assigns.dir)
  end

  def ignore_indicator_group(%IndicatorGroup{} = assigns) do
    JS.ignore_attributes(IndicatorGroup.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:indicator-group")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    page = Map.get(assigns, :page, 1)

    %{
      "data-scope" => "carousel",
      "data-part" => "indicator",
      "data-index" => to_string(assigns.index),
      "data-current" => presence_attr(assigns.index + 1 == page),
      "data-orientation" => assigns.orientation || "horizontal",
      "type" => "button",
      "id" => "carousel:#{assigns.id}:indicator:#{assigns.index}"
    }
    |> put_dir_attr(assigns.dir)
  end

  def ignore_indicator(%Indicator{} = assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("carousel:#{assigns.id}:indicator:#{assigns.index}")
    )
  end
end
