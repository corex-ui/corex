defmodule Corex.Progress.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.Progress.Anatomy.{Props, Root}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-value" => Map.get(assigns, :value),
      "data-min" => Map.get(assigns, :min),
      "data-max" => Map.get(assigns, :max),
      "data-variant" => Map.get(assigns, :variant),
      "data-orientation" => Map.get(assigns, :orientation),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "progress",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":root")
    )
  end
end
