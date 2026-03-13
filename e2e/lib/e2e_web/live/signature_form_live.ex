defmodule E2eWeb.SignatureFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.SignatureForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Signature form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %SignatureForm{}
      |> SignatureForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :signature_form, id: "signature-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"signature_form" => params}, socket) do
    changeset =
      %SignatureForm{}
      |> SignatureForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :signature_form,
         id: "signature-form"
       )
     )}
  end

  @impl true
  def handle_event("signature_drawn", %{"paths" => paths} = payload, socket) do
    value = (paths && Corex.Json.encode!(paths)) || Map.get(payload, "url", "") || ""
    params = %{"signature" => value}

    changeset =
      %SignatureForm{}
      |> SignatureForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :signature_form,
         id: "signature-form"
       )
     )}
  end

  @impl true
  def handle_event("save", %{"signature_form" => params}, socket) do
    case SignatureForm.changeset(%SignatureForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        sig_preview =
          if data.signature, do: String.slice(data.signature, 0, 50) <> "...", else: ""

        message = "Submitted: signature=#{sig_preview}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(SignatureForm.changeset(%SignatureForm{}, %{}),
             as: :signature_form,
             id: "signature-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :signature_form,
             id: "signature-form"
           )
         )}
    end
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :signature_value, get_signature_from_form(assigns.form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Signature form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled signature pad</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.signature_pad
          id="signature-form-signature"
          field={@form[:signature]}
          paths={@signature_value}
        >
          <:label>Sign here</:label>
          <:clear_trigger>
            <.heroicon name="hero-x-mark" />
          </:clear_trigger>
        </.signature_pad>
        <.action type="submit" id="signature-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  defp get_signature_from_form(form) do
    raw =
      form.params["signature"] ||
        Ecto.Changeset.get_change(form.source, :signature) ||
        Ecto.Changeset.get_field(form.source, :signature)

    case raw do
      nil -> nil
      "" -> nil
      val when is_binary(val) -> val
      _ -> nil
    end
  end
end
