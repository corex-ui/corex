defmodule E2eWeb.Demos.EditableDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.editable class="editable" value="My custom value" placeholder="Enter value">
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
    <.editable class="editable" value="Default">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable class="editable editable--accent" value="Accent">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable class="editable editable--brand" value="Brand">
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
    <.editable class="editable editable--sm" value="SM">
      <:label>Label</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    <.editable class="editable editable--lg" value="LG">
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
    <.editable id="editable-api-cb" class="editable" value="Start">
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
    <.editable id="editable-api-cb" class="editable" value="Start">
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
    <.editable id="editable-api-cjs" class="editable" value="Start">
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
      <.editable id="editable-api-cjs" class="editable" value="Start">
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
    <.editable id="editable-api-srv" class="editable" value="Start">
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
      <.editable id="editable-api-srv" class="editable" value="Start">
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
    defmodule MyApp.Form.EditableForm do
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

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@phoenix_form}
      action={~p"/editable/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.editable field={f[:text]} placeholder="Enter text" activation_mode="dblclick" select_on_focus class="editable" id="editable-form-phoenix-text">
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-phoenix-submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def editable_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"text" => ""}, as: :editable_phoenix, id: "editable-form-phoenix")

      render(conn, :editable_form_page, phoenix_form: phoenix_form)
    end

    def editable_form_submit(conn, params) do
      if is_map(params["editable_phoenix"]) do
        text = params["editable_phoenix"]["text"] || ""

        conn
        |> put_flash(:info, "Submitted: text=#{inspect(text)}")
        |> redirect(to: ~p"/editable/form#editable-form-phoenix")
      end
    end
    """
  end

  def form_doc_controller_ecto_heex do
    ~S"""
    <.form
      :let={f}
      for={@ecto_form}
      action={~p"/editable/form"}
      method="post"
      id={@ecto_form.id}
    >
      <.editable field={f[:text]} placeholder="Enter text" activation_mode="dblclick" select_on_focus class="editable" id="editable-form-ecto-text">
        <:label>Text</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-ecto-submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_ecto_elixir do
    ~S"""
    def editable_form_page(conn, _params) do
      ecto_form =
        %MyApp.Form.EditableForm{}
        |> MyApp.Form.EditableForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :editable_ecto, id: "editable-form-ecto")

      render(conn, :editable_form_page, ecto_form: ecto_form)
    end

    def editable_form_submit(conn, params) do
      if is_map(params["editable_ecto"]) do
        case MyApp.Form.EditableForm.changeset(%MyApp.Form.EditableForm{}, params["editable_ecto"]) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(:info, "Submitted: text=#{inspect(data.text)}")
            |> redirect(to: ~p"/editable/form#editable-form-ecto")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)
            ecto_form = Phoenix.Component.to_form(changeset, as: :editable_ecto, id: "editable-form-ecto")
            render(conn, :editable_form_page, ecto_form: ecto_form)
        end
      end
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/editable/form"} method="post" id="editable-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.editable name="editable[text]" value="" placeholder="Enter text" activation_mode="dblclick" select_on_focus class="editable" id="editable-form-native-text">
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-native-submit" class="button button--accent">Submit</.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def editable_form_submit(conn, %{"editable" => %{"text" => text}}) do
      conn
      |> put_flash(:info, "Submitted: text=#{inspect(text)}")
      |> redirect(to: ~p"/editable/form#editable-form-native")
    end
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.editable field={@phoenix_form[:text]} placeholder="Enter text" activation_mode="dblclick" select_on_focus class="editable" id="editable-live-form-phoenix-text">
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-live-form-phoenix-submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_ecto_heex do
    ~S"""
    <.form for={@ecto_form} id={@ecto_form.id} phx-change="validate" phx-submit="save">
      <.editable field={@ecto_form[:text]} on_value_change="value_changed" placeholder="Enter text" activation_mode="dblclick" select_on_focus class="editable" id="editable-live-form-ecto-text">
        <:label>Text</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-live-form-ecto-submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/editable/form"}
      method="post"
      id={@form.id}
    >
      <.editable
        field={f[:text]}
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
        id="editable-form-phoenix-text"
      >
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-phoenix-submit" class="button button--accent">
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
      action={~p"/editable/form"}
      method="post"
      id={@form.id}
    >
      <.editable
        field={f[:text]}
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
        id="editable-form-ecto-text"
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
      <.action type="submit" id="editable-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form action={~p"/editable/form"} method="post" id="editable-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.editable
        name="editable[text]"
        value=""
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
        id="editable-form-native-text"
      >
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.editable
        field={@form[:text]}
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
        id="editable-live-form-phoenix-text"
      >
        <:label>Text</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
      <.action type="submit" id="editable-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-change="validate" phx-submit="save">
      <.editable
        field={@form[:text]}
        on_value_change="value_changed"
        placeholder="Enter text"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
        id="editable-live-form-ecto-text"
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
      <.action type="submit" id="editable-live-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_ecto_heex()
  def form_ecto_elixir, do: form_doc_controller_ecto_elixir()

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
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
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.EditableFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"text" => ""}, as: :editable_phoenix, id: "editable-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"editable_phoenix" => params}, socket) do
        text = params["text"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"text" => text}, as: :editable_phoenix, id: "editable-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.EditableFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Form.EditableForm{}
          |> MyApp.Form.EditableForm.changeset(%{})
          |> Phoenix.Component.to_form(as: :editable_ecto, id: "editable-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", event_params, socket) do
        params =
          Map.get(event_params, "editable_ecto") ||
            socket.assigns.ecto_form.params

        changeset =
          %MyApp.Form.EditableForm{}
          |> MyApp.Form.EditableForm.changeset(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :editable_ecto,
             id: "editable-live-form-ecto"
           )
         )}
      end

      def handle_event("value_changed", %{"value" => value}, socket) do
        params = Map.merge(socket.assigns.ecto_form.params || %{}, %{"text" => to_string(value)})

        changeset =
          %MyApp.Form.EditableForm{}
          |> MyApp.Form.EditableForm.changeset(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :editable_ecto,
             id: "editable-live-form-ecto"
           )
         )}
      end

      def handle_event("save", event_params, socket) do
        params =
          Map.get(event_params, "editable_ecto") ||
            socket.assigns.ecto_form.params

        case MyApp.Form.EditableForm.changeset(%MyApp.Form.EditableForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Form.EditableForm.changeset(%MyApp.Form.EditableForm{}, params),
                 as: :editable_ecto,
                 id: "editable-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :editable_ecto,
                 id: "editable-live-form-ecto"
               )
             )}
        end
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
      <.action type="submit" id="editable-form-live-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def events_server_heex do
    ~S"""
    <.editable
      class="editable"
      value="Edit me"
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "editable_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.editable
      id="editable-events-client"
      class="editable"
      value="Edit me"
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

  def form_code, do: form_native_heex()
end
