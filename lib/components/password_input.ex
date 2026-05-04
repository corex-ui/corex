defmodule Corex.PasswordInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Password Input](https://zagjs.com/components/react/password-input).

  ## API

  Client DOM dispatches:

  - `corex:password-input:set-visible` — `detail.visible` boolean
  - `corex:password-input:toggle-visible`
  - `corex:password-input:focus`

  Server pushes (from `set_visible/3`, `toggle_visible/2`, `focus/2`):

  - `password_input_set_visible` — `%{"id" => id, "visible" => boolean}`
  - `password_input_toggle_visible` — `%{"id" => id}`
  - `password_input_focus` — `%{"id" => id}`

  ## Examples
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

  ## Phoenix Form Integration

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

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="password-input"][data-part="root"] {}
  [data-scope="password-input"][data-part="label"] {}
  [data-scope="password-input"][data-part="control"] {}
  [data-scope="password-input"][data-part="input"] {}
  [data-scope="password-input"][data-part="visibility-trigger"] {}
  [data-scope="password-input"][data-part="indicator"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `password-input` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/password-input.css";
  ```

  You can then use modifiers

  ```heex
  <.password_input class="password-input password-input--accent password-input--lg">
    <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
  ```

  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for PasswordInput component strings.

    Without gettext: `translation={%PasswordInput.Translation{ toggle_visibility: "Toggle password visibility" }}`

    With gettext: `translation={%PasswordInput.Translation{ toggle_visibility: gettext("Toggle password visibility") }}`
    """
    defstruct [:toggle_visibility]
  end

  @doc type: :component
  use Phoenix.Component

  import Corex.Gettext, only: [gettext: 1]

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
  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"])
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
    default_translation = %Translation{toggle_visibility: gettext("Toggle password visibility")}

    assigns =
      assigns
      |> assign_new(:id, fn -> "password-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))

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

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      toggle_visibility: partial.toggle_visibility || default.toggle_visibility
    }
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
