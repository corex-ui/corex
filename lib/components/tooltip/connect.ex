defmodule Corex.Tooltip.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Tooltip.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    positioning = Map.get(assigns, :positioning, %Corex.Positioning{})

    base = %{
      "id" => assigns.id,
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
    |> maybe_put("data-on-trigger-value-change", Map.get(assigns, :on_trigger_value_change))
    |> Map.merge(Corex.Positioning.to_dataset(positioning))
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  @spec trigger_id(String.t(), String.t() | nil) :: String.t()
  def trigger_id(tooltip_id, nil), do: "tooltip:#{tooltip_id}:trigger"

  def trigger_id(tooltip_id, value) when is_binary(value),
    do: "tooltip:#{tooltip_id}:trigger:#{value}"

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"
    value = Map.get(assigns, :value)
    dom_id = trigger_id(assigns.id, value)

    base = %{
      "data-scope" => "tooltip",
      "data-part" => "trigger",
      "tabindex" => if(assigns.disabled, do: -1, else: 0),
      "data-disabled" => assigns.disabled,
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-state" => data_state,
      "id" => dom_id
    }

    base
    |> maybe_put("data-value", value)
    |> then(fn m ->
      case Map.get(assigns, :tag, :button) do
        :span -> m
        _ -> Map.put(m, "type", "button")
      end
    end)
  end

  def ignore_trigger(assigns) do
    value = Map.get(assigns, :value)
    dom_id = trigger_id(assigns.id, value)

    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id(dom_id)
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
end
