defmodule Corex.PasswordInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Password Input](https://zagjs.com/components/react/password-input).

  ## Anatomy
  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.password_input class="password-input">
    <:label>Password</:label>
    <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
  ```

  ### Custom Error

  ```heex
  <.password_input field={@form[:password]} class="password-input">
    <:label>Password</:label>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
    <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
  ```

  <!-- tabs-close -->

  ## Form

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `id={@form.id}` on `<.form>`.

  ### Controller

  Build the form from an Ecto changeset:

  ```elixir
  def form_page(conn, _params) do
    form =
      %MyApp.Form.PasswordForm{}
      |> MyApp.Form.PasswordForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :password_form, id: "password-form")
    render(conn, :form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} id={@form.id} action={@action} method="post">
    <.password_input field={f[:password]} class="password-input">
      <:label>Password</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
      <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
    </.password_input>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  Prefer building the form from an Ecto changeset (see "With Ecto changeset" below).

  ### With Ecto changeset

  First create your schema and changeset:

  ```elixir
  defmodule MyApp.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :email, :string
      field :password, :string
      timestamps(type: :utc_datetime)
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:email, :password])
      |> validate_required([:email, :password])
      |> validate_length(:password, min: 8)
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
      <.form for={@form} id={@form.id} phx-change="validate">
        <.password_input field={@form[:password]} class="password-input">
          <:label>Password</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
          <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
          <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
        </.password_input>
      </.form>
      """
    end
  end
  ```

  ## API

  Requires a stable `id` on `<.password_input>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_visible/2`](#set_visible/2) | Set visibility (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_visible/3`](#set_visible/3) | Set visibility (server) | `socket` |
  | [`toggle_visible/1`](#toggle_visible/1) | Toggle visibility (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_visible/2`](#toggle_visible/2) | Toggle visibility (server) | `socket` |
  | [`focus/1`](#focus/1) | Focus input (client) | `%Phoenix.LiveView.JS{}` |
  | [`focus/2`](#focus/2) | Focus input (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.password_input>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_visibility_change="password_visibility_changed"` | Visibility toggles | `%{"id" => id, "visible" => boolean}` |

  <!-- tabs-open -->

  ### on_visibility_change

  ```heex
  <.password_input
    id="password-events"
    class="password-input"
    on_visibility_change="password_visibility_changed"
  >
    <:label>Password</:label>
    <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
  ```

  ```elixir
  def handle_event("password_visibility_changed", %{"id" => _id, "visible" => visible}, socket) do
    {:noreply, assign(socket, :password_visible, visible)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_visibility_change_client="password-visibility-changed"` | Visibility toggles | `id`, `visible` |

  ## Style

  Use data attributes to target elements:

  ```css
  [data-scope="password-input"][data-part="root"] {}
  [data-scope="password-input"][data-part="label"] {}
  [data-scope="password-input"][data-part="control"] {}
  [data-scope="password-input"][data-part="input"] {}
  [data-scope="password-input"][data-part="visibility-trigger"] {}
  [data-scope="password-input"][data-part="indicator"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/password-input.css";
  ```

  Stack modifiers on the host (`class` on `<.password_input>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `password-input` |
  | Accent | `password-input password-input--accent` |
  | Brand | `password-input password-input--brand` |
  | Alert | `password-input password-input--alert` |
  | Info | `password-input password-input--info` |
  | Success | `password-input password-input--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `password-input password-input--sm` |
  | MD | `password-input password-input--md` |
  | LG | `password-input password-input--lg` |
  | XL | `password-input password-input--xl` |

  <!-- tabs-close -->

  '''

  defmodule Translation do
    @moduledoc """
    Translatable strings for the password input.

    Pass `translation={%Corex.PasswordInput.Translation{}}` to override any field. Omitted fields use gettext defaults from [`default/0`](#default/0).

    | Field | Default | Used for |
    | ----- | ------- | -------- |
    | `toggle_visibility` | Toggle password visibility | Visibility trigger `aria-label` |
    """

    alias Corex.Gettext

    defstruct [:toggle_visibility]

    @type t :: %__MODULE__{toggle_visibility: String.t()}

    def default do
      %__MODULE__{toggle_visibility: Gettext.gettext("Toggle password visibility")}
    end

    def merge(nil, default), do: default

    def merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
      %__MODULE__{
        toggle_visibility:
          Corex.Translation.take(partial.toggle_visibility, default.toggle_visibility)
      }
    end
  end

  @doc type: :component
  use Phoenix.Component

  alias Corex.PasswordInput.Anatomy.{
    Control,
    Indicator,
    Input,
    Label,
    Props,
    Root,
    VisibilityTrigger
  }

  alias Corex.PasswordInput.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:visible, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:ignore_password_managers, :boolean, default: true)
  attr(:name, :string)
  attr(:form, :string)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])

  attr(:auto_complete, :string,
    default: "current-password",
    values: ["current-password", "new-password"]
  )

  attr(:on_visibility_change, :string, default: nil)
  attr(:on_visibility_change_client, :string, default: nil)

  attr(:errors, :list, default: [], doc: "List of error messages to display")

  attr(:translation, Corex.PasswordInput.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:password]. Automatically sets id, name, form, invalid state, and errors from the form field"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  slot :visible_indicator, required: false, doc: "Icon shown when password is visible" do
    attr(:class, :string, required: false)
  end

  slot :hidden_indicator, required: false, doc: "Icon shown when password is hidden" do
    attr(:class, :string, required: false)
  end

  def password_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:form, fn -> field.form.id end)
      |> assign(field: nil)

    password_input(assigns)
  end

  def password_input(assigns) do
    translation = Translation.merge(assigns.translation, Translation.default())

    assigns =
      assigns
      |> assign_new(:id, fn -> "password-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign(:translation, translation)

    ~H"""
    <div
      id={@id}
      phx-hook="PasswordInput"
      data-loading 
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}     
      data-no-icon={if @visible_indicator == [] or @hidden_indicator == [], do: "", else: nil}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        visible: @visible,
        disabled: @disabled,
        invalid: @invalid,
        read_only: @read_only,
        required: @required,
        ignore_password_managers: @ignore_password_managers,
        name: @name,
        form: @form,
        dir: @dir,
        orientation: @orientation,
        auto_complete: @auto_complete,
        on_visibility_change: @on_visibility_change,
        on_visibility_change_client: @on_visibility_change_client
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <label :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, orientation: @orientation})} {Connect.label(%Label{id: @id, orientation: @orientation})}>
          {render_slot(@label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, orientation: @orientation})} {Connect.control(%Control{id: @id, orientation: @orientation})}>
          <input
            type="password"
            phx-mounted={Connect.ignore_input(%Input{
              id: @id,
              disabled: @disabled,
              name: @name,
              form: @form,
              auto_complete: @auto_complete,
              orientation: @orientation
            })}
            {Connect.input(%Input{
              id: @id,
              disabled: @disabled,
              name: @name,
              form: @form,
              auto_complete: @auto_complete,
              orientation: @orientation
            })}
          />
          <button
            :if={@visible_indicator != [] and @hidden_indicator != []}
            type="button"
            phx-mounted={Connect.ignore_visibility_trigger(%VisibilityTrigger{id: @id, aria_label: @translation.toggle_visibility, orientation: @orientation})}
            {Connect.visibility_trigger(%VisibilityTrigger{id: @id, aria_label: @translation.toggle_visibility, orientation: @orientation})}
          >
            <span phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, visible: @visible, orientation: @orientation})} {Connect.indicator(%Indicator{id: @id, visible: @visible, orientation: @orientation})}>
              <span data-visible="" aria-hidden="true">{render_slot(@visible_indicator)}</span>
              <span data-hidden="" aria-hidden="true">{render_slot(@hidden_indicator)}</span>
            </span>
          </button>
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} class={Map.get(Enum.at(@error, 0), :class, nil)} data-scope="password-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  @doc type: :api
  def set_visible(password_input_id, visible)
      when is_binary(password_input_id) and is_boolean(visible) do
    JS.dispatch("corex:password-input:set-visible",
      to: "##{password_input_id}",
      detail: %{visible: visible},
      bubbles: false
    )
  end

  def set_visible(socket, password_input_id, visible)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(password_input_id) and
             is_boolean(visible) do
    LiveView.push_event(socket, "password_input_set_visible", %{
      "id" => password_input_id,
      "visible" => visible
    })
  end

  @doc type: :api
  def toggle_visible(password_input_id) when is_binary(password_input_id) do
    JS.dispatch("corex:password-input:toggle-visible",
      to: "##{password_input_id}",
      bubbles: false
    )
  end

  def toggle_visible(socket, password_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(password_input_id) do
    LiveView.push_event(socket, "password_input_toggle_visible", %{"id" => password_input_id})
  end

  @doc type: :api
  def focus(password_input_id) when is_binary(password_input_id) do
    JS.dispatch("corex:password-input:focus", to: "##{password_input_id}", bubbles: false)
  end

  def focus(socket, password_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(password_input_id) do
    LiveView.push_event(socket, "password_input_focus", %{"id" => password_input_id})
  end
end
