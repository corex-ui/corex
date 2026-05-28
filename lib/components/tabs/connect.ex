defmodule Corex.Tabs.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Tabs.Anatomy.{Content, Indicator, List, Props, Root, Trigger}

  alias Phoenix.LiveView.JS

  import Corex.Helpers,
    only: [get_boolean: 1, maybe_put_data_dir: 2, maybe_put_dir: 2]

  defp root_id(id), do: "tabs-#{id}-root"
  defp list_id(id), do: "tabs-#{id}-list"
  defp trigger_id(id, value), do: "tabs-#{id}-trigger-#{value}"
  defp content_id(id, value), do: "tabs-#{id}-content-#{value}"
  defp indicator_id(id), do: "tabs-#{id}-indicator"

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
      "data-controlled" => get_boolean(assigns.controlled),
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-focus-change-client" => assigns.on_focus_change_client
    }
    |> maybe_put_data_dir(assigns.dir)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "tabs",
      "data-part" => "root",
      "data-orientation" => assigns.orientation,
      "id" => root_id(assigns.id)
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(), to: Selectors.css_id(root_id(assigns.id)))
  end

  @spec list(List.t()) :: map()
  def list(assigns) do
    %{
      "data-scope" => "tabs",
      "data-part" => "list",
      "role" => "tablist",
      "data-orientation" => assigns.orientation,
      "id" => list_id(assigns.id)
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_list(%List{} = assigns) do
    JS.ignore_attributes(List.ignored_attrs(),
      to: Selectors.css_id(list_id(assigns.id))
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    expanded = assigns.value in assigns.values

    %{
      "data-scope" => "tabs",
      "data-part" => "trigger",
      "data-value" => assigns.value,
      "type" => "button",
      "tabindex" => if(assigns.disabled, do: -1, else: 0),
      "aria-expanded" => if(expanded, do: "true", else: "false"),
      "aria-selected" => if(expanded, do: "true", else: "false"),
      "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
      "data-disabled" => assigns.disabled,
      "data-selected" => get_boolean(expanded),
      "disabled" => assigns.disabled,
      "data-orientation" => assigns.orientation,
      "id" => trigger_id(assigns.id, assigns.value),
      "data-controls" => content_id(assigns.id, assigns.value),
      "aria-controls" => content_id(assigns.id, assigns.value),
      "data-ownedby" => list_id(assigns.id),
      "role" => "tab"
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_trigger(%Trigger{} = assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id(trigger_id(assigns.id, assigns.value))
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    data_state = if assigns.values != [], do: "open", else: "closed"

    %{
      "data-scope" => "tabs",
      "data-part" => "item-indicator",
      "aria-hidden" => true,
      "data-state" => data_state,
      "data-disabled" => false,
      "data-orientation" => assigns.orientation,
      "id" => indicator_id(assigns.id)
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_indicator(%Indicator{} = assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id(indicator_id(assigns.id))
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    expanded = assigns.value in assigns.values
    data_state = if expanded, do: "open", else: "closed"

    %{
      "data-scope" => "tabs",
      "data-part" => "content",
      "role" => "tabpanel",
      "data-value" => assigns.value,
      "data-state" => data_state,
      "data-disabled" => assigns.disabled,
      "data-orientation" => assigns.orientation,
      "aria-labelledby" => trigger_id(assigns.id, assigns.value),
      "hidden" => !expanded,
      "id" => content_id(assigns.id, assigns.value)
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_content(%Content{} = assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id(content_id(assigns.id, assigns.value))
    )
  end
end
