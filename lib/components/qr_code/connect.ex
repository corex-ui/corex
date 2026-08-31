defmodule Corex.QrCode.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.QrCode.Anatomy.{Props, Root}
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-value" => Map.get(assigns, :value),
      "data-pixel-size" => Map.get(assigns, :pixel_size),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "qr-code",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "qr-code:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("qr-code:" <> assigns.id <> ":root")
    )
  end
end
