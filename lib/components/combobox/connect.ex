defmodule Corex.Combobox.Connect do
  @moduledoc false
  alias Corex.Combobox.Anatomy.Control
  alias Corex.Combobox.Anatomy.{Props, Root, Label, Input, Positioner, Content}

  import Corex.Helpers,
    only: [get_boolean: 1, get_default_boolean: 2, get_boolean: 2, validate_value!: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-collection" => Corex.Json.encode!(validate_collection!(assigns.collection)),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-default-open" => get_default_boolean(assigns.controlled, assigns.open),
      "data-open" => get_boolean(assigns.controlled, assigns.open),
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
      "data-placeholder" => assigns.placeholder,
      "data-close-on-select" => get_boolean(assigns.close_on_select),
      "data-always-submit-on-enter" => get_boolean(assigns.always_submit_on_enter),
      "data-auto-focus" => get_boolean(assigns.auto_focus),
      "data-dir" => assigns.dir,
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
      "data-positioning" => Corex.Json.encode!(assigns.positioning),
      "data-bubble" => get_boolean(assigns.bubble),
      "data-filter" => get_boolean(assigns.filter)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "root",
      "id" => "combobox:#{assigns.id}",
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "combobox:#{assigns.id}:label",
      "htmlFor" => "combobox:#{assigns.id}:input",
      "for" => "combobox:#{assigns.id}:input",
      "data-required" => get_boolean(assigns.required),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only)
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "combobox:#{assigns.id}:control",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid)
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "input",
      "phx-update" => "ignore",
      "autoComplete" => "off",
      "autoCorrect" => "off",
      "autoCapitalize" => "off",
      "spellCheck" => "false",
      "type" => "text",
      "role" => "combobox",
      "dir" => assigns.dir,
      "id" => "combobox:#{assigns.id}:input",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "aria-controls" => "combobox:#{assigns.id}:content",
      "placeholder" => assigns.placeholder,
      "autoFocus" => get_boolean(assigns.auto_focus)
    }
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "positioner",
      "dir" => assigns.dir,
      "style" => "display: none;",
      "id" => "combobox:#{assigns.id}:positioner"
    }
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "combobox",
      "data-part" => "content",
      "dir" => assigns.dir,
      "id" => "combobox:#{assigns.id}:content",
      "tabindex" => -1,
      "role" => "listbox",
      "hidden" => "true",
      "aria-labelledby" => "combobox:#{assigns.id}:label"
    }
  end

  defp validate_collection!(items) when is_list(items) do
    Enum.map(items, fn
      %Corex.List.Item{} = item ->
        item

      %{id: _, label: _} = map ->
        struct(Corex.List.Item, map)

      other ->
        raise ArgumentError, """
        <.combobox> items must be Corex.List.Item or maps with :id and :label.

        Got:
        #{inspect(other)}
        """
    end)
  end
end
