defmodule Corex.Toc.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.Toc.Anatomy.{Props, Root}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client),
      "data-items" => Corex.Dataset.encode_json(assigns.items || Corex.Toc.default_items()),
      "data-scroll-el" => Map.get(assigns, :scroll_el)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "toc",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "toc:" <> assigns.id <> ":root",
      "aria-label" => "Table of contents " <> assigns.id
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("toc:" <> assigns.id <> ":root")
    )
  end
end
