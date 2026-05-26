defmodule Corex.Timer.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Timer.Anatomy.{
    ActionTrigger,
    Area,
    Control,
    Item,
    ItemLabel,
    Props,
    Root,
    Segment,
    Separator
  }

  alias Corex.Timer.Translation, as: TimerTranslation

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-countdown" => get_boolean(assigns.countdown),
      "data-start-ms" => to_string(assigns.start_ms),
      "data-target-ms" => if(assigns.target_ms, do: to_string(assigns.target_ms), else: nil),
      "data-auto-start" => get_boolean(assigns.auto_start),
      "data-interval" => to_string(assigns.interval),
      "data-on-tick" => assigns.on_tick,
      "data-on-tick-client" => assigns.on_tick_client,
      "data-on-complete" => assigns.on_complete,
      "data-on-complete-client" => assigns.on_complete_client,
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-collapse-leading-zeros" => collapse_dataset(assigns),
      "data-segments" => segments_dataset(assigns),
      "data-translation" => translation_json(assigns)
    }
  end

  defp collapse_dataset(%Props{collapse_leading_zeros: false}), do: "false"

  defp collapse_dataset(%Props{collapse_leading_zeros: true}), do: "true"

  defp collapse_dataset(%Props{segments: segs})
       when is_list(segs) and segs != [],
       do: "false"

  defp collapse_dataset(%Props{countdown: true}), do: "true"

  defp collapse_dataset(%Props{}), do: "false"

  defp segments_dataset(%Props{segments: list}) when is_list(list) and list != [] do
    Enum.map_join(list, ",", &Atom.to_string/1)
  end

  defp segments_dataset(_), do: nil

  defp translation_json(%Props{translation: %TimerTranslation{} = t}) do
    t
    |> TimerTranslation.to_camel_map()
    |> Enum.reject(fn {_, v} -> v in [nil, ""] end)
    |> Map.new()
    |> then(fn
      m when map_size(m) == 0 -> nil
      m -> Corex.Dataset.encode_json(m)
    end)
  end

  defp translation_json(_), do: nil

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "root",
      "id" => "timer:#{assigns.id}:root",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:root")
    )
  end

  @spec area(Area.t()) :: map()
  def area(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "area",
      "id" => "timer:#{assigns.id}:area",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  def ignore_area(assigns) do
    JS.ignore_attributes(Area.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:area")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "control",
      "id" => "timer:#{assigns.id}:control",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:control")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    value = Map.get(assigns, :value, 0)

    base = %{
      "data-scope" => "timer",
      "data-part" => "item",
      "data-type" => assigns.type,
      "id" => "timer:#{assigns.id}:item:#{assigns.type}",
      "style" => "--value:#{value};",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }

    if Map.get(assigns, :hidden, false) do
      base
      |> Map.put("hidden", "")
      |> Map.put("aria-hidden", "true")
    else
      base
    end
  end

  def ignore_item(assigns) do
    JS.ignore_attributes(
      Item.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:item:#{assigns.type}")
    )
  end

  @spec segment(Segment.t()) :: map()
  def segment(assigns) do
    base = %{
      "data-timer-segment" => "",
      "id" => "timer:#{assigns.id}:segment:#{assigns.type}",
      "data-type" => assigns.type
    }

    if Map.get(assigns, :hidden, false) do
      base |> Map.put("hidden", "")
    else
      base
    end
  end

  def ignore_segment(assigns) do
    JS.ignore_attributes(
      Segment.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:segment:#{assigns.type}")
    )
  end

  @spec item_label(ItemLabel.t()) :: map()
  def item_label(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "item-label",
      "data-type" => assigns.type,
      "id" => "timer:#{assigns.id}:label:#{assigns.type}",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  def ignore_item_label(assigns) do
    JS.ignore_attributes(
      ItemLabel.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:label:#{assigns.type}")
    )
  end

  @spec separator(Separator.t()) :: map()
  def separator(assigns) do
    base = %{
      "data-scope" => "timer",
      "data-part" => "separator",
      "aria-hidden" => "true",
      "id" => assigns.id,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal")
    }

    if Map.get(assigns, :hidden, false) do
      base |> Map.put("hidden", "")
    else
      base
    end
  end

  def ignore_separator(assigns) do
    JS.ignore_attributes(Separator.ignored_attrs(), to: Selectors.css_id(assigns.id))
  end

  defp action_label("start"), do: "Start"
  defp action_label("pause"), do: "Pause"
  defp action_label("resume"), do: "Resume"
  defp action_label("reset"), do: "Reset"
  defp action_label(_), do: "Timer action"

  @spec action_trigger(ActionTrigger.t()) :: map()
  def action_trigger(assigns) do
    base = %{
      "data-scope" => "timer",
      "data-part" => "action-trigger",
      "data-action" => assigns.action,
      "type" => "button",
      "aria-label" => action_label(assigns.action),
      "id" => "timer:#{assigns.id}:action:#{assigns.action}",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }

    if assigns.hidden do
      Map.put(base, "hidden", "")
    else
      base
    end
  end

  def ignore_action_trigger(assigns) do
    JS.ignore_attributes(
      ActionTrigger.ignored_attrs(),
      to: Selectors.css_id("timer:#{assigns.id}:action:#{assigns.action}")
    )
  end
end
