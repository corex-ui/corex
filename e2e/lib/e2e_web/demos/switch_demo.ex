defmodule E2eWeb.Demos.SwitchDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def minimal_code do
    ~S"""
    <.switch aria_label="Enable notifications" />
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.switch id="switch-anatomy-minimal" aria_label="Enable notifications" />
    """
  end

  def with_label_code do
    ~S"""
    <.switch>
      <:label>Enable</:label>
    </.switch>
    """
  end

  def with_label_example(assigns) do
    ~H"""
    <.switch id="switch-anatomy-labeled">
      <:label>Enable</:label>
    </.switch>
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.switch
       
      controlled
      checked={@checked}
      on_checked_change="patterns_checked"
    >
      <:label>Enable</:label>
    </.switch>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :checked, false)}
    end

    def handle_event("patterns_checked", %{"checked" => checked}, socket) do
      {:noreply, assign(socket, :checked, checked == true or checked == "true")}
    end
    """
  end

  def styling_size_code do
    ~S"""
    <.switch size="sm"  checked>
      <:label>SM</:label>
    </.switch>
    <.switch size="md"  checked>
      <:label>MD</:label>
    </.switch>
    <.switch size="lg"  checked>
      <:label>LG</:label>
    </.switch>
    <.switch size="xl"  checked>
      <:label>XL</:label>
    </.switch>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <.row gap="lg" align="center" wrap="wrap" width="full">
      <.switch id="switch-style-sm" size="sm" checked>
        <:label>SM</:label>
      </.switch>
      <.switch id="switch-style-md" size="md" checked>
        <:label>MD</:label>
      </.switch>
      <.switch id="switch-style-lg" size="lg" checked>
        <:label>LG</:label>
      </.switch>
      <.switch id="switch-style-xl" size="xl" checked>
        <:label>XL</:label>
      </.switch>
    </.row>
    """
  end

  def styling_semantic_code do
    ~S"""
    <.switch>
      <:label>Default</:label>
    </.switch>
    <.switch semantic="accent">
      <:label>Accent</:label>
    </.switch>

    <.switch checked>
      <:label>Default</:label>
    </.switch>
    <.switch semantic="accent" checked>
      <:label>Accent</:label>
    </.switch>
    """
  end

  def styling_semantic_example(assigns) do
    _ = assigns

    ~H"""
    <.stack width="full" gap="lg">
      <.stack gap="sm">
        <.small>Off</.small>
        <.row gap="lg" align="start" wrap="wrap">
          <.switch id="switch-style-c-default-off">
            <:label>Default</:label>
          </.switch>
          <.switch id="switch-style-c-accent-off" semantic="accent">
            <:label>Accent</:label>
          </.switch>
          <.switch id="switch-style-c-brand-off" semantic="brand">
            <:label>Brand</:label>
          </.switch>
          <.switch id="switch-style-c-alert-off" semantic="alert">
            <:label>Alert</:label>
          </.switch>
          <.switch id="switch-style-c-info-off" semantic="info">
            <:label>Info</:label>
          </.switch>
          <.switch id="switch-style-c-success-off" semantic="success">
            <:label>Success</:label>
          </.switch>
        </.row>
      </.stack>
      <.stack gap="sm">
        <.small>On</.small>
        <.row gap="lg" align="start" wrap="wrap">
          <.switch id="switch-style-c-default-on" checked>
            <:label>Default</:label>
          </.switch>
          <.switch id="switch-style-c-accent-on" semantic="accent" checked>
            <:label>Accent</:label>
          </.switch>
          <.switch id="switch-style-c-brand-on" semantic="brand" checked>
            <:label>Brand</:label>
          </.switch>
          <.switch id="switch-style-c-alert-on" semantic="alert" checked>
            <:label>Alert</:label>
          </.switch>
          <.switch id="switch-style-c-info-on" semantic="info" checked>
            <:label>Info</:label>
          </.switch>
          <.switch id="switch-style-c-success-on" semantic="success" checked>
            <:label>Success</:label>
          </.switch>
        </.row>
      </.stack>
    </.stack>
    """
  end

  def api_set_checked_client_binding_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Switch.set_checked("switch-api-cb", true)} size="sm">On</.action>
      <.action phx-click={Corex.Switch.set_checked("switch-api-cb", false)} size="sm">Off</.action>
      <.action phx-click={Corex.Switch.toggle_checked("switch-api-cb")} size="sm">Toggle</.action>
    </div>
    <.switch>
      <:label>Power</:label>
    </.switch>
    """
  end

  def api_set_checked_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-center w-full">
      <div class="flex flex-wrap gap-2 items-center">
        <.action phx-click={Corex.Switch.set_checked("switch-api-cb", true)} size="sm">
          On
        </.action>
        <.action
          phx-click={Corex.Switch.set_checked("switch-api-cb", false)}
          size="sm"
        >
          Off
        </.action>
        <.action phx-click={Corex.Switch.toggle_checked("switch-api-cb")} size="sm">
          Toggle
        </.action>
      </div>
      <.switch id="switch-api-cb">
        <:label>Power</:label>
      </.switch>
    </div>
    """
  end

  def api_set_checked_client_js_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <button
        type="button"
        size="sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: true } }))"
      >
        On
      </button>
      <button
        type="button"
        size="sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: false } }))"
      >
        Off
      </button>
      <button
        type="button"
        size="sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:toggle-checked', { bubbles: false }))"
      >
        Toggle
      </button>
    </div>
    <.switch>
      <:label>Power</:label>
    </.switch>
    """
  end

  def api_set_checked_client_js_js do
    ~S"""
    const el = document.getElementById("switch-api-cjs");

    el?.dispatchEvent(
      new CustomEvent("corex:switch:set-checked", { bubbles: false, detail: { checked: true } })
    );

    el?.dispatchEvent(
      new CustomEvent("corex:switch:set-checked", { bubbles: false, detail: { checked: false } })
    );

    el?.dispatchEvent(new CustomEvent("corex:switch:toggle-checked", { bubbles: false }));
    """
  end

  def api_set_checked_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("switch-api-cjs");

    el?.dispatchEvent(
      new CustomEvent("corex:switch:set-checked", { bubbles: false, detail: { checked: true } })
    );

    el?.dispatchEvent(
      new CustomEvent("corex:switch:set-checked", { bubbles: false, detail: { checked: false } })
    );

    el?.dispatchEvent(new CustomEvent("corex:switch:toggle-checked", { bubbles: false }));
    """
  end

  def api_set_checked_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-center w-full">
      <div class="flex flex-wrap gap-2 items-center">
        <button
          type="button"
          size="sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: true } }))"
        >
          On
        </button>
        <button
          type="button"
          size="sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: false } }))"
        >
          Off
        </button>
        <button
          type="button"
          size="sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:toggle-checked', { bubbles: false }))"
        >
          Toggle
        </button>
      </div>
      <.switch id="switch-api-cjs">
        <:label>Power</:label>
      </.switch>
    </div>
    """
  end

  def api_set_checked_server_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="switch_api_on" size="sm">On</.action>
      <.action phx-click="switch_api_off" size="sm">Off</.action>
      <.action phx-click="switch_api_toggle" size="sm">Toggle</.action>
    </div>
    <.switch>
      <:label>Power</:label>
    </.switch>
    """
  end

  def api_set_checked_server_elixir do
    ~S"""
    def handle_event("switch_api_on", _params, socket) do
      {:noreply, Corex.Switch.set_checked(socket, "switch-api-srv", true)}
    end

    def handle_event("switch_api_off", _params, socket) do
      {:noreply, Corex.Switch.set_checked(socket, "switch-api-srv", false)}
    end

    def handle_event("switch_api_toggle", _params, socket) do
      {:noreply, Corex.Switch.toggle_checked(socket, "switch-api-srv")}
    end
    """
  end

  def api_set_checked_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-center w-full">
      <div class="flex flex-wrap gap-2 items-center">
        <.action phx-click="switch_api_on" size="sm">On</.action>
        <.action phx-click="switch_api_off" size="sm">Off</.action>
        <.action phx-click="switch_api_toggle" size="sm">Toggle</.action>
      </div>
      <.switch id="switch-api-srv">
        <:label>Power</:label>
      </.switch>
    </div>
    """
  end

  def api_codes do
    %{
      set_checked_client_binding: api_set_checked_client_binding_heex(),
      set_checked_client_js_heex: api_set_checked_client_js_heex(),
      set_checked_client_js: api_set_checked_client_js_js(),
      set_checked_client_ts: api_set_checked_client_js_ts(),
      set_checked_server_heex: api_set_checked_server_heex(),
      set_checked_server_elixir: api_set_checked_server_elixir()
    }
  end

  def api_client_binding_code, do: api_set_checked_client_binding_heex()

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Switch.set_checked(@id, true)} size="sm">On</.action>
      <.action phx-click={Corex.Switch.set_checked(@id, false)} size="sm">
        Off
      </.action>
      <.action phx-click={Corex.Switch.toggle_checked(@id)} size="sm">
        Toggle
      </.action>
    </div>
    <.switch id={@id}>
      <:label>Power</:label>
    </.switch>
    """
  end

  def events_server_heex do
    ~S"""
    <.switch   on_checked_change="switch_changed">
      <:label>Subscribe</:label>
    </.switch>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "switch_changed",
      ~S|%{"id" => id, "checked" => checked} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.switch   on_checked_change_client="switch-changed">
      <:label>Subscribe</:label>
    </.switch>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("switch-on-checked-change-client");
    el?.addEventListener("switch-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("switch-on-checked-change-client");
    el?.addEventListener("switch-changed", (event: Event) =>
      console.log((event as CustomEvent<{ id: string; checked: boolean }>).detail)
    );
    """
  end

  def patterns_common_code do
    ~S"""
    <.switch>
      <:label>Option</:label>
    </.switch>
    """
  end

  def patterns_common_example(assigns) do
    ~H"""
    <.switch id="switch-pattern">
      <:label>Option</:label>
    </.switch>
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.Preferences do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :notifications, :boolean, default: false
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:notifications])
        |> validate_acceptance(:notifications)
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:notifications])
        |> validate_acceptance(:notifications, message: "must be accepted to continue")
      end
    end
    """
  end

  def form_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={@form[:notifications]}  >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset(%{})
        |> Phoenix.Component.to_form(as: :preferences_changeset, id: "switch-changeset-form")

      render(conn, :form_page, form: form)
    end
    """
  end

  def form_validate_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={@form[:notifications]}  >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :preferences_validate, id: "switch-validate-form")

      render(conn, :form_page, form: form)
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={f[:notifications]}>
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-changeset-submit" semantic="accent">
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
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={f[:notifications]}>
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-validate-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/switch/form"}
      method="post"
          >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.switch
        name="user[notifications]"
         
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def switch_form_submit(conn, %{"user" => %{"notifications" => notifications}}) do
      conn
      |> put_flash(:info, "Submitted: notifications=#{inspect(notifications)}")
      |> redirect(to: ~p"/switch/form#switch-form-native")
    end
    """
  end

  def form_native_heex, do: form_doc_native_heex()
  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate"
      phx-submit="save"
          >
      <.switch
        field={@form[:notifications]}
         
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset(%{})
        |> Phoenix.Component.to_form(as: :preferences, id: "switch-form-live")

      {:ok, assign(socket, :form, form)}
    end

    def handle_event("validate", %{"preferences" => prefs}, socket) do
      changeset =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset(prefs)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset, action: :validate, as: :preferences, id: "switch-form-live")
       )}
    end

    def handle_event("save", %{"preferences" => prefs}, socket) do
      case MyApp.Forms.Preferences.changeset(%MyApp.Forms.Preferences{}, prefs) do
        %Ecto.Changeset{valid?: true} = _changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(
               MyApp.Forms.Preferences.changeset(%MyApp.Forms.Preferences{}, %{}),
               as: :preferences,
               id: "switch-form-live"
             )
           )}

        changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :preferences, id: "switch-form-live")
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
      <.switch
        field={@form[:notifications]}
         
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :preferences_strict, id: "switch-strict-form-live")

      {:ok, assign(socket, :strict_form, form)}
    end

    def handle_event("validate_strict", %{"preferences_strict" => params}, socket) do
      changeset =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :strict_form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :preferences_strict,
           id: "switch-strict-form-live"
         )
       )}
    end

    def handle_event("save_strict", %{"preferences_strict" => params}, socket) do
      case MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params) do
        %Ecto.Changeset{valid?: true} = _changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(
               MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, %{}),
               as: :preferences_strict,
               id: "switch-strict-form-live"
             )
           )}

        changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :preferences_strict,
               id: "switch-strict-form-live"
             )
           )}
      end
    end
    """
  end

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate"
      phx-submit="save"
    >
      <.switch
        field={@form[:notifications]}
        id="switch-form-live-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <.switch
        field={@form[:notifications]}
        id="switch-form-live-strict"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-strict-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/switch/form"}
      method="post"
      id="switch-form-native"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.switch
        name="user[notifications]"
        id="switch-form-native-notifications"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-form-native-submit" semantic="accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={@form[:notifications]}  >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def switch_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"notifications" => false},
          as: :preferences_phoenix,
          id: "switch-form-phoenix"
        )

      render(conn, :switch_form_page, phoenix_form: phoenix_form)
    end

    def switch_form_submit(conn, params) do
      if is_map(params["preferences_phoenix"]) do
        notifications = params["preferences_phoenix"]["notifications"] in [true, "true", "on", "1", 1]

        conn
        |> put_flash(:info, "Submitted: notifications=#{inspect(notifications)}")
        |> redirect(to: ~p"/switch/form#switch-form-phoenix")
      end
    end
    """
  end

  def form_doc_controller_ecto_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={@form[:notifications]}  >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_ecto_elixir do
    ~S"""
    def switch_form_page(conn, _params) do
      ecto_form =
        %MyApp.Forms.Preferences{}
        |> MyApp.Forms.Preferences.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :preferences_ecto, id: "switch-form-ecto")

      render(conn, :switch_form_page, ecto_form: ecto_form)
    end

    def switch_form_submit(conn, params) do
      if is_map(params["preferences_ecto"]) do
        changeset =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(params["preferences_ecto"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted: notifications=#{inspect(data.notifications)}")
          |> redirect(to: ~p"/switch/form#switch-form-ecto")
        else
          changeset = Map.put(changeset, :action, :insert)
          ecto_form = Phoenix.Component.to_form(changeset, as: :preferences_ecto, id: "switch-form-ecto")
          render(conn, :switch_form_page, ecto_form: ecto_form)
        end
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.switch field={@form[:notifications]}  >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_heex do
    ~S"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <.switch field={@form[:notifications]}  >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" semantic="accent">
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
      action={~p"/switch/form"}
      method="post"
    >
      <.switch field={f[:notifications]} id="switch-form-phoenix-notifications">
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-form-phoenix-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/switch/form"}
      method="post"
    >
      <.switch
        field={f[:notifications]}
        id="switch-form-ecto-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-ecto-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix">
      <.switch
        field={@form[:notifications]}
        id="switch-live-form-phoenix-notifications"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-live-form-phoenix-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <.switch
        field={@form[:notifications]}
        id="switch-live-form-ecto-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-live-form-ecto-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.SwitchFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"notifications" => false},
            as: :preferences_phoenix,
            id: "switch-live-form-phoenix"
          )

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"preferences_phoenix" => params}, socket) do
        notifications = params["notifications"] in [true, "true", "on", "1", 1]

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"notifications" => notifications},
             as: :preferences_phoenix,
             id: "switch-live-form-phoenix"
           )
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.SwitchFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :preferences_ecto, id: "switch-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"preferences_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :preferences_ecto,
             id: "switch-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"preferences_ecto" => params}, socket) do
        case MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params),
                 as: :preferences_ecto,
                 id: "switch-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :preferences_ecto,
                 id: "switch-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_ecto_heex()
  def form_ecto_elixir, do: form_doc_controller_ecto_elixir()
end
