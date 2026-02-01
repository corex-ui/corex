defmodule Corex.Switch do
  @moduledoc """
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

  When using with Phoenix forms, the switch automatically integrates with form validation:

  ```heex
  <.form for={@form} phx-change="validate" phx-submit="save">
    <.switch field={@form[:terms_accepted]}>
      <:label>I accept the terms and conditions</:label>
      <:error :let={msg}>{msg}</:error>
    </.switch>
  </.form>
  ```

  The `field` attribute automatically handles:
  - Setting the `id` from the form field
  - Setting the `name` for form submission
  - Mapping the form value to the `checked` state
  - Displaying validation errors
  - Integration with Phoenix changesets

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
  """

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

  attr(:form, :string,
    default: nil,
    doc: "The form id to associate the switch with"
  )

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
    default: "ltr",
    values: ["ltr", "rtl"],
    doc: "The direction of the switch"
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
    errors = field.errors || []

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign(:checked, Phoenix.HTML.Form.normalize_value("checkbox", field[:value]))
    |> switch()
  end

  def switch(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "switch-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)

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
      <label {Connect.root(%Root{id: @id, dir: @dir, checked: @checked, changed: Map.get(assigns, :__changed__, nil) != nil})}>
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
