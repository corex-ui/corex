defmodule Corex.Switch.Connect do
  @moduledoc false
  alias Corex.Switch.Anatomy.{Props, Root, HiddenInput}

  # Generic helper for boolean data attributes
  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-checked" => data_default_checked(assigns),
      "data-checked" => data_checked(assigns),
      "data-controlled" => data_attr(assigns.controlled),
      "data-disabled" => data_attr(assigns.disabled),
      "data-value" => assigns.value,
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-label" => assigns.label,
      "data-read-only" => data_attr(assigns.read_only),
      "data-invalid" => data_attr(assigns.invalid),
      "data-required" => data_attr(assigns.required),
      "data-on-checked-change" => assigns.on_checked_change,
      "data-on-checked-change-client" => assigns.on_checked_change_client
    }
  end

  defp data_default_checked(assigns) do
    if !assigns.controlled && assigns.checked, do: "", else: nil
  end

  defp data_checked(assigns) do
    if assigns.controlled do
      if assigns.checked, do: "", else: nil
    else
      nil
    end
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    data_state = if assigns.checked, do: "checked", else: "unchecked"

    base = %{
      "data-scope" => "switch",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "switch:#{assigns.id}",
          "htmlFor" => "switch:#{assigns.id}:input",
          "for" => "switch:#{assigns.id}:input",
          "data-state" => data_state
        })
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    checked =
      if assigns.controlled do
        if assigns.checked, do: "", else: nil
      else
        nil
      end

    base = %{
      "data-scope" => "switch",
      "data-part" => "hidden-input"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "checkbox",
          "id" => "switch:#{assigns.id}:input",
          "checked" => checked,
          "name" => assigns.name,
          "required" => data_attr(assigns.required),
          "disabled" => data_attr(assigns.disabled),
          "aria-labelledby" => "switch:#{assigns.id}:label",
          "value" => assigns.value,
          "aria-invalid" => if(assigns.invalid, do: "true", else: "false"),
          "style" =>
            "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
        })
  end

  def control(assigns) do
    data_state = if assigns.checked, do: "checked", else: "unchecked"

    base = %{
      "data-scope" => "switch",
      "data-part" => "control",
      "aria-hidden" => "true"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "switch:#{assigns.id}:control",
          "data-state" => data_state
        })
  end

  def thumb(assigns) do
    data_state = if assigns.checked, do: "checked", else: "unchecked"

    base = %{
      "data-scope" => "switch",
      "data-part" => "thumb",
      "aria-hidden" => "true"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "switch:#{assigns.id}:thumb",
          "data-state" => data_state
        })
  end

  def label(assigns) do
    data_state = if assigns.checked, do: "checked", else: "unchecked"

    base = %{
      "data-scope" => "switch",
      "data-part" => "label",
      "aria-hidden" => "true"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "switch:#{assigns.id}:label",
          "data-state" => data_state
        })
  end
end
