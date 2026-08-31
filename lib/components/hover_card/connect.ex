defmodule Corex.HoverCard.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.HoverCard.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    positioning = Map.get(assigns, :positioning, %Corex.Positioning{})

    %{
      "id" => assigns.id,
      "data-disabled" => presence_attr(assigns.disabled),
      "data-dir" => Map.get(assigns, :dir),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
    |> maybe_put("data-open-delay", assigns.open_delay)
    |> maybe_put("data-close-delay", assigns.close_delay)
    |> maybe_put("data-on-trigger-value-change", Map.get(assigns, :on_trigger_value_change))
    |> maybe_put(
      "data-on-trigger-value-change-client",
      Map.get(assigns, :on_trigger_value_change_client)
    )
    |> Map.merge(Corex.Positioning.to_dataset(positioning))
  end

  @spec trigger_id(String.t(), String.t() | nil) :: String.t()
  def trigger_id(id, nil), do: "hover-card:#{id}:trigger"
  def trigger_id(id, value) when is_binary(value), do: "hover-card:#{id}:trigger:#{value}"

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    value = Map.get(assigns, :value)

    %{
      "data-scope" => "hover-card",
      "data-part" => "trigger",
      "dir" => Map.get(assigns, :dir),
      "data-disabled" => assigns.disabled,
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

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "hover-card",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "id" => "hover-card:#{assigns.id}:popper",
      "style" =>
        "position:absolute;isolation:isolate;pointer-events:none;top:0px;left:0px;transform:translate3d(0, -100vh, 0);"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("hover-card:#{assigns.id}:popper")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "hover-card",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-state" => "closed",
      "id" => "hover-card:#{assigns.id}:content",
      "hidden" => true,
      "aria-hidden" => "true",
      "style" => "display:none;pointer-events:none"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("hover-card:#{assigns.id}:content")
    )
  end

  @spec arrow(Arrow.t()) :: map()
  def arrow(assigns) do
    %{
      "data-scope" => "hover-card",
      "data-part" => "arrow",
      "dir" => Map.get(assigns, :dir),
      "id" => "hover-card:#{assigns.id}:arrow"
    }
  end

  def ignore_arrow(assigns) do
    JS.ignore_attributes(Arrow.ignored_attrs(),
      to: Selectors.css_id("hover-card:#{assigns.id}:arrow")
    )
  end

  @spec arrow_tip(ArrowTip.t()) :: map()
  def arrow_tip(assigns) do
    %{
      "data-scope" => "hover-card",
      "data-part" => "arrow-tip",
      "dir" => Map.get(assigns, :dir),
      "id" => "hover-card:#{assigns.id}:arrow-tip"
    }
  end

  def ignore_arrow_tip(assigns) do
    JS.ignore_attributes(ArrowTip.ignored_attrs(),
      to: Selectors.css_id("hover-card:#{assigns.id}:arrow-tip")
    )
  end
end
