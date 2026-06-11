defmodule E2eWeb.Demos.DataListDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def items_basic, do: E2eWeb.Demos.DocExamples.content_items()

  def items_with_meta, do: E2eWeb.Demos.DocExamples.content_items_with_meta()

  def minimal_example(assigns) do
    ~H"""
    <.data_list items={items_basic()} />
    """
  end

  def minimal_code do
    ~S"""
    <.data_list
      
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
    <.data_list>
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
    <.data_list >
      <:label value="lorem">Lorem ipsum dolor sit amet</:label>
      <:content value="lorem">Consectetur adipiscing elit.</:content>
      <:label value="duis">Duis dictum gravida odio ac pharetra?</:label>
      <:content value="duis">Nullam eget vestibulum ligula.</:content>
    </.data_list>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.data_list items={items_with_meta()}>
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
    <.data_list items={[]}>
      <:empty>
        <p>No entries</p>
      </:empty>
    </.data_list>
    """
  end

  def empty_code do
    ~S"""
    <.data_list  items={[]}>
      <:empty>No entries</:empty>
    </.data_list>
    """
  end

  def styling_items, do: items_basic()

  def styling_text_example(assigns) do
    ~H"""
    <.data_list class="data-list data-list--size-sm" items={styling_items()} />
    <.data_list class="data-list data-list--size-md" items={styling_items()} />
    <.data_list class="data-list data-list--size-lg" items={styling_items()} />
    <.data_list class="data-list data-list--size-xl" items={styling_items()} />
    """
  end

  def styling_text_code do
    ~S"""
    <.data_list
      class="data-list data-list--size-sm"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--size-md"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--size-lg"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--size-xl"
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

  def styling_semantic_example(assigns) do
    ~H"""
    <.data_list items={styling_items()} />
    <.data_list class="data-list data-list--semantic-accent" items={styling_items()} />
    <.data_list class="data-list data-list--semantic-brand" items={styling_items()} />
    <.data_list class="data-list data-list--semantic-alert" items={styling_items()} />
    <.data_list class="data-list data-list--semantic-success" items={styling_items()} />
    <.data_list class="data-list data-list--semantic-info" items={styling_items()} />
    """
  end

  def styling_semantic_code do
    ~S"""
    <.data_list
      
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--semantic-accent"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--semantic-brand"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--semantic-alert"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--semantic-success"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--semantic-info"
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
    <.data_list class="data-list data-list--max-w-2xs" items={styling_items()} />
    <.data_list class="data-list data-list--max-w-md" items={styling_items()} />
    <.data_list class="data-list data-list--max-w-xl" items={styling_items()} />
    <.data_list class="data-list data-list--max-w-2xl" items={styling_items()} />
    """
  end

  def styling_max_width_code do
    ~S"""
    <.data_list
      class="data-list data-list--max-w-2xs"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--max-w-md"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--max-w-xl"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    />
    <.data_list
      class="data-list data-list--max-w-2xl"
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
    <.action phx-click="stream_add" semantic="accent">Add row</.action>
    <.action phx-click="stream_reset" semantic="alert">Reset</.action>
    <.data_list  items={Corex.Content.new(@items_list)}>
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

  def style_preview(assigns), do: E2eWeb.Demos.StylePreview.preview(:data_list, assigns)
  def style_playground(assigns), do: style_preview(assigns)

end
