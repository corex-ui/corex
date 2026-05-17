defmodule Corex.Checkbox do
  @moduledoc ~S'''
    Phoenix implementation of [Zag.js Checkbox](https://zagjs.com/components/react/checkbox).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.checkbox id="checkbox-anatomy-minimal" class="checkbox">
    <:label>Option</:label>
  </.checkbox>
  ```

  ### Label and indicator

  ```heex
  <.checkbox id="checkbox-anatomy-labeled" class="checkbox">
    <:label>Accept the terms</:label>
    <:indicator>
      <.heroicon name="hero-check" />
    </:indicator>
  </.checkbox>
  ```

  ### Invalid

  ```heex
  <.checkbox id="checkbox-anatomy-invalid" class="checkbox" invalid errors={["Required"]}>
    <:label>Subscribe</:label>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  ### Indeterminate

  ```heex
  <.checkbox id="checkbox-anatomy-indeterminate" class="checkbox" checked={:indeterminate}>
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

  Requires a stable `id` on `<.checkbox>`. Imperative helpers set or toggle checked state (boolean only; clears indeterminate).

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_checked/2`](#set_checked/2) | Set checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_checked/3`](#set_checked/3) | Set checked state (server) | `socket` |
  | [`toggle_checked/1`](#toggle_checked/1) | Toggle checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_checked/2`](#toggle_checked/2) | Toggle checked state (server) | `socket` |

  <!-- tabs-open -->

  ### set_checked

  ```heex
  <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", true)} class="button button--sm">
    Set checked
  </.action>
  <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", false)} class="button button--sm">
    Set unchecked
  </.action>
  <.action phx-click={Corex.Checkbox.toggle_checked("checkbox-api-bind")} class="button button--sm">
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
  document.getElementById("checkbox-api-dispatch")?.dispatchEvent(
    new CustomEvent("corex:checkbox:set-checked", {
      bubbles: true,
      detail: { checked: true }
    })
  );
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
    id="checkbox-on-checked-change-server"
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
    <.checkbox id="patterns-checkbox-async" class="checkbox" checked={checkbox.checked}>
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
    id="patterns-checkbox-controlled"
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
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/checkbox.css";
  ```

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `checkbox` |
  | Accent | `checkbox checkbox--accent` |
  | Brand | `checkbox checkbox--brand` |
  | Alert | `checkbox checkbox--alert` |
  | Info | `checkbox checkbox--info` |
  | Success | `checkbox checkbox--success` |

  ```heex
  <.checkbox class="checkbox" checked>
        <:label>Default</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox checkbox--accent" checked>
        <:label>Accent</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox checkbox--brand" checked>
        <:label>Brand</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox checkbox--alert" checked>
        <:label>Alert</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox checkbox--info" checked>
        <:label>Info</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox class="checkbox checkbox--success" checked>
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
  | SM | `checkbox checkbox--sm` |
  | Default | `checkbox` |
  | LG | `checkbox checkbox--lg` |
  | XL | `checkbox checkbox--xl` |

  ```heex
  <.checkbox class="checkbox checkbox--sm">
        <:label>Small</:label>
      </.checkbox>
      <.checkbox class="checkbox">
        <:label>Default</:label>
      </.checkbox>
      <.checkbox class="checkbox checkbox--lg">
        <:label>Large</:label>
      </.checkbox>
      <.checkbox class="checkbox checkbox--xl">
        <:label>XLarge</:label>
      </.checkbox>
  ```

  <!-- tabs-close -->

  ## Form

  Set the form `id` in `to_form/2` and use `id={@form.id}` on `<.form>`. In LiveView, pass `controlled` on `<.checkbox>` so the server stays the source of truth.

  <!-- tabs-open -->

  ### Phoenix Form (changeset)

  #### Heex

  ```heex
      <.form
        :let={f}
        for={@form}
        action={~p"/account/terms"}
        method="post"
        id={@form.id}
        class="w-full max-w-2xs flex flex-col gap-space items-center"
      >
        <.checkbox field={f[:terms]} class="checkbox" id="account-terms-acceptance">
          <:label>Accept terms</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button button--accent w-full">
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
            |> redirect(to: ~p"/account")

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

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### Ecto changeset (validation)

  #### Heex

  ```heex
      <.form
        :let={f}
        for={@form}
        action={~p"/account/terms-strict"}
        method="post"
        id={@form.id}
        class="w-full max-w-2xs flex flex-col gap-space items-center"
      >
        <.checkbox field={f[:terms]} class="checkbox" id="account-terms-strict">
          <:label>Accept terms (strict messages)</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" class="button button--accent w-full">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def account_terms_strict_page(conn, _params) do
        changeset =
          MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, %{})

        form =
          Phoenix.Component.to_form(changeset,
            as: :terms_validate,
            id: "account-terms-validate-form"
          )

        render(conn, :account_terms_strict, form: form)
      end

      def account_terms_strict_create(conn, %{"terms_validate" => params}) do
        case MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)
            conn
            |> put_flash(:info, "Saved: terms=#{data.terms}")
            |> redirect(to: ~p"/account")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :terms_validate,
                id: "account-terms-validate-form"
              )

            render(conn, :account_terms_strict, form: form)
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

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### Native form (plain HTML)

  ```heex
      <form
        action={~p"/register"}
        method="post"
        class="w-full max-w-2xs flex flex-col gap-space items-center"
      >
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
        <.checkbox
          name="user[accept_terms]"
          class="checkbox"
          id="register-accept-terms"
        >
          <:label>Accept terms</:label>
        </.checkbox>
        <.action type="submit" class="button button--accent w-full">Submit</.action>
      </form>
  ```

  ### LiveView · Phoenix Form (changeset)

  #### Heex

  ```heex
      <.form
        for={@form}
        id={@form.id}
        phx-change="validate"
        phx-submit="save"
        class="w-full max-w-2xs flex flex-col gap-space items-center"
      >
        <.checkbox field={@form[:terms]} class="checkbox" controlled id="checkbox-form-live-terms">
          <:label>Accept terms</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" id="checkbox-form-live-submit" class="button button--accent w-full">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def mount(_params, _session, socket) do
        form =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset(%{})
          |> Phoenix.Component.to_form(as: :terms)

        {:ok, assign(socket, :form, form)}
      end

      def handle_event("validate", %{"terms" => params}, socket) do
        changeset =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset(params)
          |> Map.put(:action, :validate)

        {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :validate, as: :terms))}
      end

      def handle_event("save", %{"terms" => params}, socket) do
        case MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = _changeset ->
            {:noreply, assign(socket, :form, Phoenix.Component.to_form(MyApp.Forms.Terms.changeset(%MyApp.Forms.Terms{}, %{}), as: :terms))}

          changeset ->
            {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :insert, as: :terms))}
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

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  ### LiveView · Ecto Changeset (validation)

  #### Heex

  ```heex
      <.form
        for={@form}
        id={@form.id}
        phx-change="validate_strict"
        phx-submit="save_strict"
        class="w-full max-w-2xs flex flex-col gap-space items-center"
      >
        <.checkbox field={@form[:terms]} class="checkbox" controlled id="checkbox-form-live-strict">
          <:label>Accept terms</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <.action type="submit" id="checkbox-form-live-strict-submit" class="button button--accent w-full">
          Submit
        </.action>
      </.form>
  ```

  #### Elixir

  ```elixir
      def mount(_params, _session, socket) do
        form =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :terms_strict)

        {:ok, assign(socket, :strict_form, form)}
      end

      def handle_event("validate_strict", %{"terms_strict" => params}, socket) do
        changeset =
          %MyApp.Forms.Terms{}
          |> MyApp.Forms.Terms.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(socket, :strict_form, Phoenix.Component.to_form(changeset, action: :validate, as: :terms_strict))}
      end

      def handle_event("save_strict", %{"terms_strict" => params}, socket) do
        case MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = _changeset ->
            {:noreply,
             assign(
               socket,
               :strict_form,
               Phoenix.Component.to_form(MyApp.Forms.Terms.changeset_validate(%MyApp.Forms.Terms{}, %{}), as: :terms_strict)
             )}

          changeset ->
            {:noreply, assign(socket, :strict_form, Phoenix.Component.to_form(changeset, action: :insert, as: :terms_strict))}
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

        def changeset(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms])
          |> validate_acceptance(:terms)
        end

        def changeset_validate(terms, attrs \\ %{}) do
          terms
          |> cast(attrs, [:terms])
          |> validate_required([:terms], message: "can't be blank")
          |> validate_acceptance(:terms, message: "must be accepted to continue")
        end
      end
  ```

  <!-- tabs-close -->
  '''

  @doc type: :component
  use Phoenix.Component

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
  alias Corex.Helpers
  alias Phoenix.HTML.Form
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a checkbox component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the checkbox, useful for API to identify the checkbox"
  )

  attr(:checked, :any,
    default: false,
    doc:
      "Checked state: true, false, or :indeterminate (Zag CheckedState). Form fields still use boolean."
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the checkbox is controlled"
  )

  attr(:name, :string, doc: "The name of the checkbox input for form submission")

  attr(:form, :string, doc: "The form id to associate the checkbox with")

  attr(:aria_label, :string,
    default: "Label",
    doc: "The accessible label for the checkbox"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the checkbox is disabled"
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

  attr(:read_only, :boolean,
    default: false,
    doc: "Whether the checkbox is read-only"
  )

  attr(:invalid, :boolean,
    default: false,
    doc: "Whether the checkbox has validation errors"
  )

  attr(:required, :boolean,
    default: false,
    doc: "Whether the checkbox is required"
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

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:email]. Automatically sets id, name, checked state, and errors from the form field"
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
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign(:checked, Form.normalize_value("checkbox", field.value))
      |> assign_new(:form, fn -> field.form.id end)

    checkbox(assigns)
  end

  def checkbox(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "checkbox-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)
      |> assign(:checked, Helpers.normalize_checkbox_checked(assigns.checked))

    ~H"""
    <div
      id={@id}
      phx-hook="Checkbox"
      data-loading 
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}     
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        checked: @checked,
        name: @name,
        form: @form,
        dir: @dir,
        orientation: @orientation,
        read_only: @read_only,
        invalid: @invalid,
        required: @required,
        on_checked_change: @on_checked_change,
        on_checked_change_client: @on_checked_change_client,
        label: @aria_label,
        disabled: @disabled,
        value: @value
      })}
    >

      <label phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
      <input type="hidden" name={@name} value="false" form={@form} disabled={@disabled}/>

      <input
        phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, controlled: @controlled})}
        {Connect.hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, controlled: @controlled})}
      />
      <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
          <span
            :if={@indicator != []}
            phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
            {Connect.indicator(%Indicator{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          >
          {render_slot(@indicator)}
          </span>
          <span
            :if={@indeterminate != []}
            phx-mounted={Connect.ignore_indeterminate(%Indeterminate{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
            {Connect.indeterminate(%Indeterminate{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          >
          {render_slot(@indeterminate)}
          </span>
      </div>
      <span
        :if={@label != []}
        phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
      >
      {render_slot(@label)}
      </span>
      <span
        :if={@label == [] && @aria_label}
        class="sr-only"
        phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
      >
      {@aria_label}
      </span>
      </label>
      <div :if={@error} :for={msg <- @errors} data-scope="checkbox" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

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

  @doc type: :api
  @doc """
  Sets checked state from the client.

  Returns `%Phoenix.LiveView.JS{}` dispatching `corex:checkbox:set-checked` on the checkbox element with
  `detail: %{checked: boolean}`. Clears indeterminate when applied.
  """
  def set_checked(checkbox_id, checked) when is_binary(checkbox_id) and is_boolean(checked) do
    JS.dispatch("corex:checkbox:set-checked",
      to: "##{checkbox_id}",
      detail: %{checked: checked},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets checked state from the server.

  `push_event("checkbox_set_checked", %{"id" => checkbox_id, "checked" => boolean})`. No reply event.
  """
  def set_checked(socket, checkbox_id, checked)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(checkbox_id) and
             is_boolean(checked) do
    LiveView.push_event(socket, "checkbox_set_checked", %{
      "id" => checkbox_id,
      "checked" => checked
    })
  end

  @doc type: :api
  @doc """
  Toggles checked state from the client.

  Returns `%Phoenix.LiveView.JS{}` dispatching `corex:checkbox:toggle-checked` on the checkbox element with empty `detail`.
  """
  def toggle_checked(checkbox_id) when is_binary(checkbox_id) do
    JS.dispatch("corex:checkbox:toggle-checked",
      to: "##{checkbox_id}",
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Toggles checked state from the server.

  `push_event("checkbox_toggle_checked", %{"id" => checkbox_id})`. No reply event.
  """
  def toggle_checked(socket, checkbox_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(checkbox_id) do
    LiveView.push_event(socket, "checkbox_toggle_checked", %{"id" => checkbox_id})
  end
end
