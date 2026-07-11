defmodule E2eWeb.Demos.TabsDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def basic_items do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "duis",
        label: "Duis",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "donec",
        label: "Donec",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def anatomy_basic_code do
    ~S"""
    <.tabs
      class="tabs"
      items={Corex.Content.new([
        [label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
        [label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
        [label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
      ])}
    />
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <.tabs
      id="tabs-basic"
      class="tabs"
      value="lorem"
      items={E2eWeb.Demos.TabsDemo.basic_items()}
    />
    """
  end

  def anatomy_indicator_code do
    ~S"""
    <.tabs
      class="tabs"
      indicator
      items={Corex.Content.new([
        [value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
        [label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
        [value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
      ])}
    >
    </.tabs>
    """
  end

  def anatomy_indicator_example(assigns) do
    ~H"""
    <.tabs
      id="tabs-indicator"
      class="tabs"
      indicator
      value="lorem"
      items={E2eWeb.Demos.TabsDemo.basic_items()}
    />
    """
  end

  def anatomy_custom_code do
    ~S"""
    <.tabs
      class="tabs"
      value="lorem"
      items={Corex.Content.new([
        [value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", meta: %{indicator: "hero-chevron-right"}],
        [label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus.", meta: %{indicator: "hero-chevron-right"}],
        [value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
      ])}
    >
      <:trigger :let={item}>
        {item.label}
      </:trigger>
      <:content :let={item}>
        {item.content}
      </:content>
    </.tabs>
    """
  end

  def anatomy_nested_code do
    """
    <.tabs class="tabs" value="outer-2">
      <:trigger value="outer-1">Outer 1</:trigger>
      <:trigger value="outer-2">Outer 2</:trigger>

      <:content value="outer-1">
        Outer content
      </:content>

      <:content value="outer-2">
        <.tabs
          class="tabs"
          value="lorem"
          items={Corex.Content.new([
            %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
            %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
            %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
          ])}
        />
      </:content>
    </.tabs>
    """
  end

  def anatomy_nested_example(assigns) do
    ~H"""
    <.tabs id="tabs-nested-outer" class="tabs" value="outer-2">
      <:trigger value="outer-1">Outer 1</:trigger>
      <:trigger value="outer-2">Outer 2</:trigger>

      <:content value="outer-1">
        <div class="flex flex-col gap-space">
          <p>Outer content</p>
        </div>
      </:content>

      <:content value="outer-2">
        <div class="flex flex-col gap-space">
          <p>Inner tabs</p>
          <.tabs
            id="tabs-nested-inner"
            class="tabs"
            value="lorem"
            items={E2eWeb.Demos.TabsDemo.basic_items()}
          />
        </div>
      </:content>
    </.tabs>
    """
  end

  def api_set_value_client_binding_heex do
    ~S"""
    <.action phx-click={Corex.Tabs.set_value("tabs-api-cb", "lorem")} class="button ui-size-sm">Lorem</.action>
    <.action phx-click={Corex.Tabs.set_value("tabs-api-cb", "duis")} class="button ui-size-sm">Duis</.action>
    <.action phx-click={Corex.Tabs.set_value("tabs-api-cb", nil)} class="button ui-size-sm">Close all</.action>
    <.tabs id="tabs-api-cb" class="tabs" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def api_set_value_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action phx-click={Corex.Tabs.set_value("tabs-api-cb", "lorem")} class="button ui-size-sm">
          Lorem
        </.action>
        <.action phx-click={Corex.Tabs.set_value("tabs-api-cb", "duis")} class="button ui-size-sm">
          Duis
        </.action>
        <.action phx-click={Corex.Tabs.set_value("tabs-api-cb", nil)} class="button ui-size-sm">
          Close all
        </.action>
      </div>
      <.tabs
        id="tabs-api-cb"
        class="tabs w-full"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <button
      type="button"
      class="button ui-size-sm"
      onclick="document.getElementById('tabs-api-cjs')?.dispatchEvent(new CustomEvent('corex:tabs:set-value', {bubbles: false, detail: { value: 'lorem' } }))"
    >
      Lorem (client JS)
    </button>
    <.tabs id="tabs-api-cjs" class="tabs" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("tabs-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:tabs:set-value", { bubbles: false, detail: { value: "lorem" } })
    );
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("tabs-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:tabs:set-value", { bubbles: false, detail: { value: "lorem" } })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <button
          type="button"
          class="button ui-size-sm"
          onclick="document.getElementById('tabs-api-cjs')?.dispatchEvent(new CustomEvent('corex:tabs:set-value', {bubbles: false, detail: { value: 'lorem' } }))"
        >
          Lorem (client JS)
        </button>
      </div>
      <.tabs
        id="tabs-api-cjs"
        class="tabs w-full"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="tabs_api_lorem" class="button ui-size-sm">Lorem</.action>
    <.action phx-click="tabs_api_duis" class="button ui-size-sm">Duis</.action>
    <.action phx-click="tabs_api_close" class="button ui-size-sm">Close all</.action>
    <.tabs id="tabs-api-srv" class="tabs" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("tabs_api_lorem", _params, socket) do
      {:noreply, Corex.Tabs.set_value(socket, "tabs-api-srv", "lorem")}
    end

    def handle_event("tabs_api_duis", _params, socket) do
      {:noreply, Corex.Tabs.set_value(socket, "tabs-api-srv", "duis")}
    end

    def handle_event("tabs_api_close", _params, socket) do
      {:noreply, Corex.Tabs.set_value(socket, "tabs-api-srv", nil)}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action phx-click="tabs_api_lorem" class="button ui-size-sm">Lorem</.action>
        <.action phx-click="tabs_api_duis" class="button ui-size-sm">Duis</.action>
        <.action phx-click="tabs_api_close" class="button ui-size-sm">Close all</.action>
      </div>
      <.tabs
        id="tabs-api-srv"
        class="tabs w-full"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def api_codes do
    %{
      set_value_client_binding: api_set_value_client_binding_heex(),
      set_value_client_js_heex: api_set_value_client_js_heex(),
      set_value_client_js: api_set_value_client_js_js(),
      set_value_client_ts: api_set_value_client_js_ts(),
      set_value_server_heex: api_set_value_server_heex(),
      set_value_server_elixir: api_set_value_server_elixir()
    }
  end

  def api_client_binding_code, do: api_set_value_client_binding_heex()

  def api_client_binding_example(assigns), do: api_set_value_client_binding_example(assigns)

  def patterns_controlled_heex do
    ~S"""
    <.tabs
      class="tabs"
      value={@value}
      controlled
      on_value_change="tabs_pattern_value"
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :value, "lorem")}
    end

    def handle_event("tabs_pattern_value", %{"value" => value}, socket) do
      v =
        case value do
          nil -> "lorem"
          "" -> "lorem"
          other -> to_string(other)
        end

      {:noreply, assign(socket, :value, v)}
    end
    """
  end

  attr :value, :any, default: "lorem"

  def patterns_controlled_example(assigns) do
    value = if assigns.value in [nil, ""], do: "lorem", else: to_string(assigns.value)

    assigns = assign(assigns, :value, value)

    ~H"""
    <.tabs
      id="tabs-patterns-controlled"
      class="tabs w-full"
      value={@value}
      controlled
      on_value_change="tabs_pattern_value"
      items={E2eWeb.Demos.TabsDemo.basic_items()}
    />
    """
  end

  def styling_color_code do
    ~S"""
    <.tabs class="tabs" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-accent" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-brand" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-alert" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-info" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-success" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.tabs
        id="tabs-style-color-default"
        class="tabs"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-color-accent"
        class="tabs ui-accent"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-color-brand"
        class="tabs ui-brand"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-color-alert"
        class="tabs ui-alert"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-color-info"
        class="tabs ui-info"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-color-success"
        class="tabs ui-success"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.tabs class="tabs" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-solid" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.tabs
        id="tabs-style-variant-subtle"
        class="tabs"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-variant-solid"
        class="tabs ui-solid"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def styling_variant_matrix_code do
    items = ~S|items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}|

    for semantic <- DemoScales.styling_semantic_axis_steps("tabs"),
        variant <- DemoScales.styling_variant_axis_steps("tabs") do
      class = DemoScales.join_matrix_modifiers("tabs", semantic.modifier, variant.modifier)
      ~s(<.tabs class="#{class}" value="lorem" #{items} />)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("tabs"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("tabs"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.tabs
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("tabs", semantic.modifier, variant.modifier)}
            value="lorem"
            items={E2eWeb.Demos.TabsDemo.basic_items()}
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.tabs class="tabs ui-size-sm" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-size-md" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-size-lg" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-size-xl" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4">
      <.tabs
        id="tabs-style-sm"
        class="tabs ui-size-sm"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-md"
        class="tabs ui-size-md"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-lg"
        class="tabs ui-size-lg"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-xl"
        class="tabs ui-size-xl"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.tabs class="tabs ui-rounded-none" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-rounded-md" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-rounded-lg" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-rounded-xl" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    <.tabs class="tabs ui-rounded-full" value="lorem" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4">
      <.tabs
        id="tabs-style-rounded-none"
        class="tabs ui-rounded-none"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-rounded-md"
        class="tabs ui-rounded-md"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-rounded-lg"
        class="tabs ui-rounded-lg"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-rounded-xl"
        class="tabs ui-rounded-xl"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
      <.tabs
        id="tabs-style-rounded-full"
        class="tabs ui-rounded-full"
        value="lorem"
        items={E2eWeb.Demos.TabsDemo.basic_items()}
      />
    </div>
    """
  end

  def styling_max_width_code do
    items_attr = styling_tabs_items_attr()

    DemoScales.max_width_variants("tabs")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("tabs", modifier)

      """
      <.tabs class="#{class}" value="lorem" #{items_attr} />
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("tabs"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.tabs
          id={"tabs-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("tabs", variant.modifier)}
          value="lorem"
          items={E2eWeb.Demos.TabsDemo.basic_items()}
        />
      </div>
    </div>
    """
  end

  defp styling_tabs_items_attr do
    ~S|items={Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}|
  end

  def events_server_heex do
    ~S"""
    <.tabs
      class="tabs"
      value="lorem"
      on_value_change="tabs_value_changed"
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "tabs_value_changed",
      ~S|%{"value" => value, "id" => id} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.tabs
      id="tabs-events-client"
      class="tabs"
      value="lorem"
      on_value_change_client="tabs-value-changed"
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("tabs-events-client");
    el?.addEventListener("tabs-value-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("tabs-events-client");
    el?.addEventListener("tabs-value-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end
end
