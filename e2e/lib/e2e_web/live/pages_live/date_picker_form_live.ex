defmodule E2eWeb.DatePickerFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.DatePicker
  alias Corex.Toast
  alias E2e.Form.DatePickerForm
  alias E2eWeb.Demos.DatePickerDemo

  @phoenix_form_id "date-picker-live-form-phoenix"
  @phoenix_multiple_form_id "date-picker-live-form-phoenix-multiple"
  @phoenix_range_form_id "date-picker-live-form-phoenix-range"

  @impl true
  def mount(_params, _session, socket) do
    demo = DatePickerDemo

    {:ok,
     socket
     |> assign(:page_title, "Date Picker · Form")
     |> assign(:form_ecto, demo.form_ecto())
     |> assign(:live_phoenix_single_heex, demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_single_elixir, demo.form_doc_live_phoenix_elixir())
     |> assign(:live_phoenix_multiple_heex, demo.form_doc_live_phoenix_multiple_heex())
     |> assign(:live_phoenix_multiple_elixir, demo.form_doc_live_phoenix_multiple_elixir())
     |> assign(:live_phoenix_range_heex, demo.form_doc_live_phoenix_range_heex())
     |> assign(:live_phoenix_range_elixir, demo.form_doc_live_phoenix_range_elixir())
     |> assign(:live_ecto_single_heex, demo.form_doc_live_validate_heex())
     |> assign(:live_ecto_single_elixir, demo.form_doc_live_ecto_elixir())
     |> assign(:live_ecto_multiple_heex, demo.form_doc_live_ecto_multiple_heex())
     |> assign(:live_ecto_multiple_elixir, demo.form_doc_live_ecto_multiple_elixir())
     |> assign(:live_ecto_range_heex, demo.form_doc_live_ecto_range_heex())
     |> assign(:live_ecto_range_elixir, demo.form_doc_live_ecto_range_elixir())
     |> assign(:live_ecto_invalid_heex, demo.form_doc_live_ecto_invalid_heex())
     |> assign(:live_ecto_invalid_elixir, demo.form_doc_live_ecto_invalid_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    socket
    |> assign(:phoenix_form, phoenix_form(%{"date" => ""}))
    |> assign(
      :phoenix_multiple_form,
      phoenix_form(%{"dates" => []}, :date_picker_phoenix_multiple, @phoenix_multiple_form_id)
    )
    |> assign(
      :phoenix_range_form,
      phoenix_form(%{"date_range" => []}, :date_picker_phoenix_range, @phoenix_range_form_id)
    )
    |> assign(
      :validate_form,
      ecto_form(
        &DatePickerForm.changeset_validate/2,
        :date_picker_validate,
        "date-picker-validate-form-live"
      )
    )
    |> assign(
      :validate_dates_form,
      ecto_form(
        &DatePickerForm.changeset_validate_dates/2,
        :date_picker_validate_dates,
        "date-picker-validate-dates-form-live"
      )
    )
    |> assign(
      :validate_range_form,
      ecto_form(
        &DatePickerForm.changeset_validate_range/2,
        :date_picker_validate_range,
        "date-picker-validate-range-form-live"
      )
    )
    |> assign(
      :validate_invalid_form,
      ecto_form(
        &DatePickerForm.changeset_validate/2,
        :date_picker_validate_invalid,
        "date-picker-validate-form-live-invalid"
      )
    )
  end

  defp phoenix_form(params, as \\ :date_picker_phoenix, id \\ @phoenix_form_id) do
    Phoenix.Component.to_form(params, as: as, id: id)
  end

  defp ecto_form(changeset_fun, as, id) do
    %DatePickerForm{}
    |> changeset_fun.(%{})
    |> Phoenix.Component.to_form(as: as, id: id)
  end

  @impl true
  def handle_event("save_phoenix", %{"date_picker_phoenix" => params}, socket) do
    {:noreply, save_phoenix_date(socket, Map.get(params, "date", ""))}
  end

  def handle_event("save_phoenix", _params, socket) do
    {:noreply, save_phoenix_date(socket, "")}
  end

  def handle_event("save_phoenix_multiple", params, socket) do
    nested = Map.get(params, "date_picker_phoenix_multiple", %{})
    dates = Map.get(nested, "dates", [])

    {:noreply,
     socket
     |> Toast.create(
       "layout-toast",
       "Submitted",
       "Submitted: dates=#{DatePicker.format_value("multiple", dates)}",
       :info,
       duration: 5000
     )
     |> assign(
       :phoenix_multiple_form,
       phoenix_form(
         %{"dates" => List.wrap(dates)},
         :date_picker_phoenix_multiple,
         @phoenix_multiple_form_id
       )
     )}
  end

  def handle_event("save_phoenix_range", params, socket) do
    nested = Map.get(params, "date_picker_phoenix_range", %{})
    date_range = Map.get(nested, "date_range", [])

    {:noreply,
     socket
     |> Toast.create(
       "layout-toast",
       "Submitted",
       "Submitted: date_range=#{DatePicker.format_value("range", date_range)}",
       :info,
       duration: 5000
     )
     |> assign(
       :phoenix_range_form,
       phoenix_form(
         %{"date_range" => List.wrap(date_range)},
         :date_picker_phoenix_range,
         @phoenix_range_form_id
       )
     )}
  end

  def handle_event("validate_validate", params, socket) do
    nested = Map.get(params, "date_picker_validate", %{})

    {:noreply,
     validate_ecto(
       socket,
       nested,
       "single",
       &DatePickerForm.changeset_validate/2,
       :validate_form,
       :date_picker_validate,
       "date-picker-validate-form-live"
     )}
  end

  def handle_event("save_validate", params, socket) do
    nested = Map.get(params, "date_picker_validate", %{})

    {:noreply,
     save_ecto(
       socket,
       nested,
       "single",
       &DatePickerForm.changeset_validate/2,
       :validate_form,
       :date_picker_validate,
       "date-picker-validate-form-live"
     )}
  end

  def handle_event("validate_dates", params, socket) do
    nested = Map.get(params, "date_picker_validate_dates", %{})

    {:noreply,
     validate_ecto(
       socket,
       nested,
       "multiple",
       &DatePickerForm.changeset_validate_dates/2,
       :validate_dates_form,
       :date_picker_validate_dates,
       "date-picker-validate-dates-form-live"
     )}
  end

  def handle_event("save_dates", params, socket) do
    nested = Map.get(params, "date_picker_validate_dates", %{})

    {:noreply,
     save_ecto(
       socket,
       nested,
       "multiple",
       &DatePickerForm.changeset_validate_dates/2,
       :validate_dates_form,
       :date_picker_validate_dates,
       "date-picker-validate-dates-form-live"
     )}
  end

  def handle_event("validate_range", params, socket) do
    nested = Map.get(params, "date_picker_validate_range", %{})

    {:noreply,
     validate_ecto(
       socket,
       nested,
       "range",
       &DatePickerForm.changeset_validate_range/2,
       :validate_range_form,
       :date_picker_validate_range,
       "date-picker-validate-range-form-live"
     )}
  end

  def handle_event("save_range", params, socket) do
    nested = Map.get(params, "date_picker_validate_range", %{})

    {:noreply,
     save_ecto(
       socket,
       nested,
       "range",
       &DatePickerForm.changeset_validate_range/2,
       :validate_range_form,
       :date_picker_validate_range,
       "date-picker-validate-range-form-live"
     )}
  end

  def handle_event("validate_invalid", params, socket) do
    nested = Map.get(params, "date_picker_validate_invalid", %{})

    {:noreply,
     validate_ecto(
       socket,
       nested,
       "single",
       &DatePickerForm.changeset_validate/2,
       :validate_invalid_form,
       :date_picker_validate_invalid,
       "date-picker-validate-form-live-invalid"
     )}
  end

  def handle_event("save_invalid", params, socket) do
    nested = Map.get(params, "date_picker_validate_invalid", %{})

    {:noreply,
     save_ecto(
       socket,
       nested,
       "single",
       &DatePickerForm.changeset_validate/2,
       :validate_invalid_form,
       :date_picker_validate_invalid,
       "date-picker-validate-form-live-invalid"
     )}
  end

  defp save_phoenix_date(socket, date) do
    socket
    |> Toast.create("layout-toast", "Submitted", "Submitted: date=#{date}", :info, duration: 5000)
    |> assign(:phoenix_form, phoenix_form(%{"date" => date}))
  end

  defp validate_ecto(socket, params, mode, changeset_fun, form_key, form_as, form_id) do
    params = DatePicker.cast_params(mode, params)

    changeset =
      %DatePickerForm{}
      |> changeset_fun.(params)
      |> Map.put(:action, :validate)

    assign(
      socket,
      form_key,
      Phoenix.Component.to_form(changeset, action: :validate, as: form_as, id: form_id)
    )
  end

  defp save_ecto(socket, params, mode, changeset_fun, form_key, form_as, form_id) do
    params = DatePicker.cast_params(mode, params)

    case changeset_fun.(%DatePickerForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        value = Map.get(data, submit_field(mode))
        message = "Submitted: #{submit_field(mode)}=#{DatePicker.format_value(mode, value)}"

        socket
        |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
        |> assign(
          form_key,
          Phoenix.Component.to_form(changeset_fun.(%DatePickerForm{}, params),
            as: form_as,
            id: form_id
          )
        )

      %Ecto.Changeset{} = changeset ->
        assign(
          socket,
          form_key,
          Phoenix.Component.to_form(changeset, action: :insert, as: form_as, id: form_id)
        )
    end
  end

  defp submit_field("single"), do: :date
  defp submit_field("multiple"), do: :dates
  defp submit_field("range"), do: :date_range

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:validate_date_value, date_display_value(assigns.validate_form, :date, "single"))
      |> assign(
        :validate_dates_value,
        date_display_value(assigns.validate_dates_form, :dates, "multiple")
      )
      |> assign(
        :validate_range_value,
        date_display_value(assigns.validate_range_form, :date_range, "range")
      )
      |> assign(
        :validate_invalid_date_value,
        date_display_value(assigns.validate_invalid_form, :date, "single")
      )

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
        title={~t"Date Picker · Form"}
      >
        <.demo_section
          id="date-picker-live-form-phoenix-single-section"
          title={~t"Phoenix Form · Single"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_single_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_phoenix_single_elixir
            }
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-phoenix-multiple-section"
          title={~t"Phoenix Form · Multiple"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_multiple_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_phoenix_multiple_elixir
            }
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_phoenix_multiple form={@phoenix_multiple_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-phoenix-range-section"
          title={~t"Phoenix Form · Range"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_range_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_range_elixir}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_phoenix_range form={@phoenix_range_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-ecto-single-section"
          title={~t"Phoenix Form + Ecto · Single"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_single_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_single_elixir},
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
          id="date-picker-live-form-ecto-invalid-section"
          title={~t"Phoenix Form + Ecto + Invalid"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_invalid_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_ecto_invalid_elixir
            },
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_validate_invalid
              form={@validate_invalid_form}
              date_display={@validate_invalid_date_value}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-ecto-multiple-section"
          title={~t"Phoenix Form + Ecto · Multiple"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_multiple_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_multiple_elixir}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_ecto_multiple
              form={@validate_dates_form}
              date_display={@validate_dates_value}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-live-form-ecto-range-section"
          title={~t"Phoenix Form + Ecto · Range"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_range_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_range_elixir}
          ]}
        >
          <:preview>
            <DatePickerDemo.form_preview_live_ecto_range
              form={@validate_range_form}
              date_display={@validate_range_value}
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp date_display_value(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = cs} = form, field, mode) do
    raw =
      form[field].value ||
        Ecto.Changeset.get_change(cs, field) ||
        Ecto.Changeset.get_field(cs, field)

    case mode do
      "single" -> date_display_single(raw)
      "multiple" -> date_display_multiple(raw)
      "range" -> date_display_range(raw)
    end
  end

  defp date_display_single(nil), do: nil
  defp date_display_single(%Date{} = d), do: Date.to_iso8601(d)
  defp date_display_single(""), do: nil
  defp date_display_single(s) when is_binary(s), do: s
  defp date_display_single(_), do: nil

  defp date_display_multiple(nil), do: nil

  defp date_display_multiple(dates) when is_list(dates) do
    case DatePicker.format_value("multiple", dates) do
      "" -> nil
      value -> value
    end
  end

  defp date_display_multiple(_), do: nil

  defp date_display_range(nil), do: nil

  defp date_display_range(dates) when is_list(dates) do
    case DatePicker.format_value("range", dates) do
      "" -> nil
      value -> value
    end
  end

  defp date_display_range(""), do: nil
  defp date_display_range(s) when is_binary(s), do: s
  defp date_display_range(_), do: nil
end
