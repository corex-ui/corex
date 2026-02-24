defmodule Corex.PasswordInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Password Input](https://zagjs.com/components/react/password-input).

  ## Examples
  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.password_input class="password-input">
    <:label>Password</:label>
    <:visible_indicator><.icon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.icon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
  ```

  ### Custom Error

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.password_input field={@form[:password]} class="password-input">
    <:label>Password</:label>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
    <:visible_indicator><.icon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.icon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
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
  <.form :let={f} as={:user} for={@form} id={get_form_id(@form)} method="post">
    <.password_input field={f[:password]} class="password-input">
      <:label>Password</:label>
      <:error :let={msg}>
        <.icon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
      <:visible_indicator><.icon name="hero-eye" /></:visible_indicator>
      <:hidden_indicator><.icon name="hero-eye-slash" /></:hidden_indicator>
    </.password_input>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### LiveView

  ```elixir
  defmodule MyAppWeb.LoginLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      form = to_form(%{"password" => ""}, as: :user)
      {:ok, assign(socket, :form, form)}
    end

    def render(assigns) do
      ~H"""
      <.form as={:user} for={@form} id={get_form_id(@form)}>
        <.password_input field={@form[:password]} class="password-input">
          <:label>Password</:label>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
          <:visible_indicator><.icon name="hero-eye" /></:visible_indicator>
          <:hidden_indicator><.icon name="hero-eye-slash" /></:hidden_indicator>
        </.password_input>
        <button type="submit">Submit</button>
      </.form>
      """
    end
  end
  ```

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
      <.form for={@form} id={get_form_id(@form)} phx-change="validate">
        <.password_input field={@form[:password]} class="password-input">
          <:label>Password</:label>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
          <:visible_indicator><.icon name="hero-eye" /></:visible_indicator>
          <:hidden_indicator><.icon name="hero-eye-slash" /></:hidden_indicator>
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
    <:visible_indicator><.icon name="hero-eye" /></:visible_indicator>
    <:hidden_indicator><.icon name="hero-eye-slash" /></:hidden_indicator>
  </.password_input>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/password-input#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.PasswordInput.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    Input,
    VisibilityTrigger,
    Indicator
  }

  alias Corex.PasswordInput.Connect

  attr(:id, :string, required: false)
  attr(:visible, :boolean, default: false)
  attr(:controlled_visible, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:ignore_password_managers, :boolean, default: true)
  attr(:name, :string)
  attr(:form, :string)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])

  attr(:auto_complete, :string,
    default: "current-password",
    values: ["current-password", "new-password"]
  )

  attr(:on_visibility_change, :string, default: nil)
  attr(:on_visibility_change_client, :string, default: nil)

  attr(:errors, :list, default: [], doc: "List of error messages to display")

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:password]. Automatically sets id, name, form, invalid state, and errors from the form field"
  )

  attr(:rest, :global)

  slot(:label, required: false)

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  slot(:visible_indicator, required: false, doc: "Icon shown when password is visible")
  slot(:hidden_indicator, required: false, doc: "Icon shown when password is hidden")

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
    assigns =
      assigns
      |> assign_new(:id, fn -> "password-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:dir, fn -> "ltr" end)

    ~H"""
    <div
      id={@id}
      phx-hook="PasswordInput"
      data-no-icon={if @visible_indicator == [] or @hidden_indicator == [], do: "", else: nil}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        visible: @visible,
        controlled_visible: @controlled_visible,
        disabled: @disabled,
        invalid: @invalid,
        read_only: @read_only,
        required: @required,
        ignore_password_managers: @ignore_password_managers,
        name: @name,
        form: @form,
        dir: @dir,
        auto_complete: @auto_complete,
        on_visibility_change: @on_visibility_change,
        on_visibility_change_client: @on_visibility_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <input
            type="password"
            {Connect.input(%Input{
              id: @id,
              disabled: @disabled,
              name: @name,
              form: @form,
              auto_complete: @auto_complete
            })}
          />
          <button
            :if={@visible_indicator != [] and @hidden_indicator != []}
            type="button"
            {Connect.visibility_trigger(%VisibilityTrigger{id: @id, dir: @dir})}
          >
            <span {Connect.indicator(%Indicator{id: @id, dir: @dir})} data-state={if @visible, do: "visible", else: "hidden"}>
              <span data-visible="" aria-hidden="true">{render_slot(@visible_indicator)}</span>
              <span data-hidden="" aria-hidden="true">{render_slot(@hidden_indicator)}</span>
            </span>
          </button>
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="password-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end
end
