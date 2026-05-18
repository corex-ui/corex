defmodule E2eWeb.Demos.DataListDemo do
  use E2eWeb, :html

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
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit.", meta: %{icon: "hero-chat-bubble-left-right"}},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula.", meta: %{icon: "hero-device-phone-mobile"}},
        %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a.", meta: %{icon: "hero-phone"}}
      ])}
    >
      <:label :let={item}>
        <.heroicon name={item.meta.icon} /> {item.label}
      </:label>
      <:content :let={item}>
        <span class="tag tag--blue">{item.content}</span>
      </:content>
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
      <:empty>
        <p>No entries</p>
      </:empty>
    </.data_list>
    """
  end

  def styling_items, do: items_basic()

  def styling_text_example(assigns) do
    ~H"""
    <.data_list class="data-list data-list--sm" items={styling_items()} />
    <.data_list class="data-list data-list--md" items={styling_items()} />
    <.data_list class="data-list data-list--lg" items={styling_items()} />
    <.data_list class="data-list data-list--xl" items={styling_items()} />
    """
  end

  def styling_text_code do
    ~S"""
    <.data_list
      class="data-list data-list--sm"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--md"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--lg"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--xl"
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
    <.data_list class="data-list data-list--accent" items={styling_items()} />
    <.data_list class="data-list data-list--brand" items={styling_items()} />
    <.data_list class="data-list data-list--alert" items={styling_items()} />
    <.data_list class="data-list data-list--success" items={styling_items()} />
    <.data_list class="data-list data-list--info" items={styling_items()} />
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
      class="data-list data-list--accent"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--brand"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--alert"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--success"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--info"
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
    ~H"""
    <.data_list class="data-list max-w-2xs" items={styling_items()} />
    <.data_list class="data-list max-w-md" items={styling_items()} />
    <.data_list class="data-list max-w-xl" items={styling_items()} />
    <.data_list class="data-list max-w-2xl" items={styling_items()} />
    """
  end

  def styling_max_width_code do
    ~S"""
    <.data_list
      class="data-list max-w-2xs"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list max-w-md"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list max-w-xl"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list max-w-2xl"
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
    <div class="flex flex-wrap gap-4">
      <.action phx-click="stream_add" class="button button--accent">Add row</.action>
      <.action phx-click="stream_reset" class="button button--alert">Reset</.action>
    </div>
    <.data_list id="data-list-patterns-stream" class="data-list" items={Corex.Content.new(@items_list)}>
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
