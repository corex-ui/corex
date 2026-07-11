defmodule E2eWeb.Demos.DataListDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def items_basic, do: E2eWeb.Demos.DocExamples.content_items()

  def items_with_meta, do: E2eWeb.Demos.DocExamples.content_items_with_meta()

  def minimal_example(assigns) do
    ~H"""
    <.data_list class="data-list" items={items_basic()} />
    """
  end

  def minimal_code do
    ~S"""
    <.data_list
      class="data-list"
      items={
        Corex.Content.new([
          %{label: "Name", content: "Marie Curie"},
          %{label: "Field", content: "Physics"},
          %{label: "Born", content: "1867"}
        ])
      }
    />
    """
  end

  def manual_slots_example(assigns) do
    ~H"""
    <.data_list class="data-list">
      <:label value="lorem">
        <.heroicon name="hero-chat-bubble-left-right" /> Lorem ipsum dolor sit amet
      </:label>
      <:content value="lorem">
        Consectetur adipiscing elit. Sed sodales ullamcorper tristique.
      </:content>
      <:label value="duis">
        <.heroicon name="hero-device-phone-mobile" /> Duis dictum gravida odio ac pharetra?
      </:label>
      <:content value="duis">Nullam eget vestibulum ligula, at interdum tellus.</:content>
      <:label value="donec">
        <.heroicon name="hero-phone" /> Donec condimentum ex mi
      </:label>
      <:content value="donec">Congue molestie ipsum gravida a. Sed ac eros luctus.</:content>
    </.data_list>
    """
  end

  def manual_slots_code do
    ~S"""
    <.data_list class="data-list">
      <:label value="lorem">Lorem ipsum dolor sit amet</:label>
      <:content value="lorem">Consectetur adipiscing elit.</:content>
      <:label value="duis">Duis dictum gravida odio ac pharetra?</:label>
      <:content value="duis">Nullam eget vestibulum ligula.</:content>
    </.data_list>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.data_list class="data-list" items={items_with_meta()}>
      <:label :let={item}>
        <.heroicon name={item.meta.icon} /> {item.label}
      </:label>
      <:content :let={item}>
        <span class="tag tag--blue">{item.content}</span>
      </:content>
    </.data_list>
    """
  end

  def custom_slots_code do
    ~S"""
    <.data_list
      class="data-list"
      items={
        Corex.Content.new([
          %{value: "status", label: "Status", content: "Active", meta: %{color: "green"}},
          %{value: "role", label: "Role", content: "Admin", meta: %{color: "blue"}}
        ])
      }
    >
      <:label :let={item}>{item.label}</:label>
      <:content :let={item}>{item.content}</:content>
    </.data_list>
    """
  end

  def empty_example(assigns) do
    ~H"""
    <.data_list class="data-list" items={[]}>
      <:empty>
        <p>No entries</p>
      </:empty>
    </.data_list>
    """
  end

  def empty_code do
    ~S"""
    <.data_list class="data-list" items={[]}>
      <:empty>No entries</:empty>
    </.data_list>
    """
  end

  def styling_items, do: items_basic()

  def styling_size_example(assigns) do
    ~H"""
    <.data_list class="data-list ui-size-sm" items={styling_items()} />
    <.data_list class="data-list ui-size-md" items={styling_items()} />
    <.data_list class="data-list ui-size-lg" items={styling_items()} />
    <.data_list class="data-list ui-size-xl" items={styling_items()} />
    """
  end

  def styling_variant_code do
    ~S"""
    <.data_list class="data-list" items={styling_items()} />
    <.data_list class="data-list ui-solid" items={styling_items()} />
    <.data_list class="data-list" items={styling_items()} />
    <.data_list class="data-list" items={styling_items()} />
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <.data_list class="data-list" items={styling_items()} />
    <.data_list class="data-list ui-solid" items={styling_items()} />
    <.data_list class="data-list" items={styling_items()} />
    <.data_list class="data-list" items={styling_items()} />
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("data-list"),
        variant <- DemoScales.styling_variant_axis_steps("data-list") do
      class = DemoScales.join_matrix_modifiers("data-list", semantic.modifier, variant.modifier)

      """
      <.data_list class="#{class}" items={styling_items()} />
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("data-list"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("data-list"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.data_list
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("data-list", semantic.modifier, variant.modifier)}
            items={styling_items()}
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.data_list
      class="data-list ui-size-sm"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-size-md"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-size-lg"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-size-xl"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <.data_list class="data-list" items={styling_items()} />
    <.data_list class="data-list ui-accent" items={styling_items()} />
    <.data_list class="data-list ui-brand" items={styling_items()} />
    <.data_list class="data-list ui-alert" items={styling_items()} />
    <.data_list class="data-list ui-success" items={styling_items()} />
    <.data_list class="data-list ui-info" items={styling_items()} />
    """
  end

  def styling_color_code do
    ~S"""
    <.data_list
      class="data-list"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-accent"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-brand"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-alert"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-success"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-info"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("data-list"))

    ~H"""
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.data_list
          id={"data-list-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("data-list", variant.modifier)}
          items={styling_items()}
        />
      </div>
    </div>
    """
  end

  def styling_max_width_code do
    items = styling_data_list_items_heex()

    DemoScales.max_width_variants("data-list")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("data-list", modifier)

      """
      <.data_list
        class="#{class}"
        #{items}
      />
      """
    end)
    |> DemoScales.join_code()
  end

  defp styling_data_list_items_heex do
    ~S"""
    items={
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
      ])
    }
    """
  end

  def styling_rounded_example(assigns) do
    ~H"""
    <.data_list class="data-list ui-rounded-none" items={styling_items()} />
    <.data_list class="data-list ui-rounded-sm" items={styling_items()} />
    <.data_list class="data-list ui-rounded-md" items={styling_items()} />
    <.data_list class="data-list ui-rounded-lg" items={styling_items()} />
    <.data_list class="data-list ui-rounded-xl" items={styling_items()} />
    <.data_list class="data-list ui-rounded-full" items={styling_items()} />
    """
  end

  def styling_rounded_code do
    ~S"""
    <.data_list
      class="data-list ui-rounded-none"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-rounded-md"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list ui-rounded-full"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    """
  end

  def patterns_stream_demo_heex do
    ~S"""
    <.action phx-click="stream_add" class="button ui-accent">Add row</.action>
    <.action phx-click="stream_reset" class="button ui-alert">Reset</.action>
    <.data_list class="data-list" items={Corex.Content.new(@items_list)}>
      <:empty>
        <p>No items</p>
      </:empty>
    </.data_list>
    """
  end

  def patterns_stream_elixir do
    ~S'''
    @stream_initial [
      %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
      %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
    ]

    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> stream_configure(:items, dom_id: &"data-list:stream-data-list:item:#{&1.value}")
       |> stream(:items, @stream_initial)
       |> assign(:items_list, @stream_initial)
       |> assign(:next_id, 4)}
    end

    def handle_event("stream_add", _params, socket) do
      id = "item-#{socket.assigns.next_id}"
      row = %{value: id, label: "Row #{socket.assigns.next_id}", content: "Added at #{DateTime.utc_now()}"}
      items_list = socket.assigns.items_list ++ [row]

      {:noreply,
       socket
       |> stream_insert(:items, row)
       |> assign(:items_list, items_list)
       |> assign(:next_id, socket.assigns.next_id + 1)}
    end

    def handle_event("stream_reset", _params, socket) do
      {:noreply,
       socket
       |> stream(:items, [], reset: true)
       |> assign(:items_list, [])
       |> assign(:next_id, 1)}
    end
    '''
  end

  def playground_items, do: items_basic()
end
