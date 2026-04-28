defmodule E2eWeb.Demos.PasswordInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.password_input id="password-input-anatomy-basic" name="user[password]" class="password-input">
      <:label>Password</:label>
    </.password_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.password_input id="password-input-anatomy-basic" name="user[password]" class="password-input">
      <:label>Password</:label>
    </.password_input>
    """
  end

  def with_visibility_icons_code do
    ~S"""
    <.password_input id="password-input-anatomy-icons" name="user[password]" class="password-input">
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def with_visibility_icons_example(assigns) do
    ~H"""
    <.password_input id="password-input-anatomy-icons" name="user[password]" class="password-input">
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_binding_heex do
    ~S"""
    <.password_input
      id="password-input-api-binding"
      class="password-input"
      name="user[password]"
      on_visibility_change="password_input_api_visibility"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_binding_elixir do
    ~S"""
    def handle_event("password_input_api_visibility", %{"id" => id, "visible" => visible}, socket) do
      {:noreply, socket}
    end
    """
  end

  def api_binding_example(assigns) do
    ~H"""
    <.password_input
      id="password-input-api-binding"
      class="password-input"
      name="user[password]"
      on_visibility_change="password_input_api_visibility"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_client_heex do
    ~S"""
    <.password_input
      id="password-input-api-client"
      class="password-input"
      name="user[password]"
      on_visibility_change_client="password-input-api-visibility-changed"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_client_js do
    ~S"""
    const el = document.getElementById("password-input-api-client");
    el?.addEventListener("password-input-api-visibility-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def api_client_ts do
    ~S"""
    const el = document.getElementById("password-input-api-client");
    el?.addEventListener("password-input-api-visibility-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id?: string; visible?: boolean }>).detail);
    });
    """
  end

  def api_client_example(assigns) do
    ~H"""
    <.password_input
      id="password-input-api-client"
      class="password-input"
      name="user[password]"
      on_visibility_change_client="password-input-api-visibility-changed"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_initial_heex do
    ~S"""
    <.password_input
      id="password-input-api-initial"
      class="password-input"
      name="user[password]"
      visible
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_initial_elixir do
    ~S"""
    # Initial visibility: pass visible={true} on the component.
    # The hook reads data-default-visible on mount; LiveView does not control visibility after that.
    """
  end

  def api_initial_example(assigns) do
    ~H"""
    <.password_input
      id="password-input-api-initial"
      class="password-input"
      name="user[password]"
      visible
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_overview_code, do: api_binding_heex()
  def api_overview_example(assigns), do: api_binding_example(assigns)

  def events_server_heex do
    ~S"""
    <.password_input
      id="password-input-events-server"
      class="password-input"
      name="user[password]"
      on_visibility_change="password_visibility_changed"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event(\"password_visibility_changed\", %{\"id\" => id, \"visible\" => visible}, socket) do
      log = %{time: \"12:00:00\", source: \"server\", value: inspect(visible)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.password_input
      id="password-input-events-client"
      class="password-input"
      name="user[password]"
      on_visibility_change_client="password-visibility-changed"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById(\"password-input-events-client\");
    el?.addEventListener(\"password-visibility-changed\", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById(\"password-input-events-client\");
    el?.addEventListener(\"password-visibility-changed\", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.PasswordForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :password, :string, redact: true
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:password])
        |> validate_required(:password)
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:password])
        |> validate_required([:password], message: "can't be blank")
        |> validate_length(:password, min: 8, message: "must be at least 8 characters")
      end
    end
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/account/password"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={f[:password]} class="password-input" id="account-password">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def account_password_page(conn, _params) do
      changeset = MyApp.Forms.PasswordForm.changeset(%MyApp.Forms.PasswordForm{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :password_input_changeset,
          id: "account-password-changeset-form"
        )

      render(conn, :account_password, form: form)
    end

    def account_password_create(conn, %{"password_input_changeset" => params}) do
      case MyApp.Forms.PasswordForm.changeset(%MyApp.Forms.PasswordForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved")
          |> redirect(to: ~p"/account")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :password_input_changeset,
              id: "account-password-changeset-form"
            )

          render(conn, :account_password, form: form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/account/password-strict"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={f[:password]} class="password-input" id="account-password-strict">
        <:label>Password (stricter validation)</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def account_password_strict_page(conn, _params) do
      changeset =
        MyApp.Forms.PasswordForm.changeset_validate(%MyApp.Forms.PasswordForm{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :password_input_validate,
          id: "account-password-validate-form"
        )

      render(conn, :account_password_strict, form: form)
    end

    def account_password_strict_create(conn, %{"password_input_validate" => params}) do
      case MyApp.Forms.PasswordForm.changeset_validate(%MyApp.Forms.PasswordForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved")
          |> redirect(to: ~p"/account")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :password_input_validate,
              id: "account-password-validate-form"
            )

          render(conn, :account_password_strict, form: form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/register"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <input
        type="password"
        name="user[password]"
        id="register-password"
        class="native-input"
        autocomplete="new-password"
      />
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </form>
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={@form[:password]} class="password-input" id="password-input-live-changeset">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" id="password-input-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.PasswordForm{}
        |> MyApp.Forms.PasswordForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :password_input_live)

      {:ok, assign(socket, :form, form)}
    end

    def handle_event("validate", %{"password_input_live" => params}, socket) do
      changeset =
        %MyApp.Forms.PasswordForm{}
        |> MyApp.Forms.PasswordForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset, action: :validate, as: :password_input_live)
       )}
    end

    def handle_event("save", %{"password_input_live" => params}, socket) do
      case MyApp.Forms.PasswordForm.changeset(%MyApp.Forms.PasswordForm{}, params) do
        %Ecto.Changeset{valid?: true} = _changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(
               MyApp.Forms.PasswordForm.changeset(%MyApp.Forms.PasswordForm{}, %{}),
               as: :password_input_live
             )
           )}

        changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :password_input_live)
           )}
      end
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={@form[:password]} class="password-input" id="password-input-live-strict">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" id="password-input-form-live-strict-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.PasswordForm{}
        |> MyApp.Forms.PasswordForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :password_input_strict)

      {:ok, assign(socket, :strict_form, form)}
    end

    def handle_event("validate_strict", %{"password_input_strict" => params}, socket) do
      changeset =
        %MyApp.Forms.PasswordForm{}
        |> MyApp.Forms.PasswordForm.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :strict_form,
         Phoenix.Component.to_form(changeset, action: :validate, as: :password_input_strict)
       )}
    end

    def handle_event("save_strict", %{"password_input_strict" => params}, socket) do
      case MyApp.Forms.PasswordForm.changeset_validate(%MyApp.Forms.PasswordForm{}, params) do
        %Ecto.Changeset{valid?: true} = _changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(
               MyApp.Forms.PasswordForm.changeset_validate(%MyApp.Forms.PasswordForm{}, %{}),
               as: :password_input_strict
             )
           )}

        changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :password_input_strict)
           )}
      end
    end
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_validate_heex, do: form_doc_controller_validate_heex()
  def form_validate_elixir, do: form_doc_controller_validate_elixir()
  def form_native_heex, do: form_doc_native_heex()

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/password-input/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={f[:password]} class="password-input" id="password-input-changeset-field">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action
        type="submit"
        id="password-input-changeset-submit"
        class="button button--accent w-full"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/password-input/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={f[:password]} class="password-input" id="password-input-validate-field">
        <:label>Password (stricter validation)</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action
        type="submit"
        id="password-input-validate-submit"
        class="button button--accent w-full"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/password-input/form"}
      method="post"
      id="password-input-plain-form"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <label class="w-full typo-label" for="password-input-native-password">Password</label>
      <input
        type="password"
        name="user[password]"
        id="password-input-native-password"
        class="native-input w-full"
        autocomplete="new-password"
      />
      <.action
        type="submit"
        id="password-input-controller-submit"
        class="button button--accent w-full"
      >
        Submit
      </.action>
    </form>
    """
  end

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input
        field={@form[:password]}
        class="password-input"
        id="password-input-live-changeset"
      >
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" id="password-input-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.password_input field={@form[:password]} class="password-input" id="password-input-live-strict">
        <:label>Password (stricter validation)</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action
        type="submit"
        id="password-input-form-live-strict-submit"
        class="button button--accent w-full"
      >
        Submit
      </.action>
    </.form>
    """
  end
end
