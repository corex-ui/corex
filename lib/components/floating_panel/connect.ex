defmodule Corex.FloatingPanel.Connect do
  @moduledoc false
  alias Corex.FloatingPanel.Anatomy.{
    Props,
    Root,
    Trigger,
    Positioner,
    Content,
    Title,
    Header,
    Body,
    DragTrigger,
    ResizeTrigger,
    CloseTrigger,
    Control,
    StageTrigger
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  defp encode_size(nil), do: nil
  defp encode_size(%{width: w, height: h}) when is_number(w) and is_number(h), do: Corex.Json.encode!(%{width: w, height: h})
  defp encode_size(_), do: nil

  defp encode_point(nil), do: nil
  defp encode_point(%{x: x, y: y}) when is_number(x) and is_number(y), do: Corex.Json.encode!(%{x: x, y: y})
  defp encode_point(_), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-open" => data_attr(assigns.open),
      "data-default-open" => data_attr(assigns.default_open),
      "data-controlled" => data_attr(assigns.controlled),
      "data-draggable" => data_attr(assigns.draggable),
      "data-resizable" => data_attr(assigns.resizable),
      "data-allow-overflow" => data_attr(assigns.allow_overflow),
      "data-close-on-escape" => data_attr(assigns.close_on_escape),
      "data-disabled" => data_attr(assigns.disabled),
      "data-dir" => assigns.dir,
      "data-size" => encode_size(assigns.size),
      "data-default-size" => encode_size(assigns.default_size),
      "data-position" => encode_point(assigns.position),
      "data-default-position" => encode_point(assigns.default_position),
      "data-min-size" => encode_size(assigns.min_size),
      "data-max-size" => encode_size(assigns.max_size),
      "data-persist-rect" => data_attr(assigns.persist_rect),
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
      "dir" => assigns.dir,
      "id" => "floating-panel:#{assigns.id}"
    }
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "trigger",
      "type" => "button",
      "id" => "floating-panel:#{assigns.id}:trigger"
    }
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "positioner",
      "id" => "floating-panel:#{assigns.id}:positioner"
    }
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "content",
      "id" => "floating-panel:#{assigns.id}:content"
    }
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "title",
      "id" => "floating-panel:#{assigns.id}:title"
    }
  end

  @spec header(Header.t()) :: map()
  def header(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "header",
      "id" => "floating-panel:#{assigns.id}:header"
    }
  end

  @spec body(Body.t()) :: map()
  def body(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "body",
      "id" => "floating-panel:#{assigns.id}:body"
    }
  end

  @spec drag_trigger(DragTrigger.t()) :: map()
  def drag_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "drag-trigger",
      "id" => "floating-panel:#{assigns.id}:drag-trigger"
    }
  end

  @spec resize_trigger(ResizeTrigger.t()) :: map()
  def resize_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "resize-trigger",
      "data-axis" => assigns.axis,
      "id" => "floating-panel:#{assigns.id}:resize:#{assigns.axis}"
    }
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "close-trigger",
      "type" => "button",
      "id" => "floating-panel:#{assigns.id}:close"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "control",
      "id" => "floating-panel:#{assigns.id}:control"
    }
  end

  @spec stage_trigger(StageTrigger.t()) :: map()
  def stage_trigger(assigns) do
    %{
      "data-scope" => "floating-panel",
      "data-part" => "stage-trigger",
      "data-stage" => assigns.stage,
      "type" => "button",
      "id" => "floating-panel:#{assigns.id}:stage:#{assigns.stage}"
    }
  end
end
