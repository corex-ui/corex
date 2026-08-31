defmodule Corex.NavigationMenu.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.NavigationMenu.Anatomy.{Content, List, Props, Root, Trigger}
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "navigation-menu",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "navigation-menu:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("navigation-menu:" <> assigns.id <> ":root")
    )
  end

  @spec list(List.t()) :: map()
  def list(assigns) do
    %{
      "data-scope" => "navigation-menu",
      "data-part" => "list",
      "dir" => Map.get(assigns, :dir),
      "id" => "navigation-menu:" <> assigns.id <> ":list"
    }
  end

  def ignore_list(assigns) do
    JS.ignore_attributes(List.ignored_attrs(),
      to: Selectors.css_id("navigation-menu:" <> assigns.id <> ":list")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "navigation-menu",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-value" => assigns.value,
      "id" => "navigation-menu:" <> assigns.id <> ":content:" <> assigns.value,
      "hidden" => true
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("navigation-menu:" <> assigns.id <> ":content:" <> assigns.value)
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "navigation-menu",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-value" => assigns.value,
      "id" => "navigation-menu:" <> assigns.id <> ":trigger:" <> assigns.value
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("navigation-menu:" <> assigns.id <> ":trigger:" <> assigns.value)
    )
  end
end
