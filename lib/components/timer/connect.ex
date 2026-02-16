defmodule Corex.Timer.Connect do
  @moduledoc false
  alias Corex.Timer.Anatomy.{Props, Root, Area, Control, Item, Separator, ActionTrigger}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-countdown" => data_attr(assigns.countdown),
      "data-start-ms" => to_string(assigns.start_ms),
      "data-target-ms" => if(assigns.target_ms, do: to_string(assigns.target_ms), else: nil),
      "data-auto-start" => data_attr(assigns.auto_start),
      "data-interval" => to_string(assigns.interval),
      "data-on-tick" => assigns.on_tick,
      "data-on-complete" => assigns.on_complete
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "root",
      "id" => "timer:#{assigns.id}"
    }
  end

  @spec area(Area.t()) :: map()
  def area(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "area",
      "id" => "timer:#{assigns.id}:area"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "control",
      "id" => "timer:#{assigns.id}:control"
    }
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    value = Map.get(assigns, :value, 0)

    %{
      "data-scope" => "timer",
      "data-part" => "item",
      "data-type" => assigns.type,
      "style" => "--value:#{value};"
    }
  end

  @spec separator(Separator.t()) :: map()
  def separator(_assigns) do
    %{
      "data-scope" => "timer",
      "data-part" => "separator",
      "aria-hidden" => "true"
    }
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
      "aria-label" => action_label(assigns.action)
    }

    if assigns.hidden do
      Map.put(base, "hidden", "")
    else
      base
    end
  end
end
