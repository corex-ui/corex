defmodule E2eWeb.Demos.CheckboxDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.checkbox class="checkbox">
      <:label>Option</:label>
    </.checkbox>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.checkbox id="checkbox-anatomy-minimal" class="checkbox">
      <:label>Option</:label>
    </.checkbox>
    """
  end

  def labeled_code do
    ~S"""
    <.checkbox class="checkbox">
      <:label>Accept the terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
    </.checkbox>
    """
  end

  def labeled_example(assigns) do
    ~H"""
    <.checkbox id="checkbox-anatomy-labeled" class="checkbox">
      <:label>Accept the terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
    </.checkbox>
    """
  end

  def invalid_code do
    ~S"""
    <.checkbox
      class="checkbox checkbox--accent"
      invalid
      checked
      errors={["Required"]}
    >
      <:label>Subscribe</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.checkbox>
    """
  end

  def invalid_example(assigns) do
    ~H"""
    <.checkbox
      id="checkbox-anatomy-invalid"
      class="checkbox checkbox--accent"
      invalid
      checked
      errors={["Required"]}
    >
      <:label>Subscribe</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.checkbox>
    """
  end

  def styling_color_code do
    ~S"""
    <.checkbox class="checkbox" checked>
      <:label>Default</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    <.checkbox class="checkbox checkbox--accent" checked>
      <:label>Accent</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    <.checkbox class="checkbox checkbox--brand" checked>
      <:label>Brand</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    <.checkbox class="checkbox checkbox--alert" checked>
      <:label>Alert</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    <.checkbox class="checkbox checkbox--info" checked>
      <:label>Info</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    <.checkbox class="checkbox checkbox--success" checked>
      <:label>Success</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.checkbox id="checkbox-style-color-default" class="checkbox" checked>
        <:label>Default</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox id="checkbox-style-color-accent" class="checkbox" checked>
        <:label>Accent</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox id="checkbox-style-color-brand" class="checkbox checkbox--brand" checked>
        <:label>Brand</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox id="checkbox-style-color-alert" class="checkbox checkbox--alert" checked>
        <:label>Alert</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox id="checkbox-style-color-info" class="checkbox checkbox--info" checked>
        <:label>Info</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
      <.checkbox id="checkbox-style-color-success" class="checkbox checkbox--success" checked>
        <:label>Success</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.checkbox class="checkbox checkbox--sm">
      <:label>Small</:label>
    </.checkbox>
    <.checkbox class="checkbox">
      <:label>Default</:label>
    </.checkbox>
    <.checkbox class="checkbox checkbox--lg">
      <:label>Large</:label>
    </.checkbox>
    <.checkbox class="checkbox checkbox--xl">
      <:label>XLarge</:label>
    </.checkbox>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.checkbox id="checkbox-style-sm" class="checkbox checkbox--sm">
        <:label>Small</:label>
      </.checkbox>
      <.checkbox id="checkbox-style-md" class="checkbox">
        <:label>Medium</:label>
      </.checkbox>
      <.checkbox id="checkbox-style-lg" class="checkbox checkbox--lg">
        <:label>Large</:label>
      </.checkbox>
      <.checkbox id="checkbox-style-xl" class="checkbox checkbox--xl">
        <:label>XLarge</:label>
      </.checkbox>
    </div>
    """
  end

  def api_client_binding_code do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", true)} class="button button--sm">
        Set checked
      </.action>
      <.action phx-click={Corex.Checkbox.set_checked("checkbox-api-bind", false)} class="button button--sm">
        Set unchecked
      </.action>
      <.action phx-click={Corex.Checkbox.toggle_checked("checkbox-api-bind")} class="button button--sm">
        Toggle
      </.action>
    </div>
    <.checkbox id="checkbox-api-bind" class="checkbox">
      <:label>Terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Checkbox.set_checked(@id, true)} class="button button--sm">
        Set checked
      </.action>
      <.action phx-click={Corex.Checkbox.set_checked(@id, false)} class="button button--sm">
        Set unchecked
      </.action>
      <.action phx-click={Corex.Checkbox.toggle_checked(@id)} class="button button--sm">
        Toggle
      </.action>
    </div>
    <.checkbox id={@id} class="checkbox">
      <:label>Terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
    </.checkbox>
    """
  end

  def events_server_heex do
    ~S"""
    <.checkbox
      class="checkbox"
      on_checked_change="checkbox_changed"
    >
      <:label>Subscribe</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
    </.checkbox>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "checkbox_changed",
      ~S|%{"id" => id, "checked" => checked} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.checkbox
      id="checkbox-on-checked-change-client"
      class="checkbox"
      on_checked_change_client="checkbox-changed"
    >
      <:label>Subscribe</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
    </.checkbox>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("checkbox-on-checked-change-client");
    el?.addEventListener("checkbox-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("checkbox-on-checked-change-client");
    el?.addEventListener("checkbox-changed", (event: Event) =>
      console.log((event as CustomEvent<{ id: string; checked: boolean }>).detail)
    );
    """
  end

  def patterns_common_code do
    ~S"""
    <.checkbox class="checkbox">
      <:label>Option</:label>
    </.checkbox>
    """
  end

  def patterns_common_example(assigns) do
    ~H"""
    <.checkbox id="checkbox-pattern" class="checkbox">
      <:label>Option</:label>
    </.checkbox>
    """
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={checkbox} assign={@checkbox}>
      <:loading>
        <.checkbox_skeleton class="checkbox" />
      </:loading>

      <.checkbox
        class="checkbox"
        checked={checkbox.checked}
      >
        <:label>Accept terms</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:indeterminate>
          <.heroicon name="hero-minus" />
        </:indeterminate>
      </.checkbox>
    </.async_result>
    """
  end

  def patterns_async_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign_async(:checkbox, fn ->
         Process.sleep(1000)
         {:ok, %{checkbox: %{checked: true}}}
       end)}
    end
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.checkbox
      class="checkbox"
      controlled
      checked={@checked}
      on_checked_change="patterns_controlled_changed"
    >
      <:label>Accept terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :checked, true)}
    end

    def handle_event("patterns_controlled_changed", %{"checked" => checked}, socket) do
      {:noreply, assign(socket, :checked, checked)}
    end
    """
  end

  def indeterminate_code do
    ~S"""
    <.checkbox class="checkbox" checked={:indeterminate}>
      <:label>Select some rows</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def indeterminate_example(assigns) do
    ~H"""
    <.checkbox id="checkbox-anatomy-indeterminate" class="checkbox" checked={:indeterminate}>
      <:label>Select some rows</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def api_js_dispatch_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('checkbox-api-dispatch')?.dispatchEvent(new CustomEvent('corex:checkbox:set-checked', { bubbles: false, detail: { checked: true } }))"
      >
        Set checked
      </button>
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('checkbox-api-dispatch')?.dispatchEvent(new CustomEvent('corex:checkbox:set-checked', { bubbles: false, detail: { checked: false } }))"
      >
        Set unchecked
      </button>
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('checkbox-api-dispatch')?.dispatchEvent(new CustomEvent('corex:checkbox:toggle-checked', { bubbles: false }))"
      >
        Toggle
      </button>
    </div>
    <.checkbox id="checkbox-api-dispatch" class="checkbox">
      <:label>Terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def api_js_dispatch_js do
    ~S"""
    const el = document.getElementById("checkbox-api-dispatch");

    el?.dispatchEvent(
      new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: true } })
    );

    el?.dispatchEvent(
      new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: false } })
    );

    el?.dispatchEvent(new CustomEvent("corex:checkbox:toggle-checked", { bubbles: false }));
    """
  end

  def api_js_dispatch_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("checkbox-api-dispatch");

    el?.dispatchEvent(
      new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: true } })
    );

    el?.dispatchEvent(
      new CustomEvent("corex:checkbox:set-checked", { bubbles: false, detail: { checked: false } })
    );

    el?.dispatchEvent(new CustomEvent("corex:checkbox:toggle-checked", { bubbles: false }));
    """
  end

  def api_js_dispatch_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <button
        type="button"
        class="button button--sm"
        phx-click={
          JS.dispatch("corex:checkbox:set-checked",
            to: "#checkbox-api-dispatch",
            detail: %{checked: true},
            bubbles: false
          )
        }
      >
        Set checked
      </button>
      <button
        type="button"
        class="button button--sm"
        phx-click={
          JS.dispatch("corex:checkbox:set-checked",
            to: "#checkbox-api-dispatch",
            detail: %{checked: false},
            bubbles: false
          )
        }
      >
        Set unchecked
      </button>
      <button
        type="button"
        class="button button--sm"
        phx-click={
          JS.dispatch("corex:checkbox:toggle-checked", to: "#checkbox-api-dispatch", bubbles: false)
        }
      >
        Toggle
      </button>
    </div>
    <.checkbox id="checkbox-api-dispatch" class="checkbox">
      <:label>Terms</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:indeterminate>
        <.heroicon name="hero-minus" />
      </:indeterminate>
    </.checkbox>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("check", %{"id" => id}, socket) do
      {:noreply, Corex.Checkbox.set_checked(socket, id, true)}
    end

    def handle_event("uncheck", %{"id" => id}, socket) do
      {:noreply, Corex.Checkbox.set_checked(socket, id, false)}
    end

    def handle_event("toggle", %{"id" => id}, socket) do
      {:noreply, Corex.Checkbox.toggle_checked(socket, id)}
    end
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Form.Terms do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :terms, :boolean, default: false
      end

      def changeset_validate(terms, attrs \\ %{}) do
        terms
        |> cast(attrs, [:terms])
        |> validate_required([:terms], message: "can't be blank")
        |> validate_acceptance(:terms, message: "must be accepted to continue")
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@phoenix_form}
      action={~p"/checkbox/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.checkbox field={f[:terms]} class="checkbox" id="checkbox-form-phoenix-terms">
        <:label>Accept terms</:label>
      </.checkbox>
      <.action type="submit" id="checkbox-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def checkbox_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"terms" => false},
          as: :terms_phoenix,
          id: "checkbox-form-phoenix"
        )

      render(conn, :checkbox_form_page, phoenix_form: phoenix_form)
    end

    def checkbox_form_submit(conn, params) do
      if is_map(params["terms_phoenix"]) do
        terms = params["terms_phoenix"]["terms"] in [true, "true", "on", "1", 1]

        conn
        |> put_flash(:info, "Submitted: terms=#{inspect(terms)}")
        |> redirect(to: ~p"/checkbox/form#checkbox-form-phoenix")
      end
    end
    """
  end

  def form_doc_controller_ecto_heex do
    ~S"""
    <.form
      :let={f}
      for={@ecto_form}
      action={~p"/checkbox/form"}
      method="post"
      id={@ecto_form.id}
    >
      <.checkbox field={f[:terms]} class="checkbox" id="checkbox-form-ecto-terms">
        <:label>Accept terms</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>
      <.action type="submit" id="checkbox-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_ecto_elixir do
    ~S"""
    def checkbox_form_page(conn, _params) do
      ecto_form =
        %MyApp.Form.Terms{}
        |> MyApp.Form.Terms.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :terms_ecto, id: "checkbox-form-ecto")

      render(conn, :checkbox_form_page, ecto_form: ecto_form)
    end

    def checkbox_form_submit(conn, params) do
      if is_map(params["terms_ecto"]) do
        changeset =
          %MyApp.Form.Terms{}
          |> MyApp.Form.Terms.changeset_validate(params["terms_ecto"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted: terms=#{inspect(data.terms)}")
          |> redirect(to: ~p"/checkbox/form#checkbox-form-ecto")
        else
          changeset = Map.put(changeset, :action, :insert)
          ecto_form = Phoenix.Component.to_form(changeset, as: :terms_ecto, id: "checkbox-form-ecto")
          render(conn, :checkbox_form_page, ecto_form: ecto_form)
        end
      end
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/checkbox/form"} method="post" id="checkbox-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.checkbox name="terms[terms]" id="checkbox-form-native-terms" class="checkbox">
        <:label>Accept terms</:label>
      </.checkbox>
      <.action type="submit" id="checkbox-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def checkbox_form_submit(conn, %{"terms" => %{"terms" => terms}}) do
      conn
      |> put_flash(:info, "Submitted: terms=#{inspect(terms)}")
      |> redirect(to: ~p"/checkbox/form#checkbox-form-native")
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form
      for={@phoenix_form}
      id={@phoenix_form.id}
      phx-submit="save_phoenix"
    >
      <.checkbox field={@phoenix_form[:terms]} class="checkbox" controlled id="checkbox-live-form-phoenix-terms">
        <:label>Accept terms</:label>
      </.checkbox>
      <.action type="submit" id="checkbox-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_heex do
    ~S"""
    <.form
      for={@ecto_form}
      id={@ecto_form.id}
      phx-change="validate"
      phx-submit="save"
    >
      <.checkbox field={@ecto_form[:terms]} class="checkbox" controlled id="checkbox-live-form-ecto-terms">
        <:label>Accept terms</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>
      <.action type="submit" id="checkbox-live-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-submit="save_phoenix"
    >
      <.checkbox
        field={@form[:terms]}
        class="checkbox"
        controlled
        id="checkbox-live-form-phoenix-terms"
      >
        <:label>Accept terms</:label>
      </.checkbox>
      <.action type="submit" id="checkbox-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
    >
      <.checkbox field={@form[:terms]} class="checkbox" controlled id="checkbox-live-form-ecto-terms">
        <:label>Accept terms</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>
      <.action type="submit" id="checkbox-live-form-ecto-submit" class="button button--accent">
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
      action={~p"/checkbox/form"}
      method="post"
      id={@form.id}
    >
      <.checkbox field={f[:terms]} class="checkbox" id="checkbox-form-phoenix-terms">
        <:label>Accept terms</:label>
      </.checkbox>
      <.action type="submit" id="checkbox-form-phoenix-submit" class="button button--accent">
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
      action={~p"/checkbox/form"}
      method="post"
      id={@form.id}
    >
      <.checkbox field={f[:terms]} class="checkbox" id="checkbox-form-ecto-terms">
        <:label>Accept terms</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>
      <.action type="submit" id="checkbox-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form action={~p"/checkbox/form"} method="post" id="checkbox-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.checkbox name="terms[terms]" id="checkbox-form-native-terms" class="checkbox">
        <:label>Accept terms</:label>
      </.checkbox>
      <.action type="submit" id="checkbox-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.CheckboxFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"terms" => false},
            as: :terms_phoenix,
            id: "checkbox-live-form-phoenix"
          )

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"terms_phoenix" => params}, socket) do
        terms = params["terms"] in [true, "true", "on", "1", 1]

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"terms" => terms},
             as: :terms_phoenix,
             id: "checkbox-live-form-phoenix"
           )
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.CheckboxFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Form.Terms{}
          |> MyApp.Form.Terms.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :terms_ecto, id: "checkbox-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"terms_ecto" => params}, socket) do
        changeset =
          %MyApp.Form.Terms{}
          |> MyApp.Form.Terms.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :terms_ecto,
             id: "checkbox-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"terms_ecto" => params}, socket) do
        case MyApp.Form.Terms.changeset_validate(%MyApp.Form.Terms{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Form.Terms.changeset_validate(%MyApp.Form.Terms{}, params),
                 as: :terms_ecto,
                 id: "checkbox-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :terms_ecto,
                 id: "checkbox-live-form-ecto"
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
  def form_native_elixir, do: form_doc_controller_native_elixir()
end
