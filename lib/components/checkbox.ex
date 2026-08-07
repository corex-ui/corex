defmodule Corex.Checkbox do
  @moduledoc ~S'''
  Checkbox for Phoenix LiveView forms. Behavior follows [Zag.js Checkbox](https://zagjs.com/components/react/checkbox).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.checkbox
    id="terms" class="checkbox">
    <:label>Option</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ### Label and indicator

  ```heex
  <.checkbox
    id="terms" class="checkbox">
    <:label>Accept the terms</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ### Invalid

  ```heex
  <.checkbox
    id="terms"
    class="checkbox ui-accent"
    invalid
    checked
    errors={["Required"]}
  >
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  ### Indeterminate

  ```heex
  <.checkbox
    id="terms" class="checkbox" checked={:indeterminate}>
    <:label>Select some rows</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:indeterminate>
      <.heroicon name="hero-minus" />
    </:indeterminate>
  </.checkbox>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.checkbox
    id="terms">`. Imperative helpers set or toggle checked state (boolean only; clears indeterminate).

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_checked/2`](#set_checked/2) | Set checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_checked/3`](#set_checked/3) | Set checked state (server) | `socket` |
  | [`toggle_checked/1`](#toggle_checked/1) | Toggle checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_checked/2`](#toggle_checked/2) | Toggle checked state (server) | `socket` |

  <!-- tabs-open -->

  ### set_checked

  ```heex
  <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", true)} class="button ui-size-sm">
    Set checked
  </.action>
  <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", false)} class="button ui-size-sm">
    Set unchecked
  </.action>
  <.action phx-click={Corex.Checkbox.toggle_checked("checkbox-api-bind")} class="button ui-size-sm">
    Toggle
  </.action>
  <.checkbox id="checkbox-api-bind" class="checkbox">
    <:label>Terms</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:indeterminate>
      <.heroicon name="hero-minus" />
    </:indeterminate>
  </.checkbox>
  ```

  ### set_checked (dispatch)

  ```javascript
  const el = document.getElementById("checkbox-api-dispatch");

  el?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: true } })
  );

  el?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: false } })
  );

  el?.dispatchEvent(new CustomEvent("corex:checkbox:toggle-checked", { bubbles: false }));
  ```

  ```elixir
  def handle_event("check", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, id, true)}
  end

  def handle_event("uncheck", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, id, false)}
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, id)}
  end
  ```

  <!-- tabs-close -->

  ## Events

  User-driven only. Declarative `checked` may be `true`, `false`, or `:indeterminate`; imperative `set_checked` is always boolean.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_checked_change="checkbox_changed"` | User toggles checked state | `%{"id" => id, "checked" => boolean}` |

  <!-- tabs-open -->

  ### on_checked_change

  ```heex
  <.checkbox
    id="terms"
    class="checkbox"
    on_checked_change="checkbox_changed"
  >
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ```elixir
  def handle_event("checkbox_changed", %{"id" => id, "checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_checked_change_client="checkbox-changed"` | User toggles checked state | `id`, `checked` |

  <!-- tabs-open -->

  ### on_checked_change_client

  ```heex
  <.checkbox
    id="checkbox-on-checked-change-client"
    class="checkbox"
    on_checked_change_client="checkbox-changed"
  >
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ```javascript
  document.getElementById("checkbox-on-checked-change-client")?.addEventListener(
    "checkbox-changed",
    (event) => console.log(event.detail)
  );
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Async

  #### Heex

  ```heex
  <.async_result :let={checkbox} assign={@checkbox}>
    <:loading><.checkbox_skeleton class="checkbox" /></:loading>
    <.checkbox
    id="terms" class="checkbox" checked={checkbox.checked}>
      <:label>Accept terms</:label>
      <:indicator><.heroicon name="hero-check" /></:indicator>
      <:indeterminate><.heroicon name="hero-minus" /></:indeterminate>
    </.checkbox>
  </.async_result>
  ```

  #### Elixir

  ```elixir
  socket =
    assign_async(socket, :checkbox, fn ->
      Process.sleep(1000)
      {:ok, %{checkbox: %{checked: true}}}
    end)
  ```

  ### Controlled (LiveView)

  #### Heex

  ```heex
  <.checkbox
    id="terms"
    class="checkbox"
    controlled
    checked={@checked}
    on_checked_change="patterns_controlled_changed"
  >
    <:label>Accept terms</:label>
    <:indicator><.heroicon name="hero-check" /></:indicator>
    <:indeterminate><.heroicon name="hero-minus" /></:indeterminate>
  </.checkbox>
  ```

  #### Elixir

  ```elixir
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checked, true)}
  end

  def handle_event("patterns_controlled_changed", %{"checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked)}
  end
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or import `checkbox.css` and stack modifiers on the host.

  ```css
  [data-scope="checkbox"][data-part="root"] {}
  [data-scope="checkbox"][data-part="control"] {}
  [data-scope="checkbox"][data-part="label"] {}
  [data-scope="checkbox"][data-part="hidden-input"] {}
  [data-scope="checkbox"][data-part="error"] {}
  ```

  ```css
  @import "../corex/corex.css";
  ```

  Stack modifiers on the host (`class` on `<.checkbox
    id="terms">`). Combine axes, for example `checkbox ui-accent ui-size-lg`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set the checked control fill and indicator ink. Unchecked stays a neutral box; checked and indeterminate use the semantic fill with on-color ink. Checkbox has no variant axis.

  <!-- tabs-open -->

  ### Semantic

  Palette for the checked control fill and indicator ink.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `checkbox` |
  | Accent | `checkbox ui-accent` |
  | Brand | `checkbox ui-brand` |
  | Alert | `checkbox ui-alert` |
  | Info | `checkbox ui-info` |
  | Success | `checkbox ui-success` |

  ```heex
  <.checkbox
    id="terms" class="checkbox" checked>
        <:label>Default</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-accent" checked>
        <:label>Accent</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-brand" checked>
        <:label>Brand</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-alert" checked>
        <:label>Alert</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-info" checked>
        <:label>Info</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-success" checked>
        <:label>Success</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
  ```

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `checkbox ui-size-sm` |
  | Default | `checkbox` |
  | LG | `checkbox ui-size-lg` |
  | XL | `checkbox ui-size-xl` |

  ```heex
  <.checkbox
    id="terms" class="checkbox ui-size-sm">
        <:label>Small</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox">
        <:label>Default</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-size-lg">
        <:label>Large</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
      <.checkbox
    id="terms" class="checkbox ui-size-xl">
        <:label>XLarge</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
      </.checkbox>
  ```

  ### Invalid

  Invalid styles the label and control border. Checked indicators keep their semantic fill color.

  ```heex
  <.checkbox
    id="terms" class="checkbox ui-accent" invalid checked errors={["Required"]}>
    <:label>Subscribe</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  <!-- tabs-close -->

  ## Form

  Set the form `id` in `to_form/2` and use `<.form for={@form}>`. Use `field={@form[:terms]}` so the checkbox name matches the form. For Ecto validation in LiveView, add `phx-change` on the form so params stay in sync.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. With `field={@form[:…]}`, pass `auto_invalid` for alert borders from visible errors, or `invalid={true}` to force the alert state.

  <!-- tabs-open -->

  ### Phoenix Form (changeset)

  #### Heex

  ```heex
      <.form
        :let={f}
        for={@form}
        action="/account/terms"
        method="post"
        class="flex flex-col gap-space-lg w-full max-w-xl"
      >
        <.checkbox
    id="terms" field={f[:terms]} class="checkbox">
          <:label>Accept terms</:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button ui-accent">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def account_terms_page(conn, _params) do
        changeset = MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, %{})

        form =
          Phoenix.Component.to_form(changeset,
            as: :terms_changeset,
            id: "account-terms-changeset-form"
          )

        render(conn, :account_terms, form: form)
      end

      def account_terms_create(conn, %{"terms_changeset" => params}) do
        case MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)
            conn
            |> put_flash(:info, "Saved: terms=#{data.terms}")
            |> redirect(to: "/account")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :terms_changeset,
                id: "account-terms-changeset-form"
              )

            render(conn, :account_terms, form: form)
        end
      end
  ```

  #### Ecto

  ```elixir
      defmodule MyApp.Forms.Terms do
        use Ecto.Schema
        import Ecto.Changeset

        embedded_schema do
          field :terms, :boolean, default: false
        end

        def changeset(terms, attrs \ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```


  For more form patterns (controller, LiveView, Ecto validation), see the [Forms](forms.html) guide.
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
