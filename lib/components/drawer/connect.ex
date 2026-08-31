defmodule Corex.Drawer.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.Drawer.Anatomy.{
    Backdrop,
    CloseTrigger,
    Content,
    Description,
    Grabber,
    GrabberIndicator,
    Positioner,
    Props,
    Title,
    Trigger
  }

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-modal" => presence_attr(assigns.modal),
      "data-trap-focus" => presence_attr(assigns.trap_focus),
      "data-prevent-scroll" => presence_attr(assigns.prevent_scroll),
      "data-close-on-interact-outside" => presence_attr(assigns.close_on_interact_outside),
      "data-close-on-escape" => presence_attr(assigns.close_on_escape),
      "data-prevent-drag-on-scroll" => presence_attr(assigns.prevent_drag_on_scroll),
      "data-swipe-direction" => assigns.swipe_direction,
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
    |> maybe_put("data-snap-points", assigns.snap_points)
    |> maybe_put("data-default-snap-point", assigns.default_snap_point)
    |> maybe_put("data-on-snap-point-change", assigns.on_snap_point_change)
    |> maybe_put("data-on-snap-point-change-client", assigns.on_snap_point_change_client)
    |> maybe_put("data-on-trigger-value-change", Map.get(assigns, :on_trigger_value_change))
    |> maybe_put(
      "data-on-trigger-value-change-client",
      Map.get(assigns, :on_trigger_value_change_client)
    )
  end

  @spec trigger_id(String.t(), String.t() | nil) :: String.t()
  def trigger_id(id, nil), do: "drawer:#{id}:trigger"
  def trigger_id(id, value) when is_binary(value), do: "drawer:#{id}:trigger:#{value}"

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    value = Map.get(assigns, :value)

    %{
      "data-scope" => "drawer",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-state" => "closed",
      "id" => trigger_id(assigns.id, value)
    }
    |> maybe_put("data-value", value)
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id(trigger_id(assigns.id, Map.get(assigns, :value)))
    )
  end

  @spec backdrop(Backdrop.t()) :: map()
  def backdrop(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "backdrop",
      "dir" => Map.get(assigns, :dir),
      "data-state" => "closed",
      "id" => "drawer:#{assigns.id}:backdrop",
      "hidden" => true,
      "aria-hidden" => "true"
    }
  end

  def ignore_backdrop(assigns) do
    JS.ignore_attributes(Backdrop.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:backdrop")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "data-state" => "closed",
      "id" => "drawer:#{assigns.id}:positioner",
      "style" =>
        "position:fixed;isolation:isolate;pointer-events:none;top:0px;left:0px;transform:translate3d(0, -100vh, 0);"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-state" => "closed",
      "id" => "drawer:#{assigns.id}:content",
      "hidden" => true,
      "aria-hidden" => "true",
      "style" => "display:none;pointer-events:none"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:content")
    )
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "title",
      "dir" => Map.get(assigns, :dir),
      "id" => "drawer:#{assigns.id}:title"
    }
  end

  def ignore_title(assigns) do
    JS.ignore_attributes(Title.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:title")
    )
  end

  @spec description(Description.t()) :: map()
  def description(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "description",
      "dir" => Map.get(assigns, :dir),
      "id" => "drawer:#{assigns.id}:description"
    }
  end

  def ignore_description(assigns) do
    JS.ignore_attributes(Description.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:description")
    )
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "close-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "id" => "drawer:#{assigns.id}:close-trigger"
    }
  end

  def ignore_close_trigger(assigns) do
    JS.ignore_attributes(CloseTrigger.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:close-trigger")
    )
  end

  @spec grabber(Grabber.t()) :: map()
  def grabber(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "grabber",
      "dir" => Map.get(assigns, :dir),
      "id" => "drawer:#{assigns.id}:grabber"
    }
  end

  def ignore_grabber(assigns) do
    JS.ignore_attributes(Grabber.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:grabber")
    )
  end

  @spec grabber_indicator(GrabberIndicator.t()) :: map()
  def grabber_indicator(assigns) do
    %{
      "data-scope" => "drawer",
      "data-part" => "grabber-indicator",
      "dir" => Map.get(assigns, :dir),
      "id" => "drawer:#{assigns.id}:grabber-indicator"
    }
  end

  def ignore_grabber_indicator(assigns) do
    JS.ignore_attributes(GrabberIndicator.ignored_attrs(),
      to: Selectors.css_id("drawer:#{assigns.id}:grabber-indicator")
    )
  end
end
