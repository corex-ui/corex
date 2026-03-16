defmodule Corex.Tooltip.Connect do
  @moduledoc false
  alias Corex.Tooltip.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base = %{
      "id" => assigns.id,
      "data-default-open" => data_default_open(assigns),
      "data-open" => data_open(assigns),
      "data-controlled" => data_attr(assigns.controlled),
      "data-disabled" => data_attr(assigns.disabled),
      "data-dir" => assigns.dir,
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-close-on-escape" => data_attr(assigns.close_on_escape),
      "data-close-on-click" => data_attr(assigns.close_on_click),
      "data-close-on-pointer-down" => data_attr(assigns.close_on_pointer_down),
      "data-close-on-scroll" => data_attr(assigns.close_on_scroll),
      "data-interactive" => data_attr(assigns.interactive)
    }

    base
    |> maybe_put("data-open-delay", assigns.open_delay)
    |> maybe_put("data-close-delay", assigns.close_delay)
    |> maybe_put("data-placement", assigns.placement)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    %{
      "data-scope" => "tooltip",
      "data-part" => "trigger",
      "tabindex" => if(assigns.disabled, do: -1, else: 0),
      "data-disabled" => assigns.disabled,
      "dir" => assigns.dir,
      "data-state" => data_state,
      "id" => "tooltip:#{assigns.id}:trigger"
    }
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "tooltip",
      "data-part" => "positioner",
      "dir" => assigns.dir,
      "id" => "tooltip:#{assigns.id}:positioner"
    }
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    %{
      "data-scope" => "tooltip",
      "data-part" => "content",
      "dir" => assigns.dir,
      "data-state" => data_state,
      "id" => "tooltip:#{assigns.id}:content"
    }
  end

  @spec arrow(Arrow.t()) :: map()
  def arrow(assigns) do
    %{
      "data-scope" => "tooltip",
      "data-part" => "arrow",
      "dir" => assigns.dir,
      "id" => "tooltip:#{assigns.id}:arrow"
    }
  end

  @spec arrow_tip(ArrowTip.t()) :: map()
  def arrow_tip(assigns) do
    %{
      "data-scope" => "tooltip",
      "data-part" => "arrow-tip",
      "dir" => assigns.dir
    }
  end

  defp data_default_open(assigns) do
    if !assigns.controlled && assigns.open, do: "", else: nil
  end

  defp data_open(assigns) do
    if assigns.controlled do
      if assigns.open, do: "", else: nil
    else
      nil
    end
  end
end
