defmodule E2eWeb.Demos.PinInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.pin_input count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.pin_input id="pin-input-anatomy-minimal" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def with_default_code do
    ~S"""
    <.pin_input
      count={4}
      class="pin-input"
      value={["1", "2", "3", "4"]}
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def with_default_example(assigns) do
    ~H"""
    <.pin_input
      id="pin-input-anatomy-default"
      count={4}
      class="pin-input"
      value={["1", "2", "3", "4"]}
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def events_server_heex do
    ~S"""
    <.pin_input
      count={4}
      class="pin-input"
      on_value_change="pin_input_changed"
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "pin_input_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.pin_input
      id="pin-input-events-client"
      count={4}
      class="pin-input"
      on_value_change_client="pin-input-changed"
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("pin-input-events-client");
    el?.addEventListener("pin-input-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("pin-input-events-client");
    el?.addEventListener("pin-input-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Form.PinInputForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :pin, :string
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:pin])
        |> validate_required([:pin], message: "can't be blank")
        |> validate_length(:pin, is: 4, message: "must be 4 characters")
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@phoenix_form}
      action={~p"/pin-input/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.pin_input field={f[:pin]} count={4} class="pin-input" id="pin-input-form-phoenix-pin">
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def pin_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"pin" => ""}, as: :pin_phoenix, id: "pin-input-form-phoenix")

      render(conn, :pin_input_form_page, phoenix_form: phoenix_form)
    end

    def pin_input_form_submit(conn, params) do
      if is_map(params["pin_phoenix"]) do
        pin = params["pin_phoenix"]["pin"] || ""

        conn
        |> put_flash(:info, "Submitted: pin=#{inspect(pin)}")
        |> redirect(to: ~p"/pin-input/form#pin-input-form-phoenix")
      end
    end
    """
  end

  def form_doc_controller_ecto_heex do
    ~S"""
    <.form
      :let={f}
      for={@ecto_form}
      action={~p"/pin-input/form"}
      method="post"
      id={@ecto_form.id}
    >
      <.pin_input field={f[:pin]} count={4} class="pin-input" id="pin-input-form-ecto-pin">
        <:label>Code</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.pin_input>
      <.action type="submit" id="pin-input-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_ecto_elixir do
    ~S"""
    def pin_input_form_page(conn, _params) do
      ecto_form =
        %MyApp.Form.PinInputForm{}
        |> MyApp.Form.PinInputForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :pin_ecto, id: "pin-input-form-ecto")

      render(conn, :pin_input_form_page, ecto_form: ecto_form)
    end

    def pin_input_form_submit(conn, params) do
      if is_map(params["pin_ecto"]) do
        case MyApp.Form.PinInputForm.changeset_validate(%MyApp.Form.PinInputForm{}, params["pin_ecto"]) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(:info, "Submitted: pin=#{inspect(data.pin)}")
            |> redirect(to: ~p"/pin-input/form#pin-input-form-ecto")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)
            ecto_form = Phoenix.Component.to_form(changeset, as: :pin_ecto, id: "pin-input-form-ecto")
            render(conn, :pin_input_form_page, ecto_form: ecto_form)
        end
      end
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/pin-input/form"} method="post" id="pin-input-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.pin_input name="pin_input[pin]" count={4} class="pin-input" id="pin-input-form-native-pin">
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.pin_input field={@phoenix_form[:pin]} count={4} class="pin-input" id="pin-input-live-form-phoenix-pin">
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_heex do
    ~S"""
    <.form for={@ecto_form} id={@ecto_form.id} phx-change="validate" phx-submit="save">
      <.pin_input field={@ecto_form[:pin]} count={4} class="pin-input" id="pin-input-live-form-ecto-pin">
        <:label>Code</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.pin_input>
      <.action type="submit" id="pin-input-live-form-ecto-submit" class="button button--accent">
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
      action={~p"/pin-input/form"}
      method="post"
      id={@form.id}
    >
      <.pin_input field={f[:pin]} count={4} class="pin-input" id="pin-input-form-phoenix-pin">
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/pin-input/form"}
      method="post"
      id={@form.id}
    >
      <.pin_input field={f[:pin]} count={4} class="pin-input" id="pin-input-form-ecto-pin">
        <:label>Code</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.pin_input>
      <.action type="submit" id="pin-input-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form action={~p"/pin-input/form"} method="post" id="pin-input-form-native">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.pin_input name="pin_input[pin]" count={4} class="pin-input" id="pin-input-form-native-pin">
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-form-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.pin_input field={@form[:pin]} count={4} class="pin-input" id="pin-input-live-form-phoenix-pin">
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-change="validate" phx-submit="save">
      <.pin_input field={@form[:pin]} count={4} class="pin-input" id="pin-input-live-form-ecto-pin">
        <:label>Code</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.pin_input>
      <.action type="submit" id="pin-input-live-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.PinInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"pin" => ""}, as: :pin_phoenix, id: "pin-input-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"pin_phoenix" => params}, socket) do
        pin = params["pin"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"pin" => pin}, as: :pin_phoenix, id: "pin-input-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.PinInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Form.PinInputForm{}
          |> MyApp.Form.PinInputForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :pin_ecto, id: "pin-input-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"pin_ecto" => params}, socket) do
        changeset =
          %MyApp.Form.PinInputForm{}
          |> MyApp.Form.PinInputForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :pin_ecto,
             id: "pin-input-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"pin_ecto" => params}, socket) do
        case MyApp.Form.PinInputForm.changeset_validate(%MyApp.Form.PinInputForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Form.PinInputForm.changeset_validate(%MyApp.Form.PinInputForm{}, params),
                 as: :pin_ecto,
                 id: "pin-input-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :pin_ecto,
                 id: "pin-input-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_ecto_heex()
  def form_ecto_elixir, do: form_doc_controller_ecto_elixir()
  def form_code, do: form_native_heex()

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.PinInput.set_value("pin-api-set-client", ["1", "2", "3", "4"])} class="button button--sm">
      Fill
    </.action>
    <.pin_input id="pin-api-set-client" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_pin_set_value_server" class="button button--sm">
      Fill from server
    </.action>
    <.pin_input id="pin-api-set-server" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_pin_set_value_server", _params, socket) do
      {:noreply,
       Corex.PinInput.set_value(socket, "pin-api-set-server", ["1", "2", "3", "4"])}
    end
    """
  end

  def api_set_value_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:pin-input:set-value",
        to: "#pin-api-set-js",
        detail: %{value: ["1", "2", "3", "4"]},
        bubbles: false
      )}
      class="button button--sm"
    >
      Fill via dispatch
    </.action>
    <.pin_input id="pin-api-set-js" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_js_js do
    ~S"""
    const el = document.getElementById("pin-api-set-js");
    el?.dispatchEvent(
      new CustomEvent("corex:pin-input:set-value", {
        bubbles: false,
        detail: { value: ["1", "2", "3", "4"] },
      })
    );
    """
  end

  def api_set_value_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("pin-api-set-js");
    el?.dispatchEvent(
      new CustomEvent<{ value: string[] }>("corex:pin-input:set-value", {
        bubbles: false,
        detail: { value: ["1", "2", "3", "4"] },
      })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:pin-input:set-value",
            to: "##{@id}",
            detail: %{value: ["1", "2", "3", "4"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Fill via dispatch
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_pin_set_value_server" class="button button--sm">
        Fill from server
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.PinInput.value("pin-api-val-client")} class="button button--sm">
      Read value
    </.action>
    <.pin_input id="pin-api-val-client" count={4} class="pin-input" value={["1", "2", "", ""]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_server_heex do
    ~S"""
    <.action phx-click="api_pin_value_server" class="button button--sm">
      Read value (server)
    </.action>
    <.pin_input id="pin-api-val-server" count={4} class="pin-input" value={["5", "6", "7", "8"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_server_elixir do
    ~S"""
    def handle_event("api_pin_value_server", _params, socket) do
      {:noreply, Corex.PinInput.value(socket, "pin-api-val-server")}
    end
    """
  end

  def api_value_client_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:pin-input:value", to: "#pin-api-val-js", detail: %{}, bubbles: false)}
      class="button button--sm"
    >
      Read via dispatch
    </.action>
    <.pin_input id="pin-api-val-js" count={4} class="pin-input" value={["1", "0", "0", "0"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_client_js_js do
    ~S"""
    const el = document.getElementById("pin-api-val-js");
    el?.dispatchEvent(new CustomEvent("corex:pin-input:value", { bubbles: false, detail: {} }));
    """
  end

  def api_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("pin-api-val-js");
    el?.dispatchEvent(new CustomEvent("corex:pin-input:value", { bubbles: false, detail: {} }));
    """
  end

  def api_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:pin-input:value", to: "##{@id}", detail: %{}, bubbles: false)}
        class="button button--sm"
      >
        Read via dispatch
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["1", "0", "0", "0"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_client_binding_code do
    ~S"""
    <.action phx-click={Corex.PinInput.clear("pin-api-clear-client")} class="button button--sm">
      Clear
    </.action>
    <.pin_input id="pin-api-clear-client" count={4} class="pin-input" value={["9", "9", "9", "9"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <.action phx-click="api_pin_clear_server" class="button button--sm">
      Clear from server
    </.action>
    <.pin_input id="pin-api-clear-server" count={4} class="pin-input" value={["1", "1", "1", "1"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_server_elixir do
    ~S"""
    def handle_event("api_pin_clear_server", _params, socket) do
      {:noreply, Corex.PinInput.clear(socket, "pin-api-clear-server")}
    end
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.PinInput.set_value(@id, ["1", "2", "3", "4"])}
        class="button button--sm"
      >
        Fill
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.PinInput.value(@id)} class="button button--sm">Value</.action>
      <.action phx-click={Corex.PinInput.value(@id, respond_to: :client)} class="button button--sm">
        Value (client only)
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["1", "2", "", ""]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.PinInput.clear(@id)} class="button button--sm">Clear</.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["9", "9", "9", "9"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_pin_value_server" class="button button--sm">Read from server</.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["5", "6", "7", "8"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_pin_clear_server" class="button button--sm">Clear from server</.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["1", "1", "1", "1"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end
end
