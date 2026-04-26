defmodule Corex.Accordion.Connect do
  @moduledoc false
  alias Corex.Accordion.Anatomy.{Item, ItemContent, ItemIndicator, ItemTrigger, Props, Root}
  alias Corex.Animation.Height
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [validate_value!: 1, get_boolean: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base = %{
      "data-collapsible" => get_boolean(assigns.collapsible),
      "data-default-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.value), ",")
        end,
      "data-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.value), ",")
        else
          nil
        end,
      "data-controlled" => get_boolean(assigns.controlled),
      "data-multiple" => get_boolean(assigns.multiple),
      "data-orientation" => assigns.orientation,
      "data-dir" => assigns.dir,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-focus-change-client" => assigns.on_focus_change_client,
      "data-animation" => assigns.animation
    }

    if assigns.animation == "js" do
      Map.merge(base, Height.to_dataset(assigns.animation_options))
    else
      base
    end
  end

  # IDs match Zag's default scheme so the JS hook does not have to pass a
  # custom `ids` map. See @zag-js/accordion/dist/accordion.dom.mjs.

  defp root_id(id), do: "accordion:#{id}"
  defp item_id(id, value), do: "accordion:#{id}:item:#{value}"
  defp content_id(id, value), do: "accordion:#{id}:content:#{value}"
  defp trigger_id(id, value), do: "accordion:#{id}:trigger:#{value}"

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "accordion",
      "data-part" => "root",
      "dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "id" => root_id(assigns.id)
    }
  end

  @spec ignore_hook(String.t()) :: JS.t()
  def ignore_hook(id) when is_binary(id) do
    JS.ignore_attributes(["data-loading"], to: to_selector(id))
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(), to: to_selector(root_id(assigns.id)))
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    %{
      "data-scope" => "accordion",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-focus" => get_boolean(false),
      "data-orientation" => assigns.orientation,
      "dir" => assigns.dir,
      "data-state" => if(assigns.value in assigns.values, do: "open", else: "closed"),
      "id" => item_id(assigns.id, assigns.value)
    }
  end

  @spec ignore_item(Item.t()) :: JS.t()
  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: to_selector(item_id(assigns.id, assigns.value))
    )
  end

  @spec trigger(Item.t()) :: map()
  def trigger(assigns) do
    expanded = assigns.value in assigns.values

    %{
      "data-scope" => "accordion",
      "data-part" => "item-trigger",
      "type" => "button",
      "aria-expanded" => if(expanded, do: "true", else: "false"),
      "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
      "disabled" => assigns.disabled,
      "data-focus" => get_boolean(false),
      "data-orientation" => assigns.orientation,
      "dir" => assigns.dir,
      "data-state" => if(expanded, do: "open", else: "closed"),
      "id" => trigger_id(assigns.id, assigns.value),
      "data-controls" => content_id(assigns.id, assigns.value),
      "aria-controls" => content_id(assigns.id, assigns.value),
      "data-ownedby" => root_id(assigns.id)
    }
  end

  @spec ignore_trigger(Item.t()) :: JS.t()
  def ignore_trigger(assigns) do
    JS.ignore_attributes(ItemTrigger.ignored_attrs(),
      to: to_selector(trigger_id(assigns.id, assigns.value))
    )
  end

  @spec content(Item.t(), String.t()) :: map()
  def content(assigns, _animation \\ "instant") do
    expanded = assigns.value in assigns.values

    %{
      "data-scope" => "accordion",
      "data-part" => "item-content",
      "role" => "region",
      "data-state" => if(expanded, do: "open", else: "closed"),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-focus" => get_boolean(false),
      "data-orientation" => assigns.orientation,
      "dir" => assigns.dir,
      "aria-label" => "Accordion #{assigns.id} · #{assigns.value}",
      "hidden" => !expanded,
      "id" => content_id(assigns.id, assigns.value)
    }
  end

  @spec ignore_content(Item.t()) :: JS.t()
  def ignore_content(assigns) do
    JS.ignore_attributes(ItemContent.ignored_attrs(),
      to: to_selector(content_id(assigns.id, assigns.value))
    )
  end

  @spec indicator(Item.t()) :: map()
  def indicator(assigns) do
    expanded = assigns.value in assigns.values

    %{
      "data-scope" => "accordion",
      "data-part" => "item-indicator",
      "aria-hidden" => "true",
      "data-state" => if(expanded, do: "open", else: "closed"),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-focus" => get_boolean(false),
      "data-orientation" => assigns.orientation,
      "dir" => assigns.dir
    }
  end

  @spec ignore_indicator(Item.t()) :: JS.t()
  def ignore_indicator(assigns) do
    JS.ignore_attributes(ItemIndicator.ignored_attrs(),
      to: to_selector("accordion:#{assigns.id}:indicator:#{assigns.value}")
    )
  end

  defp to_selector(id) when is_binary(id) do
    "##{escape_css_identifier(id)}"
  end

  defp escape_css_identifier(id) when is_binary(id) do
    id
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn
      {ch, idx} when ch in ?a..?z or ch in ?A..?Z or ch in ?0..?9 or ch == ?- or ch == ?_ ->
        if idx == 0 and ch in ?0..?9 do
          ["\\", Integer.to_string(ch, 16), " "]
        else
          <<ch::utf8>>
        end

      {ch, _idx} ->
        ["\\", <<ch::utf8>>]
    end)
    |> IO.iodata_to_binary()
  end
end
