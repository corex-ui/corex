defmodule Corex.Toggle.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.Toggle.Anatomy.{Indicator, Props, Root}

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-controlled" => presence_attr(assigns.controlled),
      "data-pressed" => pressed_controlled_attr(assigns.controlled, assigns.pressed),
      "data-default-pressed" => pressed_default_attr(assigns.controlled, assigns.pressed),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-on-pressed-change" => assigns.on_pressed_change,
      "data-on-pressed-change-client" => assigns.on_pressed_change_client
    }
    |> put_data_dir_attr_from_assigns(assigns)
  end

  defp pressed_controlled_attr(true, pressed), do: if(pressed, do: "true", else: "false")
  defp pressed_controlled_attr(false, _), do: nil

  defp pressed_default_attr(true, _), do: nil

  defp pressed_default_attr(false, pressed) do
    if pressed, do: "true", else: nil
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    state = if(assigns.pressed, do: "on", else: "off")

    %{
      "data-scope" => "toggle",
      "data-part" => "root",
      "type" => "button",
      "id" => "toggle:#{assigns.id}",
      "data-state" => state,
      "data-disabled" => assigns.disabled
    }
    |> put_dir_attr_from_assigns(assigns)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("toggle:#{assigns.id}")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    state = if(assigns.pressed, do: "on", else: "off")

    %{
      "data-scope" => "toggle",
      "data-part" => "indicator",
      "id" => "toggle:#{assigns.id}:indicator",
      "data-state" => state,
      "data-disabled" => assigns.disabled
    }
    |> put_dir_attr_from_assigns(assigns)
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("toggle:#{assigns.id}:indicator")
    )
  end
end
