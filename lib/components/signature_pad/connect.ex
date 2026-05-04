defmodule Corex.SignaturePad.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.SignaturePad.Anatomy.{
    ClearTrigger,
    Control,
    Error,
    Guide,
    HiddenInput,
    Label,
    Path,
    Props,
    Root,
    Segment
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  defp encode_paths([]), do: nil
  defp encode_paths(nil), do: nil

  defp encode_paths(paths) when is_binary(paths) do
    if path_lines_for_connect(paths) == [] do
      nil
    else
      paths
    end
  end

  defp encode_paths(paths) when is_list(paths) do
    case Enum.filter(paths, &is_binary/1) do
      [] -> nil
      lines -> Enum.join(lines, "\n")
    end
  end

  defp encode_paths(_), do: nil

  defp path_lines_for_connect(s) when is_binary(s) do
    s
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp default_paths_attr(paths) do
    case paths do
      nil -> %{"data-default-paths" => nil}
      p -> %{"data-default-paths" => encode_paths(p)}
    end
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base_attrs = %{
      "id" => assigns.id,
      "data-drawing-fill" => assigns.drawing_fill,
      "data-drawing-size" => Integer.to_string(assigns.drawing_size),
      "data-drawing-simulate-pressure" => get_boolean(assigns.drawing_simulate_pressure),
      "data-dir" => assigns.dir,
      "data-on-draw-end" => assigns.on_draw_end,
      "data-on-draw-end-client" => assigns.on_draw_end_client
    }

    paths_attrs = default_paths_attr(assigns.paths)

    smooth = assigns.drawing_smoothing
    thin = if(assigns.drawing_thinning != nil, do: assigns.drawing_thinning, else: 0.7)
    stream = assigns.drawing_streamline

    base_attrs
    |> Map.merge(paths_attrs)
    |> maybe_put_name(assigns.name)
    |> Map.put("data-drawing-smoothing", to_string(smooth))
    |> Map.put("data-drawing-thinning", to_string(thin))
    |> Map.put("data-drawing-streamline", to_string(stream))
    |> maybe_put_drawing_easing(assigns.drawing_easing)
  end

  defp maybe_put_drawing_easing(attrs, nil), do: attrs

  defp maybe_put_drawing_easing(attrs, value) when is_binary(value),
    do: Map.put(attrs, "data-drawing-easing", value)

  defp maybe_put_name(attrs, nil), do: attrs
  defp maybe_put_name(attrs, name), do: Map.put(attrs, "data-name", name)

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}"
    }
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:label"
    }
  end

  def ignore_label(%Label{} = assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:label")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:control"
    }
  end

  def ignore_control(%Control{} = assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:control")
    )
  end

  @spec segment(Segment.t()) :: map()
  def segment(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "segment",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:segment"
    }
  end

  def ignore_segment(%Segment{} = assigns) do
    JS.ignore_attributes(Segment.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:segment")
    )
  end

  @spec path(Path.t()) :: map()
  def path(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "path",
      "id" => "signature-pad:#{assigns.id}:path:#{assigns.index}"
    }
  end

  def ignore_path(%Path{} = assigns) do
    JS.ignore_attributes(Path.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:path:#{assigns.index}")
    )
  end

  @spec guide(Guide.t()) :: map()
  def guide(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "guide",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:guide"
    }
  end

  def ignore_guide(%Guide{} = assigns) do
    JS.ignore_attributes(Guide.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:guide")
    )
  end

  @spec clear_trigger(ClearTrigger.t()) :: map()
  def clear_trigger(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "clear-trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:clear-trigger",
      "aria-label" => assigns.aria_label || "Clear signature"
    }

    if assigns.has_paths do
      base
    else
      Map.put(base, "hidden", "true")
    end
  end

  def ignore_clear_trigger(%ClearTrigger{} = assigns) do
    JS.ignore_attributes(ClearTrigger.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:clear-trigger")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    base = %{
      "data-scope" => "signature-pad",
      "data-part" => "hidden-input",
      "type" => "text",
      "dir" => assigns.dir,
      "id" => "signature-pad:#{assigns.id}:hidden-input",
      "hidden" => "true",
      "readonly" => "true",
      "autocomplete" => "off",
      "tabindex" => "-1",
      "aria-hidden" => "true"
    }

    base
    |> maybe_put_input_name(Map.get(assigns, :name))
    |> maybe_put_input_form(Map.get(assigns, :form))
  end

  defp maybe_put_input_name(attrs, nil), do: attrs
  defp maybe_put_input_name(attrs, name), do: Map.put(attrs, "name", name)

  defp maybe_put_input_form(attrs, nil), do: attrs
  defp maybe_put_input_form(attrs, form), do: Map.put(attrs, "form", form)

  def ignore_hidden_input(%HiddenInput{} = assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:hidden-input")
    )
  end

  @spec error(Error.t()) :: map()
  def error(assigns) do
    %{
      "data-scope" => "signature-pad",
      "data-part" => "error",
      "id" => "signature-pad:#{assigns.id}:error:#{assigns.index}"
    }
  end

  def ignore_error(%Error{} = assigns) do
    JS.ignore_attributes(Error.ignored_attrs(),
      to: Selectors.css_id("signature-pad:#{assigns.id}:error:#{assigns.index}")
    )
  end
end
