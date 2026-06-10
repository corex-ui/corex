defmodule E2eWeb.Demos.SelectDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  defp items do
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])
  end

  defp grouped_items do
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"}
    ])
  end

  defp items_extended do
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  end

  def minimal_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra", disabled: true},
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
    </.select>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-minimal"
      items={items()}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def with_translation_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def with_translation_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-translation"
      items={items()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def item_indicator_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"}
      ])}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.select>
    """
  end

  def item_indicator_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-item-indicator"
      items={items()}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.select>
    """
  end

  def grouped_code do
    ~S"""
    <.select
      
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
    </.select>
    """
  end

  def grouped_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-grouped"
      items={grouped_items()}
    >
      <:label>Country</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def extended_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}
    >
      <:label>
        Country of residence
      </:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end

  def extended_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-extended"
      items={items_extended()}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
        {item.label}
      </:item>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.select>
    """
  end

  def extended_grouped_code do
    ~S"""
    <.select
      
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
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end

  def extended_grouped_example(assigns) do
    ~H"""
    <.select
      id="select-anatomy-extended-grouped"
      items={grouped_items()}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
        {item.label}
      </:item>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.select>
    """
  end

  def styling_semantic_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    value_attr = ~S|value={["fra"]}|

    """
    <.select  #{items_attr} #{value_attr}>
      <:label>Default</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select semantic="accent" #{items_attr} #{value_attr}>
      <:label>Accent</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select semantic="brand" #{items_attr} #{value_attr}>
      <:label>Brand</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select semantic="alert" #{items_attr} #{value_attr}>
      <:label>Alert</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select semantic="info" #{items_attr} #{value_attr}>
      <:label>Info</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select semantic="success" #{items_attr} #{value_attr}>
      <:label>Success</:label>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def styling_semantic_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.select
        id="select-style-color-default"
        items={items()}
        value={["fra"]}
      >
        <:label>Default</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select
        id="select-style-color-accent"
        semantic="accent"
        items={items()}
        value={["fra"]}
      >
        <:label>Accent</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select
        id="select-style-color-brand"
        semantic="brand"
        items={items()}
        value={["fra"]}
      >
        <:label>Brand</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select
        id="select-style-color-alert"
        semantic="alert"
        items={items()}
        value={["fra"]}
      >
        <:label>Alert</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select
        id="select-style-color-info"
        semantic="info"
        items={items()}
        value={["fra"]}
      >
        <:label>Info</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select
        id="select-style-color-success"
        semantic="success"
        items={items()}
        value={["fra"]}
      >
        <:label>Success</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
    </div>
    """
  end

  def styling_size_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.select size="sm" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select size="md" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select size="lg" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select size="xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.select id="select-style-sm" size="sm" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-md" size="md" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-lg" size="lg" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-xl" size="xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
    </div>
    """
  end

  def styling_text_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.select class="select select--text-sm" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select class="select select--text-xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select class="select select--text-2xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select class="select select--text-4xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def styling_text_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.select id="select-style-text-sm" class="select select--text-sm" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-text-xl" class="select select--text-xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-text-2xl" class="select select--text-2xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-text-4xl" class="select select--text-4xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
    </div>
    """
  end

  def styling_radius_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.select  class="select select--rounded-none" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--rounded-md" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--rounded-lg" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--rounded-xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--rounded-full" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.select id="select-style-rounded-none" class="select select--rounded-none" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-rounded-md" class="select select--rounded-md" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-rounded-lg" class="select select--rounded-lg" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-rounded-xl" class="select select--rounded-xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-rounded-full" class="select select--rounded-full" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
    </div>
    """
  end

  def styling_max_width_code do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.select  class="select select--max-w-2xs" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--max-w-md" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--max-w-xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    <.select  class="select select--max-w-2xl" #{items_attr}>
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def styling_max_width_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full items-start">
      <.select id="select-style-max-2xs" class="select select--max-w-2xs" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-max-md" class="select select--max-w-md" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-max-xl" class="select select--max-w-xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
      <.select id="select-style-max-2xl" class="select select--max-w-2xl" items={items()}>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.select>
    </div>
    """
  end

  def items_minimal do
    [
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ]
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Select.set_value("select-api-cb", ["fra"])}>France</.action>
    <.action phx-click={Corex.Select.set_value("select-api-cb", [])}>Clear</.action>
    <.select
      id="select-api-cb"
      semantic="accent"
      items={Corex.List.new(items_minimal())}
      translation={%Corex.Select.Translation{placeholder: "Select"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="select_api_set_value">France</.action>
    <.action phx-click="select_api_clear">Clear</.action>
    <.select
      id="select-api-srv"
      semantic="accent"
      items={Corex.List.new(items_minimal())}
      translation={%Corex.Select.Translation{placeholder: "Select"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("select_api_set_value", _params, socket) do
      {:noreply, Corex.Select.set_value(socket, "select-api-srv", ["fra"])}
    end

    def handle_event("select_api_clear", _params, socket) do
      {:noreply, Corex.Select.set_value(socket, "select-api-srv", [])}
    end
    """
  end

  def api_set_value_client_js do
    ~S"""
    const el = document.getElementById("select-api-cjs");

    el?.dispatchEvent(
      new CustomEvent("corex:select:set-value", {
        bubbles: false,
        detail: { value: ["fra"] },
      })
    );

    el?.dispatchEvent(
      new CustomEvent("corex:select:set-value", {
        bubbles: false,
        detail: { value: [] },
      })
    );
    """
  end

  def api_binding_example(assigns) do
    ~H"""
    <.select
      id="select-api-overview"
      semantic="accent"
      items={Corex.List.new(items_minimal())}
      translation={%Corex.Select.Translation{placeholder: "Select"}}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def api_overview_code, do: api_set_value_client_binding_code()
  def api_overview_example(assigns), do: api_binding_example(assigns)

  def events_server_heex do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.select
      
      #{items_attr}
      on_value_change="select_changed"
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "select_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    items_attr =
      ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}])}|

    """
    <.select
      id="select-events-client"
      
      #{items_attr}
      on_value_change_client="select-changed"
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
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
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
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
      for={@form}
      action={~p"/select/form"}
      method="post"
    >
      <.select
        field={@form[:country]}
        
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
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
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" semantic="accent">
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
      for={@form}
      action={~p"/select/form"}
      method="post"
    >
      <.select
        field={@form[:country]}
        
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
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
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" semantic="accent">
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
    <form action={~p"/select/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.select
        name="user[country]"
        form="select-plain-form"
        
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
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
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def select_form_submit(conn, %{"user" => %{"country" => country}}) do
      conn
      |> put_flash(:info, "Submitted: country=#{inspect(country)}")
      |> redirect(to: ~p"/select/form#select-form-native")
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
      <.select
        
        field={@form[:country]}
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed"
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <.select
        
        field={@form[:country]}
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed_strict"
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" semantic="accent">
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

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/select/form"}
      method="post"
    >
      <.select
        field={@form[:country]}
        
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
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
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def select_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"country" => ""}, as: :select_phoenix, id: "select-form-phoenix")

      render(conn, :select_form_page, phoenix_form: phoenix_form)
    end

    def select_form_submit(conn, params) do
      if is_map(params["select_phoenix"]) do
        country = params["select_phoenix"]["country"] || ""

        conn
        |> put_flash(:info, "Submitted: country=#{inspect(country)}")
        |> redirect(to: ~p"/select/form#select-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.select
        
        field={@form[:country]}
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.SelectFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"country" => ""}, as: :select_phoenix, id: "select-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"select_phoenix" => params}, socket) do
        country = params["country"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"country" => country}, as: :select_phoenix, id: "select-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.SelectFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.CountryForm{}
          |> MyApp.Forms.CountryForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :select_ecto, id: "select-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("select_country_changed", %{"value" => value}, socket) do
        country = List.first(value) || ""
        validate_ecto(socket, %{"country" => country})
      end

      def handle_event("validate", %{"select_ecto" => params}, socket) do
        validate_ecto(socket, params)
      end

      def handle_event("save", %{"select_ecto" => params}, socket) do
        case MyApp.Forms.CountryForm.changeset_validate(%MyApp.Forms.CountryForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.CountryForm.changeset_validate(%MyApp.Forms.CountryForm{}, params),
                 as: :select_ecto,
                 id: "select-live-form-ecto"
               )
             )}

          %Ecto.Changeset{} = changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset, action: :insert, as: :select_ecto, id: "select-live-form-ecto")
             )}
        end
      end

      defp validate_ecto(socket, params) do
        changeset =
          %MyApp.Forms.CountryForm{}
          |> MyApp.Forms.CountryForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset, action: :validate, as: :select_ecto, id: "select-live-form-ecto")
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
    >
      <.select
        field={f[:country]}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={form_country_items()}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-changeset-submit" semantic="accent">
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
    >
      <.select
        field={f[:country]}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={form_country_items()}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-validate-submit" semantic="accent">
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
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.select
        id="select-native-country"
        name="user[country]"
        form="select-plain-form"
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={form_country_items()}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
      <.action type="submit" id="select-controller-submit" semantic="accent">
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
      <.select
        id="select-form-live-country"
        field={@form[:country]}
        items={form_country_items()}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed"
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-form-live-submit" semantic="accent">
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
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <.select
        id="select-form-live-strict"
        field={@form[:country]}
        items={form_country_items()}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed_strict"
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-form-live-strict-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def patterns_items_flat do
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  end

  def patterns_items_grouped do
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"},
      %{label: "Thailand", value: "tha", group: "Asia"},
      %{label: "USA", value: "usa", group: "North America"},
      %{label: "Canada", value: "can", group: "North America"},
      %{label: "Mexico", value: "mex", group: "North America"}
    ])
  end

  def patterns_controlled_heex do
    ~S"""
    <.select
      
      controlled
      value={@value}
      items={@items}
      on_value_change="value_changed"
    >
      <:label>Country</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      items =
        Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])

      {:ok, assign(socket, value: [], items: items)}
    end

    def handle_event("value_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :value, value)}
    end
    """
  end

  def patterns_stream_demo_heex do
    ~S"""
    <div class="flex flex-col gap-3 w-full max-w-xl">
      <div class="flex flex-wrap gap-2">
        <.action phx-click="add_item" size="sm" semantic="accent">
          <.heroicon name="hero-plus" /> Add item
        </.action>
        <.action phx-click="reset" size="sm" semantic="alert">
          Reset
        </.action>
      </div>
      <.select  items={Corex.List.new(@items_list)}>
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
    </div>
    """
  end

  def patterns_stream_elixir do
    ~S'''
    defmodule MyAppWeb.SelectStreamDemoLive do
      use MyAppWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        initial = [
          %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
          %{value: "donec", label: "Donec condimentum ex mi"}
        ]

        {:ok,
         socket
         |> stream_configure(:items, dom_id: &("select:stream-select:item:" <> &1.value))
         |> stream(:items, initial)
         |> assign(:items_list, initial)
         |> assign(:next_id, 1)}
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
         |> assign(:next_id, 1)}
      end

      @impl true
      def render(assigns) do
        ~H"""
        <div class="flex flex-col gap-3 w-full max-w-xl">
          <div class="flex flex-wrap gap-2">
            <.action phx-click="add_item" size="sm" semantic="accent">
              <.heroicon name="hero-plus" /> Add item
            </.action>
            <.action phx-click="reset" size="sm" semantic="alert">
              Reset
            </.action>
          </div>
          <.select id="stream-select"  items={Corex.List.new(@items_list)}>
            <:label>Country</:label>
            <:trigger>
              <.heroicon name="hero-chevron-down" />
            </:trigger>
          </.select>
        </div>
        """
      end
    end
    '''
  end

  def patterns_flat_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-flat"
      items={patterns_items_flat()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  def patterns_grouped_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-grouped"
      items={patterns_items_grouped()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  def patterns_extended_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-extended"
      items={patterns_items_flat()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end

  def patterns_extended_grouped_example(assigns) do
    ~H"""
    <.select
      id="select-patterns-extended-grouped"
      items={patterns_items_grouped()}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end

  def patterns_flat_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  def patterns_grouped_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Germany", value: "deu", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"},
        %{label: "China", value: "chn", group: "Asia"},
        %{label: "South Korea", value: "kor", group: "Asia"},
        %{label: "Thailand", value: "tha", group: "Asia"},
        %{label: "USA", value: "usa", group: "North America"},
        %{label: "Canada", value: "can", group: "North America"},
        %{label: "Mexico", value: "mex", group: "North America"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  def patterns_extended_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end

  def patterns_extended_grouped_code do
    ~S"""
    <.select
      
      items={Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Germany", value: "deu", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"},
        %{label: "China", value: "chn", group: "Asia"},
        %{label: "South Korea", value: "kor", group: "Asia"}
      ])}
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
    >
      <:label>Country of residence</:label>
      <:item :let={item}>
        <Flagpack.flag name={String.to_atom(item.value)} />
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/select/form"}
      method="post"
    >
      <.select
        field={f[:country]}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={form_country_items()}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
      <.action type="submit" semantic="accent">
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
      <.select
        id="select-live-form-phoenix-country"
        field={@form[:country]}
        items={form_country_items()}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
      <.action type="submit" id="select-live-form-phoenix-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <.select
        id="select-live-form-ecto-country"
        field={@form[:country]}
        items={form_country_items()}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        on_value_change="select_country_changed"
      >
        <:label>Country</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.select>
      <.action type="submit" id="select-live-form-ecto-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def style_preview(assigns), do: E2eWeb.Demos.StylePreview.preview(:select, assigns)
  def style_playground(assigns), do: style_preview(assigns)

end
