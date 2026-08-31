defmodule Corex.RatingGroup.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.RatingGroup.Anatomy.{Props, Root}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-count" => Map.get(assigns, :count),
      "data-value" => Map.get(assigns, :value),
      "data-allow-half" => presence_attr(Map.get(assigns, :allow_half)),
      "data-disabled" => presence_attr(Map.get(assigns, :disabled)),
      "data-readonly" => presence_attr(Map.get(assigns, :read_only)),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "rating-group",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "rating-group:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("rating-group:" <> assigns.id <> ":root")
    )
  end
end
