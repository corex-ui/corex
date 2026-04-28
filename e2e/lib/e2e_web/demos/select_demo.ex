defmodule E2eWeb.Demos.SelectDemo do
  use E2eWeb, :html

  defp items do
    Corex.List.new([
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"}
    ])
  end

  defp grouped_items do
    Corex.List.new([
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "South Korea", id: "kor", group: "Asia"}
    ])
  end

  defp items_extended do
    Corex.List.new([
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ])
  end

  def minimal_code do
    ~S"""
    <.select
      id="select-anatomy-minimal"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra"},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"}
      ])}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-minimal"
      class="select"
      items={items()}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def with_translation_code do
    ~S"""
    <.select
      id="select-anatomy-translation"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra"},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def with_translation_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-translation"
      class="select"
      items={items()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def item_indicator_code do
    ~S"""
    <.select
      id="select-anatomy-item-indicator"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra"},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"}
      ])}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.select>
    """
  end

  def item_indicator_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-item-indicator"
      class="select"
      items={items()}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.select>
    """
  end

  def grouped_code do
    ~S"""
    <.select
      id="select-anatomy-grouped"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra", group: "Europe"},
        %{label: "Belgium", id: "bel", group: "Europe"},
        %{label: "Germany", id: "deu", group: "Europe"},
        %{label: "Japan", id: "jpn", group: "Asia"},
        %{label: "China", id: "chn", group: "Asia"},
        %{label: "South Korea", id: "kor", group: "Asia"}
      ])}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def grouped_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-grouped"
      class="select"
      items={grouped_items()}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def extended_code do
    ~S"""
    <.select
      id="select-anatomy-extended"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra"},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"},
        %{label: "Netherlands", id: "nld"},
        %{label: "Switzerland", id: "che"},
        %{label: "Austria", id: "aut"}
      ])}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.select>
    """
  end

  def extended_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-extended"
      class="select"
      items={items_extended()}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.select>
    """
  end

  def extended_grouped_code do
    ~S"""
    <.select
      id="select-anatomy-extended-grouped"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra", group: "Europe"},
        %{label: "Belgium", id: "bel", group: "Europe"},
        %{label: "Germany", id: "deu", group: "Europe"},
        %{label: "Japan", id: "jpn", group: "Asia"},
        %{label: "China", id: "chn", group: "Asia"},
        %{label: "South Korea", id: "kor", group: "Asia"}
      ])}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.select>
    """
  end

  def extended_grouped_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-extended-grouped"
      class="select"
      items={grouped_items()}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
    </.select>
    """
  end

  def styling_color_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", id: "fra"}, %{label: "Belgium", id: "bel"}, %{label: "Germany", id: "deu"}])}|

    """
    <.select class="select" #{items_attr}>
      <:label>Default</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    <.select class="select select--accent" #{items_attr}>
      <:label>Accent</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    <.select class="select select--brand" #{items_attr}>
      <:label>Brand</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    <.select class="select select--alert" #{items_attr}>
      <:label>Alert</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    <.select class="select select--info" #{items_attr}>
      <:label>Info</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    <.select class="select select--success" #{items_attr}>
      <:label>Success</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.select
        id="select-style-color-default"
        class="select"
        items={items()}
      >
        <:label>Default</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
      <.select
        id="select-style-color-accent"
        class="select select--accent"
        items={items()}
      >
        <:label>Accent</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
      <.select
        id="select-style-color-brand"
        class="select select--brand"
        items={items()}
      >
        <:label>Brand</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
      <.select
        id="select-style-color-alert"
        class="select select--alert"
        items={items()}
      >
        <:label>Alert</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
      <.select
        id="select-style-color-info"
        class="select select--info"
        items={items()}
      >
        <:label>Info</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
      <.select
        id="select-style-color-success"
        class="select select--success"
        items={items()}
      >
        <:label>Success</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
    </div>
    """
  end

  def styling_size_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", id: "fra"}, %{label: "Belgium", id: "bel"}, %{label: "Germany", id: "deu"}])}|

    """
    <.select id="select-style-sm" class="select select--sm" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select id="select-style-lg" class="select select--lg" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.select
        id="select-style-sm"
        class="select select--sm"
        items={items()}
      >
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
      <.select
        id="select-style-lg"
        class="select select--lg"
        items={items()}
      >
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
    </div>
    """
  end

  defp select_items_attr do
    ~S|items={Corex.List.new([%{label: "France", id: "fra"}, %{label: "Belgium", id: "bel"}, %{label: "Germany", id: "deu"}])}|
  end

  def api_on_value_server_heex do
    items_attr = select_items_attr()

    """
    <.select
      id="select-api-on-server"
      class="select"
      #{items_attr}
      on_value_change="select_api_on_value_server"
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_on_value_server_elixir do
    ~S"""
    def handle_event("select_api_on_value_server", %{"id" => _id, "value" => _value}, socket) do
      {:noreply, socket}
    end
    """
  end

  def api_on_value_server_example(assigns) do
    ~H"""
    <.select
      id="select-api-on-server"
      class="select"
      items={items()}
      on_value_change="select_api_on_value_server"
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_on_value_client_heex do
    items_attr = select_items_attr()

    """
    <.select
      id="select-api-on-client"
      class="select"
      #{items_attr}
      on_value_change_client="select-api-on-client"
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_on_value_client_js do
    ~S"""
    const el = document.getElementById("select-api-on-client");
    el?.addEventListener("select-api-on-client", (event) => console.log(event.detail));
    """
  end

  def api_on_value_client_ts do
    ~S"""
    const el = document.getElementById("select-api-on-client");
    el?.addEventListener("select-api-on-client", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def api_on_value_client_example(assigns) do
    ~H"""
    <.select
      id="select-api-on-client"
      class="select"
      items={items()}
      on_value_change_client="select-api-on-client"
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_set_value_client_binding_heex do
    items_attr = select_items_attr()

    """
    <div class="layout__row">
      <.action phx-click={Corex.Select.set_value("select-api-cb", ["fra"])} class="button button--sm">
        France
      </.action>
      <.action phx-click={Corex.Select.set_value("select-api-cb", ["deu"])} class="button button--sm">
        Germany
      </.action>
      <.action phx-click={Corex.Select.set_open("select-api-cb", true)} class="button button--sm">
        Open
      </.action>
    </div>
    <.select
      id="select-api-cb"
      class="select"
      #{items_attr}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <.action
          phx-click={Corex.Select.set_value("select-api-cb", ["fra"])}
          class="button button--sm"
        >
          France
        </.action>
        <.action
          phx-click={Corex.Select.set_value("select-api-cb", ["deu"])}
          class="button button--sm"
        >
          Germany
        </.action>
        <.action phx-click={Corex.Select.set_open("select-api-cb", true)} class="button button--sm">
          Open
        </.action>
      </div>
      <.select
        id="select-api-cb"
        class="select"
        items={items()}
      >
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
    </div>
    """
  end

  def api_set_value_client_js_heex do
    items_attr = select_items_attr()

    """
    <div class="layout__row">
      <button
        type="button"
        class="button button--sm"
        id="select-api-cjs-dispatch"
        onclick="document.getElementById('select-api-cjs')?.dispatchEvent(new CustomEvent('corex:select:set-value', {bubbles: false, detail: { value: ['fra'] } }))"
      >
        Set France (client JS)
      </button>
    </div>
    <.select
      id="select-api-cjs"
      class="select"
      #{items_attr}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("select-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:select:set-value", { bubbles: false, detail: { value: ["fra"] } })
    );
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("select-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:select:set-value", { bubbles: false, detail: { value: ["fra"] } })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4" id="select-api-cjs-wrap">
      <div class="layout__row">
        <button
          type="button"
          class="button button--sm"
          id="select-api-cjs-dispatch"
          onclick="document.getElementById('select-api-cjs')?.dispatchEvent(new CustomEvent('corex:select:set-value', {bubbles: false, detail: { value: ['fra'] } }))"
        >
          Set France (client JS)
        </button>
      </div>
      <.select
        id="select-api-cjs"
        class="select"
        items={items()}
      >
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
    </div>
    """
  end

  def api_set_value_server_heex do
    items_attr = select_items_attr()

    """
    <div class="layout__row">
      <.action phx-click={JS.push("select_api_server_set", value: %{value: "fra"})} class="button button--sm">
        France
      </.action>
      <.action phx-click={JS.push("select_api_server_set", value: %{value: ""})} class="button button--sm">
        Clear
      </.action>
    </div>
    <.select
      id="select-api-srv"
      class="select"
      #{items_attr}
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("select_api_server_set", %{"value" => ""}, socket) do
      {:noreply, Corex.Select.set_value(socket, "select-api-srv", [])}
    end

    def handle_event("select_api_server_set", %{"value" => v}, socket) when is_binary(v) do
      {:noreply, Corex.Select.set_value(socket, "select-api-srv", [v])}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <.action
          phx-click={JS.push("select_api_server_set", value: %{value: "fra"})}
          class="button button--sm"
        >
          France
        </.action>
        <.action
          phx-click={JS.push("select_api_server_set", value: %{value: ""})}
          class="button button--sm"
        >
          Clear
        </.action>
      </div>
      <.select
        id="select-api-srv"
        class="select"
        items={items()}
      >
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.select>
    </div>
    """
  end

  def api_codes do
    %{
      on_value_server_heex: api_on_value_server_heex(),
      on_value_server_elixir: api_on_value_server_elixir(),
      on_value_client_heex: api_on_value_client_heex(),
      on_value_client_js: api_on_value_client_js(),
      on_value_client_ts: api_on_value_client_ts(),
      set_value_client_binding: api_set_value_client_binding_heex(),
      set_value_client_js_heex: api_set_value_client_js_heex(),
      set_value_client_js: api_set_value_client_js_js(),
      set_value_client_ts: api_set_value_client_js_ts(),
      set_value_server_heex: api_set_value_server_heex(),
      set_value_server_elixir: api_set_value_server_elixir()
    }
  end

  def api_overview_code, do: api_on_value_server_heex()
  def api_overview_example(assigns), do: api_on_value_server_example(assigns)

  def events_server_heex do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", id: "fra"}, %{label: "Belgium", id: "bel"}, %{label: "Germany", id: "deu"}])}|

    """
    <.select
      id="select-events-server"
      class="select"
      #{items_attr}
      on_value_change="select_changed"
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("select_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", id: "fra"}, %{label: "Belgium", id: "bel"}, %{label: "Germany", id: "deu"}])}|

    """
    <.select
      id="select-events-client"
      class="select"
      #{items_attr}
      on_value_change_client="select-changed"
    >
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("select-events-client");
    el?.addEventListener("select-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("select-events-client");
    el?.addEventListener("select-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code, do: form_changeset_heex()

  def form_country_items do
    Corex.List.new([
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ])
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.CountryForm do
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

  def form_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/select/form"}
      method="post"
      id={@form.id}
    >
      <.select
        field={f[:country]}
        class="select"
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
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
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :select_changeset, id: "select-changeset-form")

      render(conn, :form_page, form: form)
    end
    """
  end

  def form_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/select/form"}
      method="post"
      id={@form.id}
    >
      <.select
        field={f[:country]}
        class="select"
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={Corex.List.new([
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ])}
      >
        <:label>Country (stricter messages)</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-validate-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    def form_page(conn, _params) do
      form =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :select_validate, id: "select-validate-form")

      render(conn, :form_page, form: form)
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form
      action={~p"/select/form"}
      method="post"
      id="select-plain-form"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <label class="w-full typo-label" for="select-native-country">Country</label>
      <select
        name="user[country]"
        id="select-native-country"
        class="native-input w-full"
      >
        <option value="">Select a country</option>
        <option value="fra">France</option>
        <option value="bel">Belgium</option>
        <option value="deu">Germany</option>
      </select>
      <.action type="submit" id="select-controller-submit" class="button button--accent w-full">
        Submit
      </.action>
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
      <.select
        id="select-form-live-country"
        class="select"
        field={@form[:country]}
        items={Corex.List.new([
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ])}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed"
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-form-live-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
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
      <.select
        id="select-form-live-strict"
        class="select"
        field={@form[:country]}
        items={Corex.List.new([
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ])}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed_strict"
      >
        <:label>Country (stricter)</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-form-live-strict-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :select_form, id: "select-form")

      {:ok, assign(socket, :form, form)}
    end

    def handle_event("select_country_changed", %{"value" => value}, socket) do
      country = List.first(value) || ""
      params = %{"country" => country}

      changeset =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :select_form,
           id: "select-form"
         )
       )}
    end

    def handle_event("validate", %{"select_form" => params}, socket) do
      changeset =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :select_form,
           id: "select-form"
         )
       )}
    end

    def handle_event("save", %{"select_form" => params}, socket) do
      case MyApp.Forms.CountryForm.changeset(%MyApp.Forms.CountryForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, assign(socket, :form, Phoenix.Component.to_form(
            MyApp.Forms.CountryForm.changeset(%MyApp.Forms.CountryForm{}, %{}),
            as: :select_form, id: "select-form"
          ))}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(
             socket,
             :form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :select_form, id: "select-form")
           )}
      end
    end
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset_validate(%{})
        |> Phoenix.Component.to_form(as: :select_strict, id: "select-strict-form-live")

      {:ok, assign(socket, :strict_form, form)}
    end

    def handle_event("select_country_changed_strict", %{"value" => value}, socket) do
      country = List.first(value) || ""
      params = %{"country" => country}

      changeset =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :strict_form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :select_strict,
           id: "select-strict-form-live"
         )
       )}
    end

    def handle_event("validate_strict", %{"select_strict" => params}, socket) do
      changeset =
        %MyApp.Forms.CountryForm{}
        |> MyApp.Forms.CountryForm.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :strict_form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :select_strict,
           id: "select-strict-form-live"
         )
       )}
    end

    def handle_event("save_strict", %{"select_strict" => params}, socket) do
      case MyApp.Forms.CountryForm.changeset_validate(%MyApp.Forms.CountryForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(
               MyApp.Forms.CountryForm.changeset_validate(%MyApp.Forms.CountryForm{}, %{}),
               as: :select_strict,
               id: "select-strict-form-live"
             )
           )}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :select_strict, id: "select-strict-form-live")
           )}
      end
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/select/form"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
      id={@form.id}
    >
      <.select
        field={f[:country]}
        class="select"
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={form_country_items()}
        invalid={f[:country].errors != []}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-changeset-submit" class="button button--accent w-full">
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
      action={~p"/select/form"}
      method="post"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
      id={@form.id}
    >
      <.select
        field={f[:country]}
        class="select"
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={form_country_items()}
        invalid={f[:country].errors != []}
      >
        <:label>Country (stricter messages)</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-validate-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/select/form"}
      method="post"
      id="select-plain-form"
      class="w-full max-w-2xs flex flex-col gap-space items-center"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <label class="w-full typo-label" for="select-native-country">Country</label>
      <select
        name="user[country]"
        id="select-native-country"
        class="native-input w-full"
      >
        <option value="">Select a country</option>
        <option value="fra">France</option>
        <option value="bel">Belgium</option>
        <option value="deu">Germany</option>
      </select>
      <.action type="submit" id="select-controller-submit" class="button button--accent w-full">
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
      <.select
        id="select-form-live-country"
        class="select"
        field={@form[:country]}
        items={form_country_items()}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed"
        invalid={@form[:country].errors != []}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-form-live-submit" class="button button--accent w-full">
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
      <.select
        id="select-form-live-strict"
        class="select"
        field={@form[:country]}
        items={form_country_items()}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed_strict"
        invalid={@form[:country].errors != []}
      >
        <:label>Country (stricter)</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-form-live-strict-submit" class="button button--accent w-full">
        Submit
      </.action>
    </.form>
    """
  end

  def patterns_items_flat do
    Corex.List.new([
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ])
  end

  def patterns_items_grouped do
    Corex.List.new([
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "South Korea", id: "kor", group: "Asia"},
      %{label: "Thailand", id: "tha", group: "Asia"},
      %{label: "USA", id: "usa", group: "North America"},
      %{label: "Canada", id: "can", group: "North America"},
      %{label: "Mexico", id: "mex", group: "North America"}
    ])
  end

  def patterns_controlled_heex do
    ~S"""
    <.select
      id="select-patterns-controlled"
      class="select"
      controlled
      value={@value}
      items={@items}
      on_value_change="value_changed"
    >
      <:label>Country</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
    </.select>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      items =
        Corex.List.new([
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ])

      {:ok, assign(socket, value: [], items: items)}
    end

    def handle_event("value_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :value, value)}
    end
    """
  end

  def patterns_flat_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-flat"
      class="select"
      items={patterns_items_flat()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
    </.select>
    """
  end

  def patterns_grouped_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-grouped"
      class="select"
      items={patterns_items_grouped()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
    </.select>
    """
  end

  def patterns_extended_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-extended"
      class="select"
      items={patterns_items_flat()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" class="icon" />
      </:item_indicator>
    </.select>
    """
  end

  def patterns_extended_grouped_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-extended-grouped"
      class="select"
      items={patterns_items_grouped()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" class="icon" />
      </:item_indicator>
    </.select>
    """
  end

  def patterns_flat_code do
    ~S"""
    <.select
      id="select-patterns-flat"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra"},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"},
        %{label: "Netherlands", id: "nld"},
        %{label: "Switzerland", id: "che"},
        %{label: "Austria", id: "aut"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
    </.select>
    """
  end

  def patterns_grouped_code do
    ~S"""
    <.select
      id="select-patterns-grouped"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra", group: "Europe"},
        %{label: "Belgium", id: "bel", group: "Europe"},
        %{label: "Germany", id: "deu", group: "Europe"},
        %{label: "Japan", id: "jpn", group: "Asia"},
        %{label: "China", id: "chn", group: "Asia"},
        %{label: "South Korea", id: "kor", group: "Asia"},
        %{label: "Thailand", id: "tha", group: "Asia"},
        %{label: "USA", id: "usa", group: "North America"},
        %{label: "Canada", id: "can", group: "North America"},
        %{label: "Mexico", id: "mex", group: "North America"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
    </.select>
    """
  end

  def patterns_extended_code do
    ~S"""
    <.select
      id="select-patterns-extended"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra"},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"},
        %{label: "Netherlands", id: "nld"},
        %{label: "Switzerland", id: "che"},
        %{label: "Austria", id: "aut"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" class="icon" />
      </:item_indicator>
    </.select>
    """
  end

  def patterns_extended_grouped_code do
    ~S"""
    <.select
      id="select-patterns-extended-grouped"
      class="select"
      items={Corex.List.new([
        %{label: "France", id: "fra", group: "Europe"},
        %{label: "Belgium", id: "bel", group: "Europe"},
        %{label: "Germany", id: "deu", group: "Europe"},
        %{label: "Japan", id: "jpn", group: "Asia"},
        %{label: "China", id: "chn", group: "Asia"},
        %{label: "South Korea", id: "kor", group: "Asia"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.id)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" class="icon" />
      </:item_indicator>
    </.select>
    """
  end
end
