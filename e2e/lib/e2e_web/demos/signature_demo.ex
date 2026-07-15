defmodule E2eWeb.Demos.SignatureDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def minimal_code do
    ~S"""
    <.signature_pad class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger>
        <.heroicon name="hero-x-mark" />
      </:clear_trigger>
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
    <.signature_pad
      on_draw_end="signature_drawn"
      class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger>
        <.heroicon name="hero-x-mark" />
      </:clear_trigger>
    </.signature_pad>
    """
  end

  def with_presets_code do
    ~S"""
    <.signature_pad
      drawing_fill="blue"
      drawing_size={3}
      drawing_simulate_pressure
      class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger>
        <.heroicon name="hero-x-mark" />
      </:clear_trigger>
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.SignaturePad.clear("signature-api-cb")} class="button ui-size-sm">
        Clear
      </.action>
    </div>

    <.signature_pad class="signature-pad">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def api_clear_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.SignaturePad.clear("signature-api-cb")} class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('signature-api-cjs')?.dispatchEvent(new CustomEvent('corex:signature-pad:clear', { bubbles: false, detail: { id: 'signature-api-cjs' } }))"
      >
        Clear
      </button>
    </div>

    <.signature_pad class="signature-pad">
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
      <div class="flex flex-wrap items-center gap-space">
        <button
          type="button"
          class="button ui-size-sm"
          onclick="document.getElementById('signature-api-cjs')?.dispatchEvent(new CustomEvent('corex:signature-pad:clear', { bubbles: false, detail: { id: 'signature-api-cjs' } }))"
        >
          Clear
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="signature_api_clear" class="button ui-size-sm">
        Clear
      </.action>
    </div>

    <.signature_pad class="signature-pad">
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
      <div class="flex flex-wrap items-center gap-space">
        <.action phx-click="signature_api_clear" class="button ui-size-sm">
          Clear
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
      for={@form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <.signature_pad field={@form[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button ui-accent">
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
      for={@form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <input type="hidden" name="signature_ecto[_sent]" value="1" />
      <.signature_pad field={@form[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button ui-accent">
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
    <.form for={@form} phx-submit="save_phoenix">
      <.signature_pad field={@form[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button ui-accent">
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
    <.form for={@form} phx-change="validate" phx-submit="save">
      <input type="hidden" name="signature_ecto[_sent]" value="1" />
      <.signature_pad field={@form[:signature]} class="signature-pad" on_draw_end="signature_drawn">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" class="button ui-accent">
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
      for={@form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <input type="hidden" name="signature_changeset[_sent]" value="1" />
      <.signature_pad field={@form[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
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
      for={@form}
      action={~p"/signature-pad/form"}
      method="post"
    >
      <input type="hidden" name="signature_validate[_sent]" value="1" />
      <.signature_pad field={@form[:signature]} class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
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
      <input type="hidden" name="signature_changeset[_sent]" value="1" />
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
      <.action type="submit" id="signature-changeset-submit" class="button ui-accent">
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
      <input type="hidden" name="signature_ecto[_sent]" value="1" />
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
      <.action type="submit" id="signature-validate-submit" class="button ui-accent">
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
      <.action type="submit" class="button ui-accent">
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
      <.action type="submit" id="signature-form-native-submit" class="button ui-accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/signature-pad/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.signature_pad name="user[signature]" class="signature-pad">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>
      <.action type="submit" class="button ui-accent">
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
      <.action type="submit" id="signature-live-form-phoenix-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <input type="hidden" name="signature_ecto[_sent]" value="1" />
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
      <.action type="submit" id="signature-live-form-ecto-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def styling_drawing_color_code do
    ~S"""
    <.signature_pad class="signature-pad" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad" drawing_fill="var(--color-accent)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad" drawing_fill="var(--color-brand)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad" drawing_fill="var(--color-alert)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad" drawing_fill="var(--color-success)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad" drawing_fill="var(--color-info)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_drawing_color_example(assigns) do
    _ = assigns

    ~H"""
    <.signature_pad
      id="signature-style-drawing-ink"
      class="signature-pad"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-drawing-accent"
      class="signature-pad"
      drawing_fill="var(--color-accent)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-drawing-brand"
      class="signature-pad"
      drawing_fill="var(--color-brand)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-drawing-alert"
      class="signature-pad"
      drawing_fill="var(--color-alert)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-drawing-success"
      class="signature-pad"
      drawing_fill="var(--color-success)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-drawing-info"
      class="signature-pad"
      drawing_fill="var(--color-info)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_trigger_color_code do
    ~S"""
    <.signature_pad class="signature-pad" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-accent" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-brand" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-alert" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-success" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-info" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_trigger_color_example(assigns) do
    _ = assigns

    ~H"""
    <.signature_pad
      id="signature-style-trigger-default"
      class="signature-pad"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-trigger-accent"
      class="signature-pad ui-accent"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-trigger-brand"
      class="signature-pad ui-brand"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-trigger-alert"
      class="signature-pad ui-alert"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-trigger-success"
      class="signature-pad ui-success"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-trigger-info"
      class="signature-pad ui-info"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_variant_code do
    ~S"""
    <.signature_pad class="signature-pad" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-solid" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-xl">
      <.signature_pad
        id="signature-style-variant-subtle"
        class="signature-pad"
        drawing_fill="var(--color-ink)"
      >
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
      </.signature_pad>
      <.signature_pad
        id="signature-style-variant-solid"
        class="signature-pad ui-solid"
        drawing_fill="var(--color-ink)"
      >
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
      </.signature_pad>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("signature-pad"),
        variant <- DemoScales.styling_variant_axis_steps("signature-pad") do
      class =
        DemoScales.join_matrix_modifiers("signature-pad", semantic.modifier, variant.modifier)

      """
      <.signature_pad class="#{class}" drawing_fill="var(--color-ink)">
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
      </.signature_pad>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("signature-pad"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("signature-pad"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.signature_pad
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"signature-pad-matrix-#{semantic_index}-#{variant_index}"}
            class={
              DemoScales.join_matrix_modifiers("signature-pad", semantic.modifier, variant.modifier)
            }
            drawing_fill="var(--color-ink)"
          >
            <:label>{semantic.label}</:label>
            <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
          </.signature_pad>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.signature_pad class="signature-pad ui-size-sm" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-size-md" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-size-lg" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-size-xl" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <.signature_pad
      id="signature-style-size-sm"
      class="signature-pad ui-size-sm"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-size-md"
      class="signature-pad ui-size-md"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-size-lg"
      class="signature-pad ui-size-lg"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-size-xl"
      class="signature-pad ui-size-xl"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("signature-pad")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("signature-pad", modifier)

      """
      <.signature_pad class="#{class}" drawing_fill="var(--color-ink)">
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
      </.signature_pad>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("signature-pad"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.signature_pad
          id={"signature-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("signature-pad", variant.modifier)}
          drawing_fill="var(--color-ink)"
        >
          <:label>Sign here</:label>
          <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
        </.signature_pad>
      </div>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.signature_pad class="signature-pad ui-rounded-none" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-rounded-sm" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-rounded-md" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-rounded-lg" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad class="signature-pad ui-rounded-xl" drawing_fill="var(--color-ink)">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <.signature_pad
      id="signature-style-rounded-none"
      class="signature-pad ui-rounded-none"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-rounded-sm"
      class="signature-pad ui-rounded-sm"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-rounded-md"
      class="signature-pad ui-rounded-md"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-rounded-lg"
      class="signature-pad ui-rounded-lg"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    <.signature_pad
      id="signature-style-rounded-xl"
      class="signature-pad ui-rounded-xl"
      drawing_fill="var(--color-ink)"
    >
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end
end
