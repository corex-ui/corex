defmodule Corex.DateInput.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.DateInput.Anatomy.{Control, HiddenInput, Props, Root, Segment, SegmentGroup}
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-name" => Map.get(assigns, :name),
      "data-disabled" => presence_attr(Map.get(assigns, :disabled)),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "date-input",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "date-input:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("date-input:" <> assigns.id <> ":root")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "date-input",
      "data-part" => "control",
      "dir" => Map.get(assigns, :dir),
      "id" => "date-input:" <> assigns.id <> ":control"
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("date-input:" <> assigns.id <> ":control")
    )
  end

  @spec segment_group(SegmentGroup.t()) :: map()
  def segment_group(assigns) do
    %{
      "data-scope" => "date-input",
      "data-part" => "segment-group",
      "dir" => Map.get(assigns, :dir),
      "id" => "date-input:" <> assigns.id <> ":segment-group"
    }
  end

  def ignore_segment_group(assigns) do
    JS.ignore_attributes(SegmentGroup.ignored_attrs(),
      to: Selectors.css_id("date-input:" <> assigns.id <> ":segment-group")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "date-input",
      "data-part" => "hidden-input",
      "dir" => Map.get(assigns, :dir),
      "id" => "date-input:" <> assigns.id <> ":hidden-input",
      "type" => "hidden"
    }
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("date-input:" <> assigns.id <> ":hidden-input")
    )
  end

  @spec segment(Segment.t()) :: map()
  def segment(assigns) do
    %{
      "data-scope" => "date-input",
      "data-part" => "segment",
      "dir" => Map.get(assigns, :dir),
      "data-type" => assigns.type,
      "id" => "date-input:" <> assigns.id <> ":segment:" <> assigns.type
    }
  end

  def ignore_segment(assigns) do
    JS.ignore_attributes(Segment.ignored_attrs(),
      to: Selectors.css_id("date-input:" <> assigns.id <> ":segment:" <> assigns.type)
    )
  end
end
