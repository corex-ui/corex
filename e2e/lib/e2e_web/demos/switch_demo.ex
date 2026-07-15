defmodule E2eWeb.Demos.SwitchDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def minimal_code do
    ~S"""
    <.switch class="switch" aria_label="Enable notifications" />
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.switch id="switch-anatomy-minimal" class="switch" aria_label="Enable notifications" />
    """
  end

  def with_label_code do
    ~S"""
    <.switch class="switch">
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

  def styling_variant_code do
    ~S"""
    <.switch class="switch" checked>
      <:label>Subtle (default)</:label>
    </.switch>
    <.switch class="switch ui-solid" checked>
      <:label>Solid</:label>
    </.switch>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.switch id="switch-style-variant-subtle" class="switch" checked>
        <:label>Subtle (default)</:label>
      </.switch>
      <.switch id="switch-style-variant-solid" class="switch ui-solid" checked>
        <:label>Solid</:label>
      </.switch>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("switch"),
        variant <- DemoScales.styling_variant_axis_steps("switch") do
      class = DemoScales.join_matrix_modifiers("switch", semantic.modifier, variant.modifier)

      ~s(<.switch class="#{class}" checked>
        <:label>#{semantic.label}</:label>
      </.switch>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("switch"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("switch"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.switch
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"switch-matrix-#{semantic_index}-#{variant_index}"}
            class={DemoScales.join_matrix_modifiers("switch", semantic.modifier, variant.modifier)}
            checked
          >
            <:label>{semantic.label}</:label>
          </.switch>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.switch class="switch ui-size-sm" checked>
      <:label>SM</:label>
    </.switch>
    <.switch class="switch ui-size-md" checked>
      <:label>MD</:label>
    </.switch>
    <.switch class="switch ui-size-lg" checked>
      <:label>LG</:label>
    </.switch>
    <.switch class="switch ui-size-xl" checked>
      <:label>XL</:label>
    </.switch>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-center w-full max-w-4xl">
      <.switch id="switch-style-sm" class="switch ui-size-sm" checked>
        <:label>SM</:label>
      </.switch>
      <.switch id="switch-style-md" class="switch ui-size-md" checked>
        <:label>MD</:label>
      </.switch>
      <.switch id="switch-style-lg" class="switch ui-size-lg" checked>
        <:label>LG</:label>
      </.switch>
      <.switch id="switch-style-xl" class="switch ui-size-xl" checked>
        <:label>XL</:label>
      </.switch>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <.switch class="switch" checked>
      <:label>Default</:label>
    </.switch>
    <.switch class="switch ui-accent" checked>
      <:label>Accent</:label>
    </.switch>
    <.switch class="switch ui-brand" checked>
      <:label>Brand</:label>
    </.switch>
    <.switch class="switch ui-alert" checked>
      <:label>Alert</:label>
    </.switch>
    <.switch class="switch ui-info" checked>
      <:label>Info</:label>
    </.switch>
    <.switch class="switch ui-success" checked>
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
      <.switch id="switch-style-c-accent" class="switch ui-accent" checked>
        <:label>Accent</:label>
      </.switch>
      <.switch id="switch-style-c-brand" class="switch ui-brand" checked>
        <:label>Brand</:label>
      </.switch>
      <.switch id="switch-style-c-alert" class="switch ui-alert" checked>
        <:label>Alert</:label>
      </.switch>
      <.switch id="switch-style-c-info" class="switch ui-info" checked>
        <:label>Info</:label>
      </.switch>
      <.switch id="switch-style-c-success" class="switch ui-success" checked>
        <:label>Success</:label>
      </.switch>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.switch class="switch ui-rounded-none" checked>
      <:label>None</:label>
    </.switch>
    <.switch class="switch ui-rounded-sm" checked>
      <:label>SM</:label>
    </.switch>
    <.switch class="switch ui-rounded-md" checked>
      <:label>MD</:label>
    </.switch>
    <.switch class="switch ui-rounded-lg" checked>
      <:label>LG</:label>
    </.switch>
    <.switch class="switch ui-rounded-xl" checked>
      <:label>XL</:label>
    </.switch>
    <.switch class="switch ui-rounded-full" checked>
      <:label>Full</:label>
    </.switch>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.switch id="switch-style-rounded-none" class="switch ui-rounded-none" checked>
        <:label>None</:label>
      </.switch>
      <.switch id="switch-style-rounded-sm" class="switch ui-rounded-sm" checked>
        <:label>SM</:label>
      </.switch>
      <.switch id="switch-style-rounded-md" class="switch ui-rounded-md" checked>
        <:label>MD</:label>
      </.switch>
      <.switch id="switch-style-rounded-lg" class="switch ui-rounded-lg" checked>
        <:label>LG</:label>
      </.switch>
      <.switch id="switch-style-rounded-xl" class="switch ui-rounded-xl" checked>
        <:label>XL</:label>
      </.switch>
      <.switch id="switch-style-rounded-full" class="switch ui-rounded-full" checked>
        <:label>Full</:label>
      </.switch>
    </div>
    """
  end

  defp styling_block_label_code do
    """
      <:label>#{DemoScales.block_demo_label()}</:label>
    """
  end

  def styling_width_code do
    label = styling_block_label_code()

    DemoScales.width_layout_variants("switch")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("switch", modifier)

      """
      <.switch class="#{class}" checked>
      #{label}
      </.switch>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    label = styling_block_label_code()

    DemoScales.max_width_variants("switch")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_block_modifiers("switch", modifier)

      """
      <.switch class="#{class}" checked>
      #{label}
      </.switch>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("switch"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.switch
          id={"switch-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("switch", variant.modifier)}
          checked
        >
          <:label>{DemoScales.block_demo_label()}</:label>
        </.switch>
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("switch"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.switch
          id={"switch-style-max-#{variant.id}"}
          class={DemoScales.join_block_modifiers("switch", variant.modifier)}
          checked
        >
          <:label>{DemoScales.block_demo_label()}</:label>
        </.switch>
      </div>
    </div>
    """
  end

  def api_set_checked_client_binding_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Switch.set_checked("switch-api-cb", true)} class="button ui-size-sm">On</.action>
      <.action phx-click={Corex.Switch.set_checked("switch-api-cb", false)} class="button ui-size-sm">Off</.action>
      <.action phx-click={Corex.Switch.toggle_checked("switch-api-cb")} class="button ui-size-sm">Toggle</.action>
    </div>
    <.switch class="switch">
      <:label>Power</:label>
    </.switch>
    """
  end

  def api_set_checked_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-center w-full">
      <div class="flex flex-wrap gap-2 items-center">
        <.action phx-click={Corex.Switch.set_checked("switch-api-cb", true)} class="button ui-size-sm">
          On
        </.action>
        <.action
          phx-click={Corex.Switch.set_checked("switch-api-cb", false)}
          class="button ui-size-sm"
        >
          Off
        </.action>
        <.action phx-click={Corex.Switch.toggle_checked("switch-api-cb")} class="button ui-size-sm">
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
        class="button ui-size-sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: true } }))"
      >
        On
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: false } }))"
      >
        Off
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:toggle-checked', { bubbles: false }))"
      >
        Toggle
      </button>
    </div>
    <.switch class="switch">
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
          class="button ui-size-sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: true } }))"
        >
          On
        </button>
        <button
          type="button"
          class="button ui-size-sm"
          onclick="document.getElementById('switch-api-cjs')?.dispatchEvent(new CustomEvent('corex:switch:set-checked', {bubbles: false, detail: { checked: false } }))"
        >
          Off
        </button>
        <button
          type="button"
          class="button ui-size-sm"
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
      <.action phx-click="switch_api_on" class="button ui-size-sm">On</.action>
      <.action phx-click="switch_api_off" class="button ui-size-sm">Off</.action>
      <.action phx-click="switch_api_toggle" class="button ui-size-sm">Toggle</.action>
    </div>
    <.switch class="switch">
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
        <.action phx-click="switch_api_on" class="button ui-size-sm">On</.action>
        <.action phx-click="switch_api_off" class="button ui-size-sm">Off</.action>
        <.action phx-click="switch_api_toggle" class="button ui-size-sm">Toggle</.action>
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
      <.action phx-click={Corex.Switch.set_checked(@id, true)} class="button ui-size-sm">On</.action>
      <.action phx-click={Corex.Switch.set_checked(@id, false)} class="button ui-size-sm">
        Off
      </.action>
      <.action phx-click={Corex.Switch.toggle_checked(@id)} class="button ui-size-sm">
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
    <.switch class="switch" on_checked_change="switch_changed">
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
    <.switch class="switch" on_checked_change_client="switch-changed">
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
    <.switch class="switch">
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
      <.switch field={@form[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" class="button ui-accent">
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
      <.switch field={@form[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" class="button ui-accent">
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
      <.switch field={f[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-changeset-submit" class="button ui-accent">
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
      <.switch field={f[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-validate-submit" class="button ui-accent">
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
        class="switch"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" class="button ui-accent">
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
        class="switch"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
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
        class="switch"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
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
        class="switch"
        id="switch-form-live-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-submit" class="button ui-accent">
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
        class="switch"
        id="switch-form-live-strict"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-live-strict-submit" class="button ui-accent">
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
        class="switch"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-form-native-submit" class="button ui-accent">
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
      <.switch field={@form[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" class="button ui-accent">
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
      <.switch field={@form[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" class="button ui-accent">
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
      <.switch field={@form[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_heex do
    ~S"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <.switch field={@form[:notifications]} class="switch">
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_controlled_heex do
    ~S"""
    <.form for={@ecto_controlled_form} phx-change="validate_controlled" phx-submit="save_controlled">
      <.switch
        field={@ecto_controlled_form[:notifications]}
        class="switch"
        id="switch-live-form-ecto-controlled-notifications"
        controlled
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-live-form-ecto-controlled-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_invalid_heex do
    ~S"""
    <.form for={@ecto_invalid_form} phx-change="validate_invalid" phx-submit="save_invalid">
      <.switch
        field={@ecto_invalid_form[:notifications]}
        class="switch"
        id="switch-live-form-ecto-invalid-notifications"
        invalid={Corex.FormField.invalid?(@ecto_invalid_form[:notifications])}
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-live-form-ecto-invalid-submit" class="button ui-accent">
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
      <.switch field={f[:notifications]} class="switch" id="switch-form-phoenix-notifications">
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-form-phoenix-submit" class="button ui-accent">
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
        class="switch"
        id="switch-form-ecto-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-form-ecto-submit" class="button ui-accent">
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
        class="switch"
        id="switch-live-form-phoenix-notifications"
      >
        <:label>Enable notifications</:label>
      </.switch>
      <.action type="submit" id="switch-live-form-phoenix-submit" class="button ui-accent">
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
        class="switch"
        id="switch-live-form-ecto-notifications"
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-live-form-ecto-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto_controlled(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_controlled"
      phx-submit="save_controlled"
    >
      <.switch
        field={@form[:notifications]}
        class="switch"
        id="switch-live-form-ecto-controlled-notifications"
        controlled
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action
        type="submit"
        id="switch-live-form-ecto-controlled-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto_invalid(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_invalid"
      phx-submit="save_invalid"
    >
      <.switch
        field={@form[:notifications]}
        class="switch"
        id="switch-live-form-ecto-invalid-notifications"
        invalid={Corex.FormField.invalid?(@form[:notifications])}
      >
        <:label>Enable notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>
      <.action type="submit" id="switch-live-form-ecto-invalid-submit" class="button ui-accent">
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

  def form_doc_live_ecto_controlled_elixir do
    ~S"""
    defmodule MyAppWeb.SwitchFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_controlled_form =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :preferences_ecto_controlled, id: "switch-live-form-ecto-controlled")

        {:ok, assign(socket, :ecto_controlled_form, ecto_controlled_form)}
      end

      def handle_event("validate_controlled", %{"preferences_ecto_controlled" => params}, socket) do
        validate_ecto_controlled(socket, params)
      end

      def handle_event("save_controlled", %{"preferences_ecto_controlled" => params}, socket) do
        case MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_controlled_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params),
                 as: :preferences_ecto_controlled,
                 id: "switch-live-form-ecto-controlled"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_controlled_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :preferences_ecto_controlled,
                 id: "switch-live-form-ecto-controlled"
               )
             )}
        end
      end

      defp validate_ecto_controlled(socket, params) do
        changeset =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_controlled_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :preferences_ecto_controlled,
             id: "switch-live-form-ecto-controlled"
           )
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_invalid_elixir do
    ~S"""
    defmodule MyAppWeb.SwitchFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_invalid_form =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :preferences_ecto_invalid, id: "switch-live-form-ecto-invalid")

        {:ok, assign(socket, :ecto_invalid_form, ecto_invalid_form)}
      end

      def handle_event("validate_invalid", %{"preferences_ecto_invalid" => params}, socket) do
        validate_ecto_invalid(socket, params)
      end

      def handle_event("save_invalid", %{"preferences_ecto_invalid" => params}, socket) do
        case MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_invalid_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Preferences.changeset_validate(%MyApp.Forms.Preferences{}, params),
                 as: :preferences_ecto_invalid,
                 id: "switch-live-form-ecto-invalid"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_invalid_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :preferences_ecto_invalid,
                 id: "switch-live-form-ecto-invalid"
               )
             )}
        end
      end

      defp validate_ecto_invalid(socket, params) do
        changeset =
          %MyApp.Forms.Preferences{}
          |> MyApp.Forms.Preferences.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_invalid_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :preferences_ecto_invalid,
             id: "switch-live-form-ecto-invalid"
           )
         )}
      end
    end
    """
  end

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_ecto_heex()
  def form_ecto_elixir, do: form_doc_controller_ecto_elixir()
end
