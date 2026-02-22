defmodule Corex.Marquee.Connect do
  @moduledoc false
  alias Corex.Marquee.Anatomy.{Props, Root, Edge, Viewport, Content, Item}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  defp orientation(side), do: if(side in ["top", "bottom"], do: "vertical", else: "horizontal")

  defp maybe_put(acc, _key, nil), do: acc
  defp maybe_put(acc, key, value), do: [{key, value} | acc]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    orient = orientation(assigns.side)

    event_attrs =
      []
      |> maybe_put("data-aria-label", Map.get(assigns, :aria_label))
      |> maybe_put("data-on-pause-change", Map.get(assigns, :on_pause_change))
      |> maybe_put("data-on-pause-change-client", Map.get(assigns, :on_pause_change_client))
      |> maybe_put("data-on-loop-complete", Map.get(assigns, :on_loop_complete))
      |> maybe_put("data-on-loop-complete-client", Map.get(assigns, :on_loop_complete_client))
      |> maybe_put("data-on-complete", Map.get(assigns, :on_complete))
      |> maybe_put("data-on-complete-client", Map.get(assigns, :on_complete_client))
      |> Map.new()

    base = %{
      "id" => assigns.id,
      "data-duration" => to_string(assigns.duration),
      "data-content-count" => to_string(assigns.content_count),
      "data-side" => assigns.side,
      "data-speed" => to_string(assigns.speed),
      "data-spacing" => assigns.spacing,
      "data-auto-fill" => data_attr(assigns.auto_fill),
      "data-pause-on-interaction" => data_attr(assigns.pause_on_interaction),
      "data-default-paused" => data_attr(assigns.default_paused),
      "data-delay" => to_string(assigns.delay),
      "data-loop-count" => to_string(assigns.loop_count),
      "data-reverse" => data_attr(assigns.reverse),
      "data-respect-reduced-motion" => if(assigns.respect_reduced_motion, do: nil, else: "false"),
      "data-dir" => assigns.dir,
      "data-orientation" => orient
    }

    Map.merge(base, event_attrs)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    orient = assigns.orientation || "horizontal"
    loop_val = if assigns.loop_count == 0, do: "infinite", else: to_string(assigns.loop_count)

    style =
      "display:flex;flex-direction:#{if(orient == "vertical", do: "column", else: "row")};position:relative;overflow:hidden;contain:layout style paint;--marquee-duration:#{assigns.duration}s;--marquee-spacing:#{assigns.spacing};--marquee-delay:#{assigns.delay}s;--marquee-loop-count:#{loop_val};--marquee-translate:#{assigns.translate}"

    aria_label = Map.get(assigns, :aria_label) || "Marquee: #{assigns.id}"

    base = %{
      "data-scope" => "marquee",
      "data-part" => "root",
      "dir" => assigns.dir,
      "role" => "region",
      "aria-roledescription" => "marquee",
      "aria-live" => "off",
      "aria-label" => aria_label,
      "id" => "marquee:#{assigns.id}",
      "style" => style
    }

    if Map.get(assigns, :respect_reduced_motion, true) == false do
      Map.put(base, "data-respect-reduced-motion", "false")
    else
      base
    end
  end

  @spec edge(Edge.t()) :: map()
  def edge(assigns) do
    {pos_style, size_style} =
      case assigns.side do
        "start" -> {"top:0;inset-inline-start:0", "height:100%"}
        "end" -> {"top:0;inset-inline-end:0", "height:100%"}
        "top" -> {"top:0;inset-inline:0", "width:100%"}
        "bottom" -> {"bottom:0;inset-inline:0", "width:100%"}
      end

    %{
      "data-scope" => "marquee",
      "data-part" => "edge",
      "data-side" => assigns.side,
      "data-orientation" => assigns.orientation,
      "style" => "pointer-events:none;position:absolute;#{pos_style};#{size_style}"
    }
  end

  @spec viewport(Viewport.t()) :: map()
  def viewport(assigns) do
    orient = assigns.orientation || "horizontal"
    dim = if(orient == "vertical", do: "height", else: "width")
    flex_dir =
      case {orient, assigns.side} do
        {"vertical", "bottom"} -> "column-reverse"
        {"vertical", _} -> "column"
        {"horizontal", "end"} -> "row-reverse"
        _ -> "row"
      end

    %{
      "data-scope" => "marquee",
      "data-part" => "viewport",
      "data-orientation" => orient,
      "data-side" => assigns.side,
      "id" => "marquee:#{assigns.id}:viewport",
      "style" => "display:flex;#{dim}:100%;flex-direction:#{flex_dir}"
    }
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    orient = assigns.orientation || "horizontal"
    flex_dir = if(orient == "vertical", do: "column", else: "row")
    min_dim = if(orient == "vertical", do: "min-width", else: "min-height")

    attrs = %{
      "data-scope" => "marquee",
      "data-part" => "content",
      "data-index" => to_string(assigns.index),
      "data-orientation" => orient,
      "data-side" => assigns.side,
      "data-clone" => data_attr(assigns.clone),
      "dir" => "ltr",
      "id" => "marquee:#{assigns.root_id}:content:#{assigns.index}",
      "style" =>
        "display:flex;flex-direction:#{flex_dir};flex-shrink:0;backface-visibility:hidden;-webkit-backface-visibility:hidden;transform:translateZ(0);#{min_dim}:auto;contain:paint"
    }

    attrs =
      if assigns.reverse do
        Map.put(attrs, "data-reverse", "")
      else
        attrs
      end

    if assigns.clone do
      Map.merge(attrs, %{"role" => "presentation", "aria-hidden" => "true"})
    else
      attrs
    end
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    margin_prop = if((assigns.orientation || "horizontal") == "vertical", do: "margin-block", else: "margin-inline")
    style = "#{margin_prop}:calc(var(--marquee-spacing) / 2)"

    %{
      "data-scope" => "marquee",
      "data-part" => "item",
      "dir" => "ltr",
      "style" => style
    }
  end
end
