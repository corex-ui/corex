defmodule E2eWeb.Demos.TagsInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.tags_input class="tags-input" value={["alpha", "beta"]}>
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
    <.tags_input class="tags-input" value={["alpha", "beta"]}>
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

  def with_translation_code do
    ~S"""
    <.tags_input
      class="tags-input"
      value={["lorem", "duis"]}
      translation={%Corex.TagsInput.Translation{
        placeholder: "Add lorem or duis…",
        delete_tag_trigger_label: "Remove %{tag}",
        tag_edited: "Edit %{tag}. Press enter to save or escape to cancel."
      }}
    >
      <:label>Keywords</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def with_translation_example(assigns) do
    ~H"""
    <.tags_input
      id="tags-anatomy-translation"
      class="tags-input"
      value={["lorem", "duis"]}
      translation={
        %Corex.TagsInput.Translation{
          placeholder: "Add lorem or duis…",
          delete_tag_trigger_label: "Remove %{tag}",
          tag_edited: "Edit %{tag}. Press enter to save or escape to cancel."
        }
      }
    >
      <:label>Keywords</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_server_heex do
    ~S"""
    <.tags_input
      class="tags-input"
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
    def handle_event("tags_value_changed", %{"id" => id, "value" => value} = params, socket) when is_list(value) do
      IO.inspect(params, label: "tags_value_changed")
      {:noreply, socket}
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
      class="tags-input"
      value={["lorem", "duis"]}
      max={2}
      allow_overflow={true}
      on_value_invalid="tags_value_invalid"
    >
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def events_invalid_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "tags_value_invalid",
      ~S|%{"id" => id, "reason" => reason} = params|
    )
  end

  def events_invalid_client_heex do
    ~S"""
    <.tags_input
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


  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@phoenix_form}
      action={~p"/tags-input/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.tags_input field={f[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def tags_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"tags" => "alpha,beta"}, as: :tags_input_phoenix, id: "tags-input-form-phoenix")

      render(conn, :tags_input_form_page, phoenix_form: phoenix_form)
    end

    def tags_input_form_submit(conn, params) do
      if is_map(params["tags_input_phoenix"]) do
        tags = params["tags_input_phoenix"]["tags"] || ""

        conn
        |> put_flash(:info, "Submitted: tags=#{inspect(tags)}")
        |> redirect(to: ~p"/tags-input/form#tags-input-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.tags_input field={@phoenix_form[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" id="tags-input-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/tags-input/form"}
      method="post"
      id={@form.id}
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
      <.action type="submit" class="button button--accent">
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
          |> redirect(to: ~p"/tags-input/form#tags-input-changeset-form")

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
          >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.tags_input
        name="tags_native[tags]"
        class="tags-input"
        value={["alpha", "beta"]}
      >
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" class="button button--accent">
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
          >
      <.tags_input field={@form[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.tags_input>
      <.action type="submit" class="button button--accent">
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
    <.action phx-click={Corex.TagsInput.set_value("tags-api-set-client", ["lorem", "duis"])} class="button button--sm">
      Set lorem and duis
    </.action>
    <.tags_input id="tags-api-set-client" class="tags-input" value={["donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_tags_set_value_server" class="button button--sm">
      Set lorem and duis
    </.action>
    <.tags_input id="tags-api-set-server" class="tags-input" value={["donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_tags_set_value_server", _params, socket) do
      {:noreply, Corex.TagsInput.set_value(socket, "tags-api-set-server", ["lorem", "duis"])}
    end
    """
  end

  def api_set_value_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:tags-input:set-value",
        to: "#tags-api-set-js",
        detail: %{value: ["lorem", "duis"]},
        bubbles: false
      )}
      class="button button--sm"
    >
      Set lorem and duis
    </.action>
    <.tags_input id="tags-api-set-js" class="tags-input" value={["donec"]}>
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
        detail: { value: ["lorem", "duis"] },
      })
    );
    """
  end

  def api_set_value_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("tags-api-set-js");
    el?.dispatchEvent(
      new CustomEvent<{ value: string[] }>("corex:tags-input:set-value", {
        bubbles: false,
        detail: { value: ["lorem", "duis"] },
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
            detail: %{value: ["lorem", "duis"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set lorem and duis
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_set_value_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_tags_set_value_server" class="button button--sm">
        Set lorem and duis
      </.action>
    </div>
    <.tags_input id="tags-api-set-server" class="tags-input" value={["donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_add_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.TagsInput.add_value("tags-api-add-client", "duis")} class="button button--sm">
      Add duis
    </.action>
    <.tags_input id="tags-api-add-client" class="tags-input" value={["lorem", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_add_value_server_heex do
    ~S"""
    <.action phx-click="api_tags_add_value_server" class="button button--sm">
      Add duis
    </.action>
    <.tags_input id="tags-api-add-server" class="tags-input" value={["lorem", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_add_value_server_elixir do
    ~S"""
    def handle_event("api_tags_add_value_server", _params, socket) do
      {:noreply, Corex.TagsInput.add_value(socket, "tags-api-add-server", "duis")}
    end
    """
  end

  def api_add_value_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:tags-input:add-value",
        to: "#tags-api-add-js",
        detail: %{value: "duis"},
        bubbles: false
      )}
      class="button button--sm"
    >
      Add duis
    </.action>
    <.tags_input id="tags-api-add-js" class="tags-input" value={["lorem", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_add_value_js_js do
    ~S"""
    const el = document.getElementById("tags-api-add-js");
    el?.dispatchEvent(
      new CustomEvent("corex:tags-input:add-value", {
        bubbles: false,
        detail: { value: "duis" },
      })
    );
    """
  end

  def api_add_value_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("tags-api-add-js");
    el?.dispatchEvent(
      new CustomEvent<{ value: string }>("corex:tags-input:add-value", {
        bubbles: false,
        detail: { value: "duis" },
      })
    );
    """
  end

  def api_add_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.TagsInput.add_value(@id, "duis")} class="button button--sm">
        Add duis
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["lorem", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_add_value_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_tags_add_value_server" class="button button--sm">
        Add duis
      </.action>
    </div>
    <.tags_input id="tags-api-add-server" class="tags-input" value={["lorem", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_add_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:tags-input:add-value",
            to: "##{@id}",
            detail: %{value: "duis"},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Add duis
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["lorem", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_client_binding_code do
    ~S"""
    <.action phx-click={Corex.TagsInput.clear_value("tags-api-clear-client")} class="button button--sm">
      Clear all
    </.action>
    <.action phx-click={Corex.TagsInput.remove_value("tags-api-clear-client", "lorem")} class="button button--sm">
      Clear lorem
    </.action>
    <.tags_input id="tags-api-clear-client" class="tags-input" value={["lorem", "duis", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <.action phx-click="api_tags_clear_all_server" class="button button--sm">
      Clear all
    </.action>
    <.action phx-click="api_tags_clear_lorem_server" class="button button--sm">
      Clear lorem
    </.action>
    <.tags_input id="tags-api-clear-server" class="tags-input" value={["lorem", "duis", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_server_elixir do
    ~S"""
    def handle_event("api_tags_clear_all_server", _params, socket) do
      {:noreply, Corex.TagsInput.clear_value(socket, "tags-api-clear-server")}
    end

    def handle_event("api_tags_clear_lorem_server", _params, socket) do
      {:noreply, Corex.TagsInput.remove_value(socket, "tags-api-clear-server", "lorem")}
    end
    """
  end

  def api_clear_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:tags-input:clear-value", to: "#tags-api-clear-js", bubbles: false)}
      class="button button--sm"
    >
      Clear all
    </.action>
    <.action
      phx-click={JS.dispatch("corex:tags-input:remove-value",
        to: "#tags-api-clear-js",
        detail: %{value: "lorem"},
        bubbles: false
      )}
      class="button button--sm"
    >
      Clear lorem
    </.action>
    <.tags_input id="tags-api-clear-js" class="tags-input" value={["lorem", "duis"]}>
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
    const el: HTMLElement | null = document.getElementById("tags-api-clear-js");
    el?.dispatchEvent(new CustomEvent("corex:tags-input:clear-value", { bubbles: false }));
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.TagsInput.set_value(@id, ["lorem", "duis"])}
        class="button button--sm"
      >
        Set lorem and duis
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.TagsInput.clear_value(@id)} class="button button--sm">
        Clear all
      </.action>
      <.action phx-click={Corex.TagsInput.remove_value(@id, "lorem")} class="button button--sm">
        Clear lorem
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["lorem", "duis", "donec"]}>
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
        Clear all
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:tags-input:remove-value",
            to: "##{@id}",
            detail: %{value: "lorem"},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Clear lorem
      </.action>
    </div>
    <.tags_input id={@id} class="tags-input" value={["lorem", "duis"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def api_clear_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_tags_clear_all_server" class="button button--sm">Clear all</.action>
      <.action phx-click="api_tags_clear_lorem_server" class="button button--sm">Clear lorem</.action>
    </div>
    <.tags_input id="tags-api-clear-server" class="tags-input" value={["lorem", "duis", "donec"]}>
      <:label>Tags</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.tags_input
      class="tags-input"
      controlled
      value={["lorem", "duis", "donec"]}
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
      class="tags-input"
      controlled
      value={["lorem", "duis"]}
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
      {:ok, assign(socket, :allowed_tags, ["lorem", "duis", "donec"])}
    end

    def handle_event("tags_patterns_validated_changed", %{"id" => _id, "value" => value}, socket)
        when is_list(value) do
      allowed = socket.assigns.allowed_tags
      filtered = Enum.filter(value, &(&1 in allowed))
      {:noreply, assign(socket, :tags_validated, filtered)}
    end
    """
  end

  def styling_tags_value, do: ["lorem", "duis", "donec"]

  def styling_color_heex do
    ~S"""
    <.tags_input class="tags-input w-full" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--muted" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--accent" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--brand" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--alert" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--success" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--info" value={["lorem", "duis", "donec"]}>
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
    <.tags_input class="tags-input w-full tags-input--trigger--accent" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--trigger--brand" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--trigger--alert" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--trigger--success" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--trigger--info" value={["lorem", "duis", "donec"]}>
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
    <.tags_input class="tags-input w-full tags-input--sm" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--md" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--lg" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--xl" value={["lorem", "duis", "donec"]}>
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
    <.tags_input class="tags-input w-full tags-input--text-sm" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--text-xl" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--text-2xl" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--text-4xl" value={["lorem", "duis", "donec"]}>
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
    <.tags_input class="tags-input w-full tags-input--rounded-none" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--rounded-sm" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--rounded-md" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--rounded-lg" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full tags-input--rounded-xl" value={["lorem", "duis", "donec"]}>
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
    <.tags_input class="tags-input w-full max-w-2xs" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full max-w-md" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full max-w-xl" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full max-w-2xl" value={["lorem", "duis", "donec"]}>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    <.tags_input class="tags-input w-full max-w-none" value={["lorem", "duis", "donec"]}>
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

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/tags-input/form"}
      method="post"
      id={@form.id}
    >
      <.tags_input field={f[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_changeset(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_changeset_heex()
  def form_ecto_elixir, do: form_doc_controller_changeset_elixir()
  def form_doc_live_ecto_heex do
    ~S"""
    <.form for={@ecto_form} id={@ecto_form.id} phx-change="validate" phx-submit="save">
      <.tags_input field={@ecto_form[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.tags_input>
      <.action type="submit" id="tags-input-live-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.tags_input field={@form[:tags]} class="tags-input">
        <:label>Keywords</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
      </.tags_input>
      <.action type="submit" id="tags-input-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_changeset(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.TagsInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"tags" => "alpha,beta"}, as: :tags_input_phoenix, id: "tags-input-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"tags_input_phoenix" => params}, socket) do
        tags = params["tags"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"tags" => tags}, as: :tags_input_phoenix, id: "tags-input-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.TagsInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.TagsInputForm{}
          |> MyApp.Forms.TagsInputForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :tags_input_ecto, id: "tags-input-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"tags_input_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.TagsInputForm{}
          |> MyApp.Forms.TagsInputForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :tags_input_ecto,
             id: "tags-input-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"tags_input_ecto" => params}, socket) do
        case MyApp.Forms.TagsInputForm.changeset_validate(%MyApp.Forms.TagsInputForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.TagsInputForm.changeset_validate(%MyApp.Forms.TagsInputForm{}, params),
                 as: :tags_input_ecto,
                 id: "tags-input-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :tags_input_ecto,
                 id: "tags-input-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end


end
