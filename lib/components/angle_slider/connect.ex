defmodule Corex.AngleSlider.Connect do
  @moduledoc false
  alias Corex.AngleSlider.Anatomy.{
    Props,
    Root,
    Label,
    HiddenInput,
    Control,
    Thumb,
    ValueText,
    MarkerGroup,
    Marker
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-value" => if(assigns.controlled, do: nil, else: to_string(assigns.value)),
      "data-value" => if(assigns.controlled, do: to_string(assigns.value), else: nil),
      "data-controlled" => data_attr(assigns.controlled),
      "data-step" => to_string(assigns.step),
      "data-disabled" => data_attr(assigns.disabled),
      "data-read-only" => data_attr(assigns.read_only),
      "data-invalid" => data_attr(assigns.invalid),
      "data-name" => assigns.name,
      "data-dir" => assigns.dir,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "angle-slider:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "angle-slider:#{assigns.id}:label"
    }
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "hidden-input",
      "type" => "hidden",
      "name" => assigns.name,
      "value" => to_string(assigns.value),
      "disabled" => data_attr(assigns.disabled),
      "id" => "angle-slider:#{assigns.id}:hidden-input"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "angle-slider:#{assigns.id}:control"
    }
  end

  @spec thumb(Thumb.t()) :: map()
  def thumb(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "thumb",
      "dir" => assigns.dir,
      "id" => "angle-slider:#{assigns.id}:thumb"
    }
  end

  @spec value_text(ValueText.t()) :: map()
  def value_text(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "value-text",
      "dir" => assigns.dir,
      "id" => "angle-slider:#{assigns.id}:value-text"
    }
  end

  @spec marker_group(MarkerGroup.t()) :: map()
  def marker_group(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "marker-group",
      "dir" => assigns.dir,
      "id" => "angle-slider:#{assigns.id}:marker-group"
    }
  end

  @spec marker(Marker.t()) :: map()
  def marker(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "marker",
      "data-value" => to_string(assigns.value),
      "id" => "angle-slider:#{assigns.id}:marker:#{assigns.value}"
    }
  end
end
