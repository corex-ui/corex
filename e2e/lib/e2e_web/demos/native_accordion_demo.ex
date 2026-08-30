defmodule E2eWeb.Demos.NativeAccordionDemo do
  use E2eWeb, :html

  def items_basic, do: E2eWeb.Demos.DocExamples.content_items()
  def items_with_meta, do: E2eWeb.Demos.DocExamples.content_items_with_meta()
  def items_with_values, do: E2eWeb.Demos.DocExamples.content_items_with_values()

  def shared_items_full do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def styling_items do
    Corex.Content.new([
      %{
        value: "item-1",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "item-2",
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "item-3",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def patterns_items, do: shared_items_full()
  def events_items, do: shared_items_full()

  def minimal_example(assigns) do
    ~H"""
    <.native_accordion
      class="accordion"
      controlled={false}
      items={items_with_values()}
    />
    """
  end

  def minimal_code do
    ~S"""
    <.native_accordion
      class="accordion"
      controlled={false}
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
        %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
      ])}
    />
    """
  end

  def with_indicator_example(assigns) do
    ~H"""
    <.native_accordion class="accordion" controlled={false} items={items_basic()}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.native_accordion>
    """
  end

  def with_indicator_code do
    ~S"""
    <.native_accordion class="accordion" controlled={false} items={items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.native_accordion>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.native_accordion class="accordion" controlled={false} items={items_with_meta()}>
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
      </:trigger>
      <:content :let={item}>
        <p>{item.content}</p>
      </:content>
      <:indicator :let={item}>
        <.heroicon name={item.meta.indicator} />
      </:indicator>
    </.native_accordion>
    """
  end

  def custom_slots_code do
    ~S"""
    <.native_accordion class="accordion" controlled={false} items={items}>
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
      </:trigger>
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator :let={item}>
        <.heroicon name={item.meta.indicator} />
      </:indicator>
    </.native_accordion>
    """
  end

  def manual_slots_example(assigns) do
    ~H"""
    <.native_accordion
      id="native-accordion-anatomy-manual"
      class="accordion"
      controlled={false}
      value="lorem"
    >
      <:trigger value="lorem">
        <.heroicon name="hero-chat-bubble-left-right" /> Lorem ipsum dolor sit amet
      </:trigger>
      <:content value="lorem">
        <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
      </:content>
      <:trigger value="duis">
        <.heroicon name="hero-device-phone-mobile" /> Duis dictum gravida odio ac pharetra?
      </:trigger>
      <:content value="duis">
        <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
      </:content>
      <:trigger value="donec">
        <.heroicon name="hero-phone" /> Donec condimentum ex mi
      </:trigger>
      <:content value="donec">
        <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
      </:content>
      <:indicator value="lorem">
        <.heroicon name="hero-chevron-right" />
      </:indicator>
      <:indicator value="duis">
        <.heroicon name="hero-chevron-right" />
      </:indicator>
      <:indicator value="donec">
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.native_accordion>
    """
  end

  def manual_slots_code do
    ~S"""
    <.native_accordion class="accordion" controlled={false} value="lorem">
      <:trigger value="lorem">Lorem ipsum dolor sit amet</:trigger>
      <:content value="lorem"><p>Consectetur adipiscing elit.</p></:content>
      <:indicator value="lorem"><.heroicon name="hero-chevron-right" /></:indicator>
      <:trigger value="duis">Duis dictum gravida odio ac pharetra?</:trigger>
      <:content value="duis"><p>Nullam eget vestibulum ligula.</p></:content>
      <:indicator value="duis"><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    """
  end

  def compound_example(assigns) do
    ~H"""
    <.native_accordion :let={ctx} compound class="accordion" controlled={false} value="lorem">
      <.native_accordion_root ctx={ctx}>
        <.native_accordion_item :let={item} ctx={ctx} value="lorem">
          <.native_accordion_trigger item={item}>
            Lorem ipsum dolor sit amet
            <:indicator>
              <.native_accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.native_accordion_indicator>
            </:indicator>
          </.native_accordion_trigger>
          <.native_accordion_content item={item}>
            <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
          </.native_accordion_content>
        </.native_accordion_item>
        <.native_accordion_item :let={item} ctx={ctx} value="duis">
          <.native_accordion_trigger item={item}>
            Duis dictum gravida odio ac pharetra?
            <:indicator>
              <.native_accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.native_accordion_indicator>
            </:indicator>
          </.native_accordion_trigger>
          <.native_accordion_content item={item}>
            <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
          </.native_accordion_content>
        </.native_accordion_item>
      </.native_accordion_root>
    </.native_accordion>
    """
  end

  def compound_code do
    ~S"""
    <.native_accordion :let={ctx} compound class="accordion" controlled={false} value="lorem">
      <.native_accordion_root ctx={ctx}>
        <.native_accordion_item :let={item} ctx={ctx} value="lorem">
          <.native_accordion_trigger item={item}>
            Lorem ipsum dolor sit amet
            <:indicator>
              <.native_accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.native_accordion_indicator>
            </:indicator>
          </.native_accordion_trigger>
          <.native_accordion_content item={item}>
            <p>Consectetur adipiscing elit.</p>
          </.native_accordion_content>
        </.native_accordion_item>
      </.native_accordion_root>
    </.native_accordion>
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.native_accordion
      id="patterns-controlled"
      class="accordion"
      items={items}
      multiple={false}
      controlled
      value={@open}
      on_value_change="patterns_controlled_changed"
      on_keydown="patterns_keydown"
      focused_value={@focused}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.native_accordion>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def handle_event("patterns_controlled_changed", params, socket) do
      {:noreply,
       Corex.NativeAccordion.handle_toggle(socket, :open, params,
         multiple: false,
         collapsible: true
       )}
    end

    def handle_event("patterns_keydown", params, socket) do
      {:noreply, Corex.NativeAccordion.handle_keydown(socket, :focused, params)}
    end
    """
  end

  def patterns_uncontrolled_heex do
    ~S"""
    <.native_accordion
      class="accordion"
      controlled={false}
      value={["lorem"]}
      items={items}
      on_keydown="patterns_keydown"
      focused_value={@focused}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.native_accordion>
    """
  end

  def events_server_heex do
    ~S"""
    <.native_accordion
      id="events-on-value-change-server"
      class="accordion"
      controlled
      value={@open}
      on_value_change="accordion_value_changed"
      on_keydown="events_keydown"
      focused_value={@focused}
      items={items}
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("accordion_value_changed", params, socket) do
      socket =
        socket
        |> Corex.NativeAccordion.handle_toggle(:open, params)
        |> stream_insert(:server_logs, new_log(params), at: 0)

      {:noreply, socket}
    end
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NativeAccordion.set_value("api-set-value-client", "lorem", all_values: ~w(lorem duis donec))}>
      Open Lorem
    </.action>
    <.action phx-click={Corex.NativeAccordion.set_value("api-set-value-client", [], all_values: ~w(lorem duis donec))}>
      Close all
    </.action>
    <.native_accordion
      id="api-set-value-client"
      class="accordion"
      controlled={false}
      items={items}
    />
    """
  end

  def styling_canonical_code do
    ~S"""
    <.native_accordion class="accordion" controlled={false} value="item-1" items={items}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    """
  end

  def styling_canonical_example(assigns) do
    _ = assigns

    ~H"""
    <.native_accordion class="accordion" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    """
  end

  def styling_color_code, do: styling_canonical_code()

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.native_accordion class="accordion" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    <.native_accordion class="accordion ui-accent" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    <.native_accordion class="accordion ui-brand" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    <.native_accordion class="accordion ui-alert" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    <.native_accordion class="accordion ui-success" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    """
  end

  def styling_size_code, do: styling_canonical_code()

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <.native_accordion class="accordion ui-size-sm" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    <.native_accordion class="accordion" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    <.native_accordion class="accordion ui-size-lg" controlled={false} value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.native_accordion>
    """
  end
end
