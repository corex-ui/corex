defmodule Corex.Collapsible.Connect do
  @moduledoc false
  alias Corex.Collapsible.Anatomy.{Closed, Content, Opened, Props, Root, Trigger}
  alias Corex.Selectors

  alias Phoenix.LiveView.JS

  import Corex.Helpers,
    only: [data_state: 3, get_boolean: 1, get_boolean: 2, get_default_boolean: 2]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-open" => get_default_boolean(assigns.controlled, assigns.open),
      "data-open" => get_boolean(assigns.controlled, assigns.open),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "collapsible",
      "data-part" => "root",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "collapsible:#{assigns.id}",
      "data-state" => data_state(assigns.open, "open", "closed")
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("collapsible:#{assigns.id}")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "collapsible",
      "data-part" => "trigger",
      "type" => "button",
      "tabindex" => if(assigns.disabled, do: -1, else: 0),
      "aria-expanded" => if(assigns.open, do: "true", else: "false"),
      "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
      "data-disabled" => assigns.disabled,
      "disabled" => assigns.disabled,
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-state" => data_state(assigns.open, "open", "closed"),
      "id" => "collapsible:#{assigns.id}:trigger",
      "data-controls" => "collapsible:#{assigns.id}:content",
      "aria-controls" => "collapsible:#{assigns.id}:content"
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("collapsible:#{assigns.id}:trigger")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "collapsible",
      "data-part" => "content",
      "data-collapsible" => "",
      "id" => "collapsible:#{assigns.id}:content",
      "data-state" => data_state(assigns.open, "open", "closed"),
      "data-disabled" => assigns.disabled,
      "hidden" => !assigns.open,
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "aria-labelledby" => "collapsible:#{assigns.id}:trigger",
      "style" => content_style()
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("collapsible:#{assigns.id}:content")
    )
  end

  defp content_style do
    "--height: 0px; --width: 0px; --collapsed-height: 0px; --collapsed-width: 0px"
  end

  @spec closed_part(Closed.t()) :: map()
  def closed_part(assigns) do
    %{
      "data-scope" => "collapsible",
      "data-part" => "closed",
      "aria-hidden" => true,
      "id" => "collapsible:#{assigns.id}:closed",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-disabled" => assigns.disabled
    }
  end

  def ignore_closed_part(assigns) do
    JS.ignore_attributes(Closed.ignored_attrs(),
      to: Selectors.css_id("collapsible:#{assigns.id}:closed")
    )
  end

  @spec opened_part(Opened.t()) :: map()
  def opened_part(assigns) do
    %{
      "data-scope" => "collapsible",
      "data-part" => "opened",
      "aria-hidden" => true,
      "id" => "collapsible:#{assigns.id}:opened",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-disabled" => assigns.disabled
    }
  end

  def ignore_opened_part(assigns) do
    JS.ignore_attributes(Opened.ignored_attrs(),
      to: Selectors.css_id("collapsible:#{assigns.id}:opened")
    )
  end
end
