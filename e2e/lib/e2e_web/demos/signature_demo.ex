defmodule E2eWeb.Demos.SignatureDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.signature_pad class="signature-pad">
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.signature_pad id="signature-anatomy-minimal" class="signature-pad">
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def with_label_code do
    ~S"""
    <.signature_pad class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def with_label_example(assigns) do
    _ = assigns

    ~H"""
    <.signature_pad id="signature-anatomy-labeled" class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def api_clear_client_binding_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.SignaturePad.clear("signature-api-cb")} class="button button--sm">
        Clear
      </.action>
    </div>

    <.signature_pad id="signature-api-cb" class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def api_clear_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row">
      <.action phx-click={Corex.SignaturePad.clear("signature-api-cb")} class="button button--sm">
        Clear
      </.action>
    </div>

    <.signature_pad id="signature-api-cb" class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def api_clear_client_js_heex do
    ~S"""
    <div class="layout__row">
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('signature-api-cjs')?.dispatchEvent(new CustomEvent('corex:signature-pad:clear', { bubbles: false, detail: { id: 'signature-api-cjs' } }))"
      >
        Clear (client JS)
      </button>
    </div>

    <.signature_pad id="signature-api-cjs" class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def api_clear_client_js_js do
    ~S"""
    const el = document.getElementById("signature-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:signature-pad:clear", {
        bubbles: false,
        detail: { id: "signature-api-cjs" }
      })
    );
    """
  end

  def api_clear_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("signature-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:signature-pad:clear", {
        bubbles: false,
        detail: { id: "signature-api-cjs" }
      })
    );
    """
  end

  def api_clear_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="layout__row">
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('signature-api-cjs')?.dispatchEvent(new CustomEvent('corex:signature-pad:clear', { bubbles: false, detail: { id: 'signature-api-cjs' } }))"
        >
          Clear (client JS)
        </button>
      </div>
      <.signature_pad id="signature-api-cjs" class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
      </.signature_pad>
    </div>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="signature_api_clear" class="button button--sm">
        Clear (server)
      </.action>
    </div>

    <.signature_pad id="signature-api-srv" class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def api_clear_server_elixir do
    ~S"""
    def handle_event("signature_api_clear", _params, socket) do
      {:noreply, Corex.SignaturePad.clear(socket, "signature-api-srv")}
    end
    """
  end

  def api_clear_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="layout__row">
        <.action phx-click="signature_api_clear" class="button button--sm">
          Clear (server)
        </.action>
      </div>
      <.signature_pad id="signature-api-srv" class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
      </.signature_pad>
    </div>
    """
  end

  def api_client_binding_code, do: api_clear_client_binding_heex()
  def api_client_binding_example(assigns), do: api_clear_client_binding_example(assigns)

  def api_codes do
    %{
      clear_client_binding: api_clear_client_binding_heex(),
      clear_client_js_heex: api_clear_client_js_heex(),
      clear_client_js: api_clear_client_js_js(),
      clear_client_ts: api_clear_client_js_ts(),
      clear_server_heex: api_clear_server_heex(),
      clear_server_elixir: api_clear_server_elixir()
    }
  end

  def events_server_heex do
    ~S"""
    <.signature_pad class="signature-pad" on_draw_end="signature_drawn">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "signature_drawn",
      ~S|%{"id" => id, "url" => url} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.signature_pad
      id="signature-events-client"
      class="signature-pad"
      on_draw_end_client="signature-drawn"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("signature-events-client");
    el?.addEventListener("signature-drawn", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("signature-events-client");
    el?.addEventListener("signature-drawn", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code, do: form_changeset_heex()

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.SignatureForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :signature, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:signature])
        |> validate_required([:signature])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:signature])
        |> validate_required([:signature], message: "can't be blank")
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@phoenix_form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def signature_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"signature" => ""}, as: :signature_phoenix, id: "signature-form-phoenix")

      render(conn, :signature_form_page, phoenix_form: phoenix_form)
    end

    def signature_form_submit(conn, params) do
      if is_map(params["signature_phoenix"]) do
        signature = params["signature_phoenix"]["signature"] || ""

        conn
        |> put_flash(:info, "Submitted: signature saved")
        |> redirect(to: ~p"/signature-pad/form#signature-form-phoenix")
      end
    end
    """
  end

  def form_doc_controller_ecto_heex do
    ~S"""
    <.form
      :let={f}
      for={@ecto_form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_ecto_elixir do
    ~S"""
    def signature_form_page(conn, _params) do
      ecto_form =
        %MyApp.Forms.SignatureForm{}
        |> MyApp.Forms.SignatureForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :signature_ecto, id: "signature-form-ecto")

      render(conn, :signature_form_page, ecto_form: ecto_form)
    end

    def signature_form_submit(conn, params) do
      if is_map(params["signature_ecto"]) do
        case MyApp.Forms.SignatureForm.changeset_validate(%MyApp.Forms.SignatureForm{}, params["signature_ecto"]) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(:info, "Submitted: signature saved")
            |> redirect(to: ~p"/signature-pad/form#signature-form-ecto")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)
            ecto_form = Phoenix.Component.to_form(changeset, as: :signature_ecto, id: "signature-form-ecto")
            render(conn, :signature_form_page, ecto_form: ecto_form)
        end
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} phx-submit="save_phoenix">
      <.signature_pad field={@phoenix_form[:signature]} class="signature-pad" id="signature-live-form-phoenix-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" id="signature-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.SignatureFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"signature" => ""}, as: :signature_phoenix, id: "signature-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"signature_phoenix" => params}, socket) do
        signature = params["signature"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"signature" => signature}, as: :signature_phoenix, id: "signature-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_heex do
    ~S"""
    <.form for={@ecto_form} phx-change="validate" phx-submit="save">
      <.signature_pad field={@ecto_form[:signature]} class="signature-pad" id="signature-live-form-ecto-pad" on_draw_end="signature_drawn">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" id="signature-live-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.SignatureFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.SignatureForm{}
          |> MyApp.Forms.SignatureForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :signature_ecto, id: "signature-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", params, socket) do
        sparams = Map.get(params, "signature_ecto", %{})

        changeset =
          %MyApp.Forms.SignatureForm{}
          |> MyApp.Forms.SignatureForm.changeset_validate(sparams)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset, action: :validate, as: :signature_ecto, id: "signature-live-form-ecto")
         )}
      end

      def handle_event("signature_drawn", %{"paths" => paths} = payload, socket) do
        value =
          if is_list(paths) and paths != [],
            do: Enum.join(paths, "\n"),
            else: Map.get(payload, "url", "") || ""

        validate_ecto(socket, %{"signature" => value})
      end

      def handle_event("save", params, socket) do
        sparams = Map.get(params, "signature_ecto", %{})

        case MyApp.Forms.SignatureForm.changeset_validate(%MyApp.Forms.SignatureForm{}, sparams) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.SignatureForm.changeset_validate(%MyApp.Forms.SignatureForm{}, sparams),
                 as: :signature_ecto,
                 id: "signature-live-form-ecto"
               )
             )}

          %Ecto.Changeset{} = changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset, action: :insert, as: :signature_ecto, id: "signature-live-form-ecto")
             )}
        end
      end

      defp validate_ecto(socket, params) do
        changeset =
          %MyApp.Forms.SignatureForm{}
          |> MyApp.Forms.SignatureForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset, action: :validate, as: :signature_ecto, id: "signature-live-form-ecto")
         )}
      end
    end
    """
  end

  def form_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %MyApp.Forms.SignatureForm{}
        |> MyApp.Forms.SignatureForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :signature_changeset, id: "signature-changeset-form")

      render(conn, :form_page, form: form)
    end
    """
  end

  def form_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %MyApp.Forms.SignatureForm{}
        |> MyApp.Forms.SignatureForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :signature_validate, id: "signature-validate-form")

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
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" id="signature-changeset-submit" class="button button--accent">
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
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" id="signature-validate-submit" class="button button--accent">
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
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={f[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form action={~p"/signature-pad/form"} method="post" id="signature-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.signature_pad name="user[signature]" class="signature-pad" id="signature-form-native-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" id="signature-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/signature-pad/form"} method="post" id="signature-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.signature_pad name="user[signature]" class="signature-pad" id="signature-form-native-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" id="signature-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def signature_form_submit(conn, %{"user" => %{"signature" => sig}}) do
      conn
      |> put_flash(:info, "Submitted: signature=#{preview_sig(sig)}")
      |> redirect(to: ~p"/signature-pad/form#signature-form-native")
    end

    defp preview_sig(""), do: "(empty)"
    defp preview_sig(sig), do: sig
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_ecto_heex()
  def form_ecto_elixir, do: form_doc_controller_ecto_elixir()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix">
      <.signature_pad
        field={@form[:signature]}
        class="signature-pad"
        id="signature-live-form-phoenix-pad"
      >
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" id="signature-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <.signature_pad
        field={@form[:signature]}
        class="signature-pad"
        id="signature-live-form-ecto-pad"
        on_draw_end="signature_drawn"
      >
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" id="signature-live-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end
end
