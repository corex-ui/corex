defmodule E2eWeb.Demos.EditableDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.editable id="editable-anatomy-minimal" class="editable" value="My custom value" placeholder="Enter value">
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.editable
      id="editable-anatomy-minimal"
      class="editable"
      value="My custom value"
      placeholder="Enter value"
    >
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def with_triggers_code do
    ~S"""
    <.editable
      id="editable-anatomy-triggers"
      class="editable"
      value="Double click to edit"
      activation_mode="dblclick"
      select_on_focus
    >
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def with_triggers_example(assigns) do
    ~H"""
    <.editable
      id="editable-anatomy-triggers"
      class="editable"
      value="Double click to edit"
      activation_mode="dblclick"
      select_on_focus
    >
      <:label>Name</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def styling_color_code do
    ~S"""
    <.editable id="editable-style-default" class="editable" value="Default">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable id="editable-style-accent" class="editable editable--accent" value="Accent">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable id="editable-style-brand" class="editable editable--brand" value="Brand">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.editable id="editable-style-color-default" class="editable" value="Default">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.editable id="editable-style-color-accent" class="editable editable--accent" value="Accent">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.editable id="editable-style-color-brand" class="editable editable--brand" value="Brand">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.editable id="editable-style-sm" class="editable editable--sm" value="SM">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable id="editable-style-lg" class="editable editable--lg" value="LG">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-sm">
      <.editable id="editable-style-sm" class="editable editable--sm" value="SM">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.editable id="editable-style-lg" class="editable editable--lg" value="LG">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </div>
    """
  end

  def api_set_value_client_binding_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Editable.set_value("editable-api-cb", "Alpha")} class="button button--sm">Alpha</.action>
      <.action phx-click={Corex.Editable.set_value("editable-api-cb", "Beta")} class="button button--sm">Beta</.action>
    </div>
    <.editable id="editable-api-cb" class="editable" default_value="Start">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4 w-full max-w-4xl">
      <.action
        phx-click={Corex.Editable.set_value("editable-api-cb", "Alpha")}
        class="button button--sm"
      >
        Alpha
      </.action>
      <.action
        phx-click={Corex.Editable.set_value("editable-api-cb", "Beta")}
        class="button button--sm"
      >
        Beta
      </.action>
    </div>
    <.editable id="editable-api-cb" class="editable" default_value="Start">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <div class="layout__row">
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('editable-api-cjs')?.dispatchEvent(new CustomEvent('corex:editable:set-value', { bubbles: false, detail: { value: 'Gamma' } }))"
      >
        Gamma (client JS)
      </button>
    </div>
    <.editable id="editable-api-cjs" class="editable" default_value="Start">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("editable-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:editable:set-value", { bubbles: false, detail: { value: "Gamma" } })
    );
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("editable-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:editable:set-value", { bubbles: false, detail: { value: "Gamma" } })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="layout__row">
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('editable-api-cjs')?.dispatchEvent(new CustomEvent('corex:editable:set-value', { bubbles: false, detail: { value: 'Gamma' } }))"
        >
          Gamma (client JS)
        </button>
      </div>
      <.editable id="editable-api-cjs" class="editable" default_value="Start">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </div>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="editable_api_alpha" class="button button--sm">Alpha</.action>
      <.action phx-click="editable_api_beta" class="button button--sm">Beta</.action>
    </div>
    <.editable id="editable-api-srv" class="editable" default_value="Start">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
    </.editable>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("editable_api_alpha", _params, socket) do
      {:noreply, Corex.Editable.set_value(socket, "editable-api-srv", "Alpha")}
    end

    def handle_event("editable_api_beta", _params, socket) do
      {:noreply, Corex.Editable.set_value(socket, "editable-api-srv", "Beta")}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="layout__row">
        <.action phx-click="editable_api_alpha" class="button button--sm">Alpha</.action>
        <.action phx-click="editable_api_beta" class="button button--sm">Beta</.action>
      </div>
      <.editable id="editable-api-srv" class="editable" default_value="Start">
        <:label>Label</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </div>
    """
  end

  def api_codes do
    %{
      set_value_client_binding: api_set_value_client_binding_heex(),
      set_value_client_js_heex: api_set_value_client_js_heex(),
      set_value_client_js: api_set_value_client_js_js(),
      set_value_client_ts: api_set_value_client_js_ts(),
      set_value_server_heex: api_set_value_server_heex(),
      set_value_server_elixir: api_set_value_server_elixir()
    }
  end

  def form_ecto do
    ~S"""
    defmodule E2e.Form.EditableForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :text, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:text])
        |> validate_required([:text], message: "can't be blank")
      end
    end
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
      <.editable
        field={@form[:text]}
        on_value_change="value_changed"
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
      >
        <:label>Text</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %E2e.Form.EditableForm{}
        |> E2e.Form.EditableForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :editable_form, id: "editable-form")

      {:ok, assign(socket, :form, form)}
    end

    def handle_event("validate", %{"editable_form" => params}, socket) do
      changeset =
        %E2e.Form.EditableForm{}
        |> E2e.Form.EditableForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :editable_form,
           id: "editable-form"
         )
       )}
    end

    def handle_event("value_changed", %{"value" => value}, socket) do
      params = Map.merge(socket.assigns.form.params || %{}, %{"text" => to_string(value)})

      changeset =
        %E2e.Form.EditableForm{}
        |> E2e.Form.EditableForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :editable_form,
           id: "editable-form"
         )
       )}
    end

    def handle_event("save", %{"editable_form" => params}, socket) do
      case E2e.Form.EditableForm.changeset(%E2e.Form.EditableForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(E2e.Form.EditableForm.changeset(%E2e.Form.EditableForm{}, params),
               as: :editable_form,
               id: "editable-form"
             )
           )}

        changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :editable_form,
               id: "editable-form"
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
      <.editable
        field={@form[:text]}
        on_value_change="value_changed"
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
      >
        <:label>Text</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def events_server_heex do
    ~S"""
    <.editable
      id="editable-events-server"
      class="editable"
      default_value="Edit me"
      on_value_change="editable_changed"
    >
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("editable_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.editable
      id="editable-events-client"
      class="editable"
      default_value="Edit me"
      on_value_change_client="editable-changed"
    >
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("editable-events-client");
    el?.addEventListener("editable-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("editable-events-client");
    el?.addEventListener("editable-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/editable/form"}
      method="post"
      id={@form.id}
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.editable
        field={f[:text]}
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
      >
        <:label>Text</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end
end
