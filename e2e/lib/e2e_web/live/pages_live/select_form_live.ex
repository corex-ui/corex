defmodule E2eWeb.SelectFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Form.SelectForm
  alias E2eWeb.Demos.SelectDemo, as: SelectDemo
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Select · Live Form")
     |> assign(:form_ecto, SelectDemo.form_ecto())
     |> assign(:live_basic_heex, SelectDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, SelectDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, SelectDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, SelectDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %SelectForm{}
      |> SelectForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :select_form, id: "select-form")

    strict_form =
      %SelectForm{}
      |> SelectForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :select_strict, id: "select-strict-form-live")

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("select_country_changed", %{"value" => value}, socket) do
    country = List.first(value) || ""
    params = %{"country" => country}

    changeset =
      %SelectForm{}
      |> SelectForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :select_form,
         id: "select-form"
       )
     )}
  end

  @impl true
  def handle_event("validate", %{"select_form" => params}, socket) do
    changeset =
      %SelectForm{}
      |> SelectForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :select_form,
         id: "select-form"
       )
     )}
  end

  @impl true
  def handle_event("save", %{"select_form" => params}, socket) do
    case SelectForm.changeset(%SelectForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: country=#{data.country}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(SelectForm.changeset(%SelectForm{}, %{}),
             as: :select_form,
             id: "select-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :select_form,
             id: "select-form"
           )
         )}
    end
  end

  @impl true
  def handle_event("select_country_changed_strict", %{"value" => value}, socket) do
    country = List.first(value) || ""
    params = %{"country" => country}

    changeset =
      %SelectForm{}
      |> SelectForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :select_strict,
         id: "select-strict-form-live"
       )
     )}
  end

  @impl true
  def handle_event("validate_strict", %{"select_strict" => params}, socket) do
    changeset =
      %SelectForm{}
      |> SelectForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :select_strict,
         id: "select-strict-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_strict", %{"select_strict" => params}, socket) do
    case SelectForm.changeset_validate(%SelectForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: country=#{data.country}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             SelectForm.changeset_validate(%SelectForm{}, %{}),
             as: :select_strict,
             id: "select-strict-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :select_strict,
             id: "select-strict-form-live"
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
        id="select-form-live-page"
        title="Select · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="select-live-form-changeset"
          title="Phoenix form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-live-form-validate"
          title="Ecto changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
