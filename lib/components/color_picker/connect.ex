defmodule Corex.ColorPicker.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.ColorPicker.Anatomy.{
    Area,
    AreaBackground,
    AreaThumb,
    ChannelInput,
    ChannelSlider,
    ChannelSliderThumb,
    ChannelSliderTrack,
    Content,
    Control,
    HiddenInput,
    Label,
    Positioner,
    PresetSwatch,
    Props,
    Root,
    Swatch,
    SwatchGroup,
    SwatchTrigger,
    TransparencyGrid,
    Trigger
  }

  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [get_boolean: 1]

  defp maybe_put(acc, _key, nil), do: acc
  defp maybe_put(acc, key, value), do: [{key, value} | acc]

  defp get_event(assigns, key) do
    Map.get(assigns, key) || Map.get(assigns, to_string(key))
  end

  @visually_hidden_style "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"

  @transparency_grid_bg "conic-gradient(#eeeeee 0 25%, transparent 0 50%, #eeeeee 0 75%, transparent 0)"

  @channel_input_style "appearance:none;-webkit-appearance:none;-moz-appearance:textfield;"

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "root",
      "id" => "color-picker:#{assigns.id}",
      "dir" => assigns.dir,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid)
    }

    base =
      if assigns.value_style do
        Map.put(base, "style", "--value:#{assigns.value_style};")
      else
        base
      end

    base
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "label",
      "id" => "color-picker:#{assigns.id}:label",
      "for" => "color-picker:#{assigns.id}:hidden-input",
      "dir" => assigns.dir,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required)
    }
  end

  def ignore_label(%Label{} = assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:label")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "hidden-input",
      "id" => "color-picker:#{assigns.id}:hidden-input",
      "type" => "text",
      "tabindex" => -1,
      "style" => @visually_hidden_style
    }

    if assigns.name do
      Map.put(base, "name", assigns.name)
    else
      base
    end
  end

  def ignore_hidden_input(%HiddenInput{} = assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:hidden-input")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "control",
      "id" => "color-picker:#{assigns.id}:control",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-state" => if(assigns.open, do: "open", else: "closed")
    }
  end

  def ignore_control(%Control{} = assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:control")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "trigger",
      "id" => "color-picker:#{assigns.id}:trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "style" => "position:relative",
      "aria-label" => "select color. current color is #{assigns.value_str}",
      "aria-controls" => assigns.content_id,
      "aria-labelledby" => assigns.label_id,
      "aria-haspopup" => "dialog",
      "aria-expanded" => to_string(assigns.open),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-state" => if(assigns.open, do: "open", else: "closed")
    }
  end

  def ignore_trigger(%Trigger{} = assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:trigger")
    )
  end

  @spec transparency_grid(TransparencyGrid.t()) :: map()
  def transparency_grid(assigns) do
    size = assigns.size

    %{
      "data-scope" => "color-picker",
      "data-part" => "transparency-grid",
      "data-size" => size,
      "id" => "color-picker:#{assigns.id}:transparency:#{assigns.variant}",
      "style" =>
        "--size:#{size};width:100%;height:100%;position:absolute;background-color:#fff;background-image:#{@transparency_grid_bg};background-size:var(--size) var(--size);inset:0px;z-index:auto;pointer-events:none;"
    }
  end

  def ignore_transparency_grid(%TransparencyGrid{} = assigns) do
    JS.ignore_attributes(TransparencyGrid.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:transparency:#{assigns.variant}")
    )
  end

  defp swatch_dom_id(picker_id, variant) do
    v = variant || "main"
    "color-picker:#{picker_id}:swatch:#{v}"
  end

  @spec swatch(Swatch.t()) :: map()
  def swatch(assigns) do
    variant = Map.get(assigns, :variant) || "main"

    base = %{
      "data-scope" => "color-picker",
      "data-part" => "swatch",
      "id" => swatch_dom_id(assigns.id, variant),
      "style" => "position:relative"
    }

    base =
      if assigns.color do
        Map.put(
          base,
          "style",
          "--color:#{assigns.color};position:relative;background:#{assigns.color};"
        )
      else
        base
      end

    base =
      if assigns.value do
        Map.put(base, "data-value", assigns.value)
      else
        base
      end

    base =
      if assigns.checked != nil do
        state = if assigns.checked, do: "checked", else: "unchecked"
        Map.put(base, "data-state", state)
      else
        base
      end

    base
  end

  def ignore_swatch(%Swatch{} = assigns) do
    variant = Map.get(assigns, :variant) || "main"

    JS.ignore_attributes(Swatch.ignored_attrs(),
      to: Selectors.css_id(swatch_dom_id(assigns.id, variant))
    )
  end

  def channel_input_style, do: @channel_input_style

  def swatch_trigger_aria_label(value), do: "select #{value} as the color"

  @spec swatch_trigger(SwatchTrigger.t()) :: map()
  def swatch_trigger(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "swatch-trigger",
      "type" => "button",
      "id" => "color-picker:#{assigns.id}:swatch-trigger:#{assigns.index}",
      "data-value" => assigns.value,
      "aria-label" => swatch_trigger_aria_label(assigns.value),
      "style" => "--color:#{assigns.value};position:relative"
    }

    if assigns.checked do
      Map.put(base, "data-state", "checked")
    else
      Map.put(base, "data-state", "unchecked")
    end
  end

  def ignore_swatch_trigger(%SwatchTrigger{} = assigns) do
    JS.ignore_attributes(SwatchTrigger.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:swatch-trigger:#{assigns.index}")
    )
  end

  @spec preset_swatch(PresetSwatch.t()) :: map()
  def preset_swatch(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "swatch",
      "id" => "color-picker:#{assigns.id}:preset-swatch:#{assigns.index}",
      "data-value" => assigns.value,
      "data-state" => if(assigns.checked, do: "checked", else: "unchecked")
    }

    style =
      if assigns.color do
        "--color:#{assigns.color};position:relative;background:#{assigns.color};"
      else
        "position:relative"
      end

    Map.put(base, "style", style)
  end

  def ignore_preset_swatch(%PresetSwatch{} = assigns) do
    JS.ignore_attributes(PresetSwatch.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:preset-swatch:#{assigns.index}")
    )
  end

  @positioner_style "position:fixed;isolation:isolate;min-width:max-content;pointer-events:none;top:0px;left:0px;transform:translate3d(0, -100vh, 0);z-index:var(--z-index);"

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "positioner",
      "id" => "color-picker:#{assigns.id}:positioner",
      "dir" => assigns.dir,
      "style" => @positioner_style
    }
  end

  def ignore_positioner(%Positioner{} = assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "content",
      "id" => "color-picker:#{assigns.id}:content",
      "role" => "dialog",
      "tabindex" => -1,
      "dir" => assigns.dir,
      "data-state" => if(assigns.open, do: "open", else: "closed")
    }

    if assigns.open do
      base
    else
      Map.put(base, "hidden", "")
    end
  end

  def ignore_content(%Content{} = assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("color-picker:#{assigns.id}:content")
    )
  end

  defp picker(pid), do: "color-picker:#{pid}"

  @spec area(Area.t()) :: map()
  def area(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "area",
      "id" => "#{picker(assigns.picker_id)}:area",
      "dir" => assigns.dir
    }
  end

  def ignore_area(%Area{} = assigns) do
    JS.ignore_attributes(Area.ignored_attrs(),
      to: Selectors.css_id("#{picker(assigns.picker_id)}:area")
    )
  end

  @spec area_background(AreaBackground.t()) :: map()
  def area_background(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "area-background",
      "id" => "#{picker(assigns.picker_id)}:area-background"
    }
  end

  def ignore_area_background(%AreaBackground{} = assigns) do
    JS.ignore_attributes(AreaBackground.ignored_attrs(),
      to: Selectors.css_id("#{picker(assigns.picker_id)}:area-background")
    )
  end

  @spec area_thumb(AreaThumb.t()) :: map()
  def area_thumb(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "area-thumb",
      "id" => "#{picker(assigns.picker_id)}:area-thumb"
    }
  end

  def ignore_area_thumb(%AreaThumb{} = assigns) do
    JS.ignore_attributes(AreaThumb.ignored_attrs(),
      to: Selectors.css_id("#{picker(assigns.picker_id)}:area-thumb")
    )
  end

  @spec swatch_group(SwatchGroup.t()) :: map()
  def swatch_group(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "swatch-group",
      "id" => "#{picker(assigns.picker_id)}:swatch-group"
    }
  end

  def ignore_swatch_group(%SwatchGroup{} = assigns) do
    JS.ignore_attributes(SwatchGroup.ignored_attrs(),
      to: Selectors.css_id("#{picker(assigns.picker_id)}:swatch-group")
    )
  end

  defp channel_input_dom_id(pid, qualifier), do: "#{picker(pid)}:channel-input:#{qualifier}"

  @spec channel_input(ChannelInput.t()) :: map()
  @spec channel_input(ChannelInput.t(), map()) :: map()
  def channel_input(assigns), do: channel_input(assigns, %{})

  def channel_input(assigns, extra) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "channel-input",
      "data-channel" => assigns.channel,
      "id" => channel_input_dom_id(assigns.picker_id, assigns.qualifier),
      "style" => @channel_input_style
    }

    Map.merge(base, extra)
  end

  def ignore_channel_input(%ChannelInput{} = assigns) do
    JS.ignore_attributes(ChannelInput.ignored_attrs(),
      to: Selectors.css_id(channel_input_dom_id(assigns.picker_id, assigns.qualifier))
    )
  end

  defp channel_slider_dom_id(pid, ch), do: "#{picker(pid)}:channel-slider:#{ch}"

  @spec channel_slider(ChannelSlider.t()) :: map()
  def channel_slider(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "channel-slider",
      "data-channel" => assigns.channel,
      "id" => channel_slider_dom_id(assigns.picker_id, assigns.channel)
    }
  end

  def ignore_channel_slider(%ChannelSlider{} = assigns) do
    JS.ignore_attributes(ChannelSlider.ignored_attrs(),
      to: Selectors.css_id(channel_slider_dom_id(assigns.picker_id, assigns.channel))
    )
  end

  defp channel_slider_track_dom_id(pid, ch), do: "#{picker(pid)}:channel-slider-track:#{ch}"

  @spec channel_slider_track(ChannelSliderTrack.t()) :: map()
  def channel_slider_track(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "channel-slider-track",
      "data-channel" => assigns.channel,
      "id" => channel_slider_track_dom_id(assigns.picker_id, assigns.channel)
    }
  end

  def ignore_channel_slider_track(%ChannelSliderTrack{} = assigns) do
    JS.ignore_attributes(ChannelSliderTrack.ignored_attrs(),
      to: Selectors.css_id(channel_slider_track_dom_id(assigns.picker_id, assigns.channel))
    )
  end

  defp channel_slider_thumb_dom_id(pid, ch), do: "#{picker(pid)}:channel-slider-thumb:#{ch}"

  @spec channel_slider_thumb(ChannelSliderThumb.t()) :: map()
  def channel_slider_thumb(assigns) do
    %{
      "data-scope" => "color-picker",
      "data-part" => "channel-slider-thumb",
      "data-channel" => assigns.channel,
      "id" => channel_slider_thumb_dom_id(assigns.picker_id, assigns.channel)
    }
  end

  def ignore_channel_slider_thumb(%ChannelSliderThumb{} = assigns) do
    JS.ignore_attributes(ChannelSliderThumb.ignored_attrs(),
      to: Selectors.css_id(channel_slider_thumb_dom_id(assigns.picker_id, assigns.channel))
    )
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    event_attrs =
      []
      |> maybe_put("data-on-value-change", get_event(assigns, :on_value_change))
      |> maybe_put("data-on-value-change-client", get_event(assigns, :on_value_change_client))
      |> maybe_put("data-on-value-change-end", get_event(assigns, :on_value_change_end))
      |> maybe_put(
        "data-on-value-change-end-client",
        get_event(assigns, :on_value_change_end_client)
      )
      |> maybe_put("data-on-open-change", get_event(assigns, :on_open_change))
      |> maybe_put("data-on-open-change-client", get_event(assigns, :on_open_change_client))
      |> maybe_put("data-on-format-change", get_event(assigns, :on_format_change))
      |> maybe_put("data-on-pointer-down-outside", get_event(assigns, :on_pointer_down_outside))
      |> maybe_put("data-on-focus-outside", get_event(assigns, :on_focus_outside))
      |> maybe_put("data-on-interact-outside", get_event(assigns, :on_interact_outside))
      |> Map.new()

    base =
      %{
        "id" => assigns.id,
        "data-default-value" => assigns.value,
        "data-name" => Map.get(assigns, :name) || assigns.id,
        "data-close-on-select" => get_boolean(assigns.close_on_select),
        "data-open-auto-focus" => get_boolean(assigns.open_auto_focus),
        "data-disabled" => get_boolean(assigns.disabled),
        "data-invalid" => get_boolean(assigns.invalid),
        "data-read-only" => get_boolean(assigns.read_only),
        "data-required" => get_boolean(assigns.required),
        "data-dir" => assigns.dir
      }
      |> Map.merge(Corex.Positioning.to_dataset(assigns.positioning))

    Map.merge(base, event_attrs)
  end
end
