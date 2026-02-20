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

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.checkbox class="checkbox">
    <:label>
      Accept the terms
    </:label>
    <:control>
      <.icon name="hero-check" class="data-checked" />
    </:control>
  </.checkbox>
  ```

  ### Custom Error

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.checkbox class="checkbox">
    <:label>
      Accept the terms
    </:label>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>
  ```

  <!-- tabs-close -->

  ## Phoenix Form Integration

  When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

  ### Controller

  ```elixir
  defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  def home(conn, params) do
    form = Phoenix.Component.to_form(Map.get(params, "user", %{}), as: :user)
    render(conn, :home, form: form)
  end
  end
  ```

  ```heex
  <.form :let={f} as={:user} for={@form} id={get_form_id(@form)} method="get">
  <.checkbox field={f[:terms]} class="checkbox">
    <:label>I accept the terms</:label>
      <:error :let={msg}>
    <.icon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
  </.checkbox>
  <button type="submit">Submit</button>
  </.form>
  ```


  ### Live View

  When using Phoenix form in a Live view you must also add controlled mode. This allows the Live view to be the source of truth and the component to be in sync accordingly

  ```elixir
  defmodule MyAppWeb.CheckboxLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    form = to_form(%{"terms" => "false"}, as: :user)
    {:ok, socket |> assign(:form, form)}
  end

  def render(assigns) do
    ~H"""
    <.form as={:user} for={@form} id={get_form_id(@form)}>
    <.checkbox field={@form[:terms]} class="checkbox">
      <:label>I accept the terms</:label>
        <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
    """
  end
  end
  ```

  ### With Ecto changeset

  When using Ecto changeset for validation and inside a Live view you must enable the controlled mode.

  This allows the Live View to be the source of truth and the component to be in sync accordingly

  First lets create an embededed schema and changeset

  ```elixir
  defmodule MyApp.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Account.User

  embedded_schema do
    field :term, :boolean, default: false
  end


  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:term])
    |> validate_required([:term])
    |> validate_acceptance(:terms)
  end
  end
  ```

  ```elixir
  defmodule MyAppWeb.UserLive do
  use MyAppWeb, :live_view
  alias MyApp.Account.User

  @impl true

  def mount(_params, _session, socket) do
    {:ok,  assign(socket, :form, to_form(User.changeset(%User{}, %{})))}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = User.changeset(%User{}, user_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.form for={@form} id={get_form_id(@form)} phx-change="validate">
      <.checkbox field={@form[:terms]} class="checkbox" controlled>
        <:label>I accept the terms</:label>
        <:error :let={msg}>
          <.icon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>
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

  alias Corex.Checkbox.Anatomy.{Props, Root, HiddenInput, Control, Label, Indicator}
  alias Corex.Checkbox.Connect

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

  slot :control, required: false do
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
      |> assign(:checked, Phoenix.HTML.Form.normalize_value("checkbox", field.value))
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

      <label {Connect.root(%Root{id: @id, dir: @dir, checked: @checked})}>
      <input type="hidden" name={@name} value="false" form={@form} disabled={@disabled}/>

      <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value})} />
      <div {Connect.control(%Control{id: @id, dir: @dir, checked: @checked})}>
          <span {Connect.indicator(%Indicator{id: @id, dir: @dir, checked: @checked})}>
          {render_slot(@control)}
          </span>
      </div>
      <span :if={@label} {Connect.label(%Label{id: @id, dir: @dir, checked: @checked})}>
      {render_slot(@label)}
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
    Phoenix.LiveView.JS.dispatch("phx:checkbox:set-checked",
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
    Phoenix.LiveView.push_event(socket, "checkbox_set_checked", %{
      checkbox_id: checkbox_id,
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
    Phoenix.LiveView.JS.dispatch("phx:checkbox:toggle-checked",
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
    Phoenix.LiveView.push_event(socket, "checkbox_toggle_checked", %{
      checkbox_id: checkbox_id
    })
  end
end
