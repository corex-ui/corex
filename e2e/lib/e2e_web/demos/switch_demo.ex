defmodule E2eWeb.Demos.SwitchDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.switch id="switch-anatomy-minimal" class="switch" aria_label="Enable notifications" />
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.switch id="switch-anatomy-minimal" class="switch" aria_label="Enable notifications" />
    """
  end

  def with_label_code do
    ~S"""
    <.switch id="switch-anatomy-labeled" class="switch">
      <:label>Enable</:label>
    </.switch>
    """
  end

  def with_label_example(assigns) do
    ~H"""
    <.switch id="switch-anatomy-labeled" class="switch">
      <:label>Enable</:label>
    </.switch>
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.switch
      id="switch-patterns-controlled"
      class="switch"
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
    <.switch id="switch-style-sm" class="switch switch--sm" checked>
      <:label>SM</:label>
    </.switch>
    <.switch id="switch-style-md" class="switch switch--md" checked>
      <:label>MD</:label>
    </.switch>
    <.switch id="switch-style-lg" class="switch switch--lg" checked>
      <:label>LG</:label>
    </.switch>
    <.switch id="switch-style-xl" class="switch switch--xl" checked>
      <:label>XL</:label>
    </.switch>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-center w-full max-w-4xl">
      <.switch id="switch-style-sm" class="switch switch--sm" checked>
        <:label>SM</:label>
      </.switch>
      <.switch id="switch-style-md" class="switch switch--md" checked>
        <:label>MD</:label>
      </.switch>
      <.switch id="switch-style-lg" class="switch switch--lg" checked>
        <:label>LG</:label>
      </.switch>
      <.switch id="switch-style-xl" class="switch switch--xl" checked>
        <:label>XL</:label>
      </.switch>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <.switch id="switch-style-c-default" class="switch" checked>
      <:label>Default</:label>
    </.switch>
    <.switch id="switch-style-c-accent" class="switch switch--accent" checked>
      <:label>Accent</:label>
    </.switch>
    <.switch id="switch-style-c-brand" class="switch switch--brand" checked>
      <:label>Brand</:label>
    </.switch>
    <.switch id="switch-style-c-alert" class="switch switch--alert" checked>
      <:label>Alert</:label>
    </.switch>
    <.switch id="switch-style-c-info" class="switch switch--info" checked>
      <:label>Info</:label>
    </.switch>
    <.switch id="switch-style-c-success" class="switch switch--success" checked>
      <:label>Success</:label>
    </.switch>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.switch id="switch-style-c-default" class="switch" checked>
        <:label>Default</:label>
      </.switch>
      <.switch id="switch-style-c-accent" class="switch switch--accent" checked>
        <:label>Accent</:label>
      </.switch>
      <.switch id="switch-style-c-brand" class="switch switch--brand" checked>
        <:label>Brand</:label>
      </.switch>
      <.switch id="switch-style-c-alert" class="switch switch--alert" checked>
        <:label>Alert</:label>
      </.switch>
      <.switch id="switch-style-c-info" class="switch switch--info" checked>
        <:label>Info</:label>
      </.switch>
      <.switch id="switch-style-c-success" class="switch switch--success" checked>
        <:label>Success</:label>
      </.switch>
    </div>
    """
  end

  def api_set_checked_client_binding_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Switch.set_checked("switch-api-cb", true)} class="button button--sm">On</.action>
      <.action phx-click={Corex.Switch.set_checked("switch-api-cb", false)} class="button button--sm">Off</.action>
      <.action phx-click={Corex.Switch.toggle_checked("switch-api-cb")} class="button button--sm">Toggle</.action>
    </div>
    <.switch id="switch-api-cb" class="switch">
      <:label>Power</:label>
    </.switch>
    """
  end

  def api_set_checked_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-start">
      <div class="flex flex-wrap gap-2 mb-0">
        <.action phx-click={Corex.Switch.set_checked("switch-api-cb", true)} class="button button--sm">
          On
        </.action>
        <.action
          phx-click={Corex.Switch.set_checked("switch-api-cb", false)}
          class="button button--sm"
        >
          Off
        </.action>
        <.action phx-click={Corex.Switch.toggle_checked("switch-api-cb")} class="button button--sm">
          Toggle
        </.action>
      </div>
      <.switch id="switch-api-cb" class="switch">
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
        class="button button--sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: true } }))"
      >
        On
      </button>
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: false } }))"
      >
        Off
      </button>
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:toggle-checked', { bubbles: false }))"
      >
        Toggle
      </button>
    </div>
    <.switch id="switch-api-cjs" class="switch">
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
    <div class="w-full max-w-4xl flex flex-col gap-4 items-start">
      <div class="flex flex-wrap gap-2 mb-0">
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: true } }))"
        >
          On
        </button>
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: false } }))"
        >
          Off
        </button>
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:toggle-checked', { bubbles: false }))"
        >
          Toggle
        </button>
      </div>
      <.switch id="switch-api-cjs" class="switch">
        <:label>Power</:label>
      </.switch>
    </div>
    """
  end

  def api_set_checked_server_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="switch_api_on" class="button button--sm">On</.action>
      <.action phx-click="switch_api_off" class="button button--sm">Off</.action>
      <.action phx-click="switch_api_toggle" class="button button--sm">Toggle</.action>
    </div>
    <.switch id="switch-api-srv" class="switch">
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
    <div class="w-full max-w-4xl flex flex-col gap-4 items-start">
      <div class="flex flex-wrap gap-2 mb-0">
        <.action phx-click="switch_api_on" class="button button--sm">On</.action>
        <.action phx-click="switch_api_off" class="button button--sm">Off</.action>
        <.action phx-click="switch_api_toggle" class="button button--sm">Toggle</.action>
      </div>
      <.switch id="switch-api-srv" class="switch">
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
      <.action phx-click={Corex.Switch.set_checked(@id, true)} class="button button--sm">On</.action>
      <.action phx-click={Corex.Switch.set_checked(@id, false)} class="button button--sm">
        Off
      </.action>
      <.action phx-click={Corex.Switch.toggle_checked(@id)} class="button button--sm">
        Toggle
      </.action>
    </div>
    <.switch id={@id} class="switch">
      <:label>Power</:label>
    </.switch>
    """
  end

  def events_server_heex do
    ~S"""
    <.switch id="switch-on-checked-change-server" class="switch" on_checked_change="switch_changed">
      <:label>Subscribe</:label>
    </.switch>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("switch_changed", %{"id" => id, "checked" => checked}, socket) do
      {:noreply, stream_insert(socket, :logs, %{id: id, checked: checked}, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.switch id="switch-on-checked-change-client" class="switch" on_checked_change_client="switch-changed">
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
    <.switch id="switch-pattern" class="switch">
      <:label>Option</:label>
    </.switch>
    """
  end

  def patterns_common_example(assigns) do
    ~H"""
    <.switch id="switch-pattern" class="switch">
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
        |> validate_required([:notifications])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:notifications])
        |> validate_required([:notifications], message: "can't be blank")
      end
    end
    """
  end

  def form_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/switch/form"}
      method="post"
      id={@form.id}
    >
      <.switch field={f[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %E2e.Form.Preferences{}
        |> E2e.Form.Preferences.changeset(%{})
        |> Phoenix.Component.to_form(as: :preferences_changeset, id: "switch-changeset-form")

      render(conn, :form_page, form: form)
    end
    """
  end

  def form_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/switch/form"}
      method="post"
      id={@form.id}
    >
      <.switch field={f[:notifications]} class="switch">
        <:label>Enable notifications (stricter)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-validate-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %E2e.Form.Preferences{}
        |> E2e.Form.Preferences.changeset_validate(%{})
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
      class="w-full max-w-2xs flex flex-col gap-space items-center"
      id={@form.id}
    >
      <.switch field={f[:notifications]} class="switch" invalid={f[:notifications].errors != []}>
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-changeset-submit" class="button button--accent w-full">
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
      class="w-full max-w-2xs flex flex-col gap-space items-center"
      id={@form.id}
    >
      <.switch field={f[:notifications]} class="switch" invalid={f[:notifications].errors != []}>
        <:label>Enable notifications (stricter)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-validate-submit" class="button button--accent w-full">
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
      id="switch-plain-form"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.switch
        name="user[notifications]"
        id="switch-form-native"
        class="switch"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-controller-submit" class="button button--accent w-full">
        Submit
      </.action>
    </form>
    """
  end

  def form_native_heex, do: form_doc_native_heex()

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.switch
        field={@form[:notifications]}
        class="switch"
        controlled
        id="switch-form-live-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %E2e.Form.Preferences{}
        |> E2e.Form.Preferences.changeset(%{})
        |> Phoenix.Component.to_form(as: :preferences, id: "switch-form-live")

      {:ok, assign(socket, :form, form)}
    end

    def handle_event("validate", %{"preferences" => prefs}, socket) do
      changeset =
        %E2e.Form.Preferences{}
        |> E2e.Form.Preferences.changeset(prefs)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset, action: :validate, as: :preferences, id: "switch-form-live")
       )}
    end

    def handle_event("save", %{"preferences" => prefs}, socket) do
      case E2e.Form.Preferences.changeset(%E2e.Form.Preferences{}, prefs) do
        %Ecto.Changeset{valid?: true} = _changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(
               E2e.Form.Preferences.changeset(%E2e.Form.Preferences{}, %{}),
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
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.switch
        field={@form[:notifications]}
        class="switch"
        controlled
        id="switch-form-live-strict"
      >
        <:label>Enable notifications (stricter)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-strict-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %E2e.Form.Preferences{}
        |> E2e.Form.Preferences.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :preferences_strict, id: "switch-strict-form-live")

      {:ok, assign(socket, :strict_form, form)}
    end

    def handle_event("validate_strict", %{"preferences_strict" => params}, socket) do
      changeset =
        %E2e.Form.Preferences{}
        |> E2e.Form.Preferences.changeset_validate(params)
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
      case E2e.Form.Preferences.changeset_validate(%E2e.Form.Preferences{}, params) do
        %Ecto.Changeset{valid?: true} = _changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(
               E2e.Form.Preferences.changeset_validate(%E2e.Form.Preferences{}, %{}),
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
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.switch
        field={@form[:notifications]}
        class="switch"
        controlled
        id="switch-form-live-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-submit" class="button button--accent w-full">
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
      <.switch
        field={@form[:notifications]}
        class="switch"
        controlled
        id="switch-form-live-strict"
      >
        <:label>Enable notifications (stricter)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-strict-submit" class="button button--accent w-full">
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
      id="switch-plain-form"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.switch
        name="user[notifications]"
        id="switch-form-native"
        class="switch"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-controller-submit" class="button button--accent w-full">
        Submit
      </.action>
    </form>
    """
  end
end
