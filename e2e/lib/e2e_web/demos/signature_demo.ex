defmodule E2eWeb.Demos.SignatureDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.signature_pad id="signature-anatomy-minimal" class="signature-pad">
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
    <.signature_pad id="signature-anatomy-labeled" class="signature-pad">
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
    <div class="w-full max-w-4xl flex flex-col gap-4">
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
    <div class="w-full max-w-4xl flex flex-col gap-4">
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
    <.signature_pad id="signature-events-server" class="signature-pad" on_draw_end="signature_drawn">
      <:label>Sign here</:label>
      <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
    </.signature_pad>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("signature_drawn", %{"id" => id, "url" => url}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(String.slice(url, 0, 32))}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
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

  def form_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/signature/form"}
      method="post"
      id={@form.id}
    >
      <.signature_pad field={f[:signature]}>
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
      action={~p"/signature/form"}
      method="post"
      id={@form.id}
    >
      <.signature_pad field={f[:signature]}>
        <:label>Sign here (stricter)</:label>
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
      action={~p"/signature/form"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
      id={@form.id}
    >
      <.signature_pad field={f[:signature]}>
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" id="signature-changeset-submit" class="button button--accent w-full">
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
      action={~p"/signature/form"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
      id={@form.id}
    >
      <.signature_pad field={f[:signature]}>
        <:label>Sign here (stricter)</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
      <.action type="submit" id="signature-validate-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end
end
