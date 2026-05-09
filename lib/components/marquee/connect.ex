defmodule Corex.Marquee.Connect do
  @moduledoc false
  alias Corex.Marquee.Anatomy.{Content, Edge, Item, Props, Root, Viewport}
  alias Corex.Selectors
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1, maybe_put_dir: 2, maybe_put_data_dir: 2]

  defp orientation(side), do: if(side in ["top", "bottom"], do: "vertical", else: "horizontal")

  defp maybe_put(acc, _key, nil), do: acc
  defp maybe_put(acc, key, value), do: [{key, value} | acc]

  @spec ignore_hook(String.t()) :: JS.t()
  def ignore_hook(id) when is_binary(id) do
    JS.ignore_attributes(["data-loading"], to: Selectors.css_id(id))
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    orient = orientation(assigns.side)

    event_attrs =
      []
      |> maybe_put("data-on-pause-change", Map.get(assigns, :on_pause_change))
      |> maybe_put("data-on-pause-change-client", Map.get(assigns, :on_pause_change_client))
      |> maybe_put("data-on-loop-complete", Map.get(assigns, :on_loop_complete))
      |> maybe_put("data-on-loop-complete-client", Map.get(assigns, :on_loop_complete_client))
      |> maybe_put("data-on-complete", Map.get(assigns, :on_complete))
      |> maybe_put("data-on-complete-client", Map.get(assigns, :on_complete_client))
      |> Map.new()

    base = %{
      "id" => assigns.id,
      "data-aria-label" => Map.get(assigns, :aria_label) || "Marquee: #{assigns.id}",
      "data-duration" => to_string(assigns.duration),
      "data-content-count" => to_string(assigns.content_count),
      "data-side" => assigns.side,
      "data-speed" => to_string(assigns.speed),
      "data-spacing" => assigns.spacing,
      "data-auto-fill" => get_boolean(assigns.auto_fill),
      "data-pause-on-interaction" => get_boolean(assigns.pause_on_interaction),
      "data-default-paused" => get_boolean(assigns.default_paused),
      "data-delay" => to_string(assigns.delay),
      "data-loop-count" => to_string(assigns.loop_count),
      "data-reverse" => get_boolean(assigns.reverse),
      "data-respect-reduced-motion" => if(assigns.respect_reduced_motion, do: nil, else: "false"),
      "data-orientation" => orient
    }

    Map.merge(base, event_attrs)
    |> maybe_put_data_dir(Map.get(assigns, :dir))
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    orient = Map.get(assigns, :orientation, "vertical") || "horizontal"
    loop_val = if assigns.loop_count == 0, do: "infinite", else: to_string(assigns.loop_count)

    style =
      "display:flex;flex-direction:#{if(orient == "vertical", do: "column", else: "row")};position:relative;overflow:hidden;width:100%;contain:layout style paint;--marquee-duration:#{assigns.duration}s;--marquee-spacing:#{assigns.spacing};--marquee-delay:#{assigns.delay}s;--marquee-loop-count:#{loop_val};--marquee-translate:#{assigns.translate}"

    aria_label = Map.get(assigns, :aria_label) || "Marquee: #{assigns.id}"
    paused? = Map.get(assigns, :default_paused, false)

    base =
      %{
        "data-scope" => "marquee",
        "data-part" => "root",
        "role" => "region",
        "aria-roledescription" => "marquee",
        "aria-live" => "off",
        "aria-label" => aria_label,
        "id" => "marquee:#{assigns.id}",
        "data-orientation" => orient,
        "data-state" => if(paused?, do: "paused", else: "idle"),
        "style" => style
      }
      |> maybe_put_dir(Map.get(assigns, :dir))

    base =
      case get_boolean(paused?) do
        nil -> base
        v -> Map.put(base, "data-paused", v)
      end

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
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "style" => "pointer-events:none;position:absolute;#{pos_style};#{size_style}"
    }
  end

  @spec viewport(Viewport.t()) :: map()
  def viewport(assigns) do
    orient = Map.get(assigns, :orientation, "vertical") || "horizontal"
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

  @spec content(Content.t() | map()) :: map()
  def content(assigns) do
    orient = Map.get(assigns, :orientation, "vertical") || "horizontal"
    flex_dir = if(orient == "vertical", do: "column", else: "row")
    min_dim = if(orient == "vertical", do: "min-width", else: "min-height")
    index = Map.get(assigns, :index, 0)
    clone? = index > 0

    attrs =
      %{
        "data-scope" => "marquee",
        "data-part" => "content",
        "data-index" => to_string(index),
        "data-orientation" => orient,
        "data-side" => assigns.side,
        "id" => "marquee:#{assigns.root_id}:content:#{index}",
        "style" =>
          "display:flex;flex-direction:#{flex_dir};flex-shrink:0;backface-visibility:hidden;-webkit-backface-visibility:hidden;transform:translateZ(0);#{min_dim}:auto;contain:paint"
      }
      |> maybe_put_dir(Map.get(assigns, :dir))

    attrs =
      if clone? do
        attrs
        |> Map.put("data-clone", "")
        |> Map.put("role", "presentation")
        |> Map.put("aria-hidden", "true")
      else
        attrs
      end

    attrs =
      if Map.get(assigns, :reverse, false) do
        Map.put(attrs, "data-reverse", "")
      else
        attrs
      end

    attrs
  end

  @spec item(Item.t() | map()) :: map()
  def item(assigns) do
    margin_prop =
      if((Map.get(assigns, :orientation, "vertical") || "horizontal") == "vertical",
        do: "margin-block",
        else: "margin-inline"
      )

    style = "#{margin_prop}:calc(var(--marquee-spacing) / 2)"

    %{
      "data-scope" => "marquee",
      "data-part" => "item",
      "style" => style
    }
    |> maybe_put_dir(Map.get(assigns, :dir))
  end
end
