defmodule Corex.Collapsible.Connect do
  @moduledoc false
  alias Corex.Collapsible.Anatomy.{Props, Root, Trigger, Content}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-open" => data_default_open(assigns),
      "data-open" => data_open(assigns),
      "data-controlled" => data_attr(assigns.controlled),
      "data-disabled" => data_attr(assigns.disabled),
      "data-dir" => assigns.dir,
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    base = %{
      "data-scope" => "collapsible",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "collapsible:#{assigns.id}",
          "data-state" => data_state
        })
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    base = %{
      "data-scope" => "collapsible",
      "data-part" => "trigger"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "button",
          "tabindex" => if(assigns.disabled, do: -1, else: 0),
          "aria-expanded" => if(assigns.open, do: "true", else: "false"),
          "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
          "data-disabled" => assigns.disabled,
          "disabled" => assigns.disabled,
          "dir" => assigns.dir,
          "data-state" => data_state,
          "id" => "collapsible:#{assigns.id}:trigger",
          "data-controls" => "collapsible:#{assigns.id}:content",
          "aria-controls" => "collapsible:#{assigns.id}:content"
        })
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    base = %{
      "data-scope" => "collapsible",
      "data-part" => "content"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "data-state" => data_state,
          "data-disabled" => assigns.disabled,
          "dir" => assigns.dir,
          "aria-labelledby" => "collapsible:#{assigns.id}:trigger",
          "hidden" => !assigns.open,
          "id" => "collapsible:#{assigns.id}:content"
        })
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
