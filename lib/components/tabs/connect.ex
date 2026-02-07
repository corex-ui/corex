defmodule Corex.Tabs.Connect do
  @moduledoc false
  alias Corex.Tabs.Anatomy.{Props, Root, List, Trigger, Content}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
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
      "data-disabled" => data_attr(assigns.disabled),
      "data-controlled" => data_attr(assigns.controlled),
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-focus-change-client" => assigns.on_focus_change_client,
      "data-dir" => assigns.dir
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "tabs",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "data-orientation" => assigns.orientation,
          "id" => "tabs:#{assigns.id}"
        })
  end

  @spec list(List.t()) :: map()
  def list(assigns) do
    base = %{
      "data-scope" => "tabs",
      "data-part" => "list"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "role" => "tablist",
          "dir" => assigns.dir,
          "data-orientation" => assigns.orientation,
          "id" => "tabs:#{assigns.id}:list"
        })
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    expanded = assigns.value in assigns.values

    base = %{
      "data-scope" => "tabs",
      "data-part" => "trigger"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "button",
          "tabindex" => if(assigns.disabled, do: -1, else: 0),
          "aria-expanded" => if(expanded, do: "true", else: "false"),
          "aria-selected" => if(expanded, do: "true", else: "false"),
          "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
          "data-disabled" => assigns.disabled,
          "data-selected" => data_attr(expanded),
          "disabled" => assigns.disabled,
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir,
          "id" => "tabs:#{assigns.id}:trigger:#{assigns.value}",
          "data-controls" => "tabs:#{assigns.id}:content:#{assigns.value}",
          "aria-controls" => "tabs:#{assigns.id}:content:#{assigns.value}",
          "data-ownedby" => "tabs:#{assigns.id}",
          "role" => "tab"
        })
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    expanded = assigns.value in assigns.values
    data_state = if expanded, do: "open", else: "closed"

    base = %{
      "data-scope" => "tabs",
      "data-part" => "content"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "role" => "region",
          "data-state" => data_state,
          "data-disabled" => assigns.disabled,
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir,
          "aria-labelledby" => "tabs:#{assigns.id}:trigger:#{assigns.value}",
          "hidden" => !expanded,
          "id" => "tabs:#{assigns.id}:content:#{assigns.value}"
        })
  end
end
