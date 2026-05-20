defmodule Corex.Editable.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Editable.Anatomy.{
    Area,
    CancelTrigger,
    Control,
    EditTrigger,
    Input,
    Label,
    Preview,
    Props,
    Root,
    SubmitTrigger,
    Triggers
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1, maybe_put: 3]

  defp orientation(assigns), do: Map.get(assigns, :orientation, "horizontal")

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}")
    )
  end

  def ignore_area(assigns) do
    JS.ignore_attributes(Area.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:area")
    )
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:label")
    )
  end

  def ignore_input(assigns) do
    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:input")
    )
  end

  def ignore_preview(assigns) do
    JS.ignore_attributes(Preview.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:preview")
    )
  end

  def ignore_edit_trigger(assigns) do
    JS.ignore_attributes(EditTrigger.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:edit-trigger")
    )
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:control")
    )
  end

  def ignore_submit_trigger(assigns) do
    JS.ignore_attributes(SubmitTrigger.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:submit-trigger")
    )
  end

  def ignore_cancel_trigger(assigns) do
    JS.ignore_attributes(CancelTrigger.ignored_attrs(),
      to: Selectors.css_id("editable:#{assigns.id}:cancel-trigger")
    )
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-value" => assigns.value || "",
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-edit" => if(assigns.controlled, do: get_boolean(assigns.edit), else: nil),
      "data-default-edit" =>
        if(assigns.controlled, do: nil, else: get_boolean(assigns.default_edit)),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-placeholder" => assigns.placeholder,
      "data-activation-mode" => assigns.activation_mode,
      "data-select-on-focus" => get_boolean(assigns.select_on_focus),
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
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}"
    }
  end

  @spec area(Area.t()) :: map()
  def area(assigns) do
    base = %{
      "data-scope" => "editable",
      "data-part" => "area",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}:area",
      "data-focus" => get_boolean(assigns.editing),
      "data-placeholder-shown" => get_boolean(assigns.empty)
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
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}:label",
      "for" => "editable:#{assigns.id}:input"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "input",
      "disabled" => get_boolean(assigns.disabled),
      "id" => "editable:#{assigns.id}:input",
      "required" => get_boolean(assigns.required),
      "readonly" => get_boolean(assigns.read_only),
      "aria-label" => assigns.aria_label,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns)
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
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}:preview",
      "data-placeholder-shown" => get_boolean(assigns.empty),
      "aria-label" => assigns.aria_label,
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
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}:edit-trigger",
      "aria-label" => assigns.aria_label,
      "hidden" => if(assigns.editing, do: "", else: nil)
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "editable",
      "data-part" => "control",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
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
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}:submit-trigger",
      "aria-label" => assigns.aria_label,
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
      "data-orientation" => orientation(assigns),
      "id" => "editable:#{assigns.id}:cancel-trigger",
      "aria-label" => assigns.aria_label,
      "hidden" => if(assigns.editing, do: nil, else: "")
    }
  end
end
