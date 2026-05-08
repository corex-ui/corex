defmodule Corex.Combobox.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Combobox.Anatomy.{
    ClearTrigger,
    Content,
    Control,
    Empty,
    Input,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    List,
    Positioner,
    Props,
    Root,
    Trigger
  }

  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [get_boolean: 1, validate_value!: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    base = %{
      "id" => assigns.id,
      "data-items" => Corex.Json.encode!(assigns.items),
      "data-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.value), ",")
        else
          nil
        end,
      "data-default-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.value), ",")
        end,
      "data-controlled" => get_boolean(assigns.controlled),
      "data-placeholder" => assigns.placeholder,
      "data-close-on-select" => get_boolean(assigns.close_on_select),
      "data-always-submit-on-enter" => get_boolean(assigns.always_submit_on_enter),
      "data-auto-focus" => get_boolean(assigns.auto_focus),
      "data-dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-input-behavior" => assigns.input_behavior,
      "data-loop-focus" => get_boolean(assigns.loop_focus),
      "data-multiple" => get_boolean(assigns.multiple),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-read-only" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-on-input-value-change" => assigns.on_input_value_change,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-filter" => get_boolean(assigns.filter),
      "data-redirect" => get_boolean(assigns.redirect)
    }

    Map.merge(base, Corex.Positioning.to_dataset(assigns.positioning))
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}",
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "label",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:label",
      "htmlFor" => "combobox:#{assigns.id}:input",
      "for" => "combobox:#{assigns.id}:input",
      "data-required" => get_boolean(assigns.required),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:label")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "control",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:control",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid)
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:control")
    )
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "input",
      "autoComplete" => "off",
      "autoCorrect" => "off",
      "autoCapitalize" => "off",
      "spellCheck" => "false",
      "type" => "text",
      "role" => "combobox",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:input",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "aria-controls" => "combobox:#{assigns.id}:content",
      "placeholder" => assigns.placeholder,
      "autoFocus" => get_boolean(assigns.auto_focus),
      "aria-expanded" => "false"
    }
  end

  def ignore_input(assigns) do
    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:input")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:trigger",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid)
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:trigger")
    )
  end

  @spec clear_trigger(ClearTrigger.t()) :: map()
  def clear_trigger(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "clear-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:clear-trigger",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid)
    }
  end

  def ignore_clear_trigger(assigns) do
    JS.ignore_attributes(ClearTrigger.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:clear-trigger")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "style" => "display: none;",
      "id" => "combobox:#{assigns.id}:positioner"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:content",
      "tabindex" => -1,
      "role" => "listbox",
      "hidden" => "true",
      "aria-labelledby" => "combobox:#{assigns.id}:label"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:content")
    )
  end

  @spec list(List.t()) :: map()
  def list(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "list",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:list"
    }
  end

  def ignore_list(assigns) do
    JS.ignore_attributes(List.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:list")
    )
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "item-group",
      "data-id" => assigns.group_id,
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:item-group:#{assigns.group_id}"
    }
  end

  def item_group_template(assigns), do: Map.drop(item_group(assigns), ["id"])

  def ignore_item_group(assigns) do
    JS.ignore_attributes(ItemGroup.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:item-group:#{assigns.group_id}")
    )
  end

  @spec item_group_label(ItemGroupLabel.t()) :: map()
  def item_group_label(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "item-group-label",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:item-group-label:#{assigns.html_for}"
    }
  end

  def item_group_label_template(assigns), do: Map.drop(item_group_label(assigns), ["id"])

  def ignore_item_group_label(assigns) do
    JS.ignore_attributes(ItemGroupLabel.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:item-group-label:#{assigns.html_for}")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "combobox",
      "data-part" => "item",
      "data-value" => assigns.value,
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:item:#{assigns.value}"
    }

    base = if Map.get(assigns, :to), do: Map.put(base, "data-to", assigns.to), else: base

    base =
      case Map.get(assigns, :redirect) do
        false ->
          Map.put(base, "data-redirect", "false")

        mode when mode in [:href, :patch, :navigate] ->
          Map.put(base, "data-redirect", Atom.to_string(mode))

        _ ->
          base
      end

    if Map.get(assigns, :new_tab), do: Map.put(base, "data-new-tab", ""), else: base
  end

  def item_template(assigns), do: Map.drop(item(assigns), ["id"])

  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:item:#{assigns.value}")
    )
  end

  defp item_value(item) when is_map(item) do
    item
    |> Map.new(fn {k, v} -> {to_string(k), v} end)
    |> then(fn m -> Map.get(m, "value") || Map.get(m, "id") || "" end)
  end

  @spec item_text(ItemText.t()) :: map()
  def item_text(assigns) do
    val = item_value(assigns.item)

    %{
      "data-scope" => "combobox",
      "data-part" => "item-text",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:item-text:#{val}"
    }
  end

  def item_text_template(assigns), do: Map.drop(item_text(assigns), ["id"])

  def ignore_item_text(assigns) do
    val = item_value(assigns.item)

    JS.ignore_attributes(ItemText.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:item-text:#{val}")
    )
  end

  @spec item_indicator(ItemIndicator.t()) :: map()
  def item_indicator(assigns) do
    val = item_value(assigns.item)

    %{
      "data-scope" => "combobox",
      "data-part" => "item-indicator",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:item-indicator:#{val}"
    }
  end

  def item_indicator_template(assigns), do: Map.drop(item_indicator(assigns), ["id"])

  def ignore_item_indicator(assigns) do
    val = item_value(assigns.item)

    JS.ignore_attributes(ItemIndicator.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:item-indicator:#{val}")
    )
  end

  @spec empty(Empty.t()) :: map()
  def empty(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "empty",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "combobox:#{assigns.id}:empty"
    }
  end

  def empty_template(assigns), do: Map.drop(empty(assigns), ["id"])

  def ignore_empty(assigns) do
    JS.ignore_attributes(Empty.ignored_attrs(),
      to: Selectors.css_id("combobox:#{assigns.id}:empty")
    )
  end
end
