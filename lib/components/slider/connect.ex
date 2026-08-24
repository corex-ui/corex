defmodule Corex.Slider.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.FormField

  alias Corex.Slider.Anatomy.{
    Control,
    HiddenInput,
    Label,
    Marker,
    MarkerGroup,
    Props,
    Range,
    Root,
    Thumb,
    Track,
    Value,
    ValueText
  }

  alias Phoenix.LiveView.JS

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

  defp format_optional_number(nil), do: nil
  defp format_optional_number(value), do: format_number(value)

  @spec encode_number_list([number()]) :: String.t()
  def encode_number_list(values) when is_list(values), do: Corex.Json.encode!(values)

  @spec effective_values(term()) :: [number()]
  def effective_values(nil), do: [0]
  def effective_values(values) when is_list(values) and values != [], do: values
  def effective_values(value) when is_number(value), do: [value]
  def effective_values(_), do: [0]

  @spec value_text_string([number()] | nil) :: String.t()
  def value_text_string(nil), do: value_text_string([0])

  def value_text_string(values) when is_list(values) do
    values
    |> effective_values()
    |> Enum.map_join(" – ", &format_number/1)
  end

  defp percent(_value, min, max) when max == min, do: 0.0

  defp percent(value, min, max) do
    ((value - min) / (max - min) * 100)
    |> max(0.0)
    |> min(100.0)
  end

  # Zag stores --slider-range-end as the inset from the opposite edge
  # (right/top), not the fill's end percent along the track.
  @spec range_offsets([number()], number(), number(), String.t()) :: {String.t(), String.t()}
  def range_offsets(values, min, max, origin) do
    percents = Enum.map(effective_values(values), &percent(&1, min, max))

    {start_pct, end_from_opposite} =
      case {percents, origin} do
        {[p], "center"} when p >= 50.0 ->
          {50.0, 100.0 - p}

        {[p], "center"} ->
          {p, 50.0}

        {[p], "end"} ->
          {p, 0.0}

        {[p], _} ->
          {0.0, 100.0 - p}

        _ ->
          lo = Enum.min(percents)
          hi = Enum.max(percents)
          {lo, 100.0 - hi}
      end

    {"#{format_number(start_pct)}%", "#{format_number(end_from_opposite)}%"}
  end

  defp thumb_transform(orientation, dir) do
    cond do
      orientation == "vertical" -> "translateY(50%)"
      dir == "rtl" -> "translateX(50%)"
      true -> "translateX(-50%)"
    end
  end

  defp thumb_offset_css(value, min, max, index, thumb_alignment) do
    pct = format_number(percent(value, min, max))

    if thumb_alignment in [nil, "contain"] do
      "--slider-thumb-offset-#{index}:calc(#{pct}% - (var(--thumb-size) * (#{pct} / 100 - 0.5)));"
    else
      "--slider-thumb-offset-#{index}:#{pct}%;"
    end
  end

  defp thumb_offset_vars(values, min, max, thumb_alignment) do
    values
    |> effective_values()
    |> Enum.with_index()
    |> Enum.map_join("", fn {value, index} ->
      thumb_offset_css(value, min, max, index, thumb_alignment)
    end)
  end

  defp marker_translate(orientation, dir) do
    cond do
      orientation == "vertical" -> "--translate-x:0%;--translate-y:50%;"
      dir == "rtl" -> "--translate-x:50%;--translate-y:0%;"
      true -> "--translate-x:-50%;--translate-y:0%;"
    end
  end

  defp marker_placement_style(value, min, max, orientation, thumb_alignment) do
    pct = format_number(percent(value, min, max))
    prop = if orientation == "vertical", do: "bottom", else: "inset-inline-start"

    offset =
      if thumb_alignment in [nil, "contain"] do
        "calc(#{pct}% - (var(--thumb-size) * (#{pct} / 100 - 0.5)))"
      else
        "#{pct}%"
      end

    "#{prop}:#{offset};"
  end

  defp root_style(values, min, max, origin, orientation, dir, thumb_alignment) do
    {start_off, end_off} = range_offsets(values, min, max, origin)

    "#{thumb_offset_vars(values, min, max, thumb_alignment)}--slider-thumb-transform:#{thumb_transform(orientation, dir)};--slider-range-start:#{start_off};--slider-range-end:#{end_off};"
  end

  defp range_style(values, min, max, origin) do
    {start_off, end_off} = range_offsets(values, min, max, origin)
    "--slider-range-start:#{start_off};--slider-range-end:#{end_off};"
  end

  defp thumb_style(index, orientation) do
    placement = if orientation == "vertical", do: "bottom", else: "inset-inline-start"

    "#{placement}:var(--slider-thumb-offset-#{index});transform:var(--slider-thumb-transform);position:absolute;"
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    values = effective_values(assigns.value)
    formatted = encode_number_list(values)
    value_dataset = FormField.default_value_dataset(assigns, formatted)

    %{
      "id" => assigns.id,
      "data-default-value" => value_dataset,
      "data-value" => nil,
      "data-min" => format_number(assigns.min),
      "data-max" => format_number(assigns.max),
      "data-step" => format_number(assigns.step),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-readonly" => presence_attr(assigns.read_only),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-required" => presence_attr(assigns.required),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "data-origin" => assigns.origin,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-value-change-end" => assigns.on_value_change_end,
      "data-on-value-change-end-client" => assigns.on_value_change_end_client
    }
    |> maybe_put("data-large-step", format_optional_number(assigns.large_step))
    |> maybe_put("data-thumb-alignment", assigns.thumb_alignment)
    |> maybe_put(
      "data-min-steps-between-thumbs",
      format_optional_number(assigns.min_steps_between_thumbs)
    )
    |> maybe_put("data-thumb-collision-behavior", assigns.thumb_collision_behavior)
    |> maybe_put_submit_name(Map.get(assigns, :submit_name))
    |> FormField.put_form_field_attrs(assigns)
  end

  defp maybe_put_submit_name(attrs, nil), do: attrs
  defp maybe_put_submit_name(attrs, name), do: Map.put(attrs, "data-submit-name", name)

  @spec root(Root.t()) :: map()
  def root(assigns) do
    values = effective_values(assigns.value)
    min = Map.get(assigns, :min, 0)
    max = Map.get(assigns, :max, 100)
    origin = Map.get(assigns, :origin, "start")
    orient = orientation(assigns)
    thumb_alignment = Map.get(assigns, :thumb_alignment)

    %{
      "data-scope" => "slider",
      "data-part" => "root",
      "id" => "slider:#{assigns.id}",
      "dir" => assigns.dir,
      "data-orientation" => orient,
      "style" =>
        root_style(
          values,
          min,
          max,
          origin,
          orient,
          Map.get(assigns, :dir),
          thumb_alignment
        ),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-readonly" => presence_attr(assigns.read_only)
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "slider",
      "data-part" => "label",
      "id" => "slider:#{assigns.id}:label",
      "for" => "slider:#{assigns.id}:input:0",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-readonly" => presence_attr(assigns.read_only)
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:label")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    index = Map.get(assigns, :index, 0)

    %{
      "data-scope" => "slider",
      "data-part" => "hidden-input",
      "data-index" => Integer.to_string(index),
      "type" => "hidden",
      "disabled" => presence_attr(assigns.disabled),
      "id" => "slider:#{assigns.id}:input:#{index}",
      "dir" => assigns.dir
    }
    |> maybe_put("name", nonempty_string(assigns.name))
    |> maybe_put("form", nonempty_string(Map.get(assigns, :form)))
    |> maybe_put("required", presence_attr(Map.get(assigns, :required)))
    |> maybe_put("value", value_string(assigns.value))
  end

  defp nonempty_string(value) when is_binary(value) and value != "", do: value
  defp nonempty_string(_), do: nil

  defp value_string(nil), do: nil
  defp value_string(value), do: to_string(value)

  def ignore_hidden_input(assigns) do
    index = Map.get(assigns, :index, 0)

    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:input:#{index}")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "slider",
      "data-part" => "control",
      "id" => "slider:#{assigns.id}:control",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-readonly" => presence_attr(assigns.read_only)
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:control")
    )
  end

  @spec track(Track.t()) :: map()
  def track(assigns) do
    %{
      "data-scope" => "slider",
      "data-part" => "track",
      "id" => "slider:#{assigns.id}:track",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-readonly" => presence_attr(assigns.read_only)
    }
  end

  def ignore_track(assigns) do
    JS.ignore_attributes(Track.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:track")
    )
  end

  @spec range(Range.t()) :: map()
  def range(assigns) do
    values = effective_values(assigns.value)
    min = Map.get(assigns, :min, 0)
    max = Map.get(assigns, :max, 100)
    origin = Map.get(assigns, :origin, "start")

    %{
      "data-scope" => "slider",
      "data-part" => "range",
      "id" => "slider:#{assigns.id}:range",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "style" => range_style(values, min, max, origin),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-readonly" => presence_attr(assigns.read_only)
    }
  end

  def ignore_range(assigns) do
    JS.ignore_attributes(Range.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:range")
    )
  end

  @spec thumb(Thumb.t()) :: map()
  def thumb(assigns) do
    index = Map.get(assigns, :index, 0)
    orient = orientation(assigns)

    %{
      "data-scope" => "slider",
      "data-part" => "thumb",
      "data-index" => Integer.to_string(index),
      "id" => "slider:#{assigns.id}:thumb:#{index}",
      "dir" => assigns.dir,
      "data-orientation" => orient,
      "role" => "slider",
      "style" => thumb_style(index, orient),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-readonly" => presence_attr(assigns.read_only)
    }
    |> maybe_put("tabindex", if(assigns.disabled in [nil, false], do: "0"))
  end

  def ignore_thumb(assigns) do
    index = Map.get(assigns, :index, 0)

    JS.ignore_attributes(Thumb.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:thumb:#{index}")
    )
  end

  @spec value_text(ValueText.t()) :: map()
  def value_text(assigns) do
    %{
      "data-scope" => "slider",
      "data-part" => "value-text",
      "dir" => assigns.dir,
      "id" => "slider:#{assigns.id}:value-text"
    }
  end

  def ignore_value_text(assigns) do
    JS.ignore_attributes(ValueText.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:value-text")
    )
  end

  @spec value(Value.t()) :: map()
  def value(_assigns) do
    %{
      "data-scope" => "slider",
      "data-part" => "value"
    }
  end

  @spec marker_group(MarkerGroup.t()) :: map()
  def marker_group(assigns) do
    %{
      "data-scope" => "slider",
      "data-part" => "marker-group",
      "dir" => assigns.dir,
      "id" => "slider:#{assigns.id}:marker-group"
    }
  end

  def ignore_marker_group(assigns) do
    JS.ignore_attributes(MarkerGroup.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:marker-group")
    )
  end

  @spec marker(Marker.t()) :: map()
  def marker(assigns) do
    values = effective_values(assigns.slider_value)
    {lo, hi} = Enum.min_max(values)
    min = Map.get(assigns, :min, 0)
    max = Map.get(assigns, :max, 100)
    orient = orientation(assigns)
    thumb_alignment = Map.get(assigns, :thumb_alignment)

    state =
      case values do
        [current] ->
          cond do
            assigns.value < current -> "under-value"
            assigns.value > current -> "over-value"
            true -> "at-value"
          end

        _ ->
          cond do
            assigns.value < lo -> "under-value"
            assigns.value > hi -> "over-value"
            true -> "at-value"
          end
      end

    %{
      "data-scope" => "slider",
      "data-part" => "marker",
      "data-value" => format_number(assigns.value),
      "data-state" => state,
      "id" => "slider:#{assigns.id}:marker:#{assigns.value}",
      "dir" => assigns.dir,
      "style" =>
        "#{marker_placement_style(assigns.value, min, max, orient, thumb_alignment)}translate:var(--translate-x) var(--translate-y);#{marker_translate(orient, assigns.dir)}",
      "data-disabled" => presence_attr(assigns.disabled)
    }
  end

  def ignore_marker(assigns) do
    JS.ignore_attributes(Marker.ignored_attrs(),
      to: Selectors.css_id("slider:#{assigns.id}:marker:#{assigns.value}")
    )
  end
end
