defmodule Corex.Accordion.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, [:connect, :api]

  alias Corex.Accordion.Anatomy.{Item, ItemContent, ItemIndicator, ItemTrigger, Props, Root}

  alias Corex.Animation.Height

  alias Corex.Selectors

  alias Phoenix.LiveView.JS

  alias Corex.ValueBinding

  @spec props(Props.t()) :: map()
  def props(assigns) do
    vlist = (assigns.value || []) |> coerce_string_list()
    {value_str, default_value_str} = ValueBinding.list_pair(vlist, assigns.controlled)

    base = %{
      "data-collapsible" => presence_attr(assigns.collapsible),
      "data-default-value" => default_value_str,
      "data-value" => value_str,
      "data-controlled" => presence_attr(assigns.controlled),
      "data-multiple" => presence_attr(assigns.multiple),
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-focus-change-client" => assigns.on_focus_change_client,
      "data-animation" => assigns.animation
    }

    merged =
      if assigns.animation == "js" do
        Map.merge(base, Height.to_dataset(assigns.animation_options))
      else
        base
      end

    put_data_dir_attr(merged, assigns.dir)
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
      "data-orientation" => assigns.orientation,
      "id" => root_id(assigns.id)
    }
    |> put_dir_attr(assigns.dir)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(), to: Selectors.css_id(root_id(assigns.id)))
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    %{
      "data-scope" => "accordion",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-disabled" => presence_attr(assigns.disabled),
      "data-focus" => presence_attr(false),
      "data-orientation" => assigns.orientation,
      "data-state" => if(assigns.value in assigns.values, do: "open", else: "closed"),
      "id" => item_id(assigns.id, assigns.value)
    }
    |> put_dir_attr(assigns.dir)
  end

  @spec ignore_item(Item.t()) :: JS.t()
  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id(item_id(assigns.id, assigns.value))
    )
  end

  @spec trigger(Item.t()) :: map()
  def trigger(assigns) do
    expanded = assigns.value in assigns.values

    base_trigger = %{
      "data-scope" => "accordion",
      "data-part" => "item-trigger",
      "type" => "button",
      "aria-expanded" => if(expanded, do: "true", else: "false"),
      "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
      "disabled" => assigns.disabled,
      "data-focus" => presence_attr(false),
      "data-orientation" => assigns.orientation,
      "data-state" => if(expanded, do: "open", else: "closed"),
      "id" => trigger_id(assigns.id, assigns.value),
      "data-controls" => content_id(assigns.id, assigns.value),
      "aria-controls" => content_id(assigns.id, assigns.value),
      "data-ownedby" => root_id(assigns.id)
    }

    base_trigger =
      case trigger_aria_label(assigns) do
        nil -> base_trigger
        aria_label -> Map.put(base_trigger, "aria-label", aria_label)
      end

    put_dir_attr(base_trigger, assigns.dir)
  end

  @spec ignore_trigger(Item.t()) :: JS.t()
  def ignore_trigger(assigns) do
    JS.ignore_attributes(ItemTrigger.ignored_attrs(),
      to: Selectors.css_id(trigger_id(assigns.id, assigns.value))
    )
  end

  @spec content(Item.t(), String.t()) :: map()
  def content(assigns, animation \\ "instant") do
    expanded = assigns.value in assigns.values

    base = %{
      "data-scope" => "accordion",
      "data-part" => "item-content",
      "role" => "region",
      "data-state" => if(expanded, do: "open", else: "closed"),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-focus" => presence_attr(false),
      "data-orientation" => assigns.orientation,
      "id" => content_id(assigns.id, assigns.value)
    }

    base = Map.put(base, "aria-labelledby", trigger_id(assigns.id, assigns.value))

    result =
      cond do
        expanded ->
          base

        animation in ["js", "custom"] ->
          base

        true ->
          Map.put(base, "hidden", true)
      end

    put_dir_attr(result, assigns.dir)
  end

  defp trigger_aria_label(%{label: label, id: id, value: value})
       when is_binary(label) and label != "" and is_binary(id) and is_binary(value) do
    "#{label} (#{trigger_id(id, value)})"
  end

  defp trigger_aria_label(%{id: id, value: value}) when is_binary(id) and is_binary(value) do
    trigger_id(id, value)
  end

  defp trigger_aria_label(_), do: nil

  @spec ignore_content(Item.t()) :: JS.t()
  def ignore_content(assigns) do
    JS.ignore_attributes(ItemContent.ignored_attrs(),
      to: Selectors.css_id(content_id(assigns.id, assigns.value))
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
      "data-disabled" => presence_attr(assigns.disabled),
      "data-focus" => presence_attr(false),
      "data-orientation" => assigns.orientation
    }
    |> put_dir_attr(assigns.dir)
  end

  @spec ignore_indicator(Item.t()) :: JS.t()
  def ignore_indicator(assigns) do
    JS.ignore_attributes(ItemIndicator.ignored_attrs(),
      to: Selectors.css_id("accordion:#{assigns.id}:indicator:#{assigns.value}")
    )
  end
end
