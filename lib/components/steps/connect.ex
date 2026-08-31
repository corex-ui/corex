defmodule Corex.Steps.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.Steps.Anatomy.{Content, List, Props, Root, Trigger}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-count" => Map.get(assigns, :count),
      "data-step" => Map.get(assigns, :step),
      "data-linear" => presence_attr(Map.get(assigns, :linear)),
      "data-orientation" => Map.get(assigns, :orientation),
      "data-on-step-change" => Map.get(assigns, :on_step_change),
      "data-on-step-change-client" => Map.get(assigns, :on_step_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "steps",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "steps:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("steps:" <> assigns.id <> ":root")
    )
  end

  @spec list(List.t()) :: map()
  def list(assigns) do
    %{
      "data-scope" => "steps",
      "data-part" => "list",
      "dir" => Map.get(assigns, :dir),
      "id" => "steps:" <> assigns.id <> ":list"
    }
  end

  def ignore_list(assigns) do
    JS.ignore_attributes(List.ignored_attrs(),
      to: Selectors.css_id("steps:" <> assigns.id <> ":list")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    index = to_string(assigns.index)

    %{
      "data-scope" => "steps",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-index" => index,
      "id" => "steps:" <> assigns.id <> ":trigger:" <> index
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("steps:" <> assigns.id <> ":trigger:" <> to_string(assigns.index))
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    index = to_string(assigns.index)

    %{
      "data-scope" => "steps",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-index" => index,
      "id" => "steps:" <> assigns.id <> ":content:" <> index
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("steps:" <> assigns.id <> ":content:" <> to_string(assigns.index))
    )
  end
end
