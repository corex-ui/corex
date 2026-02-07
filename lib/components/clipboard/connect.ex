defmodule Corex.Clipboard.Connect do
  @moduledoc false
  alias Corex.Clipboard.Anatomy.{Props, Root, Label, Control, Input, Trigger}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-controlled" => data_attr(assigns.controlled),
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
      "data-timeout" => if(assigns.timeout, do: Integer.to_string(assigns.timeout), else: nil),
      "data-dir" => assigns.dir,
      "data-on-copy" => assigns.on_copy,
      "data-on-copy-client" => assigns.on_copy_client,
      "data-on-value-change" => assigns.on_value_change,
      "data-trigger-aria-label" => assigns.trigger_aria_label,
      "data-input-aria-label" => assigns.input_aria_label
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "clipboard",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            # "dir" => assigns.dir,
            # "id" => "clipboard:#{assigns.id}"
          }
        )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    base = %{
      "data-scope" => "clipboard",
      "data-part" => "label"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            # "dir" => assigns.dir,
            # "id" => "clipboard:#{assigns.id}:label"
          }
        )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    base = %{
      "data-scope" => "clipboard",
      "data-part" => "control"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            # "dir" => assigns.dir,
            # "id" => "clipboard:#{assigns.id}:control"
          }
        )
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    base = %{
      "data-scope" => "clipboard",
      "data-part" => "input"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            # "type" => "text",
            # "readonly" => "",
            # "dir" => assigns.dir,
            # "id" => "clipboard:#{assigns.id}:input",
            # "value" => assigns.value || ""
          }
        )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    base = %{
      "data-scope" => "clipboard",
      "data-part" => "trigger"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            # "type" => "button",
            # "dir" => assigns.dir,
            # "id" => "clipboard:#{assigns.id}:trigger"
          }
        )
  end
end
