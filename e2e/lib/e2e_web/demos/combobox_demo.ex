defmodule E2eWeb.Demos.ComboboxDemo do
  use E2eWeb, :html

  def items_minimal do
    [
      %{label: "France", id: "fra", disabled: true},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ]
  end

  def minimal_code do
    ~S"""
    <.combobox
      id="combobox-anatomy-minimal"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new([
        %{label: "France", id: "fra", disabled: true},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"},
        %{label: "Netherlands", id: "nld"},
        %{label: "Switzerland", id: "che"},
        %{label: "Austria", id: "aut"}
      ])}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-minimal"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def slots_code do
    ~S"""
    <.combobox
      id="combobox-anatomy-slots"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new([
        %{label: "France", id: "fra", disabled: true},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"},
        %{label: "Netherlands", id: "nld"},
        %{label: "Switzerland", id: "che"},
        %{label: "Austria", id: "aut"}
      ])}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.combobox>
    """
  end

  def slots_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-slots"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.combobox>
    """
  end

  def grouped_code do
    ~S"""
    <.combobox
      id="combobox-anatomy-grouped"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new([
        %{label: "France", id: "fra", group: "Europe"},
        %{label: "Belgium", id: "bel", group: "Europe"},
        %{label: "Germany", id: "deu", group: "Europe"},
        %{label: "Japan", id: "jpn", group: "Asia"},
        %{label: "China", id: "chn", group: "Asia"}
      ])}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def grouped_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-grouped"
      class="combobox"
      placeholder="Select a country"
      items={
        Corex.List.new([
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"}
        ])
      }
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.combobox>
    """
  end

  def extended_code do
    ~S"""
    <.combobox id="combobox-anatomy-extended" class="combobox" placeholder="Select" items={Corex.List.new(items_minimal())}>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.combobox>
    """
  end

  def extended_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-extended"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new(items_minimal())}
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.combobox>
    """
  end

  def extended_grouped_code do
    ~S"""
    <.combobox
      id="combobox-anatomy-extended-grouped"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new([
        %{label: "France", id: "fra", group: "Europe"},
        %{label: "Belgium", id: "bel", group: "Europe"},
        %{label: "Japan", id: "jpn", group: "Asia"}
      ])}
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.combobox>
    """
  end

  def extended_grouped_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-extended-grouped"
      class="combobox"
      placeholder="Select a country"
      items={
        Corex.List.new([
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"}
        ])
      }
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.combobox>
    """
  end

  def labeled_code do
    ~S"""
    <.combobox
      id="combobox-anatomy-labeled"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.combobox>
    """
  end

  def labeled_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-labeled"
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.combobox>
    """
  end

  def styling_size_code do
    ~S"""
    <.combobox id="combobox-style-sm" class="combobox combobox--sm" placeholder="SM" items={Corex.List.new(items_minimal())}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox id="combobox-style-lg" class="combobox combobox--lg" placeholder="LG" items={Corex.List.new(items_minimal())}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.combobox
        id="combobox-style-sm"
        class="combobox combobox--sm"
        placeholder="SM"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-lg"
        class="combobox combobox--lg"
        placeholder="LG"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
    </div>
    """
  end

  def api_overview_code do
    ~S"""
    <.combobox id="combobox-api" class="combobox" placeholder="Select a country" items={Corex.List.new(items_minimal())}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def api_overview_example(assigns) do
    ~H"""
    <.combobox
      id={@id}
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.combobox>
    """
  end

  def events_server_heex do
    ~S"""
    <.combobox
      id="combobox-events-server-field"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new(items_minimal())}
      on_value_change="combobox_changed"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("combobox_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.combobox
      id="combobox-events-client-field"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new(items_minimal())}
      on_value_change_client="combobox-changed"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("combobox-events-client-field");
    el?.addEventListener("combobox-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("combobox-events-client-field");
    el?.addEventListener("combobox-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      id={@form.id}
    >
      <.combobox
        field={f[:airport]}
        class="combobox"
        placeholder="Select a country"
        items={Corex.List.new([
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ])}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.heroicon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.heroicon name="hero-check" />
        </:item_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" id="combobox-form-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Combobox.set_value("combobox-api-sv-client", ["bel"])}>Belgium</.action>
    <.action phx-click={Corex.Combobox.set_value("combobox-api-sv-client", [])}>Clear</.action>
    <.combobox
      id="combobox-api-sv-client"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="combobox_api_set_value">Belgium</.action>
    <.combobox
      id="combobox-api-sv-server"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("combobox_api_set_value", _params, socket) do
      {:noreply, Corex.Combobox.set_value(socket, "combobox-api-sv-server", ["bel"])}
    end
    """
  end

  def api_set_value_client_js do
    ~S"""
    const el = document.getElementById("combobox-api-sv-js");
    el?.dispatchEvent(
      new CustomEvent("corex:combobox:set-value", {
        bubbles: false,
        detail: { value: ["deu"] },
      })
    );
    """
  end

  def events_open_server_heex do
    ~S"""
    <.combobox
      id="combobox-events-open-server-field"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new(items_minimal())}
      on_open_change="combobox_open_changed"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_open_server_elixir do
    ~S"""
    def handle_event("combobox_open_changed", params, socket) do
      {:noreply, assign(socket, :last_open_event, params)}
    end
    """
  end

  def events_open_client_heex do
    ~S"""
    <.combobox
      id="combobox-events-open-client-field"
      class="combobox"
      placeholder="Select"
      items={Corex.List.new(items_minimal())}
      on_open_change_client="combobox-open-changed"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_open_client_js do
    ~S"""
    const el = document.getElementById("combobox-events-open-client-field");
    el?.addEventListener("combobox-open-changed", (event) => console.log(event.detail));
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.Travel do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :airport, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:airport])
        |> validate_required([:airport])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:airport])
        |> validate_required([:airport], message: "can't be blank")
      end
    end
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox field={f[:airport]} class="combobox" placeholder="Country" items={Corex.List.new(items_minimal())}>
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def combobox_form_page(conn, _params) do
      changeset = MyApp.Forms.Travel.changeset(%MyApp.Forms.Travel{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :combobox_changeset,
          id: "combobox-changeset-form"
        )

      render(conn, :combobox_form_page, form: form)
    end
    """
  end

  def form_doc_controller_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox field={f[:airport]} class="combobox" placeholder="Country" items={Corex.List.new(items_minimal())}>
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def combobox_form_page(conn, _params) do
      changeset = MyApp.Forms.Travel.changeset_validate(%MyApp.Forms.Travel{}, %{})

      validate_form =
        Phoenix.Component.to_form(changeset,
          as: :combobox_validate,
          id: "combobox-validate-form"
        )

      render(conn, :combobox_form_page, validate_form: validate_form)
    end
    """
  end

  def form_doc_controller_native_heex do
    ~S"""
    <form action={~p"/combobox/form"} method="post" class="w-full max-w-2xs flex flex-col gap-space items-center">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <input name="combobox_native[airport]" type="hidden" value="" />
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
      <.combobox
        field={@form[:airport]}
        id="combobox-live-airport"
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
        on_value_change="airport_sync"
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("validate", %{"combobox" => params}, socket) do
      airport = params["airport"] || socket.assigns[:airport_field] || ""
      params = Map.put(params, "airport", airport)

      changeset =
        %MyApp.Forms.Travel{}
        |> MyApp.Forms.Travel.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :validate, as: :combobox)))}
    end

    def handle_event("airport_sync", %{"value" => value}, socket) do
      v = List.wrap(value) |> List.first() || ""
      {:noreply, assign(socket, :airport_field, to_string(v))}
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@strict_form}
      id={@strict_form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox
        field={@strict_form[:airport]}
        id="combobox-live-airport-strict"
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
        on_value_change="airport_sync_strict"
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def handle_event("validate_strict", %{"combobox_strict" => params}, socket) do
      airport = params["airport"] || socket.assigns[:airport_field_strict] || ""
      params = Map.put(params, "airport", airport)

      changeset =
        %MyApp.Forms.Travel{}
        |> MyApp.Forms.Travel.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :strict_form,
         Phoenix.Component.to_form(changeset, action: :validate, as: :combobox_strict)
       )}
    end

    def handle_event("airport_sync_strict", %{"value" => value}, socket) do
      v = List.wrap(value) |> List.first() || ""
      {:noreply, assign(socket, :airport_field_strict, to_string(v))}
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      id={@form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox
        field={f[:airport]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" id="combobox-form-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:validate_form, :any, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@validate_form}
      action={~p"/combobox/form"}
      method="post"
      id={@validate_form.id}
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox
        field={f[:airport]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" id="combobox-validate-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/combobox/form"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.combobox
        id="combobox-native-form-preview"
        name="combobox_native[airport]"
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </form>
    """
  end

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox
        field={@form[:airport]}
        id="airport-combobox"
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
        on_value_change="airport_sync"
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" id="combobox-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:strict_form, :any, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@strict_form}
      id={@strict_form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <.combobox
        field={@strict_form[:airport]}
        id="combobox-live-airport-strict-preview"
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
        on_value_change="airport_sync_strict"
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent w-full">Submit</.action>
    </.form>
    """
  end

  def styling_color_code do
    ~S"""
    <.combobox id="combobox-style-accent" class="combobox combobox--accent" placeholder="Accent" items={Corex.List.new(items_minimal())}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-style-accent"
      class="combobox combobox--accent"
      placeholder="Accent"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.combobox>
    """
  end

  def styling_max_width_code do
    ~S"""
    <.combobox id="combobox-style-wide" class="combobox max-w-md" placeholder="Wide" items={Corex.List.new(items_minimal())}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_max_width_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-style-wide"
      class="combobox max-w-md"
      placeholder="Wide"
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.combobox>
    """
  end
end
