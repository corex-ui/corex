defmodule E2eWeb.Demos.DatePickerDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.date_picker>
      <:label>Select a date</:label>
      <:trigger>
        <.heroicon name="hero-calendar" />
      </:trigger>
             <:prev_trigger>
            <.heroicon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.heroicon name="hero-chevron-right" class="icon" />
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
      class="date-picker"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
    </.date_picker>
    """
  end

  def anatomy_range_code do
    ~S"""
    <.date_picker
      selection_mode="range"
      value="2024-06-01,2024-06-15"
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date range", close_calendar: "Select date range", input: "Date range"}}
      class="date-picker"
    >
      <:label>Range</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
    >
      <:label>Range</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
    >
      <:label>Multiple</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
    >
      <:label>Multiple</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-01-15")} class="button button--sm">
      Set to 2024-01-15
    </.action>
    <.action phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-12-25")} class="button button--sm">
      Set to 2024-12-25
    </.action>

    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      class="date-picker"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-01-15")}
        class="button button--sm"
      >
        Set to 2024-01-15
      </.action>
      <.action
        phx-click={Corex.DatePicker.set_value("date-picker-api-sv-client", "2024-12-25")}
        class="button button--sm"
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
      class="date-picker"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="button button--sm"
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
        class="button button--sm"
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
        class="button button--sm"
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
      class="date-picker"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
    </.date_picker>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="date_picker_api_set_value" phx-value-date="2024-01-15" class="button button--sm">
      Set to 2024-01-15
    </.action>

    <.date_picker translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}} class="date-picker">
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
        class="button button--sm"
      >
        Set to 2024-01-15
      </.action>
      <.action
        phx-click="date_picker_api_set_value"
        phx-value-date="2024-12-25"
        class="button button--sm"
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
      class="date-picker"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
    </.date_picker>
    """
  end

  def events_on_value_server_heex do
    ~S"""
    <.date_picker
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
      class="date-picker"
      on_value_change="dpe_on_value_server"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
      on_open_change="dpe_on_open_server"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
      on_value_change_client="date-picker-value-changed"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
      on_open_change_client="date-picker-open-changed"
    >
      <:label>Select a date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
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
      class="date-picker"
      controlled
      value={@selected && [@selected]}
      on_value_change="pattern_date_changed"
      translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
    >
      <:label>Date</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
    </.date_picker>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def handle_event("pattern_date_changed", %{"value" => v}, socket) do
      {:noreply, assign(socket, :date, v)}
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
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:date])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:date])
        |> validate_required([:date], message: "can't be blank")
      end
    end
    """
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
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
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
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
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
        |> put_flash(:info, "Submitted: date=#{inspect(date)}")
        |> redirect(to: ~p"/date-picker/form#date-picker-form-phoenix")
      end
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
        class="date-picker"
      >
        <:label>Date (required)</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
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
            |> put_flash(:info, "Submitted: date=#{inspect(data.date)}")
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

  def form_doc_native_heex do
    ~S"""
    <form action={~p"/date-picker/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.date_picker
        name="date_picker_form[date]"
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
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
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.date_picker
        field={@form[:date]}
        translation={%Corex.DatePicker.Translation{open_calendar: "Select date", close_calendar: "Select date", input: "Select date"}}
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
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
        class="date-picker"
      >
        <:label>Date (required)</:label>
        <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
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
        params = %{"date" => value}

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

  def form_code do
    form_doc_controller_changeset_heex()
  end

  attr(:form, Phoenix.HTML.Form, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/date-picker/form"}
      method="post"
    >
      <.date_picker
        field={f[:date]}
        id="date-picker-form-changeset-input"
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action
        type="submit"
        id="date-picker-changeset-form-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/date-picker/form"}
      method="post"
    >
      <.date_picker
        field={f[:date]}
        id="date-picker-form-validate-input"
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date (required)</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action
        type="submit"
        id="date-picker-validate-form-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/date-picker/form"}
      method="post"
      id="date-picker-plain-form"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.date_picker
        name="date_picker_form[date]"
        id="date-picker-form-native"
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>
      <.action
        type="submit"
        id="date-picker-form-native-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:date_display, :any, required: true)

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_basic"
      phx-submit="save_basic"
    >
      <.date_picker
        id="date-picker-basic-live"
        field={@form[:date]}
        value={@date_display}
        on_value_change="date_changed_basic"
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action
        type="submit"
        id="date-picker-basic-form-live-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:date_display, :any, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_validate"
      phx-submit="save_validate"
    >
      <.date_picker
        id="date-picker-validate-live"
        field={@form[:date]}
        value={@date_display}
        on_value_change="date_changed_validate"
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date (required)</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>
      <.action
        type="submit"
        id="date-picker-validate-form-live-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/date-picker/form"}
      method="post"
    >
      <.date_picker
        field={f[:date]}
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_validate_heex()
  def form_ecto_elixir, do: form_doc_controller_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix">
      <.date_picker
        field={@form[:date]}
        translation={
          %Corex.DatePicker.Translation{
            open_calendar: "Select date",
            close_calendar: "Select date",
            input: "Select date"
          }
        }
        class="date-picker"
      >
        <:label>Date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)
end
