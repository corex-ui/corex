defmodule E2eWeb.Demos.PasswordInputDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def minimal_code do
    ~S"""
    <.password_input class="password-input">
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
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
    <.password_input name="user[password]" class="password-input">
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
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.PasswordInput.set_visible("password-input-api-binding", true)} class="button ui-size-sm">
        Show
      </.action>
      <.action phx-click={Corex.PasswordInput.set_visible("password-input-api-binding", false)} class="button ui-size-sm">
        Hide
      </.action>
      <.action phx-click={Corex.PasswordInput.toggle_visible("password-input-api-binding")} class="button ui-size-sm">
        Toggle
      </.action>
      <.action phx-click={Corex.PasswordInput.focus("password-input-api-binding")} class="button ui-size-sm">
        Focus
      </.action>
    </div>
    <.password_input
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
    assigns = assign_new(assigns, :id, fn -> "password-input-api-binding" end)

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.PasswordInput.set_visible(@id, true)} class="button ui-size-sm">
        Show
      </.action>
      <.action phx-click={Corex.PasswordInput.set_visible(@id, false)} class="button ui-size-sm">
        Hide
      </.action>
      <.action phx-click={Corex.PasswordInput.toggle_visible(@id)} class="button ui-size-sm">
        Toggle
      </.action>
      <.action phx-click={Corex.PasswordInput.focus(@id)} class="button ui-size-sm">
        Focus
      </.action>
    </div>
    <.password_input
      id={@id}
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
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:password-input:set-visible",
            to: "#password-input-api-client",
            detail: %{visible: true},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Show
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:password-input:set-visible",
            to: "#password-input-api-client",
            detail: %{visible: false},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Hide
      </.action>
      <.action
        phx-click={JS.dispatch("corex:password-input:toggle-visible", to: "#password-input-api-client", bubbles: false)}
        class="button ui-size-sm"
      >
        Toggle
      </.action>
      <.action
        phx-click={JS.dispatch("corex:password-input:focus", to: "#password-input-api-client", bubbles: false)}
        class="button ui-size-sm"
      >
        Focus
      </.action>
    </div>
    <.password_input
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
    el?.dispatchEvent(
      new CustomEvent("corex:password-input:set-visible", { bubbles: false, detail: { visible: true } })
    );
    """
  end

  def api_client_ts do
    ~S"""
    const el = document.getElementById("password-input-api-client");
    el?.addEventListener("password-input-api-visibility-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id?: string; visible?: boolean }>).detail);
    });
    el?.dispatchEvent(
      new CustomEvent("corex:password-input:set-visible", { bubbles: false, detail: { visible: true } })
    );
    """
  end

  def api_client_example(assigns) do
    assigns = assign_new(assigns, :id, fn -> "password-input-api-client" end)

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:password-input:set-visible",
            to: "##{@id}",
            detail: %{visible: true},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Show
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:password-input:set-visible",
            to: "##{@id}",
            detail: %{visible: false},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Hide
      </.action>
      <.action
        phx-click={JS.dispatch("corex:password-input:toggle-visible", to: "##{@id}", bubbles: false)}
        class="button ui-size-sm"
      >
        Toggle
      </.action>
      <.action
        phx-click={JS.dispatch("corex:password-input:focus", to: "##{@id}", bubbles: false)}
        class="button ui-size-sm"
      >
        Focus
      </.action>
    </div>
    <.password_input
      id={@id}
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

  def api_server_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_password_show" phx-value-id="password-input-api-server" class="button ui-size-sm">
        Show
      </.action>
      <.action phx-click="api_password_hide" phx-value-id="password-input-api-server" class="button ui-size-sm">
        Hide
      </.action>
      <.action phx-click="api_password_toggle_visible" phx-value-id="password-input-api-server" class="button ui-size-sm">
        Toggle
      </.action>
      <.action phx-click="api_password_focus" phx-value-id="password-input-api-server" class="button ui-size-sm">
        Focus
      </.action>
    </div>
    <.password_input
      class="password-input"
      name="user[password]"
    >
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("api_password_show", %{"id" => id}, socket) do
      {:noreply, Corex.PasswordInput.set_visible(socket, id, true)}
    end

    def handle_event("api_password_hide", %{"id" => id}, socket) do
      {:noreply, Corex.PasswordInput.set_visible(socket, id, false)}
    end

    def handle_event("api_password_toggle_visible", %{"id" => id}, socket) do
      {:noreply, Corex.PasswordInput.toggle_visible(socket, id)}
    end

    def handle_event("api_password_focus", %{"id" => id}, socket) do
      {:noreply, Corex.PasswordInput.focus(socket, id)}
    end
    """
  end

  def api_server_example(assigns) do
    assigns = assign_new(assigns, :id, fn -> "password-input-api-server" end)

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_password_show" phx-value-id={@id} class="button ui-size-sm">
        Show
      </.action>
      <.action phx-click="api_password_hide" phx-value-id={@id} class="button ui-size-sm">
        Hide
      </.action>
      <.action phx-click="api_password_toggle_visible" phx-value-id={@id} class="button ui-size-sm">
        Toggle
      </.action>
      <.action phx-click="api_password_focus" phx-value-id={@id} class="button ui-size-sm">
        Focus
      </.action>
    </div>
    <.password_input id={@id} class="password-input" name="user[password]">
      <:label>Password</:label>
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    </.password_input>
    """
  end

  def api_initial_heex do
    ~S"""
    <.password_input
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "password_visibility_changed",
      ~S|%{"id" => id, "visible" => visible} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.password_input
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

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/password-input/form"}
      method="post"
    >
      <.password_input field={@form[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def password_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"password" => ""}, as: :password_input_phoenix, id: "password-input-form-phoenix")

      render(conn, :password_input_form_page, phoenix_form: phoenix_form)
    end

    def password_input_form_submit(conn, params) do
      if is_map(params["password_input_phoenix"]) do
        _password = params["password_input_phoenix"]["password"] || ""

        conn
        |> put_flash(:info, "Submitted")
        |> redirect(to: ~p"/password-input/form#password-input-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.password_input field={@form[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/password-input/form"}
      method="post"
          >
      <.password_input field={@form[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" class="button ui-accent">
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
      for={@form}
      action={~p"/password-input/form"}
      method="post"
          >
      <.password_input field={@form[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" class="button ui-accent">
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
      action={~p"/password-input/form"}
      method="post"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.password_input
        name="user[password]"
        class="password-input"
        auto_complete="new-password"
      >
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def password_input_form_submit(conn, %{"user" => %{"password" => password}}) do
      message =
        if password == "", do: "Submitted: password=", else: "Submitted: password=***"

      conn
      |> put_flash(:info, message)
      |> redirect(to: ~p"/password-input/form#password-input-form-native")
    end
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate"
      phx-submit="save"
          >
      <.password_input field={@form[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" class="button ui-accent">
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
     
      phx-change="validate_strict"
      phx-submit="save_strict"
          >
      <.password_input field={@form[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.action type="submit" class="button ui-accent">
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
        class="button ui-accent"
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
    >
      <.password_input field={f[:password]} class="password-input" id="password-input-validate-field">
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
        id="password-input-validate-submit"
        class="button ui-accent"
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
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.password_input
        name="user[password]"
        id="password-input-native-password"
        class="password-input"
        auto_complete="new-password"
      >
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.action
        type="submit"
        id="password-input-controller-submit"
        class="button ui-accent"
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
      phx-change="validate"
      phx-submit="save"
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

      <.action type="submit" id="password-input-form-live-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate"
      phx-submit="save"
    >
      <.password_input
        field={@form[:password]}
        class="password-input"
        id="password-input-live-form-ecto-password"
      >
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
        id="password-input-form-live-strict-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/password-input/form"}
      method="post"
    >
      <.password_input field={f[:password]} class="password-input">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix">
      <.password_input
        field={@form[:password]}
        class="password-input"
        id="password-input-live-form-phoenix-password"
      >
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.action
        type="submit"
        id="password-input-live-form-phoenix-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.PasswordInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"password" => ""}, as: :password_input_phoenix, id: "password-input-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"password_input_phoenix" => params}, socket) do
        password = params["password"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"password" => password}, as: :password_input_phoenix, id: "password-input-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.PasswordInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.PasswordForm{}
          |> MyApp.Forms.PasswordForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :password_input_ecto, id: "password-input-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"password_input_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.PasswordForm{}
          |> MyApp.Forms.PasswordForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :password_input_ecto,
             id: "password-input-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"password_input_ecto" => params}, socket) do
        case MyApp.Forms.PasswordForm.changeset_validate(%MyApp.Forms.PasswordForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.PasswordForm.changeset_validate(%MyApp.Forms.PasswordForm{}, params),
                 as: :password_input_ecto,
                 id: "password-input-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :password_input_ecto,
                 id: "password-input-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end

  def styling_color_code do
    icons = styling_visibility_icons_code()

    """
    <.password_input name="user[password]" class="password-input">
      <:label>Default</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-accent">
      <:label>Accent</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-brand">
      <:label>Brand</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-alert">
      <:label>Alert</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-info">
      <:label>Info</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-success">
      <:label>Success</:label>
    #{icons}
    </.password_input>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.password_input
        id="password-input-style-color-default"
        name="user[password]"
        class="password-input w-full"
      >
        <:label>Default</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-color-accent"
        name="user[password]"
        class="password-input ui-accent w-full"
      >
        <:label>Accent</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-color-brand"
        name="user[password]"
        class="password-input ui-brand w-full"
      >
        <:label>Brand</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-color-alert"
        name="user[password]"
        class="password-input ui-alert w-full"
      >
        <:label>Alert</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-color-info"
        name="user[password]"
        class="password-input ui-info w-full"
      >
        <:label>Info</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-color-success"
        name="user[password]"
        class="password-input ui-success w-full"
      >
        <:label>Success</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
    </div>
    """
  end

  def styling_variant_code do
    icons = styling_visibility_icons_code()

    """
    <.password_input name="user[password]" class="password-input">
      <:label>Subtle (default)</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-solid">
      <:label>Solid</:label>
    #{icons}
    </.password_input>

    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.password_input
        id="password-input-style-variant-subtle"
        name="user[password]"
        class="password-input"
      >
        <:label>Subtle (default)</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-variant-solid"
        name="user[password]"
        class="password-input ui-solid"
      >
        <:label>Solid</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
    </div>
    """
  end

  def styling_variant_matrix_code do
    icons = styling_visibility_icons_code()

    for semantic <- DemoScales.styling_semantic_axis_steps("password-input"),
        variant <- DemoScales.styling_variant_axis_steps("password-input") do
      class =
        DemoScales.join_matrix_modifiers("password-input", semantic.modifier, variant.modifier)

      """
      <.password_input name="user[password]" class="#{class}">
        <:label>#{semantic.label}</:label>
      #{icons}
      </.password_input>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("password-input"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("password-input"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.password_input
            :for={variant <- @matrix_variants}
            name="user[password]"
            class={
              DemoScales.join_matrix_modifiers("password-input", semantic.modifier, variant.modifier)
            }
          >
            <:label>{semantic.label}</:label>
            <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
            <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
          </.password_input>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    icons = styling_visibility_icons_code()

    """
    <.password_input name="user[password]" class="password-input ui-size-sm">
      <:label>SM</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-size-md">
      <:label>MD</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-size-lg">
      <:label>LG</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-size-xl">
      <:label>XL</:label>
    #{icons}
    </.password_input>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.password_input
        id="password-input-style-sm"
        name="user[password]"
        class="password-input ui-size-sm w-full"
      >
        <:label>SM</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-md"
        name="user[password]"
        class="password-input ui-size-md w-full"
      >
        <:label>MD</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-lg"
        name="user[password]"
        class="password-input ui-size-lg w-full"
      >
        <:label>LG</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-xl"
        name="user[password]"
        class="password-input ui-size-xl w-full"
      >
        <:label>XL</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
    </div>
    """
  end

  def styling_rounded_code do
    icons = styling_visibility_icons_code()

    """
    <.password_input name="user[password]" class="password-input ui-rounded-none">
      <:label>None</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-rounded-sm">
      <:label>SM</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-rounded-md">
      <:label>MD</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-rounded-lg">
      <:label>LG</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-rounded-xl">
      <:label>XL</:label>
    #{icons}
    </.password_input>
    <.password_input name="user[password]" class="password-input ui-rounded-full">
      <:label>Full</:label>
    #{icons}
    </.password_input>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.password_input
        id="password-input-style-rounded-none"
        name="user[password]"
        class="password-input ui-rounded-none w-full"
      >
        <:label>None</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-rounded-sm"
        name="user[password]"
        class="password-input ui-rounded-sm w-full"
      >
        <:label>SM</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-rounded-md"
        name="user[password]"
        class="password-input ui-rounded-md w-full"
      >
        <:label>MD</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-rounded-lg"
        name="user[password]"
        class="password-input ui-rounded-lg w-full"
      >
        <:label>LG</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-rounded-xl"
        name="user[password]"
        class="password-input ui-rounded-xl w-full"
      >
        <:label>XL</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
      <.password_input
        id="password-input-style-rounded-full"
        name="user[password]"
        class="password-input ui-rounded-full w-full"
      >
        <:label>Full</:label>
        <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
      </.password_input>
    </div>
    """
  end

  def styling_max_width_code do
    icons = styling_visibility_icons_code()

    DemoScales.max_width_variants("password-input")
    |> Enum.map(fn %{label: label, modifier: modifier} ->
      class = DemoScales.join_block_modifiers("password-input", modifier)

      """
      <.password_input name="user[password]" class="#{class}">
        <:label>#{label}</:label>
      #{icons}
      </.password_input>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(assigns, :max_width_variants, DemoScales.max_width_variants("password-input"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.password_input
          id={"password-input-style-max-#{variant.id}"}
          name="user[password]"
          class={DemoScales.join_block_modifiers("password-input", variant.modifier)}
        >
          <:label>{variant.label}</:label>
          <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
          <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        </.password_input>
      </div>
    </div>
    """
  end

  defp styling_visibility_icons_code do
    """
      <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
    """
  end
end
