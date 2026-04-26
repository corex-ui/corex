defmodule Corex.AngleSlider.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.AngleSlider.Anatomy.{
    Control,
    HiddenInput,
    Label,
    Marker,
    MarkerGroup,
    Props,
    Root,
    Text,
    Thumb,
    Value,
    ValueText
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]
  import Corex.Gettext, only: [gettext: 1]

  defp orientation(assigns), do: Map.get(assigns, :orientation, "horizontal")

  @spec format_number(number()) :: String.t()
  def format_number(v) when is_integer(v), do: Integer.to_string(v)

  def format_number(v) when is_float(v) do
    if v == trunc(v) do
      Integer.to_string(trunc(v))
    else
      :erlang.float_to_binary(v, [:compact, decimals: 4])
    end
  end

  def format_number(v) when is_number(v), do: to_string(v)

  defp display_angle(value, assigns) do
    dir = Map.get(assigns, :dir, "ltr")

    if dir == "rtl" do
      360 - value
    else
      value
    end
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-value" => if(assigns.controlled, do: nil, else: format_number(assigns.value)),
      "data-value" => if(assigns.controlled, do: format_number(assigns.value), else: nil),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-step" => format_number(assigns.step),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-read-only" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-name" => assigns.name,
      "data-dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-value-change-end" => assigns.on_value_change_end,
      "data-on-value-change-end-client" => assigns.on_value_change_end_client,
      "data-value-text-as" => assigns.value_text_as
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    value = assigns.value
    angle = "#{format_number(display_angle(value, assigns))}deg"

    %{
      "data-scope" => "angle-slider",
      "data-part" => "root",
      "id" => "angle-slider:#{assigns.id}",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "style" => "--value:#{format_number(value)};--angle:#{angle};",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "label",
      "id" => "angle-slider:#{assigns.id}:label",
      "for" => "angle-slider:#{assigns.id}:input",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:label")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "hidden-input",
      "type" => "hidden",
      "name" => assigns.name,
      "value" => to_string(assigns.value),
      "disabled" => get_boolean(assigns.disabled),
      "id" => "angle-slider:#{assigns.id}:input",
      "dir" => assigns.dir
    }
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:input")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "control",
      "role" => "presentation",
      "id" => "angle-slider:#{assigns.id}:control",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:control")
    )
  end

  @spec thumb(Thumb.t()) :: map()
  def thumb(assigns) do
    %{
      "data-scope" => "angle-slider",
      "data-part" => "thumb",
      "id" => "angle-slider:#{assigns.id}:thumb",
      "dir" => assigns.dir,
      "style" => "rotate:var(--angle);",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only),
      "aria-label" => gettext("Angle position")
    }
  end

  def ignore_thumb(assigns) do
    JS.ignore_attributes(Thumb.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:thumb")
    )
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

  def ignore_value_text(assigns) do
    JS.ignore_attributes(ValueText.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:value-text")
    )
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

  def ignore_marker_group(assigns) do
    JS.ignore_attributes(MarkerGroup.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:marker-group")
    )
  end

  @spec marker(Marker.t()) :: map()
  def marker(assigns) do
    state =
      cond do
        assigns.value < assigns.slider_value -> "under-value"
        assigns.value > assigns.slider_value -> "over-value"
        true -> "at-value"
      end

    marker_display = display_angle(assigns.value, assigns)

    %{
      "data-scope" => "angle-slider",
      "data-part" => "marker",
      "data-value" => format_number(assigns.value),
      "data-state" => state,
      "id" => "angle-slider:#{assigns.id}:marker:#{assigns.value}",
      "dir" => assigns.dir,
      "style" =>
        "--marker-value:#{format_number(assigns.value)};--marker-display-value:#{format_number(marker_display)};rotate:calc(var(--marker-display-value) * 1deg);",
      "data-disabled" => get_boolean(assigns.disabled)
    }
  end

  def ignore_marker(assigns) do
    JS.ignore_attributes(Marker.ignored_attrs(),
      to: Selectors.css_id("angle-slider:#{assigns.id}:marker:#{assigns.value}")
    )
  end
end
