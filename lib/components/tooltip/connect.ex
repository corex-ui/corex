defmodule Corex.Tooltip.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Tooltip.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base = %{
      "id" => assigns.id,
      "data-default-open" => data_default_open(assigns),
      "data-open" => data_open(assigns),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-close-on-escape" => get_boolean(assigns.close_on_escape),
      "data-close-on-click" => get_boolean(assigns.close_on_click),
      "data-close-on-pointer-down" => get_boolean(assigns.close_on_pointer_down),
      "data-close-on-scroll" => get_boolean(assigns.close_on_scroll),
      "data-interactive" => get_boolean(assigns.interactive)
    }

    base
    |> maybe_put("data-open-delay", assigns.open_delay)
    |> maybe_put("data-close-delay", assigns.close_delay)
    |> maybe_put("data-placement", assigns.placement)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    base = %{
      "data-scope" => "tooltip",
      "data-part" => "trigger",
      "tabindex" => if(assigns.disabled, do: -1, else: 0),
      "data-disabled" => assigns.disabled,
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-state" => data_state,
      "id" => "tooltip:#{assigns.id}:trigger"
    }

    case Map.get(assigns, :tag, :button) do
      :span -> base
      _ -> Map.put(base, "type", "button")
    end
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("tooltip:#{assigns.id}:trigger")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "tooltip",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "tooltip:#{assigns.id}:positioner"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("tooltip:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    %{
      "data-scope" => "tooltip",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-state" => data_state,
      "id" => "tooltip:#{assigns.id}:content"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("tooltip:#{assigns.id}:content")
    )
  end

  @spec arrow(Arrow.t()) :: map()
  def arrow(assigns) do
    %{
      "data-scope" => "tooltip",
      "data-part" => "arrow",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "tooltip:#{assigns.id}:arrow"
    }
  end

  def ignore_arrow(assigns) do
    JS.ignore_attributes(Arrow.ignored_attrs(),
      to: Selectors.css_id("tooltip:#{assigns.id}:arrow")
    )
  end

  @spec arrow_tip(ArrowTip.t()) :: map()
  def arrow_tip(assigns) do
    %{
      "data-scope" => "tooltip",
      "data-part" => "arrow-tip",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "tooltip:#{assigns.id}:arrow-tip"
    }
  end

  def ignore_arrow_tip(assigns) do
    JS.ignore_attributes(ArrowTip.ignored_attrs(),
      to: Selectors.css_id("tooltip:#{assigns.id}:arrow-tip")
    )
  end

  defp data_default_open(assigns) do
    if !assigns.controlled && assigns.open, do: "", else: nil
  end

  defp data_open(assigns) do
    if assigns.controlled do
      if assigns.open, do: "", else: nil
    else
      nil
    end
  end
end
