defmodule E2eWeb.Demos.ComboboxDemo do
  use E2eWeb, :html

  def items_minimal do
    [
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ]
  end

  def minimal_code do
    ~S"""
    <.combobox
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
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
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
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
      class="combobox"
      placeholder="Select a country"
      items={Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Germany", value: "deu", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"},
        %{label: "China", value: "chn", group: "Asia"}
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
          %{label: "France", value: "fra", group: "Europe"},
          %{label: "Belgium", value: "bel", group: "Europe"},
          %{label: "Germany", value: "deu", group: "Europe"},
          %{label: "Japan", value: "jpn", group: "Asia"},
          %{label: "China", value: "chn", group: "Asia"}
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
    <.combobox class="combobox" placeholder="Select" items={Corex.List.new(items_minimal())}>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
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
        <Flagpack.flag name={String.to_atom(item.value)} />
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
      class="combobox"
      placeholder="Select"
      items={Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"}
      ])}
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
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
          %{label: "France", value: "fra", group: "Europe"},
          %{label: "Belgium", value: "bel", group: "Europe"},
          %{label: "Japan", value: "jpn", group: "Asia"}
        ])
      }
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
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
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox combobox--sm" placeholder="SM" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--md" placeholder="MD" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--lg" placeholder="LG" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--xl" placeholder="XL" #{items_attr}>
      <:empty>No results</:empty>
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
        id="combobox-style-md"
        class="combobox combobox--md"
        placeholder="MD"
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
      <.combobox
        id="combobox-style-xl"
        class="combobox combobox--xl"
        placeholder="XL"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.combobox
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "combobox_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
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
        field={f[:country]}
        class="combobox"
        placeholder="Select a country"
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
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
      <.action type="submit" class="button button--accent">
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
    <.action phx-click="combobox_api_clear">Clear</.action>
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

    def handle_event("combobox_api_clear", _params, socket) do
      {:noreply, Corex.Combobox.set_value(socket, "combobox-api-sv-server", [])}
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

    el?.dispatchEvent(
      new CustomEvent("corex:combobox:set-value", {
        bubbles: false,
        detail: { value: [] },
      })
    );
    """
  end

  def events_open_server_heex do
    ~S"""
    <.combobox
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
    E2eWeb.Demos.DocExamples.event_handler_snippet("combobox_open_changed")
  end

  def events_open_client_heex do
    ~S"""
    <.combobox
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
        field :country, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:country])
        |> validate_required([:country])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:country])
        |> validate_required([:country], message: "can't be blank")
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      :let={f}
      for={@phoenix_form}
      action={~p"/combobox/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.combobox field={f[:country]} class="combobox" placeholder="Country" items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}>
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def combobox_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"country" => ""}, as: :combobox_phoenix, id: "combobox-form-phoenix")

      render(conn, :combobox_form_page, phoenix_form: phoenix_form)
    end

    def combobox_form_submit(conn, params) do
      if is_map(params["combobox_phoenix"]) do
        country = params["combobox_phoenix"]["country"] || ""

        conn
        |> put_flash(:info, "Submitted: country=#{inspect(country)}")
        |> redirect(to: ~p"/combobox/form#combobox-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.combobox
        field={@phoenix_form[:country]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.action type="submit" id="combobox-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
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
    >
      <.combobox field={f[:country]} class="combobox" placeholder="Country" items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}>
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
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
    >
      <.combobox field={f[:country]} class="combobox" placeholder="Country" items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}>
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
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
    <form action={~p"/combobox/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <input name="combobox_native[country]" type="hidden" value="" />
      <.action type="submit" class="button button--accent">Submit</.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def combobox_form_submit(conn, %{"combobox_native" => %{"country" => country}}) do
      conn
      |> put_flash(:info, "Submitted: country=#{inspect(country)}")
      |> redirect(to: ~p"/combobox/form#combobox-form-native")
    end
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
    >
      <.combobox
        field={@form[:country]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("validate", %{"combobox" => params}, socket) do
      changeset =
        %MyApp.Forms.Travel{}
        |> MyApp.Forms.Travel.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :validate, as: :combobox)))}
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
    >
      <.combobox
        field={@strict_form[:country]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def handle_event("validate_strict", %{"combobox_strict" => params}, socket) do
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
    >
      <.combobox
        field={f[:country]}
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
      <.action type="submit" id="combobox-form-submit" class="button button--accent">
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
    >
      <.combobox
        field={f[:country]}
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
      <.action type="submit" id="combobox-validate-submit" class="button button--accent">
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
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.combobox
        id="combobox-native-form-preview"
        name="combobox_native[country]"
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
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
    >
      <.combobox
        field={@form[:country]}
        id="country-combobox"
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
      <.action type="submit" id="combobox-form-live-submit" class="button button--accent">
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
      phx-change="validate"
      phx-submit="save"
    >
      <.combobox
        field={@form[:country]}
        id="combobox-live-country-strict-preview"
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
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def styling_color_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox" placeholder="Default" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--accent" placeholder="Accent" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--brand" placeholder="Brand" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--alert" placeholder="Alert" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--info" placeholder="Info" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox combobox--success" placeholder="Success" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.combobox
        id="combobox-style-color-default"
        class="combobox"
        placeholder="Default"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-accent"
        class="combobox combobox--accent"
        placeholder="Accent"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-brand"
        class="combobox combobox--brand"
        placeholder="Brand"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-alert"
        class="combobox combobox--alert"
        placeholder="Alert"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-info"
        class="combobox combobox--info"
        placeholder="Info"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-success"
        class="combobox combobox--success"
        placeholder="Success"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
    </div>
    """
  end

  def styling_max_width_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox max-w-2xs" placeholder="2xs" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox max-w-md" placeholder="MD" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox max-w-xl" placeholder="XL" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox max-w-2xl" placeholder="2XL" #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_max_width_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full items-start">
      <.combobox
        id="combobox-style-max-2xs"
        class="combobox max-w-2xs"
        placeholder="2xs"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-max-md"
        class="combobox max-w-md"
        placeholder="MD"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-max-xl"
        class="combobox max-w-xl"
        placeholder="XL"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-max-2xl"
        class="combobox max-w-2xl"
        placeholder="2XL"
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
    </div>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      id={@form.id}
    >
      <.combobox
        field={f[:country]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      id={@form.id}
    >
      <.combobox
        field={f[:country]}
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
      <.action type="submit" id="combobox-form-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_doc_controller_validate_heex()
  def form_ecto_elixir, do: form_doc_controller_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.combobox
        field={@form[:country]}
        class="combobox"
        placeholder="Country"
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.action type="submit" id="combobox-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.ComboboxFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"country" => ""}, as: :combobox_phoenix, id: "combobox-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"combobox_phoenix" => params}, socket) do
        country = params["country"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"country" => country}, as: :combobox_phoenix, id: "combobox-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.ComboboxFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.Travel{}
          |> MyApp.Forms.Travel.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :combobox_ecto, id: "combobox-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"combobox_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.Travel{}
          |> MyApp.Forms.Travel.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :combobox_ecto,
             id: "combobox-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"combobox_ecto" => params}, socket) do
        case MyApp.Forms.Travel.changeset_validate(%MyApp.Forms.Travel{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Travel.changeset_validate(%MyApp.Forms.Travel{}, params),
                 as: :combobox_ecto,
                 id: "combobox-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :combobox_ecto,
                 id: "combobox-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end
end
