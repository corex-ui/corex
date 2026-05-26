defmodule E2eWeb.Demos.RadioGroupDemo do
  use E2eWeb, :html

  @styling_items_heex ~S"""
  items={[
    %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
    %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
    %{value: "donec", label: "Donec condimentum ex mi"}
  ]}
  """

  @styling_item_control_heex ~S"""
  <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
  """

  @form_items_code ~S"""
  [
    %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
    %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
    %{value: "donec", label: "Donec condimentum ex mi"}
  ]
  """

  def items_for_preview, do: E2eWeb.Demos.DocExamples.radio_items()

  defp items, do: items_for_preview()

  def minimal_code do
    ~S"""
    <.radio_group
      name="rg-minimal"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
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
      name="rg-indicator"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
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

  def invalid_code do
    ~S"""
    <.radio_group
      name="rg-invalid"
      class="radio-group"
      invalid
      errors={["Required"]}
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
      ]}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.radio_group>
    """
  end

  def invalid_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-anatomy-invalid"
      name="rg-invalid"
      class="radio-group"
      invalid
      errors={["Required"]}
      items={items()}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.radio_group>
    """
  end

  def read_only_code do
    ~S"""
    <.radio_group
      name="rg-readonly"
      class="radio-group"
      read_only
      value="lorem"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
      ]}
    >
      <:label>Choose one</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def read_only_example(assigns) do
    ~H"""
    <.radio_group
      id="radio-group-anatomy-readonly"
      name="rg-readonly"
      class="radio-group"
      read_only
      value="lorem"
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
      name="rg-api-binding"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
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
      name="rg-api-client"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
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

  def api_clear_value_heex do
    ~S"""
    <.action phx-click={Corex.RadioGroup.clear_value("radio-group-api-clear")} class="button button--sm">
      Clear
    </.action>
    <.radio_group
      name="rg-api-clear"
      class="radio-group"
      value="lorem"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
      ]}
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_clear_value_elixir do
    ~S"""
    def handle_event("clear_choice", _params, socket) do
      {:noreply, Corex.RadioGroup.clear_value(socket, "radio-group-api-clear")}
    end
    """
  end

  def api_clear_value_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.action
        phx-click={Corex.RadioGroup.clear_value("radio-group-api-clear")}
        class="button button--sm button--alert"
      >
        Clear
      </.action>
      <.radio_group
        id="radio-group-api-clear"
        name="rg-api-clear"
        class="radio-group"
        value="lorem"
        items={items()}
      >
        <:label>Pick</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
    </div>
    """
  end

  def api_focus_heex do
    ~S"""
    <.action phx-click={Corex.RadioGroup.focus("radio-group-api-focus")} class="button button--sm">
      Focus group
    </.action>
    <.radio_group
      name="rg-api-focus"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
      ]}
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_focus_elixir do
    ~S"""
    def handle_event("focus_choice", _params, socket) do
      {:noreply, Corex.RadioGroup.focus(socket, "radio-group-api-focus")}
    end
    """
  end

  def api_focus_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.action phx-click={Corex.RadioGroup.focus("radio-group-api-focus")} class="button button--sm">
        Focus group
      </.action>
      <.radio_group id="radio-group-api-focus" name="rg-api-focus" class="radio-group" items={items()}>
        <:label>Pick</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
    </div>
    """
  end

  def api_server_heex do
    ~S"""
    <.action phx-click={Corex.RadioGroup.set_value("radio-group-api-server", "duis")} class="button button--sm">
      Set Duis
    </.action>
    <.action phx-click={Corex.RadioGroup.set_value("radio-group-api-server", "donec")} class="button button--sm">
      Set Donec
    </.action>
    <.radio_group
      name="rg-api-server"
      class="radio-group"
      value="lorem"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
      ]}
    >
      <:label>Pick</:label>
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("radio_group_api_set", %{"value" => value}, socket) do
      {:noreply, Corex.RadioGroup.set_value(socket, "radio-group-api-server", value)}
    end
    """
  end

  def api_server_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <div class="flex flex-wrap gap-2">
        <.action
          phx-click={Corex.RadioGroup.set_value("radio-group-api-server", "duis")}
          class="button button--sm"
        >
          Set Duis
        </.action>
        <.action
          phx-click={Corex.RadioGroup.set_value("radio-group-api-server", "donec")}
          class="button button--sm"
        >
          Set Donec
        </.action>
      </div>
      <.radio_group
        id="radio-group-api-server"
        name="rg-api-server"
        class="radio-group"
        value="lorem"
        items={items()}
      >
        <:label>Pick</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
    </div>
    """
  end

  def api_controlled_heex do
    ~S"""
    <.radio_group
      name="rg-api-controlled"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "radio_group_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.radio_group
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
      name="patterns-rg"
      class="radio-group"
      items={[
        %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
        %{value: "donec", label: "Donec condimentum ex mi"}
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
      {:ok, assign(socket, :value, "lorem")}
    end

    def handle_event("patterns_radio_value", %{"value" => v}, socket) do
      {:noreply, assign(socket, :value, v)}
    end
    """
  end

  def patterns_stream_demo_heex do
    ~S"""
    <div class="flex flex-col gap-3 w-full max-w-xl">
      <div class="flex flex-wrap gap-2">
        <.action phx-click="add_item" class="button button--sm button--accent">
          <.heroicon name="hero-plus" /> Add item
        </.action>
        <.action phx-click="reset" class="button button--sm button--alert">
          Reset
        </.action>
      </div>
      <.radio_group
        name="stream-rg"
        class="radio-group"
        items={@items_list}
        value={@stream_value}
        controlled
        on_value_change="patterns_stream_value"
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
    </div>
    """
  end

  def patterns_stream_elixir do
    ~S'''
    defmodule MyAppWeb.RadioGroupStreamDemoLive do
      use MyAppWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        initial = [
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]

        socket =
          socket
          |> stream_configure(:items, dom_id: &("radio-group:stream-radio-group:item:" <> &1.value))
          |> stream(:items, initial)
          |> assign(:items_list, initial)
          |> assign(:stream_value, "lorem")
          |> assign(:next_id, 1)

        {:ok, socket}
      end

      @impl true
      def handle_event("add_item", _params, socket) do
        id = "item-#{socket.assigns.next_id}"
        item = %{value: id, label: "Item #{socket.assigns.next_id}"}

        {:noreply,
         socket
         |> stream_insert(:items, item)
         |> assign(:items_list, socket.assigns.items_list ++ [item])
         |> assign(:next_id, socket.assigns.next_id + 1)}
      end

      @impl true
      def handle_event("reset", _params, socket) do
        initial = [
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]

        {:noreply,
         socket
         |> stream(:items, initial, reset: true)
         |> assign(:items_list, initial)
         |> assign(:stream_value, "lorem")
         |> assign(:next_id, 1)}
      end

      @impl true
      def handle_event("patterns_stream_value", %{"value" => v}, socket) do
        {:noreply, assign(socket, :stream_value, v)}
      end

      @impl true
      def render(assigns) do
        ~H"""
        <div class="flex flex-col gap-3 w-full max-w-xl">
          <div class="flex flex-wrap gap-2">
            <.action phx-click="add_item" class="button button--sm button--accent">
              <.heroicon name="hero-plus" /> Add item
            </.action>
            <.action phx-click="reset" class="button button--sm button--alert">
              Reset
            </.action>
          </div>
          <.radio_group
            id="stream-radio-group"
            name="stream-rg"
            class="radio-group"
            items={@items_list}
            value={@stream_value}
            controlled
            on_value_change="patterns_stream_value"
          >
            <:label>Choose one</:label>
            <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
          </.radio_group>
        </div>
        """
      end
    end
    '''
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

  def form_doc_controller_phoenix_heex do
    ~s"""
    <.form
      for={@form}
      action={~p"/radio-group/form"}
      method="post"
    >
      <.radio_group field={@form[:choice]} class="radio-group" items={Corex.List.new(#{@form_items_code})}>
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def radio_group_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"choice" => ""}, as: :radio_group_phoenix, id: "radio-group-form-phoenix")

      render(conn, :radio_group_form_page, phoenix_form: phoenix_form)
    end

    def radio_group_form_submit(conn, params) do
      if is_map(params["radio_group_phoenix"]) do
        choice = params["radio_group_phoenix"]["choice"] || ""

        conn
        |> put_flash(:info, "Submitted: choice=#{inspect(choice)}")
        |> redirect(to: ~p"/radio-group/form#radio-group-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~s"""
    <.form for={@form} phx-submit="save_phoenix">
      <.radio_group field={@form[:choice]} class="radio-group" items={Corex.List.new(#{@form_items_code})}>
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action="/account/choice"
      method="post"
    >
      <.radio_group
        field={@form[:choice]}
        class="radio-group"
        items={[
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action type="submit" class="button button--accent">
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
          |> redirect(to: "/account")

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
      for={@form}
      action="/account/choice"
      method="post"
    >
      <.radio_group
        field={@form[:choice]}
        class="radio-group"
        items={[
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action type="submit" class="button button--accent">
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
          |> redirect(to: "/account")

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
    ~s"""
    <form action={~p"/radio-group/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.radio_group
        name="user[choice]"
        class="radio-group"
        items={#{@form_items_code}}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
      <.action type="submit" class="button button--accent">Submit</.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def radio_group_form_submit(conn, %{"user" => %{"choice" => choice}}) do
      conn
      |> put_flash(:info, "Submitted: choice=#{inspect(choice)}")
      |> redirect(to: ~p"/radio-group/form#radio-group-form-native")
    end
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate"
      phx-submit="save"
    >
      <.radio_group
        field={@form[:choice]}
        class="radio-group"
        items={[
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]}
        on_value_change="choice_changed"
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action type="submit" class="button button--accent">
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
     
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <.radio_group
        field={@form[:choice]}
        class="radio-group"
        items={[
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]}
        on_value_change="choice_changed_strict"
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action type="submit" class="button button--accent">
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
    >
      <.radio_group field={f[:choice]} class="radio-group" items={items()}>
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action
        type="submit"
        id="radio-group-changeset-submit"
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
      :let={f}
      for={@form}
      action={~p"/radio-group/form"}
      method="post"
    >
      <.radio_group field={f[:choice]} class="radio-group" items={items()}>
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action
        type="submit"
        id="radio-group-validate-submit"
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
      action={~p"/radio-group/form"}
      method="post"
      id="radio-group-plain-form"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.radio_group
        name="user[choice]"
        id="radio-group-form-native-choice"
        class="radio-group"
        items={items()}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
      <.action type="submit" id="radio-group-controller-submit" class="button button--accent">
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
      phx-change="validate"
      phx-submit="save"
    >
      <.radio_group
        field={@form[:choice]}
        class="radio-group"
        items={items()}
        on_value_change="choice_changed"
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action type="submit" id="radio-group-form-live-submit" class="button button--accent">
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
      phx-change="validate"
      phx-submit="save"
    >
      <.radio_group
        field={@form[:choice]}
        class="radio-group"
        items={items()}
      >
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>

      <.action
        type="submit"
        id="radio-group-form-live-strict-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def styling_items, do: E2eWeb.Demos.DocExamples.radio_items()

  def styling_color_code do
    """
    <.radio_group name="rg-style-default" class="radio-group" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-accent" class="radio-group radio-group--accent" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-brand" class="radio-group radio-group--brand" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-alert" class="radio-group radio-group--alert" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-success" class="radio-group radio-group--success" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-info" class="radio-group radio-group--info" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.radio_group
      id="radio-group-style-color-default"
      name="rg-style-color-default"
      class="radio-group"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-color-accent"
      name="rg-style-color-accent"
      class="radio-group radio-group--accent"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-color-brand"
      name="rg-style-color-brand"
      class="radio-group radio-group--brand"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-color-alert"
      name="rg-style-color-alert"
      class="radio-group radio-group--alert"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-color-success"
      name="rg-style-color-success"
      class="radio-group radio-group--success"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-color-info"
      name="rg-style-color-info"
      class="radio-group radio-group--info"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def styling_size_code do
    """
    <.radio_group name="rg-style-sm" class="radio-group radio-group--sm" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-md" class="radio-group radio-group--md" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-lg" class="radio-group radio-group--lg" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-xl" class="radio-group radio-group--xl" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <.radio_group
      id="radio-group-style-sm"
      name="rg-style-sm"
      class="radio-group radio-group--sm"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-md"
      name="rg-style-md"
      class="radio-group radio-group--md"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-lg"
      name="rg-style-lg"
      class="radio-group radio-group--lg"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-xl"
      name="rg-style-xl"
      class="radio-group radio-group--xl"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  def styling_max_width_code do
    """
    <.radio_group name="rg-style-max-2xs" class="radio-group max-w-2xs" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-max-md" class="radio-group max-w-md" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-max-xl" class="radio-group max-w-xl" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    <.radio_group name="rg-style-max-2xl" class="radio-group max-w-2xl" value="lorem" #{@styling_items_heex}>
      #{@styling_item_control_heex}
    </.radio_group>
    """
  end

  def styling_max_width_example(assigns) do
    _ = assigns

    ~H"""
    <.radio_group
      id="radio-group-style-max-2xs"
      name="rg-style-max-2xs"
      class="radio-group max-w-2xs"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-max-md"
      name="rg-style-max-md"
      class="radio-group max-w-md"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-max-xl"
      name="rg-style-max-xl"
      class="radio-group max-w-xl"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    <.radio_group
      id="radio-group-style-max-2xl"
      name="rg-style-max-2xl"
      class="radio-group max-w-2xl"
      value="lorem"
      items={styling_items()}
    >
      <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
    </.radio_group>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/radio-group/form"}
      method="post"
    >
      <.radio_group field={f[:choice]} class="radio-group" items={items()}>
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
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
      <.radio_group field={@form[:choice]} class="radio-group" items={items()}>
        <:label>Choose one</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
      </.radio_group>
      <.action type="submit" id="radio-group-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.RadioGroupFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"choice" => ""}, as: :radio_group_phoenix, id: "radio-group-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"radio_group_phoenix" => params}, socket) do
        choice = params["choice"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"choice" => choice}, as: :radio_group_phoenix, id: "radio-group-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.RadioGroupFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.RadioChoiceForm{}
          |> MyApp.Forms.RadioChoiceForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :radio_group_ecto, id: "radio-group-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"radio_group_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.RadioChoiceForm{}
          |> MyApp.Forms.RadioChoiceForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :radio_group_ecto,
             id: "radio-group-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"radio_group_ecto" => params}, socket) do
        case MyApp.Forms.RadioChoiceForm.changeset_validate(%MyApp.Forms.RadioChoiceForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.RadioChoiceForm.changeset_validate(%MyApp.Forms.RadioChoiceForm{}, params),
                 as: :radio_group_ecto,
                 id: "radio-group-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :radio_group_ecto,
                 id: "radio-group-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end
end
