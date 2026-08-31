defmodule Corex.Splitter.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.Splitter.Anatomy.{Panel, Props, ResizeTrigger, Root}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation),
      "data-on-resize" => Map.get(assigns, :on_resize),
      "data-on-resize-client" => Map.get(assigns, :on_resize_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "splitter",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "splitter:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("splitter:" <> assigns.id <> ":root")
    )
  end

  @spec panel(Panel.t()) :: map()
  def panel(assigns) do
    %{
      "data-scope" => "splitter",
      "data-part" => "panel",
      "dir" => Map.get(assigns, :dir),
      "data-id" => assigns.panel_id,
      "id" => "splitter:" <> assigns.id <> ":panel:" <> assigns.panel_id,
      "style" => "flex: 1 1 0%; min-width: 0; min-height: 0;"
    }
  end

  def ignore_panel(assigns) do
    JS.ignore_attributes(Panel.ignored_attrs(),
      to: Selectors.css_id("splitter:" <> assigns.id <> ":panel:" <> assigns.panel_id)
    )
  end

  @spec resize_trigger(ResizeTrigger.t()) :: map()
  def resize_trigger(assigns) do
    %{
      "data-scope" => "splitter",
      "data-part" => "resize-trigger",
      "dir" => Map.get(assigns, :dir),
      "data-id" => assigns.trigger_id,
      "id" => "splitter:" <> assigns.id <> ":resize:" <> String.replace(assigns.trigger_id, ":", "-")
    }
  end

  def ignore_resize_trigger(assigns) do
    JS.ignore_attributes(ResizeTrigger.ignored_attrs(),
      to:
        Selectors.css_id(
          "splitter:" <> assigns.id <> ":resize:" <> String.replace(assigns.trigger_id, ":", "-")
        )
    )
  end
end
