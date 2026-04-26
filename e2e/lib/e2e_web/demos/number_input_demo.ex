defmodule E2eWeb.Demos.NumberInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.number_input id="number-input-anatomy-minimal" class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.number_input id="number-input-anatomy-minimal" class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def min_max_default_code do
    ~S"""
    <.number_input
      id="number-input-anatomy-bounds"
      class="number-input"
      min={0.0}
      max={100.0}
      step={5.0}
      default_value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def min_max_default_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-anatomy-bounds"
      class="number-input"
      min={0.0}
      max={100.0}
      step={5.0}
      default_value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def with_triggers_code, do: minimal_code()
  def with_triggers_example(assigns), do: minimal_example(assigns)

  def styling_size_code do
    ~S"""
    <.number_input id="number-input-style-sm" class="number-input number-input--sm">
      <:label>SM</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    <.number_input id="number-input-style-lg" class="number-input number-input--lg">
      <:label>LG</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-xs">
      <.number_input id="number-input-style-sm" class="number-input number-input--sm">
        <:label>SM</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
      <.number_input id="number-input-style-lg" class="number-input number-input--lg">
        <:label>LG</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
    </div>
    """
  end

  def api_binding_heex do
    ~S"""
    <.number_input
      id="number-input-api-binding"
      class="number-input"
      on_value_change="number_input_api_binding"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_binding_elixir do
    ~S"""
    def handle_event("number_input_api_binding", %{"id" => id, "value" => value} = payload, socket) do
      n = payload["valueAsNumber"]
      {:noreply, socket}
    end
    """
  end

  def api_binding_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-api-binding"
      class="number-input"
      on_value_change="number_input_api_binding"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_client_heex do
    ~S"""
    <.number_input
      id="number-input-api-client"
      class="number-input"
      on_value_change_client="number-input-api-client-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_client_js do
    ~S"""
    const el = document.getElementById("number-input-api-client");
    el?.addEventListener("number-input-api-client-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def api_client_ts do
    ~S"""
    const el = document.getElementById("number-input-api-client");
    el?.addEventListener("number-input-api-client-changed", (event: Event) => {
      console.log((event as CustomEvent<{ value?: string; valueAsNumber?: number }>).detail);
    });
    """
  end

  def api_client_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-api-client"
      class="number-input"
      on_value_change_client="number-input-api-client-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_server_note_heex do
    ~S"""
    <.number_input id="qty" class="number-input" default_value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_server_note_elixir do
    ~S"""
    # Initial value: pass default_value (or value) on the component.
    # The hook reads data-default-value on the root element (the same id as id="qty").
    """
  end

  def api_server_note_example(assigns) do
    ~H"""
    <.number_input id="number-input-api-server-note" class="number-input" default_value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_overview_code, do: api_binding_heex()
  def api_overview_example(assigns), do: api_binding_example(assigns)

  def events_server_heex do
    ~S"""
    <.number_input
      id="number-input-events-server"
      class="number-input"
      on_value_change="number_input_changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("number_input_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.number_input
      id="number-input-events-client"
      class="number-input"
      on_value_change_client="number-input-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("number-input-events-client");
    el?.addEventListener("number-input-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("number-input-events-client");
    el?.addEventListener("number-input-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code, do: form_doc_controller_changeset_heex()

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.NumberInputForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :value, :float
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:value])
        |> validate_required([:value])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:value])
        |> validate_required([:value])
        |> validate_number(:value, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 9999.0)
      end
    end
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_validate_heex, do: form_doc_controller_validate_heex()
  def form_validate_elixir, do: form_doc_controller_validate_elixir()
  def form_native_heex, do: form_doc_native_heex()

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
      id={Corex.Form.get_form_id(@form)}
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.number_input field={f[:value]} id="number-input-changeset-field" class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def number_input_form_page(conn, _params) do
      form =
        MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, %{})
        |> Phoenix.Component.to_form(as: :number_input_changeset, id: "number-input-changeset-form")

      validate_form =
        MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, %{})
        |> Phoenix.Component.to_form(as: :number_input_validate, id: "number-input-validate-form")

      render(conn, :number_input_form_page, form: form, validate_form: validate_form)
    end

    def number_input_form_create(conn, %{"number_input_changeset" => params}) do
      case MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved")
          |> redirect(to: ~p"/number-input/form#number-input-form-changeset")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :number_input_changeset,
              id: "number-input-changeset-form"
            )

          validate_form =
            MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, %{})
            |> Phoenix.Component.to_form(as: :number_input_validate, id: "number-input-validate-form")

          render(conn, :number_input_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    form_doc_controller_changeset_heex()
    |> String.replace("number-input-changeset", "number-input-validate")
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def number_input_form_strict_create(conn, %{"number_input_validate" => params}) do
      case MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved (strict)")
          |> redirect(to: ~p"/number-input/form#number-input-form-validate")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :number_input_validate,
              id: "number-input-validate-form"
            )

          form =
            MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, %{})
            |> Phoenix.Component.to_form(as: :number_input_changeset, id: "number-input-changeset-form")

          render(conn, :number_input_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/number-input/form"}
      method="post"
      id="number-input-plain-form"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <label class="typo typo--sm font-medium" for="number-input-plain-value">Value</label>
      <input
        type="number"
        name="value"
        id="number-input-plain-value"
        value="1234"
        class="native-input"
        step="any"
      />
      <button type="submit" id="number-input-plain-submit" class="button button--accent">
        Submit
      </button>
    </form>
    """
  end

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
      id={Corex.Form.get_form_id(@form)}
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.number_input field={f[:value]} id="number-input-changeset-field" class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
      id={Corex.Form.get_form_id(@form)}
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.number_input field={f[:value]} id="number-input-validate-field" class="number-input">
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-validate-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/number-input/form"}
      method="post"
      id="number-input-plain-form"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <label class="typo typo--sm font-medium" for="number-input-plain-value">Value</label>
      <input
        type="number"
        name="value"
        id="number-input-plain-value"
        value="1234"
        class="native-input"
        step="any"
      />
      <.action type="submit" id="number-input-plain-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form for={@form} id={Corex.Form.get_form_id(@form)} phx-change="validate" phx-submit="save" class="flex flex-col gap-4 w-full max-w-lg">
      <.number_input field={@form[:value]} id="number-input-live-changeset-field" class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-form-live-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("validate", %{"number_input_changeset" => params}, socket) do
      changeset =
        %MyApp.Forms.NumberInputForm{}
        |> MyApp.Forms.NumberInputForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form, Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_changeset,
         id: "number-input-live-changeset-form"
       ))}
    end

    def handle_event("save", %{"number_input_changeset" => params}, socket) do
      case MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, put_flash(socket, :info, "Submitted: #{inspect(data.value)}")}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :form, Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_changeset,
             id: "number-input-live-changeset-form"
           ))}
      end
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
      id={Corex.Form.get_form_id(@form)}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.number_input field={@form[:value]} id="number-input-live-validate-field" class="number-input">
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-form-live-validate-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def handle_event("validate_strict", %{"number_input_validate" => params}, socket) do
      changeset =
        %MyApp.Forms.NumberInputForm{}
        |> MyApp.Forms.NumberInputForm.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :strict_form, Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_validate,
         id: "number-input-live-validate-form"
       ))}
    end

    def handle_event("save_strict", %{"number_input_validate" => params}, socket) do
      case MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, put_flash(socket, :info, "Submitted (strict): #{inspect(data.value)}")}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :strict_form, Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_validate,
             id: "number-input-live-validate-form"
           ))}
      end
    end
    """
  end

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={Corex.Form.get_form_id(@form)}
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.number_input field={@form[:value]} id="number-input-live-changeset-field" class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action
        type="submit"
        id="number-input-form-live-changeset-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      id={Corex.Form.get_form_id(@form)}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="flex flex-col gap-4 w-full max-w-lg"
    >
      <.number_input field={@form[:value]} id="number-input-live-validate-field" class="number-input">
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-form-live-validate-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end
end
