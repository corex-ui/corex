defmodule Corex.Switch do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Switch](https://zagjs.com/components/react/switch).

  ## Examples
  <!-- tabs-open -->

  ### Basic Usage

  ```heex
  <.switch id="my-switch">
    <:label>Enable notifications</:label>
  </.switch>
  ```

  ### Controlled Mode

  ```heex
  <.switch
    id="my-switch"
    controlled
    checked={@switch_checked}
    on_checked_change="switch_changed">
    <:label>Enable notifications</:label>
  </.switch>
  ```

  ```elixir
  def handle_event("switch_changed", %{"checked" => checked}, socket) do
    {:noreply, assign(socket, :switch_checked, checked)}
  end
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
    <.switch field={f[:notifications_enabled]} class="switch">
      <:label>Enable notifications</:label>
      <:error :let={msg}>
        <.icon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.switch>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  When using Phoenix form in a Live view you must also add controlled mode. This allows the Live view to be the source of truth and the component to be in sync accordingly.

  ```elixir
  defmodule MyAppWeb.SwitchLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      form = to_form(%{"notifications_enabled" => "false"}, as: :user)
      {:ok, assign(socket, :form, form)}
    end

    def render(assigns) do
      ~H"""
      <.form as={:user} for={@form} id={get_form_id(@form)}>
        <.switch field={@form[:notifications_enabled]} class="switch">
          <:label>Enable notifications</:label>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.switch>
        <button type="submit">Submit</button>
      </.form>
      """
    end
  end
  ```

  ### With Ecto changeset

  When using Ecto changeset for validation and inside a Live view you must enable the controlled mode.

  This allows the Live View to be the source of truth and the component to be in sync accordingly.

  First create your schema and changeset:

  ```elixir
  defmodule MyApp.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :notifications_enabled, :boolean, default: false
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:notifications_enabled])
      |> validate_required([:notifications_enabled])
    end
  end
  ```

  ```elixir
  defmodule MyAppWeb.UserLive do
    use MyAppWeb, :live_view
    alias MyApp.Accounts.User

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :form, to_form(User.changeset(%User{}, %{})))}
    end

    def handle_event("validate", %{"user" => user_params}, socket) do
      changeset = User.changeset(%User{}, user_params)
      {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    end

    def render(assigns) do
      ~H"""
      <.form for={@form} id={get_form_id(@form)} phx-change="validate">
        <.switch field={@form[:notifications_enabled]} class="switch" controlled>
          <:label>Enable notifications</:label>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.switch>
      </.form>
      """
    end
  end
  ```

  ## Programmatic Control

  ```heex
  # Client-side
  <button phx-click={Corex.Switch.set_checked("my-switch", true)}>
    Turn On
  </button>

  <button phx-click={Corex.Switch.toggle_checked("my-switch")}>
    Toggle
  </button>

  # Server-side
  def handle_event("turn_on", _, socket) do
    {:noreply, Corex.Switch.set_checked(socket, "my-switch", true)}
  end

  def handle_event("toggle", _, socket) do
    {:noreply, Corex.Switch.toggle_checked(socket, "my-switch")}
  end
  ```

  ## Styling

  Use data attributes to target elements:
  - `[data-scope="switch"][data-part="root"]` - Label wrapper
  - `[data-scope="switch"][data-part="control"]` - Switch track
  - `[data-scope="switch"][data-part="thumb"]` - Switch thumb/handle
  - `[data-scope="switch"][data-part="label"]` - Label text
  - `[data-scope="switch"][data-part="input"]` - Hidden input
  - `[data-scope="switch"][data-part="error"]` - Error message

  State-specific styling:
  - `[data-state="checked"]` - When switch is on
  - `[data-state="unchecked"]` - When switch is off
  - `[data-disabled]` - When switch is disabled
  - `[data-readonly]` - When switch is read-only
  - `[data-invalid]` - When switch has validation errors

  If you wish to use the default Corex styling, you can use the class `switch` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/switch.css";
  ```

  You can then use modifiers

  ```heex
  <.switch class="switch switch--accent switch--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/switch#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Switch.Anatomy.{Props, Root, HiddenInput, Control, Thumb, Label}
  alias Corex.Switch.Connect

  @doc """
  Renders a switch component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the switch, useful for API to identify the switch"
  )

  attr(:checked, :boolean,
    default: false,
    doc: "The initial checked state or the controlled checked state"
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the switch is controlled"
  )

  attr(:name, :string, doc: "The name of the switch input for form submission")

  attr(:form, :string, doc: "The form id to associate the switch with")

  attr(:aria_label, :string,
    default: "Label",
    doc: "The accessible label for the switch"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the switch is disabled"
  )

  attr(:value, :string,
    default: "true",
    doc: "The value of the switch when checked"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the switch. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:read_only, :boolean,
    default: false,
    doc: "Whether the switch is read-only"
  )

  attr(:invalid, :boolean,
    default: false,
    doc: "Whether the switch has validation errors"
  )

  attr(:required, :boolean,
    default: false,
    doc: "Whether the switch is required"
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

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def switch(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign(:checked, Phoenix.HTML.Form.normalize_value("checkbox", field.value))
      |> assign_new(:form, fn -> field.form.id end)

    switch(assigns)
  end

  def switch(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "switch-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)

    ~H"""
    <div
      id={@id}
      phx-hook="Switch"
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
      <label phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir, checked: @checked, changed: Map.get(assigns, :__changed__, nil) != nil})}>
      <input type="hidden" name={@name} value="false" form={@form} disabled={@disabled}/>
      <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, changed: Map.get(assigns, :__changed__, nil) != nil})} />
        <span {Connect.control(%Control{id: @id, dir: @dir, checked: @checked, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          <span {Connect.thumb(%Thumb{id: @id, dir: @dir, checked: @checked, changed: Map.get(assigns, :__changed__, nil) != nil})}></span>
        </span>
        <span
          :if={@label}
          {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, changed: Map.get(assigns, :__changed__, nil) != nil})}
        >
          {render_slot(@label)}
        </span>
      </label>
      <div :if={@error} :for={msg <- @errors} data-scope="switch" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the switch checked state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Switch.set_checked("my-switch", true)}>
        Turn On
      </button>

      <button phx-click={Corex.Switch.set_checked("my-switch", false)}>
        Turn Off
      </button>
  """
  def set_checked(switch_id, checked) when is_binary(switch_id) and is_boolean(checked) do
    Phoenix.LiveView.JS.dispatch("phx:switch:set-checked",
      to: "##{switch_id}",
      detail: %{checked: checked},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the switch checked state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("turn_on", _params, socket) do
        socket = Corex.Switch.set_checked(socket, "my-switch", true)
        {:noreply, socket}
      end
  """
  def set_checked(socket, switch_id, checked)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(switch_id) and
             is_boolean(checked) do
    Phoenix.LiveView.push_event(socket, "switch_set_checked", %{
      switch_id: switch_id,
      checked: checked
    })
  end

  @doc type: :api
  @doc """
  Toggles the switch checked state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Switch.toggle_checked("my-switch")}>
        Toggle
      </button>
  """
  def toggle_checked(switch_id) when is_binary(switch_id) do
    Phoenix.LiveView.JS.dispatch("phx:switch:toggle-checked",
      to: "##{switch_id}",
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Toggles the switch checked state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("toggle", _params, socket) do
        socket = Corex.Switch.toggle_checked(socket, "my-switch")
        {:noreply, socket}
      end
  """
  def toggle_checked(socket, switch_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(switch_id) do
    Phoenix.LiveView.push_event(socket, "switch_toggle_checked", %{
      switch_id: switch_id
    })
  end
end
