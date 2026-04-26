defmodule Corex.Clipboard.Connect do
  @moduledoc false
  alias Corex.Clipboard.Anatomy.{Control, Copied, Copy, Input, Label, Props, Root, Trigger}
  alias Corex.Selectors

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-value" => assigns.value || "",
      "data-timeout" => if(assigns.timeout, do: Integer.to_string(assigns.timeout), else: nil),
      "data-dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "data-on-copy" => assigns.on_copy,
      "data-on-copy-client" => assigns.on_copy_client,
      "data-trigger-aria-label" => assigns.trigger_aria_label,
      "data-input-aria-label" => assigns.input_aria_label
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "root",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "label",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}:label"
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}:label")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "control",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}:control"
    }
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}:control")
    )
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "input",
      "type" => "text",
      "readonly" => "",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}:input",
      "value" => assigns.value || ""
    }
  end

  def ignore_input(assigns) do
    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}:input")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}:trigger"
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}:trigger")
    )
  end

  @spec copy_part(Copy.t()) :: map()
  def copy_part(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "copy",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}:copy"
    }
  end

  def ignore_copy_part(assigns) do
    JS.ignore_attributes(Copy.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}:copy")
    )
  end

  @spec copied_part(Copied.t()) :: map()
  def copied_part(assigns) do
    %{
      "data-scope" => "clipboard",
      "data-part" => "copied",
      "dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "id" => "clipboard:#{assigns.id}:copied"
    }
  end

  def ignore_copied_part(assigns) do
    JS.ignore_attributes(Copied.ignored_attrs(),
      to: Selectors.css_id("clipboard:#{assigns.id}:copied")
    )
  end
end
