defmodule Corex.Presence.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors
  alias Corex.Presence.Anatomy.{Props, Root}
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-present" => if(Map.get(assigns, :present, true), do: "true", else: "false"),
      "data-on-exit-complete" => Map.get(assigns, :on_exit_complete),
      "data-on-exit-complete-client" => Map.get(assigns, :on_exit_complete_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "presence",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "presence:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("presence:" <> assigns.id <> ":root")
    )
  end
end
