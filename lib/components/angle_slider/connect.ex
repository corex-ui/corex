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
    Value,
    Text,
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
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-value-change-end" => assigns.on_value_change_end,
      "data-on-value-change-end-client" => assigns.on_value_change_end_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    value = assigns.value
    angle = "#{value}deg"

    %{
      "data-scope" => "angle-slider",
      "data-part" => "root",
      "dir" => assigns.dir,
      "style" => "--value:#{value};--angle:#{angle};"
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
      "id" => "angle-slider:#{assigns.id}:input"
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
      "id" => "angle-slider:#{assigns.id}:thumb",
      "style" => "rotate:var(--angle);"
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

  @spec value(Value.t()) :: map()
  def value(_assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "value"
    }
  end

  @spec text(Text.t()) :: map()
  def text(_assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "text"
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
    state =
      cond do
        assigns.value < assigns.slider_value -> "under-value"
        assigns.value > assigns.slider_value -> "over-value"
        true -> "at-value"
      end

    %{
      "data-scope" => "angle-slider",
      "data-part" => "marker",
      "data-value" => to_string(assigns.value),
      "data-state" => state,
      "id" => "angle-slider:#{assigns.id}:marker:#{assigns.value}",
      "style" => "--marker-value:#{assigns.value};rotate:calc(var(--marker-value) * 1deg);"
    }
  end
end
