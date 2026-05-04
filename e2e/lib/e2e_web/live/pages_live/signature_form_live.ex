defmodule E2eWeb.SignatureFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Form.SignatureForm
  alias E2eWeb.Demos.SignatureDemo, as: SignatureDemo
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Signature · Live Form")
     |> assign(:form_ecto, SignatureDemo.form_ecto())
     |> assign(:live_basic_heex, SignatureDemo.form_changeset_heex())
     |> assign(:live_basic_elixir, SignatureDemo.form_changeset_elixir())
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
  def handle_event("validate", params, socket) do
    sparams = Map.get(params, "signature_form", %{})

    changeset =
      %SignatureForm{}
      |> SignatureForm.changeset(sparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
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
    value =
      if is_list(paths) and paths != [],
        do: Enum.join(paths, "\n"),
        else: Map.get(payload, "url", "") || ""

    params = %{"signature" => value}

    changeset =
      %SignatureForm{}
      |> SignatureForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :signature_form,
         id: "signature-form"
       )
     )}
  end

  @impl true
  def handle_event("save", params, socket) do
    sparams = Map.get(params, "signature_form", %{})

    case SignatureForm.changeset(%SignatureForm{}, sparams) do
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
         assign(
           socket,
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
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="signature-form-live-page"
        title="Signature · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="signature-live-form-changeset"
          title="Phoenix form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <.form
              for={@form}
              id={@form.id}
              phx-change="validate"
              phx-submit="save"
              class="w-full max-w-2xs flex flex-col gap-space items-center"
            >
              <.signature_pad
                id="signature-form-signature"
                class="signature-pad"
                field={@form[:signature]}
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
              <.action
                type="submit"
                id="signature-form-live-submit"
                class="button button--accent w-full"
              >
                Submit
              </.action>
            </.form>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
