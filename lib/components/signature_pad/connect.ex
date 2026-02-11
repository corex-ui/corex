defmodule Corex.SignaturePad.Connect do
  @moduledoc false
  alias Corex.SignaturePad.Anatomy.{
    ClearTrigger,
    Control,
    Guide,
    HiddenInput,
    Label,
    Props,
    Root,
    Segment
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  defp encode_paths(paths) when is_binary(paths), do: paths
  defp encode_paths(paths) when is_list(paths), do: Corex.Json.encode!(paths)
  defp encode_paths(_), do: nil

  defp build_paths_attrs(controlled, paths) do
    cond do
      controlled && paths ->
        %{"data-paths" => encode_paths(paths), "data-default-paths" => nil}

      !controlled && paths ->
        %{"data-paths" => nil, "data-default-paths" => encode_paths(paths)}

      true ->
        %{"data-paths" => nil, "data-default-paths" => nil}
    end
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base_attrs = %{
      "id" => assigns.id,
      "data-controlled" => data_attr(assigns.controlled),
      "data-drawing-fill" => assigns.drawing_fill,
      "data-drawing-size" => Integer.to_string(assigns.drawing_size),
      "data-drawing-simulate-pressure" => data_attr(assigns.drawing_simulate_pressure),
      "data-dir" => assigns.dir,
      "data-on-draw-end" => assigns.on_draw_end,
      "data-on-draw-end-client" => assigns.on_draw_end_client
    }

    paths_attrs = build_paths_attrs(assigns.controlled, assigns.paths)

    base_attrs
    |> Map.merge(paths_attrs)
    |> maybe_put_name(assigns.name)
    |> maybe_put_drawing_option("data-drawing-smoothing", assigns.drawing_smoothing, &to_string/1)
    |> maybe_put_drawing_option("data-drawing-easing", assigns.drawing_easing, & &1)
    |> maybe_put_drawing_option("data-drawing-thinning", assigns.drawing_thinning, &to_string/1)
    |> maybe_put_drawing_option(
      "data-drawing-streamline",
      assigns.drawing_streamline,
      &to_string/1
    )
  end

  defp maybe_put_drawing_option(attrs, _key, nil, _fun), do: attrs

  defp maybe_put_drawing_option(attrs, key, value, fun) when value != nil,
    do: Map.put(attrs, key, fun.(value))

  defp maybe_put_name(attrs, nil), do: attrs
  defp maybe_put_name(attrs, name), do: Map.put(attrs, "data-name", name)

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

    base = if assigns.has_paths, do: base, else: Map.put(base, "hidden", "true")

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

    attrs = %{
      "type" => "hidden",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:hidden-input"
    }

    attrs =
      if assigns.name do
        Map.put(attrs, "name", assigns.name)
      else
        attrs
      end

    if assigns.changed,
      do: base,
      else: Map.merge(base, attrs)
  end
end
