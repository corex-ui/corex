defmodule E2eWeb.ComboboxForm do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.Combobox
  alias E2eWeb.Demos.ComboboxDemo, as: Demo

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Combobox form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_basic_heex, Demo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, Demo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, Demo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, Demo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %Combobox{}
      |> Combobox.changeset(%{})
      |> Phoenix.Component.to_form(as: :combobox, id: "combobox-live-form")

    strict_form =
      %Combobox{}
      |> Combobox.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :combobox_strict, id: "combobox-strict-form-live")

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  def handle_event("validate", params, socket) do
    cparams = Map.get(params, "combobox", %{})

    changeset =
      %Combobox{}
      |> Combobox.changeset(cparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :combobox,
         id: "combobox-live-form"
       )
     )}
  end

  def handle_event("save", params, socket) do
    cparams = Map.get(params, "combobox", %{})

    case Combobox.changeset(%Combobox{}, cparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: country=#{data.country}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(Combobox.changeset(%Combobox{}, cparams),
             as: :combobox,
             id: "combobox-live-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :combobox,
             id: "combobox-live-form"
           )
         )}
    end
  end

  def handle_event("validate_strict", params, socket) do
    cparams = Map.get(params, "combobox_strict", %{})

    changeset =
      %Combobox{}
      |> Combobox.changeset_validate(cparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :combobox_strict,
         id: "combobox-strict-form-live"
       )
     )}
  end

  def handle_event("save_strict", params, socket) do
    cparams = Map.get(params, "combobox_strict", %{})

    case Combobox.changeset_validate(%Combobox{}, cparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: country=#{data.country}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             Combobox.changeset_validate(%Combobox{}, cparams),
             as: :combobox_strict,
             id: "combobox-strict-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :combobox_strict,
             id: "combobox-strict-form-live"
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
        id="combobox-form-live-page"
        title={~t"Combobox · Form"}
        subtitle={~t"LiveView form with hook-driven country field."}
      >
        <.demo_section
          id="combobox-live-form-changeset"
          title={~t"Phoenix Form (changeset)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-live-form-validate"
          title={~t"Ecto Changeset (validation)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_validate strict_form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
