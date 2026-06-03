defmodule E2eWeb.Demos.DatePickerDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def minimal_code do
    ~S"""
    <.date_picker>
      <:label>Select a date</:label>
      <:trigger>
        <.heroicon name="hero-calendar" />
      </:trigger>
             <:prev_trigger>
            <.heroicon name="hero-chevron-left" />
          </:prev_trigger>
          <:next_trigger>
            <.heroicon name="hero-chevron-right" />
          </:next_trigger>
    </.date_picker>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.date_picker
      id="date-picker-anatomy-minimal"
      translation={
        %Corex.DatePicker.Translation{
          open_calendar: "Select date",
          close_calendar: "Select date",
          input: "Select date"
        }
      }
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def anatomy_range_code do
    ~S"""
    <.date_picker
      selection_mode="range"
      value="2024-06-01,2024-06-15"
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date range", close_calendar: "Select date range", input: "Date range"}}
      
    >
      <:label>Range</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def anatomy_range_example(assigns) do
    ~H"""
    <.date_picker
      id="date-picker-anatomy-range"
      selection_mode="range"
      value="2024-06-01,2024-06-15"
      translation={
        %Corex.DatePicker.Translation{
          open_calendar: "Select date range",
          close_calendar: "Select date range",
          input: "Date range"
        }
      }
    >
      <:label>Range</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def anatomy_multiple_code do
    ~S"""
    <.date_picker
      selection_mode="multiple"
      max_selected_dates={3}
      value="2024-06-03,2024-06-10,2024-06-17"
      translation={%Corex.DatePicker.Translation{open_calendar: "Select dates", close_calendar: "Select dates", input: "Dates"}}
      
    >
      <:label>Multiple</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def anatomy_multiple_example(assigns) do
    ~H"""
    <.date_picker
      id="date-picker-anatomy-multiple"
      selection_mode="multiple"
      max_selected_dates={3}
      value="2024-06-03,2024-06-10,2024-06-17"
      translation={
        %Corex.DatePicker.Translation{
          open_calendar: "Select dates",
          close_calendar: "Select dates",
          input: "Dates"
        }
      }
    >
      <:label>Multiple</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-01-15")} size="sm">
      Set to 2024-01-15
    </.action>
    <.action phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-12-25")} size="sm">
      Set to 2024-12-25
    </.action>

    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-01-15")}
        size="sm"
      >
        Set to 2024-01-15
      </.action>
      <.action
        phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-12-25")}
        size="sm"
      >
        Set to 2024-12-25
      </.action>
    </div>

    <.date_picker
      id="date-picker-api-sv-client"
      translation={
        %Corex.DatePicker.Translation{
          open_calendar: "Select date",
          close_calendar: "Select date",
          input: "Select date"
        }
      }
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:date-picker:set-value",
        to: "#date-picker-api-sv-js",
        detail: %{value: "2024-01-15"},
        bubbles: false
      )}
      size="sm"
    >
      Set to 2024-01-15
    </.action>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("date-picker-api-sv-js");
    if (!el) return;
    el.dispatchEvent(
      new CustomEvent("corex:date-picker:set-value", { bubbles: false, detail: { value: "2024-12-25" } })
    );
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el = document.getElementById("date-picker-api-sv-js");
    if (!el) return;
    el.dispatchEvent(
      new CustomEvent<{ value: string }>("corex:date-picker:set-value", {
        bubbles: false,
        detail: { value: "2024-12-25" }
      })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click={
          JS.dispatch("corex:date-picker:set-value",
            to: "#date-picker-api-sv-js",
            detail: %{value: "2024-01-15"},
            bubbles: false
          )
        }
        size="sm"
      >
        Set to 2024-01-15
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:date-picker:set-value",
            to: "#date-picker-api-sv-js",
            detail: %{value: "2024-12-25"},
            bubbles: false
          )
        }
        size="sm"
      >
        Set to 2024-12-25
      </.action>
    </div>
    <.date_picker
      id="date-picker-api-sv-js"
      translation={
        %Corex.DatePicker.Translation{
          open_calendar: "Select date",
          close_calendar: "Select date",
          input: "Select date"
        }
      }
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="date_picker_api_set_value" phx-value-date="2024-01-15" size="sm">
      Set to 2024-01-15
    </.action>

    <.date_picker translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}} >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("date_picker_api_set_value", %{"date" => value}, socket) do
      {:noreply, Corex.DatePicker.set_value(socket, "date-picker-api-sv-server", value)}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click="date_picker_api_set_value"
        phx-value-date="2024-01-15"
        size="sm"
      >
        Set to 2024-01-15
      </.action>
      <.action
        phx-click="date_picker_api_set_value"
        phx-value-date="2024-12-25"
        size="sm"
      >
        Set to 2024-12-25
      </.action>
    </div>
    <.date_picker
      id="date-picker-api-sv-server"
      translation={
        %Corex.DatePicker.Translation{
          open_calendar: "Select date",
          close_calendar: "Select date",
          input: "Select date"
        }
      }
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def events_on_value_server_heex do
    ~S"""
    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      
      on_value_change="dpe_on_value_server"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def events_on_value_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "dpe_on_value_server",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_on_open_server_heex do
    ~S"""
    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      
      on_open_change="dpe_on_open_server"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def events_on_open_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "dpe_on_open_server",
      ~S|%{"id" => id, "open" => open} = params|
    )
  end

  def events_on_value_client_heex do
    ~S"""
    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      
      on_value_change_client="date-picker-value-changed"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def events_on_value_client_js do
    ~S"""
    const el = document.getElementById("date-picker-e-cv");
    el?.addEventListener("date-picker-value-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def events_on_value_client_ts do
    ~S"""
    const el = document.getElementById("date-picker-e-cv");
    el?.addEventListener("date-picker-value-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id: string; value: string }>).detail);
    });
    """
  end

  def events_on_open_client_heex do
    ~S"""
    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      
      on_open_change_client="date-picker-open-changed"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def events_on_open_client_js do
    ~S"""
    const el = document.getElementById("date-picker-e-co");
    el?.addEventListener("date-picker-open-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def events_on_open_client_ts do
    ~S"""
    const el = document.getElementById("date-picker-e-co");
    el?.addEventListener("date-picker-open-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id: string; open: boolean }>).detail);
    });
    """
  end

  def patterns_controlled_code do
    ~S"""
    <.date_picker
      
      controlled
      value={@selected}
      on_value_change="pattern_date_changed"
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
    >
      <:label>Date</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :selected, nil)}
    end

    def handle_event("pattern_date_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :selected, value)}
    end
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Form.DatePickerForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :date, :date
        field :dates, {:array, :date}
        field :date_range, {:array, :date}
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(normalize_range_attrs(attrs), [:date, :dates, :date_range])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:date])
        |> validate_required([:date], message: "can't be blank")
      end

      def changeset_validate_dates(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:dates])
        |> validate_required([:dates], message: "can't be blank")
        |> validate_length(:dates, min: 1, message: "can't be blank")
      end

      def changeset_validate_range(form, attrs \\ %{}) do
        form
        |> cast(normalize_range_attrs(attrs), [:date_range])
        |> validate_required([:date_range], message: "can't be blank")
        |> validate_length(:date_range, min: 2, max: 2, message: "must be a start and end date")
      end

      defp normalize_range_attrs(%{"date_range" => range} = attrs) when is_binary(range) do
        %{attrs | "date_range" => String.split(range, ",", trim: true)}
      end

      defp normalize_range_attrs(attrs), do: attrs
    end
    """
  end

  attr(:id, :string, required: true)
  attr(:field, :any, default: nil)
  attr(:name, :string, default: nil)
  attr(:selection_mode, :string, default: "single")
  attr(:value, :any, default: nil)
  attr(:max_selected_dates, :integer, default: nil)
  attr(:on_value_change, :string, default: nil)
  attr(:label, :string, required: true)

  def form_date_picker(assigns) do
    assigns =
      assign_new(assigns, :max_selected_dates, fn ->
        if assigns.selection_mode == "multiple", do: 3, else: nil
      end)

    ~H"""
    <.date_picker
      id={@id}
      field={@field}
      name={@name}
      selection_mode={@selection_mode}
      max_selected_dates={@max_selected_dates}
      value={@value}
      on_value_change={@on_value_change}
      translation={form_date_picker_translation(@selection_mode)}
    >
      <:label>{@label}</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.date_picker>
    """
  end

  def date_form_value(nil, _mode), do: nil
  def date_form_value(%Date{} = date, _mode), do: Date.to_iso8601(date)
  def date_form_value(value, _mode) when is_binary(value), do: value

  def date_form_value(values, _mode) when is_list(values) do
    values
    |> Enum.map(&date_form_value(&1, "single"))
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> nil
      list -> Enum.join(list, ",")
    end
  end

  defp form_date_picker_translation("multiple") do
    %Corex.DatePicker.Translation{
      open_calendar: "Select dates",
      close_calendar: "Select dates",
      input: "Dates"
    }
  end

  defp form_date_picker_translation("range") do
    %Corex.DatePicker.Translation{
      open_calendar: "Select date range",
      close_calendar: "Select date range",
      input: "Date range",
      range_start: "From",
      range_end: "To"
    }
  end

  defp form_date_picker_translation(_) do
    %Corex.DatePicker.Translation{
      open_calendar: "Select date",
      close_calendar: "Select date",
      input: "Select date"
    }
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/date-picker/form"}
      method="post"
    >
      <.date_picker
        field={@form[:date]}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/date-picker/form"}
      method="post"
    >
      <.date_picker
        field={@form[:date]}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"date" => ""}, as: :date_picker_phoenix, id: "date-picker-form-phoenix")

      render(conn, :date_picker_form_page, phoenix_form: phoenix_form)
    end

    def date_picker_form_submit(conn, params) do
      if is_map(params["date_picker_phoenix"]) do
        date = params["date_picker_phoenix"]["date"] || ""

        conn
        |> put_flash(:info, "Submitted: date=#{date}")
        |> redirect(to: ~p"/date-picker/form#date-picker-form-phoenix")
      end
    end
    """
  end

  def form_doc_controller_phoenix_multiple_heex do
    ~S"""
    <.form for={@form} action={~p"/date-picker/form"} method="post">
      <.date_picker
        field={@form[:dates]}
        selection_mode="multiple"
        max_selected_dates={3}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select dates", close_calendar: "Select dates", input: "Dates"}}
        
      >
        <:label>Dates</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_multiple_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      phoenix_multiple_form =
        Phoenix.Component.to_form(%{"dates" => []},
          as: :date_picker_phoenix_multiple,
          id: "date-picker-form-phoenix-multiple"
        )

      render(conn, :date_picker_form_page, phoenix_multiple_form: phoenix_multiple_form)
    end

    def date_picker_form_submit(conn, %{"date_picker_phoenix_multiple" => %{"dates" => dates}}) do
      conn
      |> put_flash(:info, "Submitted: dates=#{Corex.DatePicker.format_value("multiple", dates)}")
      |> redirect(to: ~p"/date-picker/form#date-picker-form-phoenix-multiple")
    end
    """
  end

  def form_doc_controller_phoenix_range_heex do
    ~S"""
    <.form for={@form} action={~p"/date-picker/form"} method="post">
      <.date_picker
        field={@form[:date_range]}
        selection_mode="range"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date range", close_calendar: "Select date range", input: "Date range", range_start: "From", range_end: "To"}}
        
      >
        <:label>Date range</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_range_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      phoenix_range_form =
        Phoenix.Component.to_form(%{"date_range" => []},
          as: :date_picker_phoenix_range,
          id: "date-picker-form-phoenix-range"
        )

      render(conn, :date_picker_form_page, phoenix_range_form: phoenix_range_form)
    end

    def date_picker_form_submit(conn, %{"date_picker_phoenix_range" => params}) do
      date_range = Corex.DatePicker.format_value("range", Map.get(params, "date_range", []))

      conn
      |> put_flash(:info, "Submitted: date_range=#{date_range}")
      |> redirect(to: ~p"/date-picker/form#date-picker-form-phoenix-range")
    end
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      form =
        %MyApp.Form.DatePickerForm{}
        |> MyApp.Form.DatePickerForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :date_picker_changeset, id: "date-picker-changeset-form")

      render(conn, :date_picker_form_page, form: form)
    end
    """
  end

  def form_doc_controller_validate_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/date-picker/form"}
      method="post"
    >
      <.date_picker
        field={@form[:date]}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date (required)</:label>
        <:trigger>
          <.heroicon name="hero-calendar" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      form =
        %MyApp.Form.DatePickerForm{}
        |> MyApp.Form.DatePickerForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :date_picker_validate, id: "date-picker-validate-form")

      render(conn, :date_picker_form_page, form: form)
    end

    def date_picker_form_submit(conn, params) do
      if is_map(params["date_picker_validate"]) do
        case MyApp.Form.DatePickerForm.changeset_validate(%MyApp.Form.DatePickerForm{}, params["date_picker_validate"]) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(:info, "Submitted: date=#{Corex.DatePicker.format_value("single", data.date)}")
            |> redirect(to: ~p"/date-picker/form#date-picker-validate-form")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)
            form = Phoenix.Component.to_form(changeset, as: :date_picker_validate, id: "date-picker-validate-form")
            render(conn, :date_picker_form_page, form: form)
        end
      end
    end
    """
  end

  def form_doc_controller_ecto_multiple_heex do
    form_doc_controller_phoenix_multiple_heex()
  end

  def form_doc_controller_ecto_multiple_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      ecto_multiple_form =
        %MyApp.Form.DatePickerForm{}
        |> MyApp.Form.DatePickerForm.changeset_validate_dates(%{})
        |> Phoenix.Component.to_form(as: :date_picker_ecto_multiple, id: "date-picker-form-ecto-multiple")

      render(conn, :date_picker_form_page, ecto_multiple_form: ecto_multiple_form)
    end

    def date_picker_form_submit(conn, %{"date_picker_ecto_multiple" => params}) do
      params = Corex.DatePicker.cast_params("multiple", params)

      case MyApp.Form.DatePickerForm.changeset_validate_dates(%MyApp.Form.DatePickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted: dates=#{Corex.DatePicker.format_value("multiple", data.dates)}")
          |> redirect(to: ~p"/date-picker/form#date-picker-form-ecto-multiple")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :date_picker_ecto_multiple,
              id: "date-picker-form-ecto-multiple"
            )

          render(conn, :date_picker_form_page, ecto_multiple_form: form)
      end
    end
    """
  end

  def form_doc_controller_ecto_range_heex do
    form_doc_controller_phoenix_range_heex()
  end

  def form_doc_controller_ecto_range_elixir do
    ~S"""
    def date_picker_form_page(conn, _params) do
      ecto_range_form =
        %MyApp.Form.DatePickerForm{}
        |> MyApp.Form.DatePickerForm.changeset_validate_range(%{})
        |> Phoenix.Component.to_form(as: :date_picker_ecto_range, id: "date-picker-form-ecto-range")

      render(conn, :date_picker_form_page, ecto_range_form: ecto_range_form)
    end

    def date_picker_form_submit(conn, %{"date_picker_ecto_range" => params}) do
      params = Corex.DatePicker.cast_params("range", params)

      case MyApp.Form.DatePickerForm.changeset_validate_range(%MyApp.Form.DatePickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted: date_range=#{Corex.DatePicker.format_value("range", data.date_range)}")
          |> redirect(to: ~p"/date-picker/form#date-picker-form-ecto-range")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :date_picker_ecto_range,
              id: "date-picker-form-ecto-range"
            )

          render(conn, :date_picker_form_page, ecto_range_form: form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form action={~p"/date-picker/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.date_picker
        name="date_picker_form[date]"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def date_picker_form_submit(conn, %{"date_picker_form" => %{"date" => date}}) do
      conn
      |> put_flash(:info, "Submitted: date=#{date}")
      |> redirect(to: ~p"/date-picker/form#date-picker-form-native")
    end
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_native_multiple_heex do
    ~S"""
    <form action={~p"/date-picker/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.date_picker
        name="date_picker_form_multiple[dates]"
        selection_mode="multiple"
        max_selected_dates={3}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select dates", close_calendar: "Select dates", input: "Dates"}}
        
      >
        <:label>Dates</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </form>
    """
  end

  def form_doc_native_multiple_elixir do
    ~S"""
    def date_picker_form_submit(conn, %{"date_picker_form_multiple" => %{"dates" => dates}}) do
      dates = List.wrap(dates) |> Enum.join(", ")

      conn
      |> put_flash(:info, "Submitted: dates=#{dates}")
      |> redirect(to: ~p"/date-picker/form#date-picker-form-native-multiple")
    end
    """
  end

  def form_doc_native_range_heex do
    ~S"""
    <form action={~p"/date-picker/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.date_picker
        name="date_picker_form_range[date_range]"
        selection_mode="range"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date range", close_calendar: "Select date range", input: "Date range", range_start: "From", range_end: "To"}}
        
      >
        <:label>Date range</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </form>
    """
  end

  def form_doc_native_range_elixir do
    ~S"""
    def date_picker_form_submit(conn, %{"date_picker_form_range" => params}) do
      date_range = Corex.DatePicker.format_value("range", Map.get(params, "date_range", []))

      conn
      |> put_flash(:info, "Submitted: date_range=#{date_range}")
      |> redirect(to: ~p"/date-picker/form#date-picker-form-native-range")
    end
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate_basic"
      phx-submit="save_basic"
    >
      <.date_picker
        field={@form[:date]}
        value={@date_display}
        on_value_change="date_changed_basic"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.date_picker
        field={@form[:date]}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"date" => ""}, as: :date_picker_phoenix, id: "date-picker-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"date_picker_phoenix" => params}, socket) do
        date = params["date"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"date" => date}, as: :date_picker_phoenix, id: "date-picker-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        basic_form =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset(%{})
          |> Phoenix.Component.to_form(as: :date_picker_basic, id: "date-picker-basic-form")

        {:ok, assign(socket, :basic_form, basic_form)}
      end

      def handle_event("validate_basic", %{"date_picker_basic" => params}, socket) do
        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :basic_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :date_picker_basic,
             id: "date-picker-basic-form"
           )
         )}
      end

      def handle_event("date_changed_basic", %{"value" => value}, socket) do
        params = %{"date" => value}

        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :basic_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :date_picker_basic,
             id: "date-picker-basic-form"
           )
         )}
      end

      def handle_event("save_basic", %{"date_picker_basic" => params}, socket) do
        case MyApp.Form.DatePickerForm.changeset(%MyApp.Form.DatePickerForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :basic_form,
               Phoenix.Component.to_form(
                 MyApp.Form.DatePickerForm.changeset(%MyApp.Form.DatePickerForm{}, params),
                 as: :date_picker_basic,
                 id: "date-picker-basic-form"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :basic_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :date_picker_basic,
                 id: "date-picker-basic-form"
               )
             )}
        end
      end
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate_validate"
      phx-submit="save_validate"
    >
      <.date_picker
        field={@form[:date]}
        value={@date_display}
        on_value_change="date_changed_validate"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        
      >
        <:label>Date (required)</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        validate_form =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :date_picker_validate, id: "date-picker-validate-form-live")

        {:ok, assign(socket, :validate_form, validate_form)}
      end

      def handle_event("validate_validate", %{"date_picker_validate" => params}, socket) do
        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :validate_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :date_picker_validate,
             id: "date-picker-validate-form-live"
           )
         )}
      end

      def handle_event("date_changed_validate", %{"value" => value}, socket) do
        params = Corex.DatePicker.cast_params("single", %{"value" => value})

        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :validate_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :date_picker_validate,
             id: "date-picker-validate-form-live"
           )
         )}
      end

      def handle_event("save_validate", %{"date_picker_validate" => params}, socket) do
        case MyApp.Form.DatePickerForm.changeset_validate(%MyApp.Form.DatePickerForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :validate_form,
               Phoenix.Component.to_form(
                 MyApp.Form.DatePickerForm.changeset_validate(%MyApp.Form.DatePickerForm{}, params),
                 as: :date_picker_validate,
                 id: "date-picker-validate-form-live"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :validate_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :date_picker_validate,
                 id: "date-picker-validate-form-live"
               )
             )}
        end
      end
    end
    """
  end

  def form_doc_live_phoenix_multiple_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix_multiple">
      <.date_picker
        field={@form[:dates]}
        selection_mode="multiple"
        max_selected_dates={3}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select dates", close_calendar: "Select dates", input: "Dates"}}
        
      >
        <:label>Dates</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_multiple_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_multiple_form =
          Phoenix.Component.to_form(%{"dates" => []},
            as: :date_picker_phoenix_multiple,
            id: "date-picker-live-form-phoenix-multiple"
          )

        {:ok, assign(socket, :phoenix_multiple_form, phoenix_multiple_form)}
      end

      def handle_event("save_phoenix_multiple", %{"date_picker_phoenix_multiple" => params}, socket) do
        dates = Map.get(params, "dates", [])

        {:noreply,
         assign(
           socket,
           :phoenix_multiple_form,
           Phoenix.Component.to_form(%{"dates" => List.wrap(dates)},
             as: :date_picker_phoenix_multiple,
             id: "date-picker-live-form-phoenix-multiple"
           )
         )}
      end
    end
    """
  end

  def form_doc_live_phoenix_range_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix_range">
      <.date_picker
        field={@form[:date_range]}
        selection_mode="range"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date range", close_calendar: "Select date range", input: "Date range", range_start: "From", range_end: "To"}}
        
      >
        <:label>Date range</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_range_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_range_form =
          Phoenix.Component.to_form(%{"date_range" => []},
            as: :date_picker_phoenix_range,
            id: "date-picker-live-form-phoenix-range"
          )

        {:ok, assign(socket, :phoenix_range_form, phoenix_range_form)}
      end

      def handle_event("save_phoenix_range", %{"date_picker_phoenix_range" => params}, socket) do
        date_range = List.wrap(Map.get(params, "date_range", []))

        {:noreply,
         assign(
           socket,
           :phoenix_range_form,
           Phoenix.Component.to_form(%{"date_range" => date_range},
             as: :date_picker_phoenix_range,
             id: "date-picker-live-form-phoenix-range"
           )
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_multiple_heex do
    ~S"""
    <.form for={@form} phx-change="validate_dates" phx-submit="save_dates">
      <.date_picker
        field={@form[:dates]}
        selection_mode="multiple"
        max_selected_dates={3}
        value={@date_display}
        on_value_change="date_changed_dates"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select dates", close_calendar: "Select dates", input: "Dates"}}
        
      >
        <:label>Dates (required)</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_ecto_multiple_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        validate_dates_form =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate_dates(%{})
          |> Phoenix.Component.to_form(as: :date_picker_validate_dates, id: "date-picker-validate-dates-form-live")

        {:ok, assign(socket, :validate_dates_form, validate_dates_form)}
      end

      def handle_event("validate_dates", %{"date_picker_validate_dates" => params}, socket) do
        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate_dates(params)
          |> Map.put(:action, :validate)

        {:noreply, assign(socket, :validate_dates_form, Phoenix.Component.to_form(changeset, action: :validate, as: :date_picker_validate_dates, id: "date-picker-validate-dates-form-live"))}
      end

      def handle_event("date_changed_dates", %{"value" => value}, socket) do
        params = Corex.DatePicker.cast_params("multiple", %{"value" => value})

        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate_dates(params)
          |> Map.put(:action, :validate)

        {:noreply, assign(socket, :validate_dates_form, Phoenix.Component.to_form(changeset, action: :validate, as: :date_picker_validate_dates, id: "date-picker-validate-dates-form-live"))}
      end

      def handle_event("save_dates", %{"date_picker_validate_dates" => params}, socket) do
        case MyApp.Form.DatePickerForm.changeset_validate_dates(%MyApp.Form.DatePickerForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            {:noreply,
             assign(
               socket,
               :validate_dates_form,
               Phoenix.Component.to_form(
                 MyApp.Form.DatePickerForm.changeset_validate_dates(%MyApp.Form.DatePickerForm{}, params),
                 as: :date_picker_validate_dates,
                 id: "date-picker-validate-dates-form-live"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :validate_dates_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :date_picker_validate_dates,
                 id: "date-picker-validate-dates-form-live"
               )
             )}
        end
      end
    end
    """
  end

  def form_doc_live_ecto_range_heex do
    ~S"""
    <.form for={@form} phx-change="validate_range" phx-submit="save_range">
      <.date_picker
        field={@form[:date_range]}
        selection_mode="range"
        value={@date_display}
        on_value_change="date_changed_range"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date range", close_calendar: "Select date range", input: "Date range", range_start: "From", range_end: "To"}}
        
      >
        <:label>Date range (required)</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_ecto_range_elixir do
    ~S"""
    defmodule MyAppWeb.DatePickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        validate_range_form =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate_range(%{})
          |> Phoenix.Component.to_form(as: :date_picker_validate_range, id: "date-picker-validate-range-form-live")

        {:ok, assign(socket, :validate_range_form, validate_range_form)}
      end

      def handle_event("validate_range", %{"date_picker_validate_range" => params}, socket) do
        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate_range(params)
          |> Map.put(:action, :validate)

        {:noreply, assign(socket, :validate_range_form, Phoenix.Component.to_form(changeset, action: :validate, as: :date_picker_validate_range, id: "date-picker-validate-range-form-live"))}
      end

      def handle_event("date_changed_range", %{"value" => value}, socket) do
        params = Corex.DatePicker.cast_params("range", %{"value" => value})

        changeset =
          %MyApp.Form.DatePickerForm{}
          |> MyApp.Form.DatePickerForm.changeset_validate_range(params)
          |> Map.put(:action, :validate)

        {:noreply, assign(socket, :validate_range_form, Phoenix.Component.to_form(changeset, action: :validate, as: :date_picker_validate_range, id: "date-picker-validate-range-form-live"))}
      end

      def handle_event("save_range", %{"date_picker_validate_range" => params}, socket) do
        case MyApp.Form.DatePickerForm.changeset_validate_range(%MyApp.Form.DatePickerForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            {:noreply,
             assign(
               socket,
               :validate_range_form,
               Phoenix.Component.to_form(
                 MyApp.Form.DatePickerForm.changeset_validate_range(%MyApp.Form.DatePickerForm{}, params),
                 as: :date_picker_validate_range,
                 id: "date-picker-validate-range-form-live"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :validate_range_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :date_picker_validate_range,
                 id: "date-picker-validate-range-form-live"
               )
             )}
        end
      end
    end
    """
  end

  def form_code do
    form_doc_controller_changeset_heex()
  end

  defp form_field_key("multiple"), do: :dates
  defp form_field_key("range"), do: :date_range
  defp form_field_key(_), do: :date

  defp form_label("multiple"), do: "Dates"
  defp form_label("range"), do: "Date range"
  defp form_label(_), do: "Date"

  defp form_label_required("multiple"), do: "Dates (required)"
  defp form_label_required("range"), do: "Date range (required)"
  defp form_label_required(_), do: "Date (required)"

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:selection_mode, :string, default: "single")
  attr(:date_display, :any, default: nil)
  attr(:on_value_change, :string, default: nil)
  attr(:form_id, :string, required: true)
  attr(:submit_id, :string, required: true)
  attr(:picker_id, :string, required: true)
  attr(:required_label, :boolean, default: false)

  defp form_preview_phoenix_form(assigns) do
    assigns =
      assign(
        assigns,
        :picker_label,
        if(assigns.required_label,
          do: form_label_required(assigns.selection_mode),
          else: form_label(assigns.selection_mode)
        )
      )

    ~H"""
    <.form :let={f} for={@form} action={~p"/date-picker/form"} method="post" id={@form_id}>
      <.form_date_picker
        id={@picker_id}
        field={f[form_field_key(@selection_mode)]}
        selection_mode={@selection_mode}
        value={@date_display}
        on_value_change={@on_value_change}
        label={@picker_label}
      />
      <.action type="submit" id={@submit_id} semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_changeset(assigns) do
    assigns
    |> Map.put(:selection_mode, "single")
    |> Map.put(:form_id, "date-picker-changeset-form")
    |> Map.put(:submit_id, "date-picker-changeset-form-submit")
    |> Map.put(:picker_id, "date-picker-form-changeset-input")
    |> form_preview_phoenix_form()
  end

  def form_preview_controller_validate(assigns) do
    assigns
    |> Map.put(:selection_mode, "single")
    |> Map.put(:form_id, "date-picker-form-ecto")
    |> Map.put(:submit_id, "date-picker-validate-form-submit")
    |> Map.put(:picker_id, "date-picker-form-validate-input")
    |> Map.put(:required_label, true)
    |> form_preview_phoenix_form()
  end

  def form_preview_controller_phoenix(assigns) do
    assigns
    |> Map.put(:selection_mode, "single")
    |> Map.put(:form_id, "date-picker-form-phoenix")
    |> Map.put(:submit_id, "date-picker-form-phoenix-submit")
    |> Map.put(:picker_id, "date-picker-form-phoenix-input")
    |> form_preview_phoenix_form()
  end

  def form_preview_controller_phoenix_multiple(assigns) do
    assigns
    |> Map.put(:selection_mode, "multiple")
    |> Map.put(:form_id, "date-picker-form-phoenix-multiple")
    |> Map.put(:submit_id, "date-picker-form-phoenix-multiple-submit")
    |> Map.put(:picker_id, "date-picker-form-phoenix-multiple-input")
    |> form_preview_phoenix_form()
  end

  def form_preview_controller_phoenix_range(assigns) do
    assigns
    |> Map.put(:selection_mode, "range")
    |> Map.put(:form_id, "date-picker-form-phoenix-range")
    |> Map.put(:submit_id, "date-picker-form-phoenix-range-submit")
    |> Map.put(:picker_id, "date-picker-form-phoenix-range-input")
    |> form_preview_phoenix_form()
  end

  def form_preview_controller_ecto_multiple(assigns) do
    assigns
    |> Map.put(:selection_mode, "multiple")
    |> Map.put(:form_id, "date-picker-form-ecto-multiple")
    |> Map.put(:submit_id, "date-picker-form-ecto-multiple-submit")
    |> Map.put(:picker_id, "date-picker-form-ecto-multiple-input")
    |> Map.put(:required_label, true)
    |> form_preview_phoenix_form()
  end

  def form_preview_controller_ecto_range(assigns) do
    assigns
    |> Map.put(:selection_mode, "range")
    |> Map.put(:form_id, "date-picker-form-ecto-range")
    |> Map.put(:submit_id, "date-picker-form-ecto-range-submit")
    |> Map.put(:picker_id, "date-picker-form-ecto-range-input")
    |> Map.put(:required_label, true)
    |> form_preview_phoenix_form()
  end

  attr(:selection_mode, :string, default: "single")

  def form_preview_controller_native(assigns) do
    assigns =
      assigns
      |> assign(:native_form_name, native_form_name(assigns.selection_mode))
      |> assign(:picker_label, form_label(assigns.selection_mode))

    ~H"""
    <form
      action={~p"/date-picker/form"}
      method="post"
      id={"date-picker-plain-form-#{@selection_mode}"}
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.form_date_picker
        id={"date-picker-form-native-#{@selection_mode}"}
        name={@native_form_name}
        selection_mode={@selection_mode}
        label={@picker_label}
      />
      <.action
        type="submit"
        id={"date-picker-form-native-#{@selection_mode}-submit"}
        semantic="accent"
      >
        Submit
      </.action>
    </form>
    """
  end

  defp native_form_name("multiple"), do: "date_picker_form_multiple[dates]"
  defp native_form_name("range"), do: "date_picker_form_range[date_range]"
  defp native_form_name(_), do: "date_picker_form[date]"

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:selection_mode, :string, default: "single")
  attr(:date_display, :any, default: nil)
  attr(:required_label, :boolean, default: false)

  defp form_preview_live_form(assigns) do
    assigns =
      assigns
      |> assign(:form_field_key, form_field_key(assigns.selection_mode))
      |> assign(
        :picker_label,
        if(assigns.required_label,
          do: form_label_required(assigns.selection_mode),
          else: form_label(assigns.selection_mode)
        )
      )

    ~H"""
    <.form for={@form} id={@form_id} phx-change={@phx_change} phx-submit={@phx_submit}>
      <.form_date_picker
        id={@picker_id}
        field={@form[@form_field_key]}
        selection_mode={@selection_mode}
        value={@date_display}
        on_value_change={@on_value_change}
        label={@picker_label}
      />
      <.action type="submit" id={@submit_id} semantic="accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_live_phoenix(assigns) do
    assigns
    |> Map.put(:selection_mode, "single")
    |> Map.put(:form_id, "date-picker-live-form-phoenix")
    |> Map.put(:phx_change, nil)
    |> Map.put(:phx_submit, "save_phoenix")
    |> Map.put(:submit_id, "date-picker-live-form-phoenix-submit")
    |> Map.put(:picker_id, "date-picker-live-form-phoenix-input")
    |> Map.put(:on_value_change, nil)
    |> form_preview_live_form()
  end

  def form_preview_live_phoenix_multiple(assigns) do
    assigns
    |> Map.put(:selection_mode, "multiple")
    |> Map.put(:form_id, "date-picker-live-form-phoenix-multiple")
    |> Map.put(:phx_change, nil)
    |> Map.put(:phx_submit, "save_phoenix_multiple")
    |> Map.put(:submit_id, "date-picker-live-form-phoenix-multiple-submit")
    |> Map.put(:picker_id, "date-picker-live-form-phoenix-multiple-input")
    |> Map.put(:on_value_change, nil)
    |> form_preview_live_form()
  end

  def form_preview_live_phoenix_range(assigns) do
    assigns
    |> Map.put(:selection_mode, "range")
    |> Map.put(:form_id, "date-picker-live-form-phoenix-range")
    |> Map.put(:phx_change, nil)
    |> Map.put(:phx_submit, "save_phoenix_range")
    |> Map.put(:submit_id, "date-picker-live-form-phoenix-range-submit")
    |> Map.put(:picker_id, "date-picker-live-form-phoenix-range-input")
    |> Map.put(:on_value_change, nil)
    |> form_preview_live_form()
  end

  def form_preview_live_validate(assigns) do
    assigns
    |> Map.put(:selection_mode, "single")
    |> Map.put(:form_id, "date-picker-validate-form-live")
    |> Map.put(:phx_change, "validate_validate")
    |> Map.put(:phx_submit, "save_validate")
    |> Map.put(:submit_id, "date-picker-validate-form-live-submit")
    |> Map.put(:picker_id, "date-picker-validate-live")
    |> Map.put(:on_value_change, "date_changed_validate")
    |> Map.put(:required_label, true)
    |> form_preview_live_form()
  end

  def form_preview_live_ecto_multiple(assigns) do
    assigns
    |> Map.put(:selection_mode, "multiple")
    |> Map.put(:form_id, "date-picker-validate-dates-form-live")
    |> Map.put(:phx_change, "validate_dates")
    |> Map.put(:phx_submit, "save_dates")
    |> Map.put(:submit_id, "date-picker-validate-dates-form-live-submit")
    |> Map.put(:picker_id, "date-picker-validate-dates-live")
    |> Map.put(:on_value_change, "date_changed_dates")
    |> Map.put(:required_label, true)
    |> form_preview_live_form()
  end

  def form_preview_live_ecto_range(assigns) do
    assigns
    |> Map.put(:selection_mode, "range")
    |> Map.put(:form_id, "date-picker-validate-range-form-live")
    |> Map.put(:phx_change, "validate_range")
    |> Map.put(:phx_submit, "save_range")
    |> Map.put(:submit_id, "date-picker-validate-range-form-live-submit")
    |> Map.put(:picker_id, "date-picker-validate-range-live")
    |> Map.put(:on_value_change, "date_changed_range")
    |> Map.put(:required_label, true)
    |> form_preview_live_form()
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_validate_heex()
  def form_ecto_elixir, do: form_doc_controller_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  defp styling_translation do
    %Corex.DatePicker.Translation{
      open_calendar: "Select date",
      close_calendar: "Select date",
      input: "Select date"
    }
  end

  def styling_semantic_code do
    ~S"""
    <.date_picker  value="2024-06-15">
      <:label>Default</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--accent" value="2024-06-15">
      <:label>Accent</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--brand" value="2024-06-15">
      <:label>Brand</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--alert" value="2024-06-15">
      <:label>Alert</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--info" value="2024-06-15">
      <:label>Info</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--success" value="2024-06-15">
      <:label>Success</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def styling_semantic_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full">
      <.date_picker
        id="date-picker-style-color-default"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Default</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-color-accent"
        class="date-picker date-picker--accent"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Accent</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-color-brand"
        class="date-picker date-picker--brand"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Brand</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-color-alert"
        class="date-picker date-picker--alert"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Alert</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-color-info"
        class="date-picker date-picker--info"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Info</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-color-success"
        class="date-picker date-picker--success"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Success</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.date_picker class="date-picker date-picker--sm" value="2024-06-15">
      <:label>SM</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--md" value="2024-06-15">
      <:label>MD</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--lg" value="2024-06-15">
      <:label>LG</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--xl" value="2024-06-15">
      <:label>XL</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.date_picker
        id="date-picker-style-size-sm"
        class="date-picker date-picker--sm"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>SM</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-size-md"
        class="date-picker date-picker--md"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>MD</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-size-lg"
        class="date-picker date-picker--lg"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>LG</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-size-xl"
        class="date-picker date-picker--xl"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>XL</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.date_picker class="date-picker date-picker--rounded-none" value="2024-06-15">
      <:label>None</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--rounded-sm" value="2024-06-15">
      <:label>SM</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--rounded-md" value="2024-06-15">
      <:label>MD</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--rounded-lg" value="2024-06-15">
      <:label>LG</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--rounded-xl" value="2024-06-15">
      <:label>XL</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    <.date_picker class="date-picker date-picker--rounded-full" value="2024-06-15">
      <:label>Full</:label>
      <:trigger><.heroicon name="hero-calendar" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
    </.date_picker>
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full">
      <.date_picker
        id="date-picker-style-rounded-none"
        class="date-picker date-picker--rounded-none"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>None</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-rounded-sm"
        class="date-picker date-picker--rounded-sm"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>SM</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-rounded-md"
        class="date-picker date-picker--rounded-md"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>MD</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-rounded-lg"
        class="date-picker date-picker--rounded-lg"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>LG</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-rounded-xl"
        class="date-picker date-picker--rounded-xl"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>XL</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
      <.date_picker
        id="date-picker-style-rounded-full"
        class="date-picker date-picker--rounded-full"
        value="2024-06-15"
        focused_value="2024-06-01"
        translation={styling_translation()}
      >
        <:label>Full</:label>
        <:trigger><.heroicon name="hero-calendar" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
      </.date_picker>
    </div>
    """
  end
end
