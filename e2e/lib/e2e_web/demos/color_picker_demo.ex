defmodule E2eWeb.Demos.ColorPickerDemo do
  @moduledoc false

  use E2eWeb, :html

  alias E2eWeb.DemoScales

  @presets ["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]

  def presets, do: @presets

  def minimal_code do
    ~S"""
    <.color_picker
      value="rgb(25, 9, 192, 0.9)"
      label="Select Color (RGBA)"
      presets={["#ff0000", "#00ff00", "#0000ff", "rgb(25, 9, 192, 0.9)"]}
      class="color-picker"
    />
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.color_picker
      id="color-picker-anatomy-minimal"
      label="Pick a color"
      class="color-picker"
    />
    """
  end

  def with_value_code do
    ~S"""
    <.color_picker
      value="#22c55e"
      label="Initial value"
      class="color-picker"
    />
    """
  end

  def with_value_example(assigns) do
    ~H"""
    <.color_picker
      id="color-picker-anatomy-with-value"
      value="#22c55e"
      label="Initial value"
      class="color-picker"
    />
    """
  end

  def with_positioning_code do
    ~S"""
    <.color_picker
      value="#3b82f6"
      label="Placement and gutter"
      positioning={%Corex.Positioning{placement: "left-start", gutter: 12}}
      class="color-picker"
    />
    """
  end

  def with_positioning_example(assigns) do
    _ = assigns

    ~H"""
    <.color_picker
      id="color-picker-anatomy-positioning"
      value="#3b82f6"
      label="Placement and gutter"
      positioning={%Corex.Positioning{placement: "left-start", gutter: 12}}
      class="color-picker"
    />
    """
  end

  def with_presets_code do
    ~S"""
    <.color_picker
      value="#3b82f6"
      label="Presets + picker"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
    />
    """
  end

  def with_presets_example(assigns) do
    ~H"""
    <.color_picker
      id="color-picker-anatomy-with-preset"
      value="#3b82f6"
      label="Presets + picker"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
    />
    """
  end

  def api_set_value_client_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.ColorPicker.set_value("color-picker-api-value-c", "#ff0000")} class="button ui-size-sm">Set red</.action>
      <.action phx-click={Corex.ColorPicker.set_value("color-picker-api-value-c", "#3b82f6")} class="button ui-size-sm">Set blue</.action>
    </div>
    <.color_picker
      value="#3b82f6"
      label="Set the color from actions"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
    />
    """
  end

  attr(:id, :string, required: true)

  def api_set_value_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.ColorPicker.set_value(@id, "#ff0000")} class="button ui-size-sm">
        Set red
      </.action>
      <.action phx-click={Corex.ColorPicker.set_value(@id, "#3b82f6")} class="button ui-size-sm">
        Set blue
      </.action>
    </div>
    <.color_picker
      id={@id}
      value="#3b82f6"
      label="Set the color from actions"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
    />
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="cp_api_s_value" phx-value-color="#ff0000" class="button ui-size-sm">Set red</.action>
      <.action phx-click="cp_api_s_value" phx-value-color="#3b82f6" class="button ui-size-sm">Set blue</.action>
    </div>
    <.color_picker
      value="#3b82f6"
      label="Set the color (Server)"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
    />
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("cp_api_s_value", %{"color" => hex}, socket) do
      {:noreply, Corex.ColorPicker.set_value(socket, "color-picker-api-value-s", hex)}
    end
    """
  end

  def events_server_value_heex do
    ~S"""
    <.color_picker
      value="#3b82f6"
      label="Value (server)"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
      on_value_change="cp_ev_server_value"
    />
    """
  end

  def events_server_value_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "cp_ev_server_value",
      ~S|%{"id" => id, "valueAsString" => value} = params|
    )
  end

  def events_server_open_heex do
    ~S"""
    <.color_picker
      value="#3b82f6"
      label="Open (server)"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
      on_open_change="cp_ev_server_open"
    />
    """
  end

  def events_server_open_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "cp_ev_server_open",
      ~S|%{"id" => id, "open" => open} = params|
    )
  end

  def events_client_value_heex do
    ~S"""
    <.color_picker
      value="#3b82f6"
      label="Value (client only)"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
      on_value_change_client="color-picker-cv"
    />
    """
  end

  def events_client_value_js do
    ~S"""
    const el = document.getElementById("color-picker-ev-cv");
    el?.addEventListener("color-picker-cv", (event) => {
      console.log(event.detail);
    });
    """
  end

  def events_client_value_ts do
    ~S"""
    const el = document.getElementById("color-picker-ev-cv");
    el?.addEventListener("color-picker-cv", (event: Event) => {
      console.log((event as CustomEvent<unknown>).detail);
    });
    """
  end

  def events_client_open_heex do
    ~S"""
    <.color_picker
      value="#3b82f6"
      label="Open (client only)"
      presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      class="color-picker"
      on_open_change_client="color-picker-co"
    />
    """
  end

  def events_client_open_js do
    ~S"""
    const el = document.getElementById("color-picker-ev-co");
    el?.addEventListener("color-picker-co", (event) => {
      console.log(event.detail);
    });
    """
  end

  def events_client_open_ts do
    ~S"""
    const el = document.getElementById("color-picker-ev-co");
    el?.addEventListener("color-picker-co", (event: Event) => {
      console.log((event as CustomEvent<unknown>).detail);
    });
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Form.ColorPickerForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :color, :string, default: "#3b82f6"
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:color])
        |> validate_required([:color])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:color])
        |> validate_required([:color])
        |> validate_alpha_max_50()
      end

      defp validate_alpha_max_50(changeset) do
        with value when is_binary(value) <- get_field(changeset, :color),
             [_, alpha] <-
               Regex.run(~r/rgba?\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*([\d.]+)\s*\)/, value),
             {float_val, _} <- Float.parse(alpha),
             true <- float_val > 0.5 do
          add_error(changeset, :color, "maximum alpha allowed is 50%")
        else
          _ -> changeset
        end
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action="/color-picker/form"
      method="post"
    >
      <.color_picker
        field={f[:color]}
        label="Color"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>

      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def color_picker_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"color" => "#3b82f6"},
          as: :color_picker_phoenix,
          id: "color-picker-form-phoenix"
        )

      render(conn, :color_picker_form_page, phoenix_form: phoenix_form)
    end

    def color_picker_form_submit(conn, params) do
      if is_map(params["color_picker_phoenix"]) do
        color = params["color_picker_phoenix"]["color"] || ""

        conn
        |> put_flash(:info, "Submitted: color=#{inspect(color)}")
        |> redirect(to: "/color-picker/form")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.color_picker
        name={@form[:color].name}
        value={@form[:color].value || "#3b82f6"}
        label="Color"
        class="color-picker"
      />
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/color-picker/form"}
      method="post"
          >
      <.color_picker
        name={@form[:color].name}
        value={@form[:color].value || "#3b82f6"}
        label="Color"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_elixir do
    ~S"""
    def color_picker_form_page(conn, _params) do
      form =
        %MyApp.Form.ColorPickerForm{}
        |> MyApp.Form.ColorPickerForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :color_picker_changeset, id: "color-picker-changeset-form")

      validate_form =
        %MyApp.Form.ColorPickerForm{}
        |> MyApp.Form.ColorPickerForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(
          as: :color_picker_validate,
          id: "color-picker-validate-form"
        )

      render(conn, :color_picker_form_page, form: form, validate_form: validate_form)
    end

    def color_picker_form_create(conn, %{"color_picker_changeset" => params}) do
      case MyApp.Form.ColorPickerForm.changeset(%MyApp.Form.ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved: color=#{data.color}")
          |> redirect(to: ~p"/settings")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset, as: :color_picker_changeset, id: "color-picker-changeset-form")

          validate_form =
            %MyApp.Form.ColorPickerForm{}
            |> MyApp.Form.ColorPickerForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :color_picker_validate,
              id: "color-picker-validate-form"
            )

          render(conn, :color_picker_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action="/color-picker/form"
      method="post"
    >
      <.color_picker
        field={f[:color]}
        label="Color"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>

      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    def color_picker_form_validate_page(conn, _params) do
      changeset =
        MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :color_picker_validate,
          id: "color-picker-validate-form"
        )

      render(conn, :color_picker_form_page, form: form)
    end

    def color_picker_form_validate_create(conn, %{"color_picker_validate" => params}) do
      case MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Saved: color=#{data.color}")
          |> redirect(to: "/settings")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :color_picker_validate,
              id: "color-picker-validate-form"
            )

          render(conn, :color_picker_form_page, form: form)
      end
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form
      action="/color-picker/form"
      method="post"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.color_picker
        name="color_picker_form[color]"
        value="#3b82f6"
        label="Color"
        class="color-picker"
      />
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def color_picker_form_submit(conn, %{"color_picker_form" => %{"color" => color}}) do
      conn
      |> put_flash(:info, "Submitted: color=#{color}")
      |> redirect(to: "/color-picker/form")
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
      <.color_picker
        name={@form[:color].name}
        value={@color}
        label="Color"
        on_value_change="color_changed_basic"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("save_basic", %{"color_picker_basic" => params}, socket) do
      case MyApp.Form.ColorPickerForm.changeset(%MyApp.Form.ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          new_form = Phoenix.Component.to_form(MyApp.Form.ColorPickerForm.changeset(%MyApp.Form.ColorPickerForm{}, params),
            as: :color_picker_basic,
            id: "color-picker-basic-form"
          )

          {:noreply, assign(socket, :basic_form, new_form)}

        changeset ->
          {:noreply,
           assign(
             socket,
             :basic_form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :color_picker_basic, id: "color-picker-basic-form")
           )}
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
      <.color_picker
        name={@form[:color].name}
        value={@color}
        label="Color"
        on_value_change="color_changed_validate"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def handle_event("save_validate", %{"color_picker_validate" => params}, socket) do
      case MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          new_form =
            Phoenix.Component.to_form(
              MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, params),
              as: :color_picker_validate,
              id: "color-picker-validate-form-live"
            )

          {:noreply, assign(socket, :validate_form, new_form)}

        changeset ->
          {:noreply,
           assign(
             socket,
             :validate_form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :color_picker_validate,
               id: "color-picker-validate-form-live"
             )
           )}
      end
    end
    """
  end

  def form_code do
    form_native_heex()
  end

  attr(:form, :any, required: true)

  def color_form_errors(assigns) do
    ~H"""
    <div
      :if={@form[:color].errors != []}
      id={"#{@form.id}-color-errors"}
      class="w-full max-w-2xs flex flex-col gap-space-xs"
      role="alert"
    >
      <p :for={{msg, _} <- @form[:color].errors} class="ui-error">{msg}</p>
    </div>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/color-picker/form"}
      method="post"
    >
      <.color_picker
        field={@form[:color]}
        id="color-picker-changeset"
        label="Color"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>
      <.action
        type="submit"
        id="color-picker-changeset-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/color-picker/form"}
      method="post"
    >
      <.color_picker
        field={@form[:color]}
        id="color-picker-validate"
        label="Color"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>
      <.action
        type="submit"
        id="color-picker-validate-submit"
        class="button ui-accent"
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
      action={~p"/color-picker/form"}
      method="post"
      id="color-picker-plain-form"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.color_picker
        name="color_picker_form[color]"
        id="color-picker-form-native"
        value="#3b82f6"
        label="Color"
        class="color-picker"
      />
      <.action
        type="submit"
        id="color-picker-form-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, :any, required: true)
  attr(:color, :string, required: true)

  def form_preview_live_basic(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_basic"
      phx-submit="save_basic"
    >
      <.color_picker
        field={@form[:color]}
        id="color-picker-live-basic"
        label="Color"
        on_value_change="color_changed_basic"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>
      <.action
        type="submit"
        id="color-picker-basic-form-live-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_validate"
      phx-submit="save_validate"
    >
      <.color_picker
        field={@form[:color]}
        id="color-picker-live-validate"
        label="Color"
        on_value_change="color_changed_validate"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>
      <.action
        type="submit"
        id="color-picker-validate-form-live-submit"
        class="button ui-accent"
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
      for={@form}
      action={~p"/color-picker/form"}
      method="post"
    >
      <.color_picker
        field={@form[:color]}
        label="Color"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()

  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix">
      <.color_picker
        field={@form[:color]}
        label="Color"
        class="color-picker"
        presets={["#ff0000", "#00ff00", "#0000ff"]}
      >
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.ColorPickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"color" => "#ff0000"}, as: :color_picker_phoenix, id: "color-picker-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"color_picker_phoenix" => params}, socket) do
        color = params["color"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"color" => color}, as: :color_picker_phoenix, id: "color-picker-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.ColorPickerFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Form.ColorPickerForm{}
          |> MyApp.Form.ColorPickerForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :color_picker_ecto, id: "color-picker-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"color_picker_ecto" => params}, socket) do
        changeset =
          %MyApp.Form.ColorPickerForm{}
          |> MyApp.Form.ColorPickerForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :color_picker_ecto,
             id: "color-picker-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"color_picker_ecto" => params}, socket) do
        case MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, params),
                 as: :color_picker_ecto,
                 id: "color-picker-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :color_picker_ecto,
                 id: "color-picker-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end

  def styling_color_code do
    ~S"""
    <.color_picker class="color-picker" value="#3b82f6" label="Default" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-accent" value="#3b82f6" label="Accent" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-brand" value="#3b82f6" label="Brand" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-alert" value="#3b82f6" label="Alert" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-info" value="#3b82f6" label="Info" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-success" value="#3b82f6" label="Success" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    """
  end

  def styling_color_example(assigns) do
    assigns = assign(assigns, :presets, @presets)

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full">
      <.color_picker
        id="color-picker-style-color-default"
        class="color-picker"
        value="#3b82f6"
        label="Default"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-color-accent"
        class="color-picker ui-accent"
        value="#3b82f6"
        label="Accent"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-color-brand"
        class="color-picker ui-brand"
        value="#3b82f6"
        label="Brand"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-color-alert"
        class="color-picker ui-alert"
        value="#3b82f6"
        label="Alert"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-color-info"
        class="color-picker ui-info"
        value="#3b82f6"
        label="Info"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-color-success"
        class="color-picker ui-success"
        value="#3b82f6"
        label="Success"
        presets={@presets}
      />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.color_picker class="color-picker" value="#3b82f6" label="Subtle (default)" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-solid" value="#3b82f6" label="Solid" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    """
  end

  def styling_variant_example(assigns) do
    assigns = assign(assigns, :presets, @presets)

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full">
      <.color_picker
        id="color-picker-style-variant-subtle"
        class="color-picker"
        value="#3b82f6"
        label="Subtle (default)"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-variant-solid"
        class="color-picker ui-solid"
        value="#3b82f6"
        label="Solid"
        presets={@presets}
      />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("color-picker"),
        variant <- DemoScales.styling_variant_axis_steps("color-picker") do
      class =
        DemoScales.join_matrix_modifiers("color-picker", semantic.modifier, variant.modifier)

      ~s(<.color_picker class="#{class}" value="#3b82f6" label="#{semantic.label}" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:presets, @presets)
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("color-picker"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("color-picker"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.color_picker
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"color-picker-matrix-#{semantic_index}-#{variant_index}"}
            class={
              DemoScales.join_matrix_modifiers("color-picker", semantic.modifier, variant.modifier)
            }
            value="#3b82f6"
            label={semantic.label}
            presets={@presets}
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.color_picker class="color-picker ui-size-sm" value="#3b82f6" label="SM" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-size-md" value="#3b82f6" label="MD" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-size-lg" value="#3b82f6" label="LG" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-size-xl" value="#3b82f6" label="XL" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :presets, @presets)

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full">
      <.color_picker
        id="color-picker-style-size-sm"
        class="color-picker ui-size-sm"
        value="#3b82f6"
        label="SM"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-size-md"
        class="color-picker ui-size-md"
        value="#3b82f6"
        label="MD"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-size-lg"
        class="color-picker ui-size-lg"
        value="#3b82f6"
        label="LG"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-size-xl"
        class="color-picker ui-size-xl"
        value="#3b82f6"
        label="XL"
        presets={@presets}
      />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.color_picker class="color-picker ui-rounded-none" value="#3b82f6" label="None" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-rounded-sm" value="#3b82f6" label="SM" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-rounded-md" value="#3b82f6" label="MD" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-rounded-lg" value="#3b82f6" label="LG" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-rounded-xl" value="#3b82f6" label="XL" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    <.color_picker class="color-picker ui-rounded-full" value="#3b82f6" label="Full" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
    """
  end

  def styling_rounded_example(assigns) do
    assigns = assign(assigns, :presets, @presets)

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full">
      <.color_picker
        id="color-picker-style-rounded-none"
        class="color-picker ui-rounded-none"
        value="#3b82f6"
        label="None"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-rounded-sm"
        class="color-picker ui-rounded-sm"
        value="#3b82f6"
        label="SM"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-rounded-md"
        class="color-picker ui-rounded-md"
        value="#3b82f6"
        label="MD"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-rounded-lg"
        class="color-picker ui-rounded-lg"
        value="#3b82f6"
        label="LG"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-rounded-xl"
        class="color-picker ui-rounded-xl"
        value="#3b82f6"
        label="XL"
        presets={@presets}
      />
      <.color_picker
        id="color-picker-style-rounded-full"
        class="color-picker ui-rounded-full"
        value="#3b82f6"
        label="Full"
        presets={@presets}
      />
    </div>
    """
  end

  def styling_width_code do
    label = DemoScales.block_demo_label()

    DemoScales.width_layout_variants("color-picker")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("color-picker", modifier)

      """
      <.color_picker class="#{class}" value="#3b82f6" label="#{label}" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    label = DemoScales.block_demo_label()

    DemoScales.max_width_variants("color-picker")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_block_modifiers("color-picker", modifier)

      """
      <.color_picker class="#{class}" value="#3b82f6" label="#{label}" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]} />
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns =
      assigns
      |> assign(:presets, @presets)
      |> assign(:width_variants, DemoScales.width_layout_variants("color-picker"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.color_picker
          id={"color-picker-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("color-picker", variant.modifier)}
          value="#3b82f6"
          label={DemoScales.block_demo_label()}
          presets={@presets}
        />
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns =
      assigns
      |> assign(:presets, @presets)
      |> assign(:max_width_variants, DemoScales.max_width_variants("color-picker"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.color_picker
          id={"color-picker-style-max-#{variant.id}"}
          class={DemoScales.join_block_modifiers("color-picker", variant.modifier)}
          value="#3b82f6"
          label={DemoScales.block_demo_label()}
          presets={@presets}
        />
      </div>
    </div>
    """
  end
end
