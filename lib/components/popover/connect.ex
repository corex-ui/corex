defmodule Corex.Popover.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.Popover.Anatomy.{
    Arrow,
    ArrowTip,
    CloseTrigger,
    Content,
    Description,
    Positioner,
    Props,
    Title,
    Trigger
  }

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    positioning = Map.get(assigns, :positioning, %Corex.Positioning{})

    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-modal" => presence_attr(assigns.modal),
      "data-portalled" => presence_attr(assigns.portalled),
      "data-auto-focus" => presence_attr(assigns.auto_focus),
      "data-restore-focus" => presence_attr(assigns.restore_focus),
      "data-close-on-interact-outside" => presence_attr(assigns.close_on_interact_outside),
      "data-close-on-escape" => presence_attr(assigns.close_on_escape),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
    |> maybe_put("data-on-trigger-value-change", Map.get(assigns, :on_trigger_value_change))
    |> maybe_put(
      "data-on-trigger-value-change-client",
      Map.get(assigns, :on_trigger_value_change_client)
    )
    |> Map.merge(Corex.Positioning.to_dataset(positioning))
  end

  @spec trigger_id(String.t(), String.t() | nil) :: String.t()
  def trigger_id(id, nil), do: "popover:#{id}:trigger"

  def trigger_id(id, value) when is_binary(value), do: "popover:#{id}:trigger:#{value}"

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    value = Map.get(assigns, :value)
    dom_id = trigger_id(assigns.id, value)

    %{
      "data-scope" => "popover",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-state" => data_state(assigns.open, "open", "closed"),
      "id" => dom_id
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
      "data-scope" => "popover",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "id" => "popover:#{assigns.id}:popper"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:popper")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    closed? = assigns.open != true

    %{
      "data-scope" => "popover",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-state" => data_state(assigns.open, "open", "closed"),
      "id" => "popover:#{assigns.id}:content"
    }
    |> then(fn attrs ->
      if closed?, do: Map.put(attrs, "hidden", true), else: attrs
    end)
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:content")
    )
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "popover",
      "data-part" => "title",
      "dir" => Map.get(assigns, :dir),
      "id" => "popover:#{assigns.id}:title"
    }
  end

  def ignore_title(assigns) do
    JS.ignore_attributes(Title.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:title")
    )
  end

  @spec description(Description.t()) :: map()
  def description(assigns) do
    %{
      "data-scope" => "popover",
      "data-part" => "description",
      "dir" => Map.get(assigns, :dir),
      "id" => "popover:#{assigns.id}:description"
    }
  end

  def ignore_description(assigns) do
    JS.ignore_attributes(Description.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:description")
    )
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "popover",
      "data-part" => "close-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "id" => "popover:#{assigns.id}:close-trigger"
    }
  end

  def ignore_close_trigger(assigns) do
    JS.ignore_attributes(CloseTrigger.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:close-trigger")
    )
  end

  @spec arrow(Arrow.t()) :: map()
  def arrow(assigns) do
    %{
      "data-scope" => "popover",
      "data-part" => "arrow",
      "dir" => Map.get(assigns, :dir),
      "id" => "popover:#{assigns.id}:arrow"
    }
  end

  def ignore_arrow(assigns) do
    JS.ignore_attributes(Arrow.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:arrow")
    )
  end

  @spec arrow_tip(ArrowTip.t()) :: map()
  def arrow_tip(assigns) do
    %{
      "data-scope" => "popover",
      "data-part" => "arrow-tip",
      "dir" => Map.get(assigns, :dir),
      "id" => "popover:#{assigns.id}:arrow-tip"
    }
  end

  def ignore_arrow_tip(assigns) do
    JS.ignore_attributes(ArrowTip.ignored_attrs(),
      to: Selectors.css_id("popover:#{assigns.id}:arrow-tip")
    )
  end
end
