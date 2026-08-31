defmodule Corex.Progress.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Progress.Anatomy

  alias Corex.Progress.Anatomy.{
    Circle,
    CircleRange,
    CircleTrack,
    Props,
    Range,
    Root,
    Track,
    ValueText
  }

  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-min" => Map.get(assigns, :min),
      "data-max" => Map.get(assigns, :max),
      "data-variant" => Map.get(assigns, :variant),
      "data-orientation" => Map.get(assigns, :orientation),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client),
      "data-indeterminate" => presence_attr(is_nil(Map.get(assigns, :value)))
    }
    |> maybe_put("data-value", Map.get(assigns, :value))
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    percent = Anatomy.percent(assigns.value, assigns.min, assigns.max)

    %{
      "data-scope" => "progress",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":root",
      "data-state" => if(is_nil(assigns.value), do: "indeterminate", else: "loading"),
      "style" => root_style(percent)
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":root")
    )
  end

  @spec track(Track.t()) :: map()
  def track(assigns) do
    %{
      "data-scope" => "progress",
      "data-part" => "track",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":track"
    }
  end

  def ignore_track(assigns) do
    JS.ignore_attributes(Track.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":track")
    )
  end

  @spec range(Range.t()) :: map()
  def range(assigns) do
    percent = Anatomy.percent(assigns.value, assigns.min, assigns.max)

    %{
      "data-scope" => "progress",
      "data-part" => "range",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":range",
      "data-state" => if(is_nil(assigns.value), do: "indeterminate", else: "loading"),
      "style" => range_style(percent)
    }
  end

  def ignore_range(assigns) do
    JS.ignore_attributes(Range.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":range")
    )
  end

  @spec circle(Circle.t()) :: map()
  def circle(assigns) do
    %{
      "data-scope" => "progress",
      "data-part" => "circle",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":circle"
    }
  end

  def ignore_circle(assigns) do
    JS.ignore_attributes(Circle.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":circle")
    )
  end

  @spec circle_track(CircleTrack.t()) :: map()
  def circle_track(assigns) do
    %{
      "data-scope" => "progress",
      "data-part" => "circle-track",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":circle-track"
    }
  end

  def ignore_circle_track(assigns) do
    JS.ignore_attributes(CircleTrack.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":circle-track")
    )
  end

  @spec circle_range(CircleRange.t()) :: map()
  def circle_range(assigns) do
    %{
      "data-scope" => "progress",
      "data-part" => "circle-range",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":circle-range"
    }
  end

  def ignore_circle_range(assigns) do
    JS.ignore_attributes(CircleRange.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":circle-range")
    )
  end

  @spec value_text(ValueText.t()) :: map()
  def value_text(assigns) do
    %{
      "data-scope" => "progress",
      "data-part" => "value-text",
      "dir" => Map.get(assigns, :dir),
      "id" => "progress:" <> assigns.id <> ":value-text"
    }
  end

  def ignore_value_text(assigns) do
    JS.ignore_attributes(ValueText.ignored_attrs(),
      to: Selectors.css_id("progress:" <> assigns.id <> ":value-text")
    )
  end

  defp root_style(nil), do: nil
  defp root_style(percent), do: "--percent: #{percent}%"

  defp range_style(nil), do: nil
  defp range_style(percent), do: "width: #{percent}%"
end
