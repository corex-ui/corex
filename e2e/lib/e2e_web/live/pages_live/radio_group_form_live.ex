defmodule E2eWeb.RadioGroupFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.RadioGroupForm
  alias E2eWeb.Demos.RadioGroupDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Radio Group form")
     |> assign(:form_ecto, RadioGroupDemo.form_ecto())
     |> assign(:live_basic_heex, RadioGroupDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, RadioGroupDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, RadioGroupDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, RadioGroupDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :radio_group_live, id: "radio-group-live-form")

    strict_form =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :radio_group_strict, id: "radio-group-strict-form-live")

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("choice_changed", %{"value" => value}, socket) do
    params = %{"choice" => value}

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_live,
         id: "radio-group-live-form"
       )
     )}
  end

  @impl true
  def handle_event("validate", params, socket) do
    rparams = Map.get(params, "radio_group_live", %{})

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_live,
         id: "radio-group-live-form"
       )
     )}
  end

  @impl true
  def handle_event("save", params, socket) do
    rparams = Map.get(params, "radio_group_live", %{})

    case RadioGroupForm.changeset(%RadioGroupForm{}, rparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: choice=#{data.choice}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(RadioGroupForm.changeset(%RadioGroupForm{}, %{}),
             as: :radio_group_live,
             id: "radio-group-live-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :radio_group_live,
             id: "radio-group-live-form"
           )
         )}
    end
  end

  @impl true
  def handle_event("choice_changed_strict", %{"value" => value}, socket) do
    params = %{"choice" => value}

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_strict,
         id: "radio-group-strict-form-live"
       )
     )}
  end

  @impl true
  def handle_event("validate_strict", params, socket) do
    rparams = Map.get(params, "radio_group_strict", %{})

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset_validate(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_strict,
         id: "radio-group-strict-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_strict", params, socket) do
    rparams = Map.get(params, "radio_group_strict", %{})

    case RadioGroupForm.changeset_validate(%RadioGroupForm{}, rparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: choice=#{data.choice}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             RadioGroupForm.changeset_validate(%RadioGroupForm{}, %{}),
             as: :radio_group_strict,
             id: "radio-group-strict-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :radio_group_strict,
             id: "radio-group-strict-form-live"
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
        path={@path}
        id="radio-group-form-live-page"
        title="Radio Group · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="radio-group-live-form-changeset"
          title="Phoenix Form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <RadioGroupDemo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-live-form-validate"
          title="Ecto Changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <RadioGroupDemo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
