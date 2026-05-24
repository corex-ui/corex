defmodule E2eWeb.CheckboxFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.Terms
  alias E2eWeb.Demos.CheckboxDemo

  @phoenix_form_id "checkbox-live-form-phoenix"
  @ecto_form_id "checkbox-live-form-ecto"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Checkbox · Form")
     |> assign(:form_ecto, CheckboxDemo.form_ecto())
     |> assign(:live_phoenix_heex, CheckboxDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, CheckboxDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, CheckboxDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, CheckboxDemo.form_doc_live_ecto_elixir())
     |> assign(:native_heex, CheckboxDemo.form_native_heex())
     |> assign(:native_elixir, CheckboxDemo.form_native_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"terms" => false},
        as: :terms_phoenix,
        id: @phoenix_form_id
      )

    ecto_form =
      %Terms{}
      |> Terms.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :terms_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  def handle_event("save_phoenix", %{"terms_phoenix" => params}, socket) do
    terms = params["terms"] in [true, "true", "on", "1", 1]

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "terms=#{terms}", :info, duration: 5000)
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"terms" => terms},
         as: :terms_phoenix,
         id: @phoenix_form_id
       )
     )}
  end

  def handle_event("validate", %{"terms_ecto" => params}, socket) do
    changeset =
      %Terms{}
      |> Terms.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :terms_ecto,
         id: @ecto_form_id
       )
     )}
  end

  def handle_event("save", %{"terms_ecto" => params}, socket) do
    case Terms.changeset_validate(%Terms{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: terms=#{data.terms}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :ecto_form,
           Phoenix.Component.to_form(
             Terms.changeset_validate(%Terms{}, params),
             as: :terms_ecto,
             id: @ecto_form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :terms_ecto,
             id: @ecto_form_id
           )
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="checkbox-form-live-page"
        title={~t"Checkbox · Form"}
      >
        <.demo_section
          id="checkbox-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <CheckboxDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="checkbox-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <CheckboxDemo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="checkbox-live-form-native"
          title={~t"Native HTML Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @native_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @native_elixir}
          ]}
        >
          <:preview>
            <CheckboxDemo.form_preview_controller_native />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
