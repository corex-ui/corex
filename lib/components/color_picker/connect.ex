defmodule Corex.ColorPicker.Connect do
  @moduledoc false
  alias Corex.ColorPicker.Anatomy.{
    Props,
    Root,
    Label,
    HiddenInput,
    Control,
    Trigger,
    Positioner,
    Content,
    TransparencyGrid,
    Swatch,
    SwatchTrigger,
    PresetSwatch
  }

  import Corex.Helpers, only: [get_boolean: 1]

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

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

  @spec transparency_grid(TransparencyGrid.t()) :: map()
  def transparency_grid(assigns) do
    size = assigns.size

    %{
      "data-scope" => "color-picker",
      "data-part" => "transparency-grid",
      "data-size" => size,
      "style" =>
        "--size:#{size};width:100%;height:100%;position:absolute;background-color:#fff;background-image:#{@transparency_grid_bg};background-size:var(--size) var(--size);inset:0px;z-index:auto;pointer-events:none;"
    }
  end

  @spec swatch(Swatch.t()) :: map()
  def swatch(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "swatch",
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

  def channel_input_style, do: @channel_input_style

  def swatch_trigger_aria_label(value), do: "select #{value} as the color"

  @spec swatch_trigger(SwatchTrigger.t()) :: map()
  def swatch_trigger(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "swatch-trigger",
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

  @spec preset_swatch(PresetSwatch.t()) :: map()
  def preset_swatch(assigns) do
    base = %{
      "data-scope" => "color-picker",
      "data-part" => "swatch",
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

    base = %{
      "id" => assigns.id,
      "data-default-value" => assigns.default_value,
      "data-value" => if(assigns.controlled, do: assigns.value, else: nil),
      "data-name" => assigns.name,
      "data-format" => assigns.format,
      "data-default-format" => assigns.default_format,
      "data-controlled" => data_attr(assigns.controlled),
      "data-close-on-select" => data_attr(assigns.close_on_select),
      "data-default-open" => data_attr(assigns.default_open),
      "data-open" => if(assigns.controlled, do: data_attr(assigns.open), else: nil),
      "data-open-auto-focus" => data_attr(assigns.open_auto_focus),
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "data-read-only" => data_attr(assigns.read_only),
      "data-required" => data_attr(assigns.required),
      "data-dir" => assigns.dir,
      "data-positioning" =>
        if assigns.positioning && assigns.positioning != %{} do
          Corex.Json.encode!(assigns.positioning)
        else
          nil
        end
    }

    Map.merge(base, event_attrs)
  end
end
