defmodule E2eWeb.DatePickerFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.DatePickerForm
  alias E2eWeb.Demos.DatePickerDemo

  @phoenix_form_id "date-picker-live-form-phoenix"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Date Picker · Form")
     |> assign(:form_ecto, DatePickerDemo.form_ecto())
     |> assign(:live_phoenix_heex, DatePickerDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, DatePickerDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, DatePickerDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, DatePickerDemo.form_doc_live_ecto_elixir())
     |> assign(:native_heex, DatePickerDemo.form_doc_native_heex())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"date" => ""},
        as: :date_picker_phoenix,
        id: @phoenix_form_id
      )

    validate_form =
      %DatePickerForm{}
      |> DatePickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :date_picker_validate,
        id: "date-picker-validate-form-live"
      )

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:validate_form, validate_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"date_picker_phoenix" => params}, socket) do
    date = params["date"] || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "Submitted: date=#{date}", :info,
       duration: 5000
     )
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"date" => date},
         as: :date_picker_phoenix,
         id: @phoenix_form_id
       )
     )}
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
    assigns = assign(assigns, :validate_date_value, date_display_list(assigns.validate_form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="date-picker-form-live-page"
        title={~t"Date Picker form"}
      >
        <.demo_section
          id="date-picker-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
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

        <.demo_section
          id="date-picker-live-form-native"
          title={~t"Native HTML Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @native_heex}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_controller_native />
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
