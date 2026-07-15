defmodule Corex.Select.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Select.Anatomy.{
    Content,
    Control,
    HiddenSelect,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    Positioner,
    Props,
    Root,
    Trigger,
    ValueInput
  }

  alias Corex.FormField
  alias Corex.ValueBinding
  alias Phoenix.LiveView.JS

  import Corex.Helpers,
    only: [get_boolean: 1, maybe_put: 3, maybe_put_data_dir: 2, maybe_put_dir: 2]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    vlist = assigns.value || []
    controlled = Map.get(assigns, :controlled, false)

    {value_str, default_value_str} = ValueBinding.list_pair(vlist, controlled)

    items_json =
      Map.get(assigns, :items_json) || Corex.Dataset.encode_json(assigns.items || [])

    base = %{
      "id" => assigns.id,
      "data-items" => items_json,
      "data-controlled" => get_boolean(controlled),
      "data-value" => value_str,
      "data-default-value" => default_value_str,
      "data-placeholder" => assigns.placeholder || "",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-close-on-select" => get_boolean(assigns.close_on_select),
      "data-loop-focus" => get_boolean(assigns.loop_focus),
      "data-multiple" => get_boolean(assigns.multiple),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-readonly" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }

    base
    |> Map.merge(Corex.Positioning.to_dataset(assigns.positioning))
    |> merge_optional_select_props(assigns)
    |> maybe_put_data_dir(assigns.dir)
    |> FormField.put_form_field_attrs(assigns)
  end

  defp merge_optional_select_props(base, assigns) do
    base
    |> maybe_put("data-on-value-change", assigns.on_value_change)
    |> maybe_put("data-on-value-change-client", assigns.on_value_change_client)
    |> maybe_put("data-redirect", get_boolean(assigns.redirect))
    |> maybe_put("data-deselectable", get_boolean(Map.get(assigns, :deselectable)))
    |> maybe_put("data-hidden-select-name", Map.get(assigns, :hidden_select_name))
    |> maybe_put(
      "data-update-trigger",
      if(Map.get(assigns, :update_trigger, true), do: nil, else: "false")
    )
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")
    dir = Map.get(assigns, :dir)

    %{
      "data-scope" => "select",
      "data-part" => "root",
      "data-orientation" => orientation,
      "id" => "select:#{assigns.id}",
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
    |> maybe_put_dir(dir)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "select",
      "data-part" => "label",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "select:#{assigns.id}:label",
      "data-required" => get_boolean(assigns.required),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:label")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "select",
      "data-part" => "control",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "select:#{assigns.id}:control",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid)
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:control")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "select",
      "data-part" => "trigger",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "select:#{assigns.id}:trigger",
      "type" => "button",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid)
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:trigger")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "select",
      "data-part" => "positioner",
      "dir" => assigns.dir,
      "data-orientation" => orientation,
      "style" =>
        "position:fixed;isolation:isolate;width:var(--reference-width);pointer-events:none;top:0px;left:0px;transform:translate3d(0, -100vh, 0);z-index:var(--z-index);",
      "id" => "select:#{assigns.id}:positioner"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "select",
      "data-part" => "content",
      "dir" => assigns.dir,
      "data-orientation" => orientation,
      "id" => "select:#{assigns.id}:content",
      "tabindex" => -1,
      "role" => "listbox",
      "hidden" => "true",
      "aria-labelledby" => "select:#{assigns.id}:label"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:content")
    )
  end

  @spec hidden_select(HiddenSelect.t()) :: map()
  def hidden_select(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "select",
      "data-part" => "hidden-select",
      "dir" => assigns.dir,
      "data-orientation" => orientation,
      "id" => "select:#{assigns.id}:hidden-select",
      "aria-hidden" => "true",
      "tabindex" => -1,
      "style" =>
        "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
    }
  end

  def ignore_hidden_select(assigns) do
    JS.ignore_attributes(HiddenSelect.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:hidden-select")
    )
  end

  @spec value_input(ValueInput.t()) :: map()
  def value_input(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "type" => "text",
      "hidden" => "true",
      "aria-hidden" => "true",
      "autocomplete" => "off",
      "tabindex" => "-1",
      "data-scope" => "select",
      "data-part" => "value-input",
      "dir" => assigns.dir,
      "data-orientation" => orientation,
      "id" => "select:#{assigns.id}:value-input"
    }
  end

  def ignore_value_input(assigns) do
    JS.ignore_attributes(ValueInput.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:value-input")
    )
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    %{
      "data-scope" => "select",
      "data-part" => "item-group",
      "data-id" => assigns.group_id,
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "select:#{assigns.id}:item-group:#{assigns.group_id}"
    }
  end

  def ignore_item_group(assigns) do
    JS.ignore_attributes(ItemGroup.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:item-group:#{assigns.group_id}")
    )
  end

  @spec item_group_label(ItemGroupLabel.t()) :: map()
  def item_group_label(assigns) do
    %{
      "data-scope" => "select",
      "data-part" => "item-group-label",
      "data-id" => assigns.group_id,
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "select:#{assigns.id}:item-group-label:#{assigns.group_id}"
    }
  end

  def ignore_item_group_label(assigns) do
    JS.ignore_attributes(ItemGroupLabel.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:item-group-label:#{assigns.group_id}")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "select",
      "data-part" => "item",
      "data-value" => assigns.value,
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "select:#{assigns.id}:item:#{assigns.value}"
    }

    Corex.Connect.ItemNav.put_item_nav_attrs(base, assigns)
  end

  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:item:#{assigns.value}")
    )
  end

  @spec item_text(ItemText.t()) :: map()
  def item_text(assigns) do
    %{
      "data-scope" => "select",
      "data-part" => "item-text",
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "select:#{assigns.id}:item-text:#{assigns.value}"
    }
  end

  def ignore_item_text(assigns) do
    JS.ignore_attributes(ItemText.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:item-text:#{assigns.value}")
    )
  end

  @spec item_indicator(ItemIndicator.t()) :: map()
  def item_indicator(assigns) do
    %{
      "data-scope" => "select",
      "data-part" => "item-indicator",
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "select:#{assigns.id}:item-indicator:#{assigns.value}"
    }
  end

  def ignore_item_indicator(assigns) do
    JS.ignore_attributes(ItemIndicator.ignored_attrs(),
      to: Selectors.css_id("select:#{assigns.id}:item-indicator:#{assigns.value}")
    )
  end
end
