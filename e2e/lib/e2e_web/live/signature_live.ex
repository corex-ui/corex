defmodule E2eWeb.SignatureLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, signature_url: nil)}
  end

  def handle_event("signature_drawn", %{"paths" => paths, "url" => url}, socket) do
    socket =
      socket
      |> put_flash(:info, "Signature drawn with #{length(paths)} paths")
      |> assign(signature_url: url)

    {:noreply, socket}
  end

  def handle_event("clear_signature", _params, socket) do
    {:noreply, Corex.SignaturePad.clear(socket, "my-signature-pad")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Signature Pad</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client API</h3>
      <div class="layout__row">
        <button phx-click={Corex.SignaturePad.clear("my-signature-pad")} class="button button--sm">
          Clear Signature
        </button>
      </div>
      <h3>Server API</h3>
      <div class="layout__row">
        <button phx-click="clear_signature" class="button button--sm">
          Clear Signature
        </button>
      </div>
      <.signature_pad id="my-signature-pad" on_draw_end="signature_drawn">
        <:label>Sign here</:label>
        <:clear_trigger>
          <.icon name="hero-x-mark" />
        </:clear_trigger>
      </.signature_pad>

      <div :if={@signature_url && @signature_url != ""}>
        <h3>On Draw End</h3>
        <p>Signature URL: <code>{String.slice(@signature_url, 0, 50)}...</code></p>
        <img src={@signature_url} alt="Signature" class="max-w-xs border" />
        <a
          href={@signature_url}
          download="signature.png"
          class="button button--sm"
        >
          Download Image
        </a>
      </div>
    </Layouts.app>
    """
  end
end
