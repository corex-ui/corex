defmodule E2eWeb.Demos.TagsInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.tags_input id="tags-anatomy-minimal" class="tags-input" value={["alpha", "beta"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.tags_input id="tags-anatomy-minimal" class="tags-input" value={["alpha", "beta"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def with_label_code do
    ~S"""
    <.tags_input id="tags-anatomy-with-label" class="tags-input" value={["alpha", "beta"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def with_label_example(assigns) do
    ~H"""
    <.tags_input id="tags-anatomy-with-label" class="tags-input" value={["alpha", "beta"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_server_heex do
    ~S"""
    <.tags_input
      id="tags-input-on-value-change-server"
      class="tags-input"
      controlled
      value={["lorem", "duis", "donec"]}
      on_value_change="tags_value_changed"
    >
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("tags_value_changed", %{"id" => id, "value" => value}, socket) when is_list(value) do
      log = new_log("server", id, inspect(value))
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.tags_input
      id="tags-input-on-value-change-client"
      class="tags-input"
      value={["lorem", "duis", "donec"]}
      on_value_change_client="tags-client-changed"
    >
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("tags-input-on-value-change-client");
    el?.addEventListener("tags-client-changed", (e) => console.log(e.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("tags-input-on-value-change-client");
    el?.addEventListener("tags-client-changed", (e: Event) =>
      console.log((e as CustomEvent).detail)
    );
    """
  end

  def events_invalid_server_heex do
    ~S"""
    <.tags_input
      id="tags-input-on-value-invalid-server"
      class="tags-input"
      controlled
      value={["lorem", "duis"]}
      max={2}
      allow_overflow={true}
      on_value_change="tags_invalid_server_changed"
      on_value_invalid="tags_value_invalid"
    >
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_invalid_server_elixir do
    ~S"""
    def handle_event("tags_invalid_server_changed", %{"value" => value}, socket) when is_list(value) do
      {:noreply, assign(socket, :tags_invalid_server, value)}
    end

    def handle_event("tags_value_invalid", %{"id" => id, "reason" => reason}, socket) do
      log = new_invalid_log("server", id, inspect(reason))
      {:noreply, stream_insert(socket, :server_invalid_logs, log, at: 0)}
    end
    """
  end

  def events_invalid_client_heex do
    ~S"""
    <.tags_input
      id="tags-input-on-value-invalid-client"
      class="tags-input"
      value={["lorem", "duis"]}
      max={2}
      allow_overflow={true}
      on_value_invalid_client="tags-client-invalid"
    >
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_invalid_client_js do
    ~S"""
    const el = document.getElementById("tags-input-on-value-invalid-client");
    el?.addEventListener("tags-client-invalid", (e) => console.log(e.detail));
    """
  end

  def events_invalid_client_ts do
    ~S"""
    const el = document.getElementById("tags-input-on-value-invalid-client");
    el?.addEventListener("tags-client-invalid", (e: Event) =>
      console.log((e as CustomEvent).detail)
    );
    """
  end

  def form_code, do: form_doc_native_heex()

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.TagsInputForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :tags, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:tags])
        |> validate_required([:tags])
        |> validate_tag_count(:tags, 3)
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:tags])
        |> validate_required([:tags], message: "can't be blank")
        |> validate_format(:tags, ~r/^[^;]+$/, message: "must not contain semicolons")
        |> validate_tag_count(:tags, 3)
      end

      defp validate_tag_count(changeset, field, max) do
        validate_change(changeset, field, fn _, value ->
          n = value |> String.split(",", trim: true) |> length()
          if n <= max, do: [], else: [{field, "must have at most #{max} tags"}]
        end)
      end
    end
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_native_heex, do: form_doc_native_heex()

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/tags-input/form"}
      method="post"
      id={@form.id}
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.tags_input field={f[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.tags_input>
      <.action type="submit" id="tags-input-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def tags_input_form_page(conn, _params) do
      form =
        MyApp.Forms.TagsInputForm.changeset_validate(%MyApp.Forms.TagsInputForm{}, %{"tags" => "alpha,beta"})
        |> Phoenix.Component.to_form(as: :tags_input_changeset, id: "tags-input-changeset-form")

      render(conn, :tags_input_form_page, form: form)
    end

    def tags_input_form_create(conn, %{"tags_input_changeset" => params}) do
      case MyApp.Forms.TagsInputForm.changeset_validate(%MyApp.Forms.TagsInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Submitted: tags=#{data.tags}")
          |> redirect(to: ~p"/tags-input/form#tags-input-form-changeset")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :tags_input_changeset,
              id: "tags-input-changeset-form"
            )

          render(conn, :tags_input_form_page, form: form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/tags-input/form"}
      method="post"
      id="tags-input-native-form"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.tags_input
        id="tags-input-native-field"
        name="tags_native[tags]"
        class="tags-input"
        value={["alpha", "beta"]}
      >
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" id="tags-input-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/tags-input/form"}
      method="post"
      id={@form.id}
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.tags_input field={f[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.tags_input>
      <.action type="submit" id="tags-input-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/tags-input/form"}
      method="post"
      id="tags-input-native-form"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.tags_input
        id="tags-input-native-field"
        name="tags_native[tags]"
        class="tags-input"
        value={["alpha", "beta"]}
      >
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" id="tags-input-native-submit" class="button button--accent">
        Submit
      </.action>
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
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.tags_input field={@form[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.tags_input>
      <.action type="submit" id="tags-input-live-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("validate", %{"tags_input_changeset" => params}, socket) do
      changeset =
        %MyApp.Forms.TagsInputForm{}
        |> MyApp.Forms.TagsInputForm.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form, Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :tags_input_changeset,
         id: "tags-input-live-changeset-form"
       ))}
    end

    def handle_event("save", %{"tags_input_changeset" => params}, socket) do
      case MyApp.Forms.TagsInputForm.changeset_validate(%MyApp.Forms.TagsInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, put_flash(socket, :info, "Submitted: tags=#{data.tags}")}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :form, Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :tags_input_changeset,
             id: "tags-input-live-changeset-form"
           ))}
      end
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.tags_input field={@form[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.tags_input>
      <.action type="submit" id="tags-input-live-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.TagsInput.set_value("tags-api-set-client", ["lorem", "ipsum"])} class="button button--sm">
      Fill
    </.action>
    <.tags_input id="tags-api-set-client" class="tags-input" value={["one"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_tags_set_value_server" class="button button--sm">
      Fill from server
    </.action>
    <.tags_input id="tags-api-set-server" class="tags-input" controlled value={["one"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_tags_set_value_server", _params, socket) do
      socket = assign(socket, :tags, ["lorem", "ipsum"])
      {:noreply, Corex.TagsInput.set_value(socket, "tags-api-set-server", ["lorem", "ipsum"])}
    end
    """
  end

  def api_set_value_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:tags-input:set-value",
        to: "#tags-api-set-js",
        detail: %{value: ["lorem", "ipsum"]},
        bubbles: false
      )}
      class="button button--sm"
    >
      Fill via dispatch
    </.action>
    <.tags_input id="tags-api-set-js" class="tags-input" value={["one"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_set_value_js_js do
    ~S"""
    const el = document.getElementById("tags-api-set-js");
    el?.dispatchEvent(
      new CustomEvent("corex:tags-input:set-value", {
        bubbles: false,
        detail: { value: ["lorem", "ipsum"] },
      })
    );
    """
  end

  def api_set_value_js_ts do
    ~S"""
    const el = document.getElementById("tags-api-set-js");
    el?.dispatchEvent(
      new CustomEvent("corex:tags-input:set-value", {
        bubbles: false,
        detail: { value: ["lorem", "ipsum"] },
      })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:tags-input:set-value",
            to: "##{@id}",
            detail: %{value: ["lorem", "ipsum"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Fill via dispatch
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["one"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  attr(:value, :list, required: true)

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_tags_set_value_server" class="button button--sm">
        Fill from server
      </.action>
    </div>
    <.tags_input id="tags-api-set-server" class="tags-input" controlled value={@value}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_client_binding_code do
    ~S"""
    <.action phx-click={Corex.TagsInput.clear_value("tags-api-clear-client")} class="button button--sm">
      Clear
    </.action>
    <.tags_input id="tags-api-clear-client" class="tags-input" value={["a", "b", "c"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <.action phx-click="api_tags_clear_server" class="button button--sm">
      Clear from server
    </.action>
    <.tags_input id="tags-api-clear-server" class="tags-input" controlled value={["x", "y"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_server_elixir do
    ~S"""
    def handle_event("api_tags_clear_server", _params, socket) do
      socket = assign(socket, :tags_clear, [])
      {:noreply, Corex.TagsInput.clear_value(socket, "tags-api-clear-server")}
    end
    """
  end

  def api_clear_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:tags-input:clear-value", to: "#tags-api-clear-js", bubbles: false)}
      class="button button--sm"
    >
      Clear via dispatch
    </.action>
    <.tags_input id="tags-api-clear-js" class="tags-input" value={["a", "b"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_js_js do
    ~S"""
    const el = document.getElementById("tags-api-clear-js");
    el?.dispatchEvent(new CustomEvent("corex:tags-input:clear-value", { bubbles: false }));
    """
  end

  def api_clear_js_ts do
    ~S"""
    const el = document.getElementById("tags-api-clear-js");
    el?.dispatchEvent(new CustomEvent("corex:tags-input:clear-value", { bubbles: false }));
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.TagsInput.set_value(@id, ["lorem", "ipsum"])}
        class="button button--sm"
      >
        Fill
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["one"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.TagsInput.clear_value(@id)} class="button button--sm">Clear</.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["a", "b", "c"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:tags-input:clear-value", to: "##{@id}", bubbles: false)}
        class="button button--sm"
      >
        Clear via dispatch
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["a", "b"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  attr(:tags_clear, :list, required: true)

  def api_clear_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_tags_clear_server" class="button button--sm">Clear from server</.action>
    </div>
    <.tags_input id="tags-api-clear-server" class="tags-input" controlled value={@tags_clear}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.tags_input
      id="tags-input-patterns-controlled"
      class="tags-input"
      controlled
      value={~w(lorem duis donec)}
      on_value_change="tags_patterns_value_changed"
    >
      <:label>Labels</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def handle_event("tags_patterns_value_changed", %{"id" => _id, "value" => value}, socket)
        when is_list(value) do
      {:noreply, assign(socket, :tags, value)}
    end
    """
  end

  def patterns_validation_heex do
    ~S"""
    <.tags_input
      id="tags-input-patterns-validation"
      class="tags-input"
      controlled
      value={~w(lorem duis)}
      on_value_change="tags_patterns_validated_changed"
    >
      <:label>Allowed: lorem, duis, donec</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def patterns_validation_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :allowed_tags, ~w(lorem duis donec))}
    end

    def handle_event("tags_patterns_validated_changed", %{"id" => _id, "value" => value}, socket)
        when is_list(value) do
      allowed = socket.assigns.allowed_tags
      filtered = Enum.filter(value, &(&1 in allowed))
      {:noreply, assign(socket, :tags_validated, filtered)}
    end
    """
  end

  def styling_tags_value, do: ~w(lorem duis donec)

  def styling_color_heex do
    ~S"""
    <.tags_input id="tags-style-color-base" class="tags-input w-full" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-color-muted" class="tags-input w-full tags-input--muted" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-color-accent" class="tags-input w-full tags-input--accent" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-color-brand" class="tags-input w-full tags-input--brand" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-color-alert" class="tags-input w-full tags-input--alert" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-color-success" class="tags-input w-full tags-input--success" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-color-info" class="tags-input w-full tags-input--info" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def styling_color_example(assigns) do
    assigns = assign(assigns, :demo_tags, styling_tags_value())

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.tags_input id="tags-style-color-base" class="tags-input w-full" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-color-muted"
        class="tags-input w-full tags-input--muted"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-color-accent"
        class="tags-input w-full tags-input--accent"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-color-brand"
        class="tags-input w-full tags-input--brand"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-color-alert"
        class="tags-input w-full tags-input--alert"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-color-success"
        class="tags-input w-full tags-input--success"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-color-info"
        class="tags-input w-full tags-input--info"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
    </div>
    """
  end

  def styling_trigger_heex do
    ~S"""
    <.tags_input id="tags-style-trigger-accent" class="tags-input w-full tags-input--trigger--accent" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-trigger-brand" class="tags-input w-full tags-input--trigger--brand" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-trigger-alert" class="tags-input w-full tags-input--trigger--alert" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-trigger-success" class="tags-input w-full tags-input--trigger--success" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-trigger-info" class="tags-input w-full tags-input--trigger--info" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def styling_trigger_example(assigns) do
    assigns = assign(assigns, :demo_tags, styling_tags_value())

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.tags_input
        id="tags-style-trigger-accent"
        class="tags-input w-full tags-input--trigger--accent"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-trigger-brand"
        class="tags-input w-full tags-input--trigger--brand"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-trigger-alert"
        class="tags-input w-full tags-input--trigger--alert"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-trigger-success"
        class="tags-input w-full tags-input--trigger--success"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-trigger-info"
        class="tags-input w-full tags-input--trigger--info"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
    </div>
    """
  end

  def styling_size_heex do
    ~S"""
    <.tags_input id="tags-style-size-sm" class="tags-input w-full tags-input--sm" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-size-md" class="tags-input w-full tags-input--md" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-size-lg" class="tags-input w-full tags-input--lg" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-size-xl" class="tags-input w-full tags-input--xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :demo_tags, styling_tags_value())

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.tags_input id="tags-style-size-sm" class="tags-input w-full tags-input--sm" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-size-md" class="tags-input w-full tags-input--md" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-size-lg" class="tags-input w-full tags-input--lg" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-size-xl" class="tags-input w-full tags-input--xl" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
    </div>
    """
  end

  def styling_text_heex do
    ~S"""
    <.tags_input id="tags-style-text-sm" class="tags-input w-full tags-input--text-sm" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-text-xl" class="tags-input w-full tags-input--text-xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-text-2xl" class="tags-input w-full tags-input--text-2xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-text-4xl" class="tags-input w-full tags-input--text-4xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def styling_text_example(assigns) do
    assigns = assign(assigns, :demo_tags, styling_tags_value())

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.tags_input
        id="tags-style-text-sm"
        class="tags-input w-full tags-input--text-sm"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-text-xl"
        class="tags-input w-full tags-input--text-xl"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-text-2xl"
        class="tags-input w-full tags-input--text-2xl"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-text-4xl"
        class="tags-input w-full tags-input--text-4xl"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
    </div>
    """
  end

  def styling_radius_heex do
    ~S"""
    <.tags_input id="tags-style-radius-none" class="tags-input w-full tags-input--rounded-none" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-radius-sm" class="tags-input w-full tags-input--rounded-sm" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-radius-md" class="tags-input w-full tags-input--rounded-md" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-radius-lg" class="tags-input w-full tags-input--rounded-lg" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-radius-xl" class="tags-input w-full tags-input--rounded-xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def styling_radius_example(assigns) do
    assigns = assign(assigns, :demo_tags, styling_tags_value())

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.tags_input
        id="tags-style-radius-none"
        class="tags-input w-full tags-input--rounded-none"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-radius-sm"
        class="tags-input w-full tags-input--rounded-sm"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-radius-md"
        class="tags-input w-full tags-input--rounded-md"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-radius-lg"
        class="tags-input w-full tags-input--rounded-lg"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input
        id="tags-style-radius-xl"
        class="tags-input w-full tags-input--rounded-xl"
        value={@demo_tags}
      >
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
    </div>
    """
  end

  def styling_max_width_heex do
    ~S"""
    <.tags_input id="tags-style-max-2xs" class="tags-input w-full max-w-2xs" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-max-md" class="tags-input w-full max-w-md" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-max-xl" class="tags-input w-full max-w-xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-max-2xl" class="tags-input w-full max-w-2xl" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input id="tags-style-max-none" class="tags-input w-full max-w-none" value={~w(lorem duis donec)}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :demo_tags, styling_tags_value())

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.tags_input id="tags-style-max-2xs" class="tags-input w-full max-w-2xs" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-max-md" class="tags-input w-full max-w-md" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-max-xl" class="tags-input w-full max-w-xl" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-max-2xl" class="tags-input w-full max-w-2xl" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.tags_input id="tags-style-max-none" class="tags-input w-full max-w-none" value={@demo_tags}>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
    </div>
    """
  end
end
