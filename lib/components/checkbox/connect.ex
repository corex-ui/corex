defmodule Corex.Checkbox.Connect do
  @moduledoc false
  alias Corex.Checkbox.Anatomy.{Props, Root, HiddenInput, Indicator, Control, Label}

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

  @spec root(Root.t()) :: map()
  def root(assigns) do
    data_state = data_state(assigns)

    base = %{
      "data-scope" => "checkbox",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "checkbox:#{assigns.id}",
          "htmlFor" => "checkbox:#{assigns.id}:input",
          "for" => "checkbox:#{assigns.id}:input",
          "data-state" => data_state
        })
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    base = %{
      "data-scope" => "checkbox",
      "data-part" => "hidden-input",
      "id" => "checkbox:#{assigns.id}:input",
      "type" => "checkbox",
      "checked" => data_attr(assigns.checked),
      "value" => "true",
      "name" => assigns.name,
      "phx-update" => "ignore"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "required" => data_attr(assigns.required),
          "disabled" => data_attr(assigns.disabled),
          "aria-labelledby" => "checkbox:#{assigns.id}:label",
          "aria-invalid" => if(assigns.invalid, do: "true", else: "false"),
          "style" =>
            "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
        })
  end

  @spec props(Control.t()) :: map()

  def control(assigns) do
    data_state = data_state(assigns)

    base = %{
      "data-scope" => "checkbox",
      "data-part" => "control",
      "aria-hidden" => "true"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "checkbox:#{assigns.id}:control",
          "data-state" => data_state
        })
  end

  @spec props(Label.t()) :: map()

  def label(assigns) do
    data_state = data_state(assigns)

    base = %{
      "data-scope" => "checkbox",
      "data-part" => "label"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "checkbox:#{assigns.id}:label",
          "data-state" => data_state
        })
  end

  @spec props(Indicator.t()) :: map()

  def indicator(assigns) do
    data_state = data_state(assigns)

    base = %{
      "data-scope" => "checkbox",
      "data-part" => "indicator"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "checkbox:#{assigns.id}:indicator",
          "data-state" => data_state
        })
  end

  defp data_state(assigns) do
    if assigns.checked, do: "checked", else: "unchecked"
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
end
