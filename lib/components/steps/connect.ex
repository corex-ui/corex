defmodule Corex.Steps.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.Steps.Anatomy.{Props, Root}
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
end
