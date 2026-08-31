defmodule Corex.CascadeSelect.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.CascadeSelect.Anatomy.{
    ClearTrigger,
    Content,
    Control,
    HiddenInput,
    Indicator,
    Label,
    Positioner,
    Props,
    Root,
    Trigger,
    ValueText
  }

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    tree_json =
      Map.get(assigns, :tree_json) ||
        Corex.Dataset.encode_json(assigns.tree || Corex.CascadeSelect.default_tree())

    %{
      "id" => assigns.id,
      "data-tree" => tree_json,
      "data-disabled" => presence_attr(assigns.disabled),
      "data-placeholder" => assigns.placeholder || "Select"
    }
    |> maybe_put("data-name", assigns.name)
    |> maybe_put("data-on-value-change", assigns.on_value_change)
    |> maybe_put("data-on-value-change-client", assigns.on_value_change_client)
    |> put_data_dir_attr(Map.get(assigns, :dir))
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":root",
      "data-disabled" => presence_attr(Map.get(assigns, :disabled))
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":root")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "label",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":label",
      "data-disabled" => presence_attr(Map.get(assigns, :disabled))
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":label")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "control",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":control",
      "data-disabled" => presence_attr(Map.get(assigns, :disabled))
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":control")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":trigger",
      "data-state" => "closed",
      "data-disabled" => presence_attr(Map.get(assigns, :disabled))
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":trigger")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "indicator",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":indicator",
      "data-state" => "closed"
    }
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":indicator")
    )
  end

  @spec clear_trigger(ClearTrigger.t()) :: map()
  def clear_trigger(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "clear-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":clear-trigger",
      "hidden" => true
    }
  end

  def ignore_clear_trigger(assigns) do
    JS.ignore_attributes(ClearTrigger.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":clear-trigger")
    )
  end

  @spec value_text(ValueText.t()) :: map()
  def value_text(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "value-text",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":value-text"
    }
  end

  def ignore_value_text(assigns) do
    JS.ignore_attributes(ValueText.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":value-text")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":positioner",
      "style" => Corex.CascadeSelect.Anatomy.closed_positioner_style()
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":content",
      "hidden" => true,
      "aria-hidden" => "true",
      "tabindex" => -1,
      "style" => "display:none;pointer-events:none"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":content")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "cascade-select",
      "data-part" => "hidden-input",
      "dir" => Map.get(assigns, :dir),
      "id" => "cascade-select:" <> assigns.id <> ":hidden-input",
      "type" => "hidden",
      "aria-hidden" => "true"
    }
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("cascade-select:" <> assigns.id <> ":hidden-input")
    )
  end
end
