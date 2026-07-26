defmodule Corex.Checkbox do
  @moduledoc ~S'''
  Checkbox for Phoenix LiveView forms. Behavior follows [Zag.js Checkbox](https://zagjs.com/components/react/checkbox).

  Examples, events, patterns, form wiring, and styling: [Checkbox guide](components/checkbox.html).
  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Api.Imports, to: Corex.Checkbox.Api

  import Corex.Component, only: [form_control_attrs: 1]

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  alias Corex.Checkbox.Anatomy.{
    Control,
    HiddenInput,
    Indeterminate,
    Indicator,
    Label,
    Props,
    Root
  }

  alias Corex.Checkbox.Connect

  alias Phoenix.HTML.Form

  @doc """
  Renders a checkbox component.
  """

  form_control_attrs(
    docs: [
      id: "The id of the checkbox, useful for API to identify the checkbox",
      name: "The name of the checkbox input for form submission",
      form: "The form id to associate the checkbox with",
      field:
        "A form field struct retrieved from the form, for example: @form[:email]. Automatically sets id, name, checked state, and errors from the form field"
    ]
  )

  attr(:checked, :any,
    default: false,
    doc:
      "Checked state: true, false, or :indeterminate (Zag CheckedState). Form fields still use boolean."
  )

  attr(:aria_label, :string,
    default: "Label",
    doc: "The accessible label for the checkbox"
  )

  attr(:value, :string,
    default: "true",
    doc: "The value of the checkbox when checked"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the checkbox. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["vertical", "horizontal"],
    doc: "Layout orientation for CSS (vertical or horizontal)"
  )

  attr(:on_checked_change, :string,
    default: nil,
    doc:
      "LiveView event when checked changes. `handle_event` receives `%{\"id\" => id, \"checked\" => boolean}`."
  )

  attr(:on_checked_change_client, :string,
    default: nil,
    doc:
      "Browser event type on the checkbox element when checked changes. `event.detail`: `{ id, checked }`."
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

  slot :indeterminate, required: false do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def checkbox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assigns
      |> Corex.FormField.assign_form_field(field)
      |> assign(:checked, Form.normalize_value("checkbox", field.value))

    checkbox(assigns)
  end

  def checkbox(assigns) do
    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (checkbox)")
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:form_field, fn -> false end)
      |> assign(:checked, CheckableHelpers.normalize_checked(assigns.checked))
      |> assign_checkbox_part_attrs()

    ~H"""
    <div
      id={@id}
      phx-hook="Checkbox"
      {Corex.Hook.loading()}
      {@rest}
      {@connect_props}
    >
      <input type="hidden" name={@name} value="false" disabled={@disabled} />

      <label phx-mounted={@root_ignore} {@root_attrs}>
      <input
        phx-mounted={@hidden_input_ignore}
        {@hidden_input_attrs}
      />
      <div phx-mounted={@control_ignore} {@control_attrs}>
          <span
            :if={@indicator != []}
            phx-mounted={@indicator_ignore}
            {@indicator_attrs}
          >
          {render_slot(@indicator)}
          </span>
          <span
            :if={@indeterminate != []}
            phx-mounted={@indeterminate_ignore}
            {@indeterminate_attrs}
          >
          {render_slot(@indeterminate)}
          </span>
      </div>
      <span
        :if={@label != []}
        phx-mounted={@label_ignore}
        {@label_attrs}
      >
      {render_slot(@label)}
      </span>
      <span
        :if={@label == [] && @aria_label}
        style={Corex.Attrs.visually_hidden_style()}
        phx-mounted={@label_ignore}
        {@label_attrs}
      >
      {@aria_label}
      </span>
      </label>
      <div
        :if={@error != []}
        :for={msg <- @errors}
        class={Map.get(Enum.at(@error, 0), :class, nil)}
        data-scope="checkbox"
        data-part="error"
      >
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  defp assign_checkbox_part_attrs(assigns) do
    root = %Root{
      id: assigns.id,
      dir: assigns.dir,
      checked: assigns.checked,
      orientation: assigns.orientation,
      read_only: assigns.read_only
    }

    hidden = %HiddenInput{
      id: assigns.id,
      name: assigns.name,
      checked: assigns.checked,
      disabled: assigns.disabled,
      required: assigns.required,
      invalid: assigns.invalid,
      value: assigns.value,
      controlled: assigns.controlled
    }

    control = %Control{
      id: assigns.id,
      dir: assigns.dir,
      checked: assigns.checked,
      orientation: assigns.orientation
    }

    indicator = %Indicator{
      id: assigns.id,
      dir: assigns.dir,
      checked: assigns.checked,
      orientation: assigns.orientation
    }

    indeterminate = %Indeterminate{
      id: assigns.id,
      dir: assigns.dir,
      checked: assigns.checked,
      orientation: assigns.orientation
    }

    label = %Label{
      id: assigns.id,
      dir: assigns.dir,
      checked: assigns.checked,
      orientation: assigns.orientation
    }

    props = %Props{
      id: assigns.id,
      controlled: assigns.controlled,
      checked: assigns.checked,
      form_field: assigns.form_field,
      name: assigns.name,
      form: assigns.form,
      dir: assigns.dir,
      orientation: assigns.orientation,
      read_only: assigns.read_only,
      invalid: assigns.invalid,
      required: assigns.required,
      on_checked_change: assigns.on_checked_change,
      on_checked_change_client: assigns.on_checked_change_client,
      label: assigns.aria_label,
      disabled: assigns.disabled,
      value: assigns.value
    }

    assigns
    |> assign(:connect_props, Connect.props(props))
    |> assign(:root_attrs, Connect.root(root))
    |> assign(:root_ignore, Connect.ignore_root(root))
    |> assign(:hidden_input_attrs, Connect.hidden_input(hidden))
    |> assign(:hidden_input_ignore, Connect.ignore_hidden_input(hidden))
    |> assign(:control_attrs, Connect.control(control))
    |> assign(:control_ignore, Connect.ignore_control(control))
    |> assign(:indicator_attrs, Connect.indicator(indicator))
    |> assign(:indicator_ignore, Connect.ignore_indicator(indicator))
    |> assign(:indeterminate_attrs, Connect.indeterminate(indeterminate))
    |> assign(:indeterminate_ignore, Connect.ignore_indeterminate(indeterminate))
    |> assign(:label_attrs, Connect.label(label))
    |> assign(:label_ignore, Connect.ignore_label(label))
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the checkbox component.
  """

  attr(:skeleton_label, :boolean,
    default: true,
    doc:
      "When true, renders a compact label-line placeholder (same line height band as the real checkbox label)."
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Same as checkbox: logical direction for layout."
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["vertical", "horizontal"],
    doc: "Same as checkbox: layout orientation for the skeleton root."
  )

  attr(:rest, :global)

  def checkbox_skeleton(assigns) do
    ~H"""
    <div data-dir={@dir} data-orientation={@orientation} {@rest}>
      <div
        data-scope="checkbox"
        data-part="root"
        data-loading
        dir={@dir}
        data-orientation={@orientation}
      >
        <div data-scope="checkbox" data-part="control" aria-hidden="true">
          <span data-scope="checkbox" data-part="indicator">
          </span>
        </div>
        <div
          :if={@skeleton_label}
          data-scope="checkbox"
          data-part="label"
          aria-hidden="true"
        >
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set checked state from a control (`phx-click`). Clears indeterminate when applied.

  ```heex
  <.action phx-click={Corex.Checkbox.set_checked("my-checkbox", true)}>Check</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```javascript
  document.getElementById("my-checkbox")?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", {
      bubbles: false,
      detail: { checked: true },
    })
  );
  ```
  """)

  defdelegate set_checked(checkbox_id, checked), to: Api

  api_doc(~S"""
  Set checked state from `handle_event`. Pushes `checkbox_set_checked` (no reply event).

  ```heex
  <.action phx-click="check_box">Check</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```elixir
  def handle_event("check_box", _, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, "my-checkbox", true)}
  end
  ```
  """)

  defdelegate set_checked(socket, checkbox_id, checked), to: Api

  api_doc(~S"""
  Set checked state for many checkboxes from `handle_event`. Pushes `checkbox_set_checked_many` (no reply event).

  ```elixir
  def handle_event("select_all", _, socket) do
    ids = ["row-1", "row-2", "row-3"]
    {:noreply, Corex.Checkbox.set_checked_many(socket, ids, true)}
  end
  ```
  """)

  defdelegate set_checked_many(socket, checkbox_ids, checked), to: Api

  api_doc(~S"""
  Toggle checked state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Checkbox.toggle_checked("my-checkbox")}>Toggle</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```javascript
  document.getElementById("my-checkbox")?.dispatchEvent(
    new CustomEvent("corex:checkbox:toggle-checked", { bubbles: false })
  );
  ```
  """)

  defdelegate toggle_checked(checkbox_id), to: Api

  api_doc(~S"""
  Toggle checked from `handle_event`. Pushes `checkbox_toggle_checked` (no reply event).

  ```heex
  <.action phx-click="toggle_box">Toggle</.action>
  <.checkbox id="my-checkbox" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ```elixir
  def handle_event("toggle_box", _, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, "my-checkbox")}
  end
  ```
  """)

  defdelegate toggle_checked(socket, checkbox_id), to: Api
end
