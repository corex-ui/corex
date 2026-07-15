defmodule Corex.DatePicker.Connect do
  @moduledoc false
  alias Corex.DatePicker.Anatomy.{
    Content,
    Control,
    Decade,
    Error,
    Input,
    Label,
    Positioner,
    Props,
    Root,
    Trigger,
    ViewNav
  }

  alias Corex.DatePicker.Translation, as: DatePickerTranslation
  alias Corex.FormField
  alias Corex.Positioning
  alias Corex.Selectors

  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [get_boolean: 1]

  defp zag_root_id(id), do: "datepicker:#{id}"
  defp zag_label_id(id, index \\ 0), do: "datepicker:#{id}:label:#{index}"
  defp zag_control_id(id), do: "datepicker:#{id}:control"
  defp zag_input_id(id, index), do: "datepicker:#{id}:input:#{index}"
  defp zag_trigger_id(id), do: "datepicker:#{id}:trigger"
  defp zag_positioner_id(id), do: "datepicker:#{id}:positioner"
  defp zag_content_id(id), do: "datepicker:#{id}:content"
  defp zag_prev_id(id, view), do: "datepicker:#{id}:prev:#{view}"
  defp zag_next_id(id, view), do: "datepicker:#{id}:next:#{view}"
  defp zag_view_trigger_id(id, view), do: "datepicker:#{id}:view:#{view}"

  @spec props(Props.t()) :: map()
  def props(assigns) do
    default_raw = default_value_for_props(assigns)
    default_attr = FormField.default_value_dataset(assigns, default_raw)

    %{
      "id" => assigns.id,
      "data-default-value" => default_attr,
      "data-value" => nil,
      "data-locale" => assigns.locale,
      "data-time-zone" => assigns.time_zone,
      "data-name" => assigns.name,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-outside-day-selectable" => get_boolean(assigns.outside_day_selectable),
      "data-close-on-select" => get_boolean(assigns.close_on_select),
      "data-min" => assigns.min,
      "data-max" => assigns.max,
      "data-focused-value" => assigns.focused_value,
      "data-start-of-week" => assigns.start_of_week,
      "data-fixed-weeks" => get_boolean(assigns.fixed_weeks),
      "data-selection-mode" => assigns.selection_mode,
      "data-placeholder" => assigns.placeholder,
      "data-default-view" => assigns.view,
      "data-min-view" => assigns.min_view,
      "data-max-view" => assigns.max_view,
      "data-dir" => assigns.dir,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-view-change" => assigns.on_view_change,
      "data-on-visible-range-change" => assigns.on_visible_range_change,
      "data-on-open-change" => assigns.on_open_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-focus-change-client" => assigns.on_focus_change_client,
      "data-on-view-change-client" => assigns.on_view_change_client,
      "data-on-visible-range-change-client" => assigns.on_visible_range_change_client,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-translation" => translation_json(assigns),
      "data-max-selected-dates" =>
        case assigns.max_selected_dates do
          n when is_integer(n) and n > 0 -> Integer.to_string(n)
          _ -> nil
        end
    }
    |> Map.merge(Corex.Positioning.to_dataset(assigns.positioning))
    |> maybe_put_submit_name(Map.get(assigns, :submit_name))
    |> FormField.put_form_field_attrs(assigns)
  end

  defp default_value_for_props(assigns) do
    array_mode = assigns.selection_mode in ["multiple", "range"]

    if array_mode do
      assigns.value
      |> iso_values_from_assigns()
      |> Corex.ValueBinding.encode_list()
    else
      assigns.value
    end
  end

  defp iso_values_from_assigns(nil), do: []

  defp iso_values_from_assigns(value) when is_list(value), do: Enum.map(value, &to_string/1)

  defp iso_values_from_assigns(value) when is_binary(value) do
    case Corex.Json.decode(value) do
      {:ok, list} when is_list(list) ->
        Enum.map(list, &to_string/1)

      _ ->
        value
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
    end
  end

  defp iso_values_from_assigns(_), do: []

  defp maybe_put_submit_name(attrs, nil), do: attrs
  defp maybe_put_submit_name(attrs, name), do: Map.put(attrs, "data-submit-name", name)

  defp translation_json(assigns) do
    case Map.get(assigns, :translation) do
      %DatePickerTranslation{} = t ->
        encode_translation_to_json(t)

      _ ->
        nil
    end
  end

  defp encode_translation_to_json(%DatePickerTranslation{} = t) do
    t
    |> DatePickerTranslation.to_camel_map()
    |> Enum.reject(fn {_, v} -> v in [nil, ""] end)
    |> Map.new()
    |> then(fn
      m when map_size(m) == 0 -> nil
      m -> Corex.Dataset.encode_json(m)
    end)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => zag_root_id(assigns.id),
      "data-state" => "closed",
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id(zag_root_id(assigns.id))
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => zag_label_id(assigns.id),
      "htmlFor" => zag_input_id(assigns.id, 0),
      "data-state" => "closed"
    }
  end

  def ignore_label(%Label{} = assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id(zag_label_id(assigns.id))
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => zag_control_id(assigns.id)
    }
  end

  def ignore_control(%Control{} = assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id(zag_control_id(assigns.id))
    )
  end

  @spec input(Input.t() | map()) :: map()
  def input(assigns) do
    i = input_index(assigns)

    %{
      "data-scope" => "date-picker",
      "data-part" => "input",
      "dir" => assigns.dir,
      "id" => zag_input_id(assigns.id, i)
    }
  end

  def ignore_input(%Input{} = assigns) do
    i = input_index(assigns)

    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id(zag_input_id(assigns.id, i))
    )
  end

  @spec ignore_value_input(String.t()) :: Phoenix.LiveView.JS.t()
  def ignore_value_input(id) when is_binary(id) do
    JS.ignore_attributes(["value"], to: Selectors.css_id("#{id}-value"))
  end

  defp input_index(assigns) do
    Map.get(assigns, :index) || 0
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "trigger",
      "dir" => assigns.dir,
      "id" => zag_trigger_id(assigns.id)
    }
  end

  def ignore_trigger(%Trigger{} = assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id(zag_trigger_id(assigns.id))
    )
  end

  @spec positioner(Positioner.t() | map()) :: map()
  def positioner(assigns) do
    positioning = positioner_positioning(assigns)

    %{
      "data-scope" => "date-picker",
      "data-part" => "positioner",
      "dir" => assigns.dir,
      "id" => zag_positioner_id(assigns.id),
      "style" => positioner_initial_floating_style(positioning)
    }
  end

  defp positioner_positioning(%Positioner{positioning: p}) when not is_nil(p), do: p
  defp positioner_positioning(%Positioner{positioning: nil}), do: %Positioning{}
  defp positioner_positioning(m) when is_map(m), do: Map.get(m, :positioning) || %Positioning{}

  defp positioner_initial_floating_style(%Positioning{} = p) do
    parts =
      [
        "position: #{p.strategy}",
        "isolation: isolate",
        "top: 0px",
        "left: 0px",
        "transform: translate3d(0, -100vh, 0)",
        "pointer-events: none",
        "z-index: var(--z-index)"
      ]
      |> then(fn acc ->
        if p.same_width do
          acc ++ ["width: var(--reference-width)"]
        else
          acc ++ ["min-width: max-content"]
        end
      end)
      |> then(fn acc ->
        if p.fit_viewport do
          acc ++ ["max-width: var(--available-width)", "max-height: var(--available-height)"]
        else
          acc
        end
      end)

    Enum.join(parts, "; ") <> ";"
  end

  def ignore_positioner(%Positioner{} = assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id(zag_positioner_id(assigns.id))
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "content",
      "dir" => assigns.dir,
      "id" => zag_content_id(assigns.id),
      "hidden" => true,
      "data-state" => "closed"
    }
  end

  def ignore_content(%Content{} = assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id(zag_content_id(assigns.id))
    )
  end

  @spec view_prev(%{id: String.t(), view: String.t(), dir: String.t()}) :: map()
  def view_prev(%{id: id, view: view, dir: dir}) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "prev-trigger",
      "type" => "button",
      "dir" => dir,
      "id" => zag_prev_id(id, view)
    }
  end

  def ignore_view_prev(%{id: id, view: view}) do
    JS.ignore_attributes(ViewNav.ignored_attrs(),
      to: Selectors.css_id(zag_prev_id(id, view))
    )
  end

  @spec view_next(%{id: String.t(), view: String.t(), dir: String.t()}) :: map()
  def view_next(%{id: id, view: view, dir: dir}) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "next-trigger",
      "type" => "button",
      "dir" => dir,
      "id" => zag_next_id(id, view)
    }
  end

  def ignore_view_next(%{id: id, view: view}) do
    JS.ignore_attributes(ViewNav.ignored_attrs(),
      to: Selectors.css_id(zag_next_id(id, view))
    )
  end

  @spec view_trigger(%{id: String.t(), view: String.t(), dir: String.t()}) :: map()
  def view_trigger(%{id: id, view: view, dir: dir}) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "view-trigger",
      "type" => "button",
      "dir" => dir,
      "id" => zag_view_trigger_id(id, view)
    }
  end

  def ignore_view_trigger(%{id: id, view: view}) do
    JS.ignore_attributes(ViewNav.ignored_attrs(),
      to: Selectors.css_id(zag_view_trigger_id(id, view))
    )
  end

  @spec decade(Decade.t()) :: map()
  def decade(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "decade",
      "dir" => assigns.dir,
      "id" => "datepicker:#{assigns.id}:decade"
    }
  end

  def ignore_decade(%Decade{} = assigns) do
    JS.ignore_attributes(Decade.ignored_attrs(),
      to: Selectors.css_id("datepicker:#{assigns.id}:decade")
    )
  end

  defp error_dom_id(id, index), do: "datepicker:#{id}:error:#{index}"

  @spec error(Error.t()) :: map()
  def error(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "error",
      "id" => error_dom_id(assigns.id, assigns.index)
    }
  end

  def ignore_error(%Error{} = assigns) do
    JS.ignore_attributes(Error.ignored_attrs(),
      to: Selectors.css_id(error_dom_id(assigns.id, assigns.index))
    )
  end
end
