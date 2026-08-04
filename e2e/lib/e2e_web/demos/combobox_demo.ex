defmodule E2eWeb.Demos.ComboboxDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.combobox>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-minimal"
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
      items={Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Germany", value: "deu", group: "Europe"},
        %{label: "Netherlands", value: "nld", group: "Europe"},
        %{label: "Switzerland", value: "che", group: "Europe"},
        %{label: "Austria", value: "aut", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"},
        %{label: "China", value: "chn", group: "Asia"},
        %{label: "South Korea", value: "kor", group: "Asia"},
        %{label: "Thailand", value: "tha", group: "Asia"},
        %{label: "USA", value: "usa", group: "North America"},
        %{label: "Canada", value: "can", group: "North America"},
        %{label: "Mexico", value: "mex", group: "North America"}
      ])}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.combobox>
    """
  end

  def grouped_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-grouped"
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
    <.combobox
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:clear_trigger>
        <.heroicon name="hero-backspace" />
      </:clear_trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.combobox>
    """
  end

  def extended_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-extended"
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
      items={Corex.List.new(items_minimal())}
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
      items={Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Germany", value: "deu", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"},
        %{label: "China", value: "chn", group: "Asia"},
        %{label: "South Korea", value: "kor", group: "Asia"}
      ])}
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:clear_trigger>
        <.heroicon name="hero-backspace" />
      </:clear_trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.combobox>
    """
  end

  def extended_grouped_example(assigns) do
    ~H"""
    <.combobox
      id="combobox-anatomy-extended-grouped"
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
      items={
        Corex.List.new([
          %{label: "France", value: "fra", group: "Europe"},
          %{label: "Belgium", value: "bel", group: "Europe"},
          %{label: "Japan", value: "jpn", group: "Asia"}
        ])
      }
    >
      <:item :let={item}>
        <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
    <.combobox class="combobox ui-size-sm" translation={%Corex.Combobox.Translation{placeholder: "SM", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-size-md" translation={%Corex.Combobox.Translation{placeholder: "MD", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-size-lg" translation={%Corex.Combobox.Translation{placeholder: "LG", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-size-xl" translation={%Corex.Combobox.Translation{placeholder: "XL", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-space-lg w-full max-w-md">
      <.combobox
        id="combobox-style-sm"
        class="combobox ui-size-sm"
        translation={%Corex.Combobox.Translation{placeholder: "SM", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-md"
        class="combobox ui-size-md"
        translation={%Corex.Combobox.Translation{placeholder: "MD", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-lg"
        class="combobox ui-size-lg"
        translation={%Corex.Combobox.Translation{placeholder: "LG", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-xl"
        class="combobox ui-size-xl"
        translation={%Corex.Combobox.Translation{placeholder: "XL", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
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
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
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
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={@form[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
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
      <.action type="submit" class="button ui-accent">
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
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
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
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
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
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
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

  def events_input_server_heex do
    ~S"""
    <.combobox
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
      filter={false}
      items={Corex.List.new(items_minimal())}
      on_input_value_change="combobox_input_changed"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_input_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet("combobox_input_changed")
  end

  def events_highlight_server_heex do
    ~S"""
    <.combobox
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
      items={Corex.List.new(items_minimal())}
      on_highlight_change="combobox_highlight_changed"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_highlight_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet("combobox_highlight_changed")
  end

  def events_select_server_heex do
    ~S"""
    <.combobox
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Select", empty: "No results"}}
      items={Corex.List.new(items_minimal())}
      on_select="combobox_selected"
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def events_select_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet("combobox_selected")
  end

  def api_set_open_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Combobox.set_open("combobox-api-open-client", true)}>Open</.action>
    <.action phx-click={Corex.Combobox.set_open("combobox-api-open-client", false)}>Close</.action>
    <.combobox id="combobox-api-open-client" class="combobox" items={Corex.List.new(items_minimal())}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def api_set_open_server_heex do
    ~S"""
    <.action phx-click="combobox_api_open">Open</.action>
    <.action phx-click="combobox_api_close">Close</.action>
    <.combobox id="combobox-api-open-server" class="combobox" items={Corex.List.new(items_minimal())}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def api_set_open_server_elixir do
    ~S"""
    def handle_event("combobox_api_open", _, socket) do
      {:noreply, Corex.Combobox.set_open(socket, "combobox-api-open-server", true)}
    end

    def handle_event("combobox_api_close", _, socket) do
      {:noreply, Corex.Combobox.set_open(socket, "combobox-api-open-server", false)}
    end
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
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox field={@form[:country]} class="combobox" translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}} items={Corex.List.new([
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
      <.action type="submit" class="button ui-accent">Submit</.action>
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
    <.form for={@form} phx-submit="save_phoenix"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={@form[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
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
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox field={@form[:country]} class="combobox" translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}} items={Corex.List.new([
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
      <.action type="submit" class="button ui-accent">Submit</.action>
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
      for={@form}
      action={~p"/combobox/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox field={@form[:country]} class="combobox" translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}} items={Corex.List.new([
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
      <.action type="submit" class="button ui-accent">Submit</.action>
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
    <form action={~p"/combobox/form"} method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.combobox
        name="combobox_native[country]"
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"}
        ])}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.action type="submit" class="button ui-accent">Submit</.action>
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
     
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={@form[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
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
      <.action type="submit" class="button ui-accent">Submit</.action>
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
     
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={@strict_form[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        clear_on_empty={true}
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
        <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button ui-accent">Submit</.action>
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
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={f[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
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
      <.action type="submit" id="combobox-form-submit" class="button ui-accent">
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
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={f[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
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
      <.action type="submit" id="combobox-validate-submit" class="button ui-accent">
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
      class="flex flex-col gap-space-lg w-full max-w-xl"
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
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={@form[:country]}
        id="country-combobox"
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
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
      <.action type="submit" id="combobox-form-live-submit" class="button ui-accent">
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
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={@form[:country]}
        id="combobox-live-country-strict-preview"
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        clear_on_empty={true}
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        <:clear_trigger><.heroicon name="hero-backspace" class="icon" /></:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def styling_canonical_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox" translation={%Corex.Combobox.Translation{placeholder: "Subtle (default)", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_canonical_example(assigns) do
    _ = assigns

    ~H"""
    <.combobox
      id="combobox-style-canonical"
      class="combobox"
      translation={%Corex.Combobox.Translation{placeholder: "Subtle (default)", empty: "No results"}}
      items={Corex.List.new(items_minimal())}
    >
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.combobox>
    """
  end

  def styling_color_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox" translation={%Corex.Combobox.Translation{placeholder: "Default", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-accent" translation={%Corex.Combobox.Translation{placeholder: "Accent", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-brand" translation={%Corex.Combobox.Translation{placeholder: "Brand", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-alert" translation={%Corex.Combobox.Translation{placeholder: "Alert", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-info" translation={%Corex.Combobox.Translation{placeholder: "Info", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-success" translation={%Corex.Combobox.Translation{placeholder: "Success", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-xl items-start w-full max-w-4xl">
      <.combobox
        id="combobox-style-color-default"
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Default", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-accent"
        class="combobox ui-accent"
        translation={%Corex.Combobox.Translation{placeholder: "Accent", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-brand"
        class="combobox ui-brand"
        translation={%Corex.Combobox.Translation{placeholder: "Brand", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-alert"
        class="combobox ui-alert"
        translation={%Corex.Combobox.Translation{placeholder: "Alert", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-info"
        class="combobox ui-info"
        translation={%Corex.Combobox.Translation{placeholder: "Info", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-color-success"
        class="combobox ui-success"
        translation={%Corex.Combobox.Translation{placeholder: "Success", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
    </div>
    """
  end

  def styling_variant_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox" translation={%Corex.Combobox.Translation{placeholder: "Subtle (default)", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-solid" translation={%Corex.Combobox.Translation{placeholder: "Solid", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-ghost" translation={%Corex.Combobox.Translation{placeholder: "Ghost", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-xl items-start w-full max-w-4xl">
      <.combobox
        id="combobox-style-variant-subtle"
        class="combobox"
        translation={
          %Corex.Combobox.Translation{placeholder: "Subtle (default)", empty: "No results"}
        }
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-variant-solid"
        class="combobox ui-solid"
        translation={%Corex.Combobox.Translation{placeholder: "Solid", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-variant-ghost"
        class="combobox ui-ghost"
        translation={%Corex.Combobox.Translation{placeholder: "Ghost", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
    </div>
    """
  end

  def styling_variant_matrix_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    for semantic <- DemoScales.styling_semantic_axis_steps("combobox"),
        variant <- DemoScales.styling_variant_axis_steps("combobox") do
      class = DemoScales.join_matrix_modifiers("combobox", semantic.modifier, variant.modifier)

      """
      <.combobox class="#{class}" translation={%Corex.Combobox.Translation{placeholder: "#{semantic.label}", empty: "No results"}} #{items_attr}>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("combobox"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("combobox"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.combobox
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"combobox-matrix-#{semantic_index}-#{variant_index}"}
            class={DemoScales.join_matrix_modifiers("combobox", semantic.modifier, variant.modifier)}
            translation={
              %Corex.Combobox.Translation{placeholder: semantic.label, empty: "No results"}
            }
            items={Corex.List.new(items_minimal())}
          >
            <:empty>No results</:empty>
            <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
          </.combobox>
        </div>
      </div>
    </div>
    """
  end

  def styling_max_width_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    DemoScales.max_width_variants("combobox")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("combobox", modifier)

      """
      <.combobox class="#{class}" translation={%Corex.Combobox.Translation{placeholder: "Placeholder", empty: "No results"}} #{items_attr}>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("combobox"))

    ~H"""
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-space-sm">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.combobox
          id={"combobox-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("combobox", variant.modifier)}
          translation={%Corex.Combobox.Translation{placeholder: variant.label, empty: "No results"}}
          items={Corex.List.new(items_minimal())}
        >
          <:empty>No results</:empty>
          <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        </.combobox>
      </div>
    </div>
    """
  end

  def items_scrollable do
    [
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"},
      %{label: "Italy", value: "ita"},
      %{label: "Spain", value: "esp"},
      %{label: "Portugal", value: "prt"},
      %{label: "Poland", value: "pol"},
      %{label: "Sweden", value: "swe"},
      %{label: "Norway", value: "nor"},
      %{label: "Denmark", value: "dnk"},
      %{label: "Finland", value: "fin"},
      %{label: "Ireland", value: "irl"},
      %{label: "Greece", value: "grc"}
    ]
  end

  defp styling_max_height_items_attr do
    ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}, %{label: "Netherlands", value: "nld"}, %{label: "Switzerland", value: "che"}, %{label: "Austria", value: "aut"}, %{label: "Italy", value: "ita"}, %{label: "Spain", value: "esp"}, %{label: "Portugal", value: "prt"}, %{label: "Poland", value: "pol"}, %{label: "Sweden", value: "swe"}, %{label: "Norway", value: "nor"}, %{label: "Denmark", value: "dnk"}, %{label: "Finland", value: "fin"}, %{label: "Ireland", value: "irl"}, %{label: "Greece", value: "grc"}])}|
  end

  def styling_max_height_code do
    items_attr = styling_max_height_items_attr()

    DemoScales.max_height_variants("combobox")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("combobox", modifier)

      """
      <.combobox class="#{class}" translation={%Corex.Combobox.Translation{placeholder: "Placeholder", empty: "No results"}} #{items_attr}>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_height_example(assigns) do
    assigns = assign(assigns, :max_height_variants, DemoScales.max_height_variants("combobox"))

    ~H"""
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @max_height_variants} class="flex flex-col gap-space-sm">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.combobox
          id={"combobox-style-max-h-#{variant.id}"}
          class={DemoScales.join_modifiers("combobox", variant.modifier)}
          translation={%Corex.Combobox.Translation{placeholder: variant.label, empty: "No results"}}
          items={Corex.List.new(items_scrollable())}
        >
          <:empty>No results</:empty>
          <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        </.combobox>
      </div>
    </div>
    """
  end

  def styling_rounded_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.combobox class="combobox ui-rounded-none" translation={%Corex.Combobox.Translation{placeholder: "None", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-rounded-md" translation={%Corex.Combobox.Translation{placeholder: "MD", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-rounded-lg" translation={%Corex.Combobox.Translation{placeholder: "LG", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-rounded-xl" translation={%Corex.Combobox.Translation{placeholder: "XL", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    <.combobox class="combobox ui-rounded-full" translation={%Corex.Combobox.Translation{placeholder: "Full", empty: "No results"}} #{items_attr}>
      <:empty>No results</:empty>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.combobox>
    """
  end

  def styling_rounded_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-space-lg w-full max-w-md">
      <.combobox
        id="combobox-style-rounded-none"
        class="combobox ui-rounded-none"
        translation={%Corex.Combobox.Translation{placeholder: "None", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-rounded-md"
        class="combobox ui-rounded-md"
        translation={%Corex.Combobox.Translation{placeholder: "MD", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-rounded-lg"
        class="combobox ui-rounded-lg"
        translation={%Corex.Combobox.Translation{placeholder: "LG", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-rounded-xl"
        class="combobox ui-rounded-xl"
        translation={%Corex.Combobox.Translation{placeholder: "XL", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.combobox
        id="combobox-style-rounded-full"
        class="combobox ui-rounded-full"
        translation={%Corex.Combobox.Translation{placeholder: "Full", empty: "No results"}}
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
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={f[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      <.action type="submit" class="button ui-accent">Submit</.action>
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
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.combobox
        field={f[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
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
      <.action type="submit" id="combobox-form-ecto-submit" class="button ui-accent">
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
    <.form for={@form} phx-submit="save_phoenix" class="flex flex-col gap-space-lg w-full max-w-xl">
      <.combobox
        field={@form[:country]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "No results"}}
        items={Corex.List.new(items_minimal())}
      >
        <:label>Country</:label>
        <:empty>No results</:empty>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      </.combobox>
      <.action type="submit" id="combobox-live-form-phoenix-submit" class="button ui-accent">
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
