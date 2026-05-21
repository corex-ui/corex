defmodule Corex.FloatingPanel.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.FloatingPanel.Anatomy.{
    Body,
    CloseTrigger,
    Content,
    Control,
    DragTrigger,
    Header,
    Positioner,
    Props,
    ResizeTrigger,
    Root,
    StageTrigger,
    Title,
    Trigger
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  defp encode_size(nil), do: nil

  defp encode_size(%{width: w, height: h}) when is_number(w) and is_number(h),
    do: Corex.Dataset.encode_json(%{width: w, height: h})

  defp encode_size(_), do: nil

  defp encode_point(point) do
    case Corex.Point.to_map(point) do
      nil -> nil
      map -> Corex.Dataset.encode_json(map)
    end
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "data-draggable" => get_boolean(assigns.draggable),
      "data-resizable" => get_boolean(assigns.resizable),
      "data-allow-overflow" => get_boolean(assigns.allow_overflow),
      "data-close-on-escape" => get_boolean(assigns.close_on_escape),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "data-size" => encode_size(assigns.size),
      "data-default-size" => encode_size(assigns.default_size),
      "data-default-position" => encode_point(assigns.default_position),
      "data-min-size" => encode_size(assigns.min_size),
      "data-max-size" => encode_size(assigns.max_size),
      "data-persist-rect" => get_boolean(assigns.persist_rect),
      "data-grid-size" => to_string(assigns.grid_size),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-on-position-change" => assigns.on_position_change,
      "data-on-size-change" => assigns.on_size_change,
      "data-on-stage-change" => assigns.on_stage_change
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    base = %{
      "data-scope" => "floating-panel",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:trigger"
    }

    Map.put(base, "data-state", "closed")
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:trigger")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:positioner"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    base = %{
      "data-scope" => "floating-panel",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:content"
    }

    Map.merge(base, %{"data-state" => "closed", "hidden" => ""})
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:content")
    )
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "title",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:title"
    }
  end

  def ignore_title(assigns) do
    JS.ignore_attributes(Title.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:title")
    )
  end

  @spec header(Header.t()) :: map()
  def header(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "header",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:header"
    }
  end

  def ignore_header(assigns) do
    JS.ignore_attributes(Header.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:header")
    )
  end

  @spec body(Body.t()) :: map()
  def body(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "body",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:body"
    }
  end

  def ignore_body(assigns) do
    JS.ignore_attributes(Body.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:body")
    )
  end

  @spec drag_trigger(DragTrigger.t()) :: map()
  def drag_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "drag-trigger",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:drag-trigger"
    }
  end

  def ignore_drag_trigger(assigns) do
    JS.ignore_attributes(DragTrigger.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:drag-trigger")
    )
  end

  @spec resize_trigger(ResizeTrigger.t()) :: map()
  def resize_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "resize-trigger",
      "data-axis" => assigns.axis,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:resize:#{assigns.axis}"
    }
  end

  def ignore_resize_trigger(assigns) do
    JS.ignore_attributes(ResizeTrigger.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:resize:#{assigns.axis}")
    )
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "close-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:close"
    }
  end

  def ignore_close_trigger(assigns) do
    JS.ignore_attributes(CloseTrigger.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:close")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "control",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:control"
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:control")
    )
  end

  @spec stage_trigger(StageTrigger.t()) :: map()
  def stage_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "stage-trigger",
      "data-stage" => assigns.stage,
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "floating-panel:#{assigns.id}:stage:#{assigns.stage}"
    }
  end

  def ignore_stage_trigger(assigns) do
    JS.ignore_attributes(StageTrigger.ignored_attrs(),
      to: Selectors.css_id("floating-panel:#{assigns.id}:stage:#{assigns.stage}")
    )
  end
end
