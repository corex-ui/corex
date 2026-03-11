defmodule Corex.Checkbox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Checkbox](https://zagjs.com/components/react/checkbox).

  ## Examples
  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.checkbox class="checkbox">
    <:label>Accept terms</:label>
  </.checkbox>
  ```

  ### Custom Control

  ```heex
  <.checkbox class="checkbox">
    <:label>
      Accept the terms
    </:label>
    <:indicator>
      <.heroicon name="hero-check" class="data-checked" />
    </:indicator>
  </.checkbox>
  ```

  ### Custom Error

  ```heex
  <.checkbox class="checkbox">
    <:label>
      Accept the terms
    </:label>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  <!-- tabs-close -->

  ## Phoenix Form Integration

  When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

  ### Controller

  Build the form from an Ecto changeset and pass it to the template. Use `Corex.Form.get_form_id/1` for the form `id`:

  ```elixir
  def checkbox_form_page(conn, _params) do
    form =
      %MyApp.Form.Terms{}
      |> MyApp.Form.Terms.changeset(%{})
      |> Phoenix.Component.to_form(as: :terms, id: "checkbox-form")
    render(conn, :checkbox_form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} id={Corex.Form.get_form_id(@form)} action={@action} method="post">
    <.checkbox field={f[:terms]} class="checkbox">
      <:label>Accept terms</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
  ```


  ### Live View

  When using Phoenix form in a Live view you must also add controlled mode. Prefer building the form from an Ecto changeset (see "With Ecto changeset" below).

  ### With Ecto changeset (LiveView)

  When using an Ecto changeset for validation in a LiveView, enable the `controlled` attribute on the checkbox so the LiveView remains the source of truth.

  Schema and changeset:

  ```elixir
  defmodule MyApp.Form.Terms do
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
  end
  ```

  LiveView with validate and submit:

  ```elixir
  defmodule MyAppWeb.CheckboxFormLive do
    use MyAppWeb, :live_view
    alias MyApp.Form.Terms
    alias Corex.Form

    def mount(_params, _session, socket) do
      form = %Terms{} |> Terms.changeset(%{}) |> to_form(as: :terms)
      {:ok, assign(socket, :form, form)}
    end

    def handle_event("validate", %{"terms" => params}, socket) do
      changeset = Terms.changeset(%Terms{}, params)
      {:noreply, assign(socket, :form, to_form(changeset, action: :validate, as: :terms))}
    end

    def handle_event("save", %{"terms" => params}, socket) do
      case Terms.changeset(%Terms{}, params) do
        %Ecto.Changeset{valid?: true} = _ ->
          {:noreply, assign(socket, :form, to_form(Terms.changeset(%Terms{}, %{}), as: :terms))}
        changeset ->
          {:noreply, assign(socket, :form, to_form(changeset, action: :insert, as: :terms))}
      end
    end

    def render(assigns) do
      ~H"""
      <.form for={@form} id={Form.get_form_id(@form)} phx-change="validate" phx-submit="save">
        <.checkbox field={@form[:terms]} class="checkbox" controlled>
          <:label>Accept terms</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>
        <button type="submit">Submit</button>
      </.form>
      """
    end
  end
  ```

  ## API Control

  ```heex
  # Client-side
  <button phx-click={Corex.Checkbox.set_checked("my-checkbox", true)}>
    Check
  </button>

  <button phx-click={Corex.Checkbox.toggle_checked("my-checkbox")}>
    Toggle
  </button>

  # Server-side
  def handle_event("check", _, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, "my-checkbox", true)}
  end

  def handle_event("toggle", _, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, "my-checkbox")}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="checkbox"][data-part="root"] {}
  [data-scope="checkbox"][data-part="control"] {}
  [data-scope="checkbox"][data-part="label"] {}
  [data-scope="checkbox"][data-part="input"] {}
  [data-scope="checkbox"][data-part="error"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `checkbox` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/checkbox.css";
  ```

  You can then use modifiers

  ```heex
  <.checkbox class="checkbox checkbox--accent checkbox--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/checkbox#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Checkbox.Anatomy.{Control, HiddenInput, Indicator, Label, Props, Root}
  alias Corex.Checkbox.Connect
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

  attr(:checked, :boolean,
    default: false,
    doc: "The initial checked state or the controlled checked state"
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
    doc: "The server event name when the checked state changes"
  )

  attr(:on_checked_change_client, :string,
    default: nil,
    doc: "The client event name when the checked state changes"
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

    ~H"""
    <div
      id={@id}
      phx-hook="Checkbox"
      data-js="pending"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        checked: @checked,
        name: @name,
        form: @form,
        dir: @dir,
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

      <label {Connect.root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
      <input type="hidden" name={@name} value="false" form={@form} disabled={@disabled}/>

      <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value})} />
      <div {Connect.control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
          <span {Connect.indicator(%Indicator{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
          {render_slot(@indicator)}
          </span>
      </div>
      <span :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
      {render_slot(@label)}
      </span>
      <span :if={@label == [] && @aria_label} class="sr-only" {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
      {@aria_label}
      </span>
      </label>
      <div :if={@error} :for={msg <- @errors} data-scope="checkbox" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the checkbox checked state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Checkbox.set_checked("my-checkbox", true)}>
        Check
      </button>

      <button phx-click={Corex.Checkbox.set_checked("my-checkbox", false)}>
        Uncheck
      </button>
  """
  def set_checked(checkbox_id, checked) when is_binary(checkbox_id) and is_boolean(checked) do
    JS.dispatch("phx:checkbox:set-checked",
      to: "##{checkbox_id}",
      detail: %{checked: checked},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the checkbox checked state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("check", _params, socket) do
        socket = Corex.Checkbox.set_checked(socket, "my-checkbox", true)
        {:noreply, socket}
      end
  """
  def set_checked(socket, checkbox_id, checked)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(checkbox_id) and
             is_boolean(checked) do
    LiveView.push_event(socket, "checkbox_set_checked", %{
      id: checkbox_id,
      checked: checked
    })
  end

  @doc type: :api
  @doc """
  Toggles the checkbox checked state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Checkbox.toggle_checked("my-checkbox")}>
        Toggle
      </button>
  """
  def toggle_checked(checkbox_id) when is_binary(checkbox_id) do
    JS.dispatch("phx:checkbox:toggle-checked",
      to: "##{checkbox_id}",
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Toggles the checkbox checked state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("toggle", _params, socket) do
        socket = Corex.Checkbox.toggle_checked(socket, "my-checkbox")
        {:noreply, socket}
      end
  """
  def toggle_checked(socket, checkbox_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(checkbox_id) do
    LiveView.push_event(socket, "checkbox_toggle_checked", %{
      id: checkbox_id
    })
  end
end
