defmodule E2eWeb.DatePickerFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.DatePickerForm
  alias E2eWeb.Demos.DatePickerDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Date Picker form")
     |> assign(:form_ecto, DatePickerDemo.form_ecto())
     |> assign(:live_basic_heex, DatePickerDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, DatePickerDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, DatePickerDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, DatePickerDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    basic_form =
      %DatePickerForm{}
      |> DatePickerForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :date_picker_basic, id: "date-picker-basic-form")

    validate_form =
      %DatePickerForm{}
      |> DatePickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :date_picker_validate,
        id: "date-picker-validate-form-live"
      )

    socket
    |> assign(:basic_form, basic_form)
    |> assign(:validate_form, validate_form)
  end

  @impl true
  def handle_event("validate_basic", %{"date_picker_basic" => params}, socket) do
    changeset =
      %DatePickerForm{}
      |> DatePickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :basic_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :date_picker_basic,
         id: "date-picker-basic-form"
       )
     )}
  end

  @impl true
  def handle_event("date_changed_basic", %{"value" => value}, socket) do
    params = %{"date" => value}

    changeset =
      %DatePickerForm{}
      |> DatePickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :basic_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :date_picker_basic,
         id: "date-picker-basic-form"
       )
     )}
  end

  @impl true
  def handle_event("save_basic", %{"date_picker_basic" => params}, socket) do
    case DatePickerForm.changeset(%DatePickerForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: date=#{data.date}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :basic_form,
           Phoenix.Component.to_form(DatePickerForm.changeset(%DatePickerForm{}, params),
             as: :date_picker_basic,
             id: "date-picker-basic-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :basic_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :date_picker_basic,
             id: "date-picker-basic-form"
           )
         )}
    end
  end

  @impl true
  def handle_event("validate_validate", %{"date_picker_validate" => params}, socket) do
    changeset =
      %DatePickerForm{}
      |> DatePickerForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :validate_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :date_picker_validate,
         id: "date-picker-validate-form-live"
       )
     )}
  end

  @impl true
  def handle_event("date_changed_validate", %{"value" => value}, socket) do
    params = %{"date" => value}

    changeset =
      %DatePickerForm{}
      |> DatePickerForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :validate_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :date_picker_validate,
         id: "date-picker-validate-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_validate", %{"date_picker_validate" => params}, socket) do
    case DatePickerForm.changeset_validate(%DatePickerForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: date=#{data.date}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :validate_form,
           Phoenix.Component.to_form(
             DatePickerForm.changeset_validate(%DatePickerForm{}, params),
             as: :date_picker_validate,
             id: "date-picker-validate-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :validate_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :date_picker_validate,
             id: "date-picker-validate-form-live"
           )
         )}
    end
  end

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:basic_date_value, date_display_list(assigns.basic_form))
      |> assign(:validate_date_value, date_display_list(assigns.validate_form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="date-picker-form-live-page"
        title={~t"Date Picker form"}
        subtitle={~t"Live View Form"}
      >
        <.demo_section
          id="date-picker-live-form-changeset"
          title={~t"Phoenix Form (changeset)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_changeset
              form={@basic_form}
              date_display={@basic_date_value}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-validate"
          title={~t"Ecto Changeset (validation)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_validate
              form={@validate_form}
              date_display={@validate_date_value}
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp date_display_list(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = cs} = form) do
    raw =
      form[:date].value ||
        Ecto.Changeset.get_change(cs, :date) ||
        Ecto.Changeset.get_field(cs, :date)

    case raw do
      nil -> nil
      %Date{} = d -> [Date.to_iso8601(d)]
      "" -> nil
      s when is_binary(s) -> [s]
      _ -> nil
    end
  end
end
