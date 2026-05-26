defmodule E2eWeb.Demos.ColorPickerDemo do
  @moduledoc false

  use E2eWeb, :html

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
    <div class="layout__row">
      <.action phx-click={Corex.ColorPicker.set_value("color-picker-api-value-c", "#ff0000")} class="button button--sm">Set red</.action>
      <.action phx-click={Corex.ColorPicker.set_value("color-picker-api-value-c", "#3b82f6")} class="button button--sm">Set blue</.action>
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
    <div class="layout__row">
      <.action phx-click={Corex.ColorPicker.set_value(@id, "#ff0000")} class="button button--sm">
        Set red
      </.action>
      <.action phx-click={Corex.ColorPicker.set_value(@id, "#3b82f6")} class="button button--sm">
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
    <div class="layout__row">
      <.action phx-click="cp_api_s_value" phx-value-color="#ff0000" class="button button--sm">Set red</.action>
      <.action phx-click="cp_api_s_value" phx-value-color="#3b82f6" class="button button--sm">Set blue</.action>
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
    case get_field(changeset, :color) do
      nil ->
        changeset

      value ->
        case Regex.run(~r/rgba?\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*([\d.]+)\s*\)/, value) do
          [_, a] ->
            case Float.parse(a) do
              {float_val, _} ->
                if float_val > 0.5 do
                  add_error(changeset, :color, "maximum alpha allowed is 50%")
                else
                  changeset
                end

              :error ->
                changeset
            end
          _ ->
            changeset
        end
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
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
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def color_picker_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"color" => "#3b82f6"}, as: :color_picker_phoenix, id: "color-picker-form-phoenix")

      render(conn, :color_picker_form_page, phoenix_form: phoenix_form)
    end

    def color_picker_form_submit(conn, params) do
      if is_map(params["color_picker_phoenix"]) do
        color = params["color_picker_phoenix"]["color"] || ""

        conn
        |> put_flash(:info, "Submitted: color=#{inspect(color)}")
        |> redirect(to: ~p"/color-picker/form#color-picker-form-phoenix")
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
      <.action type="submit" class="button button--accent">
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
      <.action type="submit" class="button button--accent">
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
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    def color_picker_form_validate_create(conn, %{"color_picker_validate" => params}) do
      case MyApp.Form.ColorPickerForm.changeset_validate(%MyApp.Form.ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved: color=#{data.color}")
          |> redirect(to: ~p"/settings")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset, as: :color_picker_validate, id: "color-picker-validate-form")

          form =
            %MyApp.Form.ColorPickerForm{}
            |> MyApp.Form.ColorPickerForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :color_picker_changeset,
              id: "color-picker-changeset-form"
            )

          render(conn, :color_picker_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form
      action={~p"/color-picker/form"}
      method="post"
          >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.color_picker
        name="color_picker_form[color]"
        value="#3b82f6"
        label="Color"
        class="color-picker"
      />
      <.action type="submit" class="button button--accent">
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
      |> redirect(to: ~p"/color-picker/form#color-picker-form-native")
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
      <.action type="submit" class="button button--accent">
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
      <.action type="submit" class="button button--accent">
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
        name={@form[:color].name}
        id="color-picker-changeset"
        value={@form[:color].value || "#3b82f6"}
        label="Color"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action
        type="submit"
        id="color-picker-changeset-submit"
        class="button button--accent"
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
        name={@form[:color].name}
        id="color-picker-validate"
        value={@form[:color].value || "#3b82f6"}
        label="Color"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action
        type="submit"
        id="color-picker-validate-submit"
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
        class="button button--accent"
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
        name={@form[:color].name}
        id="color-picker-live-basic"
        value={@color}
        label="Color"
        on_value_change="color_changed_basic"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action
        type="submit"
        id="color-picker-basic-form-live-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)
  attr(:color, :string, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_validate"
      phx-submit="save_validate"
    >
      <.color_picker
        name={@form[:color].name}
        id="color-picker-live-validate"
        value={@color}
        label="Color"
        on_value_change="color_changed_validate"
        class="color-picker"
      />
      <.color_form_errors form={@form} />
      <.action
        type="submit"
        id="color-picker-validate-form-live-submit"
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
      <.action type="submit" class="button button--accent">
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
        name={@form[:color].name}
        value={@form[:color].value || "#3b82f6"}
        label="Color"
        class="color-picker"
      />
      <.action type="submit" class="button button--accent">
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
end
