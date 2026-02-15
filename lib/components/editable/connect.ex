defmodule Corex.Editable.Connect do
  @moduledoc false
  alias Corex.Editable.Anatomy.{
    Props,
    Root,
    Area,
    Label,
    Input,
    Preview,
    EditTrigger,
    Control,
    Triggers,
    SubmitTrigger,
    CancelTrigger
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-value" => if(assigns.controlled, do: assigns.value, else: nil),
      "data-default-value" => if(assigns.controlled, do: nil, else: assigns.value),
      "data-controlled" => data_attr(assigns.controlled),
      "data-disabled" => data_attr(assigns.disabled),
      "data-read-only" => data_attr(assigns.read_only),
      "data-required" => data_attr(assigns.required),
      "data-invalid" => data_attr(assigns.invalid),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-edit" => if(assigns.controlled_edit, do: data_attr(assigns.edit), else: nil),
      "data-default-edit" => if(assigns.controlled_edit, do: nil, else: data_attr(assigns.default_edit)),
      "data-controlled-edit" => data_attr(assigns.controlled_edit),
      "data-placeholder" => assigns.placeholder,
      "data-activation-mode" => assigns.activation_mode,
      "data-select-on-focus" => data_attr(assigns.select_on_focus),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}"
    }
  end

  @spec area(Area.t()) :: map()
  def area(assigns) do
    base = %{
      "data-scope" => "editable",
      "data-part" => "area",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:area",
      "data-focus" => data_attr(assigns.editing),
      "data-placeholder-shown" => data_attr(assigns.empty)
    }

    if assigns.auto_resize do
      Map.put(base, "style", "display:inline-grid")
    else
      base
    end
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:label",
      "for" => "editable:#{assigns.id}:input"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "input",
      "disabled" => data_attr(assigns.disabled),
      "id" => "editable:#{assigns.id}:input",
      "required" => data_attr(assigns.required),
      "readonly" => data_attr(assigns.read_only),
      "aria-label" => assigns.aria_label || "editable input",
      "data-disabled" => data_attr(assigns.disabled),
      "data-readonly" => data_attr(assigns.read_only)
    }
    |> maybe_put("placeholder", assigns.placeholder)
    |> maybe_put("name", assigns.name)
    |> maybe_put("form", assigns.form)
    |> maybe_put("value", assigns.value)
    |> maybe_put("hidden", if(assigns.editing, do: nil, else: ""))
  end

  @spec preview(Preview.t()) :: map()
  def preview(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "preview",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:preview",
      "data-placeholder-shown" => data_attr(assigns.empty),
      "aria-label" => "edit",
      "tabindex" => "0",
      "hidden" => if(assigns.editing, do: "", else: nil)
    }
  end

  @spec edit_trigger(EditTrigger.t()) :: map()
  def edit_trigger(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "edit-trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:edit-trigger",
      "aria-label" => "edit",
      "hidden" => if(assigns.editing, do: "", else: nil)
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:control"
    }
  end

  @spec triggers(Triggers.t()) :: map()
  def triggers(_assigns) do
    %{"data-scope" => "editable", "data-part" => "triggers"}
  end

  @spec submit_trigger(SubmitTrigger.t()) :: map()
  def submit_trigger(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "submit-trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:submit-trigger",
      "aria-label" => "submit",
      "hidden" => if(assigns.editing, do: nil, else: "")
    }
  end

  @spec cancel_trigger(CancelTrigger.t()) :: map()
  def cancel_trigger(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "cancel-trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "editable:#{assigns.id}:cancel-trigger",
      "aria-label" => "cancel",
      "hidden" => if(assigns.editing, do: nil, else: "")
    }
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
