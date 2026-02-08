defmodule Corex.SignaturePad.Connect do
  @moduledoc false
  alias Corex.SignaturePad.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    Segment,
    Guide,
    ClearTrigger,
    HiddenInput
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-drawing-fill" => assigns.drawing_fill,
      "data-drawing-size" => Integer.to_string(assigns.drawing_size),
      "data-drawing-simulate-pressure" => data_attr(assigns.drawing_simulate_pressure),
      "data-dir" => assigns.dir,
      "data-on-draw-end" => assigns.on_draw_end,
      "data-on-draw-end-client" => assigns.on_draw_end_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}"
        })
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "label"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}:label"
        })
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "control"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}:control"
        })
  end

  @spec segment(Segment.t()) :: map()
  def segment(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "segment"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}:segment"
        })
  end

  @spec guide(Guide.t()) :: map()
  def guide(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "guide"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}:guide"
        })
  end

  @spec clear_trigger(ClearTrigger.t()) :: map()
  def clear_trigger(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "clear-trigger"
    }

    aria_label = assigns.aria_label || "Clear signature"

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "button",
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}:clear-trigger",
          "aria-label" => aria_label
        })
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "hidden-input"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "hidden",
          "dir" => assigns.dir,
          "id" => "signature-pad:#{assigns.id}:hidden-input"
        })
  end
end
