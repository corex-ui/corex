defmodule E2eWeb.Demos.RadioGroupDemo do
  use E2eWeb, :html

  defp items do
    [
      %{value: "a", label: "Option A"},
      %{value: "b", label: "Option B"},
      %{value: "c", label: "Option C"}
    ]
  end

  def minimal_code do
    ~S"""
    <.radio_group
      id="radio-group-anatomy-minimal"
      name="rg-minimal"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
    >
      <:label>Choose one</:label>
    </.radio_group>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-anatomy-minimal"
      name="rg-minimal"
      class="radio-group"
      items={items()}
    >
      <:label>Choose one</:label>
    </.radio_group>
    """
  end

  def indicator_code do
    ~S"""
    <.radio_group
      id="radio-group-anatomy-indicator"
      name="rg-indicator"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def indicator_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-anatomy-indicator"
      name="rg-indicator"
      class="radio-group"
      items={items()}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_binding_heex do
    ~S"""
    <.radio_group
      id="radio-group-api-binding"
      name="rg-api-binding"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
      on_value_change="radio_group_api_binding"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_binding_elixir do
    ~S"""
    def handle_event("radio_group_api_binding", %{"id" => id, "value" => value}, socket) do
      {:noreply, socket}
    end
    """
  end

  def api_binding_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-api-binding"
      name="rg-api-binding"
      class="radio-group"
      items={items()}
      on_value_change="radio_group_api_binding"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_client_heex do
    ~S"""
    <.radio_group
      id="radio-group-api-client"
      name="rg-api-client"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
      on_value_change_client="radio-group-api-changed"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_client_js do
    ~S"""
    const el = document.getElementById("radio-group-api-client");
    el?.addEventListener("radio-group-api-changed", (event) => console.log(event.detail));
    """
  end

  def api_client_ts do
    ~S"""
    const el = document.getElementById("radio-group-api-client");
    el?.addEventListener("radio-group-api-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id?: string; value?: string | null }>).detail);
    });
    """
  end

  def api_client_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-api-client"
      name="rg-api-client"
      class="radio-group"
      items={items()}
      on_value_change_client="radio-group-api-changed"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_controlled_heex do
    ~S"""
    <.radio_group
      id="radio-group-api-controlled"
      name="rg-api-controlled"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
      value={@value}
      controlled
      on_value_change="radio_group_api_controlled"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_controlled_elixir do
    ~S"""
    # With controlled={true}, pass value={...} and update it from handle_event.
    # The hook reapplies value on LiveView patches (see updated() in the RadioGroup hook).
    def handle_event("radio_group_api_controlled", %{"value" => v}, socket) do
      {:noreply, assign(socket, :value, v)}
    end
    """
  end

  def api_controlled_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-api-controlled"
      name="rg-api-controlled"
      class="radio-group"
      items={items()}
      value={@value}
      controlled
      on_value_change="radio_group_api_controlled"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_overview_code, do: api_binding_heex()

  def api_overview_example(assigns), do: api_binding_example(assigns)

  def events_server_heex do
    ~S"""
    <.radio_group
      id="radio-group-events-server"
      name="rg-events-server"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"}
      ]}
      on_value_change="radio_group_changed"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("radio_group_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.radio_group
      id="radio-group-events-client"
      name="rg-events-client"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"}
      ]}
      on_value_change_client="radio-group-changed"
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("radio-group-events-client");
    el?.addEventListener("radio-group-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("radio-group-events-client");
    el?.addEventListener("radio-group-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.radio_group
      id="patterns-radio-group-controlled"
      name="patterns-rg"
      class="radio-group"
      items={[
        %{value: "a", label: "Option A"},
        %{value: "b", label: "Option B"},
        %{value: "c", label: "Option C"}
      ]}
      value={@value}
      controlled
      on_value_change="patterns_radio_value"
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :value, "a")}
    end

    def handle_event("patterns_radio_value", %{"value" => v}, socket) do
      {:noreply, assign(socket, :value, v)}
    end
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.RadioChoiceForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :choice, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:choice])
        |> validate_required(:choice)
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:choice])
        |> validate_required([:choice], message: "can't be blank")
      end
    end
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/account/choice"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id={Phoenix.HTML.Form.input_id(f, :choice)}
        name={Phoenix.HTML.Form.input_name(f, :choice)}
        value={to_string(Phoenix.HTML.Form.input_value(f, :choice) || "")}
        invalid={f[:choice].errors != []}
        class="radio-group"
        items={[
          %{value: "a", label: "Option A"},
          %{value: "b", label: "Option B"},
          %{value: "c", label: "Option C"}
        ]}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action type="submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def account_choice_page(conn, _params) do
      changeset = MyApp.Forms.RadioChoiceForm.changeset(%MyApp.Forms.RadioChoiceForm{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :radio_group_changeset,
          id: "account-choice-changeset-form"
        )

      render(conn, :account_choice, form: form)
    end

    def account_choice_create(conn, %{"radio_group_changeset" => params}) do
      case MyApp.Forms.RadioChoiceForm.changeset(%MyApp.Forms.RadioChoiceForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved: choice=#{data.choice}")
          |> redirect(to: ~p"/account")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :radio_group_changeset,
              id: "account-choice-changeset-form"
            )

          render(conn, :account_choice, form: form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/account/choice-strict"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id={Phoenix.HTML.Form.input_id(f, :choice)}
        name={Phoenix.HTML.Form.input_name(f, :choice)}
        value={to_string(Phoenix.HTML.Form.input_value(f, :choice) || "")}
        invalid={f[:choice].errors != []}
        class="radio-group"
        items={[
          %{value: "a", label: "Option A"},
          %{value: "b", label: "Option B"},
          %{value: "c", label: "Option C"}
        ]}
      >
        <:label>Choose one (stricter messages)</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action type="submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def account_choice_strict_page(conn, _params) do
      changeset =
        MyApp.Forms.RadioChoiceForm.changeset_validate(%MyApp.Forms.RadioChoiceForm{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :radio_group_validate,
          id: "account-choice-validate-form"
        )

      render(conn, :account_choice_strict, form: form)
    end

    def account_choice_strict_create(conn, %{"radio_group_validate" => params}) do
      case MyApp.Forms.RadioChoiceForm.changeset_validate(%MyApp.Forms.RadioChoiceForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved: choice=#{data.choice}")
          |> redirect(to: ~p"/account")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :radio_group_validate,
              id: "account-choice-validate-form"
            )

          render(conn, :account_choice_strict, form: form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/register"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <fieldset class="w-full flex flex-col gap-space">
        <legend class="typo-label">Choose one</legend>
        <label class="flex items-center gap-2">
          <input type="radio" name="user[choice]" value="a" />
          <span>Option A</span>
        </label>
        <label class="flex items-center gap-2">
          <input type="radio" name="user[choice]" value="b" />
          <span>Option B</span>
        </label>
        <label class="flex items-center gap-2">
          <input type="radio" name="user[choice]" value="c" />
          <span>Option C</span>
        </label>
      </fieldset>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </form>
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id="radio-group-live-changeset"
        name={@form[:choice].name}
        value={to_string(Phoenix.HTML.Form.input_value(@form, :choice) || "")}
        controlled
        invalid={@form[:choice].errors != []}
        class="radio-group"
        items={[
          %{value: "a", label: "Option A"},
          %{value: "b", label: "Option B"},
          %{value: "c", label: "Option C"}
        ]}
        on_value_change="choice_changed"
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action type="submit" id="radio-group-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.RadioChoiceForm{}
        |> MyApp.Forms.RadioChoiceForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :radio_group_live, id: "radio-group-live-form")

      {:ok, assign(socket, :form, form)}
    end

    def handle_event("choice_changed", %{"value" => v}, socket) do
      params = %{"choice" => v}

      changeset =
        %MyApp.Forms.RadioChoiceForm{}
        |> MyApp.Forms.RadioChoiceForm.changeset(params)
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

    def handle_event("validate", %{"radio_group_live" => params}, socket) do
      changeset =
        %MyApp.Forms.RadioChoiceForm{}
        |> MyApp.Forms.RadioChoiceForm.changeset(params)
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

    def handle_event("save", %{"radio_group_live" => params}, socket) do
      case MyApp.Forms.RadioChoiceForm.changeset(%MyApp.Forms.RadioChoiceForm{}, params) do
        %Ecto.Changeset{valid?: true} ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(
               MyApp.Forms.RadioChoiceForm.changeset(%MyApp.Forms.RadioChoiceForm{}, %{}),
               as: :radio_group_live,
               id: "radio-group-live-form"
             )
           )}

        changeset ->
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
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id="radio-group-live-strict"
        name={@form[:choice].name}
        value={to_string(Phoenix.HTML.Form.input_value(@form, :choice) || "")}
        controlled
        invalid={@form[:choice].errors != []}
        class="radio-group"
        items={[
          %{value: "a", label: "Option A"},
          %{value: "b", label: "Option B"},
          %{value: "c", label: "Option C"}
        ]}
        on_value_change="choice_changed_strict"
      >
        <:label>Choose one (stricter validation)</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action type="submit" id="radio-group-form-live-strict-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.RadioChoiceForm{}
        |> MyApp.Forms.RadioChoiceForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :radio_group_strict, id: "radio-group-strict-form-live")

      {:ok, assign(socket, :strict_form, form)}
    end

    def handle_event("choice_changed_strict", %{"value" => v}, socket) do
      params = %{"choice" => v}

      changeset =
        %MyApp.Forms.RadioChoiceForm{}
        |> MyApp.Forms.RadioChoiceForm.changeset_validate(params)
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

    def handle_event("validate_strict", %{"radio_group_strict" => params}, socket) do
      changeset =
        %MyApp.Forms.RadioChoiceForm{}
        |> MyApp.Forms.RadioChoiceForm.changeset_validate(params)
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

    def handle_event("save_strict", %{"radio_group_strict" => params}, socket) do
      case MyApp.Forms.RadioChoiceForm.changeset_validate(%MyApp.Forms.RadioChoiceForm{}, params) do
        %Ecto.Changeset{valid?: true} ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(
               MyApp.Forms.RadioChoiceForm.changeset_validate(%MyApp.Forms.RadioChoiceForm{}, %{}),
               as: :radio_group_strict,
               id: "radio-group-strict-form-live"
             )
           )}

        changeset ->
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
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_validate_heex, do: form_doc_controller_validate_heex()
  def form_validate_elixir, do: form_doc_controller_validate_elixir()
  def form_native_heex, do: form_doc_native_heex()

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/radio-group/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id={Phoenix.HTML.Form.input_id(f, :choice)}
        name={Phoenix.HTML.Form.input_name(f, :choice)}
        value={to_string(Phoenix.HTML.Form.input_value(f, :choice) || "")}
        invalid={f[:choice].errors != []}
        class="radio-group"
        items={items()}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action
        type="submit"
        id="radio-group-changeset-submit"
        class="button button--accent w-full"
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
      :let={f}
      for={@form}
      action={~p"/radio-group/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id={Phoenix.HTML.Form.input_id(f, :choice)}
        name={Phoenix.HTML.Form.input_name(f, :choice)}
        value={to_string(Phoenix.HTML.Form.input_value(f, :choice) || "")}
        invalid={f[:choice].errors != []}
        class="radio-group"
        items={items()}
      >
        <:label>Choose one (stricter messages)</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action
        type="submit"
        id="radio-group-validate-submit"
        class="button button--accent w-full"
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
      action={~p"/radio-group/form"}
      method="post"
      id="radio-group-plain-form"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <fieldset class="w-full flex flex-col gap-space">
        <legend class="typo-label">Choose one</legend>
        <label class="flex items-center gap-2">
          <input type="radio" name="user[choice]" value="a" />
          <span>Option A</span>
        </label>
        <label class="flex items-center gap-2">
          <input type="radio" name="user[choice]" value="b" />
          <span>Option B</span>
        </label>
        <label class="flex items-center gap-2">
          <input type="radio" name="user[choice]" value="c" />
          <span>Option C</span>
        </label>
      </fieldset>
      <.action type="submit" id="radio-group-controller-submit" class="button button--accent w-full">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id="radio-group-live-changeset"
        name={@form[:choice].name}
        value={choice_value(@form)}
        controlled
        invalid={@form[:choice].errors != []}
        class="radio-group"
        items={items()}
        on_value_change="choice_changed"
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action type="submit" id="radio-group-form-live-submit" class="button button--accent w-full">
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
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.radio_group
        id="radio-group-live-strict"
        name={@form[:choice].name}
        value={choice_value(@form)}
        controlled
        invalid={@form[:choice].errors != []}
        class="radio-group"
        items={items()}
        on_value_change="choice_changed_strict"
      >
        <:label>Choose one (stricter validation)</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>

      <.action
        type="submit"
        id="radio-group-form-live-strict-submit"
        class="button button--accent w-full"
      >
        Submit
      </.action>
    </.form>
    """
  end

  defp choice_value(form) do
    v =
      form.params["choice"] ||
        Ecto.Changeset.get_change(form.source, :choice) ||
        Ecto.Changeset.get_field(form.source, :choice)

    if v in [nil, ""], do: "", else: to_string(v)
  end
end
