defmodule Corex.DatePicker.Connect do
  @moduledoc false
  alias Corex.DatePicker.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    Input,
    Trigger,
    Positioner,
    Content
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-controlled" => data_attr(assigns.controlled),
      "data-default-value" =>
        if assigns.controlled do
          nil
        else
          assigns.value
        end,
      "data-value" =>
        if assigns.controlled do
          assigns.value
        else
          nil
        end,
      "data-locale" => assigns.locale,
      "data-time-zone" => assigns.time_zone,
      "data-name" => assigns.name,
      "data-disabled" => data_attr(assigns.disabled),
      "data-read-only" => data_attr(assigns.read_only),
      "data-required" => data_attr(assigns.required),
      "data-invalid" => data_attr(assigns.invalid),
      "data-outside-day-selectable" => data_attr(assigns.outside_day_selectable),
      "data-close-on-select" => data_attr(assigns.close_on_select),
      "data-min" => assigns.min,
      "data-max" => assigns.max,
      "data-focused-value" => assigns.focused_value,
      "data-num-of-months" => assigns.num_of_months,
      "data-start-of-week" => assigns.start_of_week,
      "data-fixed-weeks" => data_attr(assigns.fixed_weeks),
      "data-selection-mode" => assigns.selection_mode,
      "data-placeholder" => assigns.placeholder,
      "data-default-view" => assigns.default_view,
      "data-min-view" => assigns.min_view,
      "data-max-view" => assigns.max_view,
      "data-default-open" =>
        if assigns.default_open != nil do
          data_attr(assigns.default_open)
        else
          nil
        end,
      "data-inline" => data_attr(assigns.inline),
      "data-positioning" => encode_positioning(assigns.positioning),
      "data-dir" => assigns.dir,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-view-change" => assigns.on_view_change,
      "data-on-visible-range-change" => assigns.on_visible_range_change,
      "data-on-open-change" => assigns.on_open_change,
      "data-trigger-aria-label" => assigns.trigger_aria_label,
      "data-input-aria-label" => assigns.input_aria_label
    }
  end

  defp encode_positioning(nil), do: nil

  defp encode_positioning(positioning) when is_map(positioning) do
    Corex.Json.encode!(positioning)
  rescue
    _ -> nil
  end

  defp encode_positioning(_), do: nil

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else: base
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "label"
    }

    if assigns.changed,
      do: base,
      else: base
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "control"
    }

    if assigns.changed,
      do: base,
      else: base
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "input"
    }

    if assigns.changed,
      do: base,
      else: base
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "trigger"
    }

    if assigns.changed,
      do: base,
      else: base
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "positioner"
    }

    base =
      if initially_open?(assigns.default_open) do
        base
      else
        Map.put(base, "hidden", "true")
      end

    if assigns.changed,
      do: base,
      else: base
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    base = %{
      "data-scope" => "date-picker",
      "data-part" => "content"
    }

    base =
      if initially_open?(assigns.default_open) do
        base
      else
        Map.put(base, "hidden", "true")
      end

    if assigns.changed,
      do: base,
      else: base
  end

  defp initially_open?(true), do: true
  defp initially_open?(_), do: false
end
