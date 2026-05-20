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
  alias Corex.Positioning
  alias Corex.Selectors

  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [get_boolean: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-controlled" => get_boolean(assigns.controlled),
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
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-translation" => translation_json(assigns),
      "data-max-selected-dates" =>
        case assigns.max_selected_dates do
          n when is_integer(n) and n > 0 -> Integer.to_string(n)
          _ -> nil
        end
    }
    |> Map.merge(Corex.Positioning.to_dataset(assigns.positioning))
  end

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
      m -> Corex.Json.encode!(m)
    end)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}",
      "data-state" => "closed",
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}:label:0",
      "htmlFor" => "date-picker:#{assigns.id}:input:0",
      "data-state" => "closed"
    }
  end

  def ignore_label(%Label{} = assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}:label:0")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}:control"
    }
  end

  def ignore_control(%Control{} = assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}:control")
    )
  end

  @spec input(Input.t() | map()) :: map()
  def input(assigns) do
    i = input_index(assigns)

    %{
      "data-scope" => "date-picker",
      "data-part" => "input",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}:input:#{i}"
    }
  end

  def ignore_input(%Input{} = assigns) do
    i = input_index(assigns)

    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}:input:#{i}")
    )
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
      "id" => "date-picker:#{assigns.id}:trigger"
    }
  end

  def ignore_trigger(%Trigger{} = assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}:trigger")
    )
  end

  @spec positioner(Positioner.t() | map()) :: map()
  def positioner(assigns) do
    positioning = positioner_positioning(assigns)

    %{
      "data-scope" => "date-picker",
      "data-part" => "positioner",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}:positioner",
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
      to: Selectors.css_id("date-picker:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "content",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}:content",
      "hidden" => true,
      "data-state" => "closed"
    }
  end

  def ignore_content(%Content{} = assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}:content")
    )
  end

  defp nav_id(id, view, part) do
    "date-picker:#{id}:view:#{view}:#{part}"
  end

  @spec view_prev(%{id: String.t(), view: String.t(), dir: String.t()}) :: map()
  def view_prev(%{id: id, view: view, dir: dir}) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "prev-trigger",
      "type" => "button",
      "dir" => dir,
      "id" => nav_id(id, view, "prev")
    }
  end

  def ignore_view_prev(%{id: id, view: view}) do
    JS.ignore_attributes(ViewNav.ignored_attrs(),
      to: Selectors.css_id(nav_id(id, view, "prev"))
    )
  end

  @spec view_next(%{id: String.t(), view: String.t(), dir: String.t()}) :: map()
  def view_next(%{id: id, view: view, dir: dir}) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "next-trigger",
      "type" => "button",
      "dir" => dir,
      "id" => nav_id(id, view, "next")
    }
  end

  def ignore_view_next(%{id: id, view: view}) do
    JS.ignore_attributes(ViewNav.ignored_attrs(),
      to: Selectors.css_id(nav_id(id, view, "next"))
    )
  end

  @spec view_trigger(%{id: String.t(), view: String.t(), dir: String.t()}) :: map()
  def view_trigger(%{id: id, view: view, dir: dir}) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "view-trigger",
      "type" => "button",
      "dir" => dir,
      "id" => nav_id(id, view, "view-trigger")
    }
  end

  def ignore_view_trigger(%{id: id, view: view}) do
    JS.ignore_attributes(ViewNav.ignored_attrs(),
      to: Selectors.css_id(nav_id(id, view, "view-trigger"))
    )
  end

  @spec decade(Decade.t()) :: map()
  def decade(assigns) do
    %{
      "data-scope" => "date-picker",
      "data-part" => "decade",
      "dir" => assigns.dir,
      "id" => "date-picker:#{assigns.id}:decade"
    }
  end

  def ignore_decade(%Decade{} = assigns) do
    JS.ignore_attributes(Decade.ignored_attrs(),
      to: Selectors.css_id("date-picker:#{assigns.id}:decade")
    )
  end

  defp error_dom_id(id, index), do: "date-picker:#{id}:error:#{index}"

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
