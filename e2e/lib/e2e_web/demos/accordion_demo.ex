defmodule E2eWeb.Demos.AccordionDemo do
  use E2eWeb, :html

  def minimal_example(assigns) do
    ~H"""
    <.accordion class="accordion" items={items_basic()} />
    """
  end

  def with_indicator_example(assigns) do
    ~H"""
    <.accordion class="accordion" items={items_basic()}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.accordion class="accordion" value="lorem" items={items_with_meta()}>
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.trigger}
      </:trigger>
      <:content :let={item}>
        <p>{item.content}</p>
      </:content>
      <:indicator :let={item}>
        <.heroicon name={item.meta.indicator} />
      </:indicator>
    </.accordion>
    """
  end

  def manual_slots_example(assigns) do
    ~H"""
    <.accordion id="accordion-anatomy-manual" class="accordion" value="lorem">
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
    </.accordion>
    """
  end

  def manual_slots_code do
    ~S"""
    <.accordion class="accordion" value="lorem">
      <:trigger value="lorem">
        <.heroicon name="hero-chat-bubble-left-right" /> Lorem ipsum dolor sit amet
      </:trigger>
      <:content value="lorem">
        <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
      </:content>
      <:indicator value="lorem">
        <.heroicon name="hero-chevron-right" />
      </:indicator>

      <:trigger value="duis">
        <.heroicon name="hero-device-phone-mobile" /> Duis dictum gravida odio ac pharetra?
      </:trigger>
      <:content value="duis">
        <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
      </:content>
      <:indicator value="duis">
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def nested_items do
    Corex.Content.new([
      %{value: "outer-1", trigger: "Outer 1", content: "Outer content"},
      %{value: "outer-2", trigger: "Outer 2", content: "Outer content"}
    ])
  end

  def items_basic do
    Corex.Content.new([
      %{
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def items_with_meta do
    Corex.Content.new([
      %{
        value: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      },
      %{
        value: "duis",
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      },
      %{
        value: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      }
    ])
  end

  def shared_items_full do
    Corex.Content.new([
      %{
        value: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "duis",
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Accordion.set_value("api-set-value-client", "lorem")}>Open Lorem</.action>
    <.action phx-click={Corex.Accordion.set_value("api-set-value-client", ["lorem", "donec"])}>Lorem and Donec</.action>
    <.action phx-click={Corex.Accordion.set_value("api-set-value-client", [])}>Close all</.action>
    <.accordion id="api-set-value-client" items={Corex.Content.new([
      %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def code_items_basic do
    ~S"""
    Corex.Content.new([
      %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
    """
  end

  def code_items_with_meta do
    ~S"""
    Corex.Content.new([
      %{
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      },
      %{
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      },
      %{
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      }
    ])
    """
  end

  def minimal_code do
    ~S"""
    <.accordion
      class="accordion"
      items={
    """ <>
      code_items_basic() <>
      ~S"""
        }
      />
      """
  end

  def with_indicator_code do
    ~S"""
    <.accordion
      class="accordion"
      items={
    """ <>
      code_items_basic() <>
      ~S"""
        }
      >
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
      """
  end

  def custom_slots_code do
    ~S"""
    <.accordion
      class="accordion"
      items={
    """ <>
      code_items_with_meta() <>
      ~S"""
        }
      >
        <:trigger :let={item}>
          <.heroicon name={item.meta.icon} />{item.trigger}
        </:trigger>
        <:content :let={item}>
          <p>{item.content}</p>
        </:content>
        <:indicator :let={item}>
          <.heroicon name={item.meta.indicator} />
        </:indicator>
      </.accordion>
      """
  end

  def compound_code do
    ~S"""
    <.accordion :let={ctx} compound class="accordion">
      <.accordion_root ctx={ctx}>
        <.accordion_item :let={item} ctx={ctx} value="lorem">
          <.accordion_trigger item={item}>
            Lorem ipsum dolor sit amet
            <:indicator>
              <.accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>
          <.accordion_content item={item}>
            <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
          </.accordion_content>
        </.accordion_item>
        <.accordion_item :let={item} ctx={ctx} value="duis">
          <.accordion_trigger item={item}>
            Duis dictum gravida odio ac pharetra?
            <:indicator>
              <.accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>
          <.accordion_content item={item}>
            <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
          </.accordion_content>
        </.accordion_item>
        <.accordion_item :let={item} ctx={ctx} value="donec">
          <.accordion_trigger item={item}>
            Donec condimentum ex mi
            <:indicator>
              <.accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>
          <.accordion_content item={item}>
            <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
          </.accordion_content>
        </.accordion_item>
      </.accordion_root>
    </.accordion>
    """
  end

  def compound_example(assigns) do
    ~H"""
    <.accordion :let={ctx} compound class="accordion">
      <.accordion_root ctx={ctx}>
        <.accordion_item :let={item} ctx={ctx} value="lorem">
          <.accordion_trigger item={item}>
            Lorem ipsum dolor sit amet
            <:indicator>
              <.accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>
          <.accordion_content item={item}>
            <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
          </.accordion_content>
        </.accordion_item>
        <.accordion_item :let={item} ctx={ctx} value="duis">
          <.accordion_trigger item={item}>
            Duis dictum gravida odio ac pharetra?
            <:indicator>
              <.accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>
          <.accordion_content item={item}>
            <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
          </.accordion_content>
        </.accordion_item>
        <.accordion_item :let={item} ctx={ctx} value="donec">
          <.accordion_trigger item={item}>
            Donec condimentum ex mi
            <:indicator>
              <.accordion_indicator item={item}>
                <.heroicon name="hero-chevron-right" />
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>
          <.accordion_content item={item}>
            <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
          </.accordion_content>
        </.accordion_item>
      </.accordion_root>
    </.accordion>
    """
  end

  def api_demo_items do
    shared_items_full()
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Accordion.set_value(@id, "lorem")} class="button button--sm">
        Open Lorem
      </.action>
      <.action
        phx-click={Corex.Accordion.set_value(@id, ["lorem", "donec"])}
        class="button button--sm"
      >
        Lorem and Donec
      </.action>
      <.action phx-click={Corex.Accordion.set_value(@id, [])} class="button button--sm">
        Close all
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:accordion:set-value",
            to: "##{@id}",
            detail: %{value: ["lorem"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Open Lorem
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:accordion:set-value",
            to: "##{@id}",
            detail: %{value: ["lorem", "donec"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Lorem and Donec
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:accordion:set-value",
            to: "##{@id}",
            detail: %{value: []},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Close all
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} value="lorem" class="button button--sm">Open Lorem</.action>
      <.action phx-click={@event} value="lorem,donec" class="button button--sm">
        Lorem and Donec
      </.action>
      <.action phx-click={@event} value="" class="button button--sm">Close all</.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Accordion.value(@id)} class="button button--sm">Value</.action>
      <.action
        phx-click={Corex.Accordion.value(@id, respond_to: :client)}
        class="button button--sm"
      >
        Value (client only)
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:accordion:value", to: "##{@id}", detail: %{}, bubbles: false)}
        class="button button--sm"
      >
        Value
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:accordion:value",
            to: "##{@id}",
            detail: %{respond_to: "client"},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Value (client only)
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_value} class="button button--sm">Value</.action>
      <.action phx-click={@event_value_client_only} class="button button--sm">
        Value (client only)
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_focused_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_focused} class="button button--sm">Focused</.action>
      <.action phx-click={@event_focused_client_only} class="button button--sm">
        Focused (client only)
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_focused_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_focused} class="button button--sm">Focused</.action>
      <.action phx-click={@event_focused_client_only} class="button button--sm">
        Focused (client only)
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_focused_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_focused} class="button button--sm">Focused</.action>
      <.action phx-click={@event_focused_client_only} class="button button--sm">
        Focused (client only)
      </.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_item_state_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_lorem} class="button button--sm">lorem</.action>
      <.action phx-click={@event_duis} class="button button--sm">duis</.action>
      <.action phx-click={@event_donec} class="button button--sm">donec</.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_item_state_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_lorem} class="button button--sm">lorem</.action>
      <.action phx-click={@event_duis} class="button button--sm">duis</.action>
      <.action phx-click={@event_donec} class="button button--sm">donec</.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_item_state_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_lorem} class="button button--sm">lorem</.action>
      <.action phx-click={@event_duis} class="button button--sm">duis</.action>
      <.action phx-click={@event_donec} class="button button--sm">donec</.action>
    </div>
    <.accordion class="accordion" id={@id} items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_set_value_client_js_heex, do: api_string(:set_value_js_heex)
  def api_set_value_client_js_js, do: api_string(:set_value_js)
  def api_set_value_client_js_ts, do: api_string(:set_value_js_ts)
  def api_set_value_server_heex, do: api_string(:set_value_server_heex)
  def api_set_value_server_elixir, do: api_string(:set_value_server_elixir)
  def api_value_client_heex, do: api_string(:value_client_heex)
  def api_value_client_js_heex, do: api_string(:value_js_heex)
  def api_value_client_js_js, do: api_string(:value_js)
  def api_value_client_js_ts, do: api_string(:value_js_ts)
  def api_value_server_heex, do: api_string(:value_server_heex)
  def api_value_server_elixir, do: api_string(:value_elixir)
  def api_focused_client_heex, do: api_string(:focused_client_heex)
  def api_focused_client_js_heex, do: api_string(:focused_js_heex)
  def api_focused_client_js_js, do: api_string(:focused_js)
  def api_focused_client_js_ts, do: api_string(:focused_js_ts)
  def api_focused_server_heex, do: api_string(:focused_server_heex)
  def api_focused_server_elixir, do: api_string(:focused_elixir)
  def api_item_state_client_heex, do: api_string(:item_state_client_heex)
  def api_item_state_client_js_heex, do: api_string(:item_state_js_heex)
  def api_item_state_client_js_js, do: api_string(:item_state_js)
  def api_item_state_client_js_ts, do: api_string(:item_state_js_ts)
  def api_item_state_server_heex, do: api_string(:item_state_server_heex)
  def api_item_state_server_elixir, do: api_string(:item_state_elixir)

  defp api_string(key) do
    case key do
      :set_value_js_heex ->
        """
        <.action phx-click={JS.dispatch("corex:accordion:set-value", to: "#api-set-value-client-js", detail: %{value: ["lorem"]}, bubbles: false)}>Open Lorem</.action>
        <.action phx-click={JS.dispatch("corex:accordion:set-value", to: "#api-set-value-client-js", detail: %{value: ["lorem", "donec"]}, bubbles: false)}>Lorem and Donec</.action>
        <.action phx-click={JS.dispatch("corex:accordion:set-value", to: "#api-set-value-client-js", detail: %{value: []}, bubbles: false)}>Close all</.action>
        <.accordion id="api-set-value-client-js" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :set_value_js ->
        """
        const el = document.getElementById("api-set-value-client-js");
        el?.dispatchEvent(
          new CustomEvent("corex:accordion:set-value", {
            bubbles: false,
            detail: { value: ["lorem"] },
          })
        );
        el?.dispatchEvent(
          new CustomEvent("corex:accordion:set-value", {
            bubbles: false,
            detail: { value: ["lorem", "donec"] },
          })
        );
        el?.dispatchEvent(
          new CustomEvent("corex:accordion:set-value", {
            bubbles: false,
            detail: { value: [] },
          })
        );
        """

      :set_value_js_ts ->
        """
        const el = document.getElementById("api-set-value-client-js");
        const set = (value: string[]) =>
          el?.dispatchEvent(
            new CustomEvent("corex:accordion:set-value", {
              bubbles: false,
              detail: { value },
            })
          );
        set(["lorem"]);
        set(["lorem", "donec"]);
        set([]);
        """

      :set_value_server_heex ->
        """
        <.action phx-click="api_set_value_server" value="lorem">Open Lorem</.action>
        <.action phx-click="api_set_value_server" value="lorem,donec">Lorem and Donec</.action>
        <.action phx-click="api_set_value_server" value="">Close all</.action>
        <.accordion id="api-set-value-server" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :set_value_server_elixir ->
        """
        def handle_event("api_set_value_server", %{"value" => value}, socket) do
          {:noreply, Corex.Accordion.set_value(socket, "api-set-value-server", value)}
        end
        """

      :value_client_heex ->
        """
        <.action phx-click={Corex.Accordion.value("api-value-client")}>Value</.action>
        <.action phx-click={Corex.Accordion.value("api-value-client", respond_to: :client)}>Value (client only)</.action>
        <.accordion id="api-value-client" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :value_js_heex ->
        """
        <.action phx-click={JS.dispatch("corex:accordion:value", to: "#api-value-client-js", detail: %{}, bubbles: false)}>Value</.action>
        <.action phx-click={JS.dispatch("corex:accordion:value", to: "#api-value-client-js", detail: %{respond_to: "client"}, bubbles: false)}>Value (client only)</.action>
        <.accordion id="api-value-client-js" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :value_js ->
        """
        const layoutToast = (title, description) => {
          document.querySelector("#layout-toast")?.dispatchEvent(
            new CustomEvent("toast:create", {
              bubbles: true,
              detail: { title, description, type: "info", duration: 5000 },
            })
          );
        };
        const el = document.getElementById("api-value-client-js");
        el?.dispatchEvent(
          new CustomEvent("corex:accordion:value", { bubbles: false, detail: {} })
        );
        el?.addEventListener("accordion-value", (e) => {
          layoutToast(
            "accordion-value",
            `${e.detail.id}\\n${JSON.stringify(e.detail.value)}`
          );
        });
        """

      :value_js_ts ->
        """
        const layoutToast = (title: string, description: string) => {
          document.querySelector("#layout-toast")?.dispatchEvent(
            new CustomEvent("toast:create", {
              bubbles: true,
              detail: { title, description, type: "info", duration: 5000 },
            })
          );
        };
        const el = document.getElementById("api-value-client-js");
        el?.dispatchEvent(
          new CustomEvent("corex:accordion:value", { bubbles: false, detail: {} })
        );
        el?.addEventListener("accordion-value", (e: Event) => {
          const d = (e as CustomEvent<{ id: string; value: string[] | null }>).detail;
          layoutToast("accordion-value", `${d.id}\\n${JSON.stringify(d.value)}`);
        });
        """

      :value_server_heex ->
        """
        <.action phx-click="api_value_server">Value</.action>
        <.action phx-click="api_value_server_client_only">Value (client only)</.action>
        <.accordion id="api-value-server" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :value_elixir ->
        ~S"""
        def handle_event("api_value_server", _params, socket) do
          {:noreply, Corex.Accordion.value(socket, "api-value-server")}
        end

        def handle_event("api_value_server_client_only", _params, socket) do
          {:noreply, Corex.Accordion.value(socket, "api-value-server", respond_to: :client)}
        end

        def handle_event("accordion_value_response", %{"id" => id, "value" => value}, socket) do
          desc = "#{id}\n#{inspect(value)}"

          {:noreply,
           Corex.Toast.push_toast(socket, "layout-toast", "accordion_value_response", desc, :info, 5000)}
        end
        """

      :focused_client_heex ->
        """
        <.action phx-click="api_focused_client">Focused</.action>
        <.action phx-click="api_focused_client_client_only">Focused (client only)</.action>
        <.accordion id="api-focused-client" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :focused_js_heex ->
        """
        <.action phx-click="api_focused_js">Focused</.action>
        <.action phx-click="api_focused_js_client_only">Focused (client only)</.action>
        <.accordion id="api-focused-client-js" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :focused_js ->
        """
        const el = document.getElementById(\"api-focused-client-js\");
        el?.dispatchEvent(new CustomEvent(\"corex:accordion:focused\", { bubbles: false, detail: {} }));
        el?.dispatchEvent(
          new CustomEvent(\"corex:accordion:focused\", {
            bubbles: false,
            detail: { respond_to: \"client\" },
          })
        );
        """

      :focused_js_ts ->
        """
        const el = document.getElementById(\"api-focused-client-js\");
        const focused = (respond_to?: \"client\") =>
          el?.dispatchEvent(
            new CustomEvent(\"corex:accordion:focused\", {
              bubbles: false,
              detail: respond_to ? { respond_to } : {},
            })
          );
        focused();
        focused(\"client\");
        """

      :focused_server_heex ->
        """
        <.action phx-click="api_focused_server">Focused</.action>
        <.action phx-click="api_focused_server_client_only">Focused (client only)</.action>
        <.accordion id="api-focused-server" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :focused_elixir ->
        ~S"""
        def handle_event("api_focused_client", _params, socket) do
          Process.send_after(self(), {:accordion_api_focused_after_delay, "api-focused-client", []}, 5_000)
          {:noreply, socket}
        end

        def handle_event("api_focused_client_client_only", _params, socket) do
          Process.send_after(
            self(),
            {:accordion_api_focused_after_delay, "api-focused-client", [respond_to: :client]},
            5_000
          )

          {:noreply, socket}
        end

        def handle_event("api_focused_js", _params, socket) do
          Process.send_after(self(), {:accordion_api_focused_after_delay, "api-focused-client-js", []}, 5_000)
          {:noreply, socket}
        end

        def handle_event("api_focused_js_client_only", _params, socket) do
          Process.send_after(
            self(),
            {:accordion_api_focused_after_delay, "api-focused-client-js", [respond_to: :client]},
            5_000
          )

          {:noreply, socket}
        end

        def handle_event("api_focused_server", _params, socket) do
          Process.send_after(self(), {:accordion_api_focused_after_delay, "api-focused-server", []}, 5_000)
          {:noreply, socket}
        end

        def handle_event("api_focused_server_client_only", _params, socket) do
          Process.send_after(
            self(),
            {:accordion_api_focused_after_delay, "api-focused-server", [respond_to: :client]},
            5_000
          )

          {:noreply, socket}
        end
        """

      :item_state_client_heex ->
        """
        <.action phx-click={Corex.Accordion.item_state("api-item-client", "lorem")}>lorem</.action>
        <.action phx-click={Corex.Accordion.item_state("api-item-client", "duis")}>duis</.action>
        <.action phx-click={Corex.Accordion.item_state("api-item-client", "donec")}>donec</.action>
        <.accordion id="api-item-client" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :item_state_js_heex ->
        """
        <.action phx-click={JS.dispatch("corex:accordion:item-state", to: "#api-item-client-js", detail: %{value: "lorem"}, bubbles: false)}>lorem</.action>
        <.action phx-click={JS.dispatch("corex:accordion:item-state", to: "#api-item-client-js", detail: %{value: "duis"}, bubbles: false)}>duis</.action>
        <.action phx-click={JS.dispatch("corex:accordion:item-state", to: "#api-item-client-js", detail: %{value: "donec"}, bubbles: false)}>donec</.action>
        <.accordion id="api-item-client-js" items={Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :item_state_js ->
        """
        const el = document.getElementById(\"api-item-client-js\");
        const itemState = (value) =>
          el?.dispatchEvent(
            new CustomEvent(\"corex:accordion:item-state\", { bubbles: false, detail: { value } })
          );
        itemState(\"lorem\");
        itemState(\"duis\");
        itemState(\"donec\");
        """

      :item_state_js_ts ->
        """
        const el = document.getElementById(\"api-item-client-js\");
        const itemState = (value: string) =>
          el?.dispatchEvent(
            new CustomEvent(\"corex:accordion:item-state\", { bubbles: false, detail: { value } })
          );
        itemState(\"lorem\");
        itemState(\"duis\");
        itemState(\"donec\");
        """

      :item_state_server_heex ->
        """
        <.action phx-click=\"api_item_state_server_lorem\">lorem</.action>
        <.action phx-click=\"api_item_state_server_duis\">duis</.action>
        <.action phx-click=\"api_item_state_server_donec\">donec</.action>
        <.accordion id=\"api-item-server\" items={Corex.Content.new([
          %{value: \"lorem\", trigger: \"Lorem ipsum dolor sit amet\", content: \"Consectetur adipiscing elit. Sed sodales ullamcorper tristique.\"},
          %{value: \"duis\", trigger: \"Duis dictum gravida odio ac pharetra?\", content: \"Nullam eget vestibulum ligula, at interdum tellus.\"},
          %{value: \"donec\", trigger: \"Donec condimentum ex mi\", content: \"Congue molestie ipsum gravida a. Sed ac eros luctus.\", disabled: true}
        ])} />
        """

      :item_state_elixir ->
        ~S"""
        def handle_event("api_item_state_server_lorem", _params, socket) do
          {:noreply, Corex.Accordion.item_state(socket, "api-item-server", "lorem", disabled: false)}
        end

        def handle_event("api_item_state_server_duis", _params, socket) do
          {:noreply, Corex.Accordion.item_state(socket, "api-item-server", "duis", disabled: false)}
        end

        def handle_event("api_item_state_server_donec", _params, socket) do
          {:noreply, Corex.Accordion.item_state(socket, "api-item-server", "donec", disabled: true)}
        end
        """
    end
  end

  def styling_items do
    Corex.Content.new([
      %{
        value: "item-1",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "item-2",
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "item-3",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end

  def styling_color_example(assigns) do
    ~H"""
    <.accordion class="accordion" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--accent" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--brand" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--alert" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--success" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--info" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <.accordion class="accordion accordion--sm" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--md" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--lg" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_text_example(assigns) do
    ~H"""
    <.accordion class="accordion accordion--text-sm" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--text-xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--text-2xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--text-4xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <.accordion class="accordion accordion--rounded-none" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-sm" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-md" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-lg" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-full" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_max_width_example(assigns) do
    ~H"""
    <.accordion class="accordion max-w-2xs" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion max-w-md" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion max-w-xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion max-w-2xl" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_mix_modifiers_example(assigns) do
    ~H"""
    <.accordion
      class="accordion accordion--sm accordion--brand max-w-2xs"
      value="item-1"
      items={styling_items()}
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--sm max-w-none" value="item-1" items={styling_items()}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion
      class="accordion accordion--alert accordion--xl max-w-2xs"
      value="item-1"
      items={styling_items()}
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_color_code do
    ~S"""
    <.accordion class="accordion" items={Corex.Content.new([
      %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
    </.accordion>
    <.accordion class="accordion accordion--accent" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--brand" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--info" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--alert" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--success" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_size_code do
    ~S"""
    <.accordion class="accordion accordion--sm" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--md" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--lg" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_text_code do
    ~S"""
    <.accordion class="accordion accordion--text-sm" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--text-xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--text-2xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--text-4xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_radius_code do
    ~S"""
    <.accordion class="accordion accordion--rounded-none" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-sm" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-md" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-lg" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--rounded-full" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_max_width_code do
    ~S"""
    <.accordion class="accordion max-w-xs" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion max-w-sm" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion max-w-lg" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion max-w-5xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_mix_modifiers_code do
    ~S"""
    <.accordion class="accordion accordion--sm max-w-5xs" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--md max-w-xs" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--lg max-w-lg" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion class="accordion accordion--xl max-w-2xl" value="item-1" items={Corex.Content.new([
      %{value: "item-1", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "item-2", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "item-3", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])}>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def patterns_items do
    items_with_meta()
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={accordion} assign={@accordion}>
      <:loading>
        <.accordion_skeleton count={3} class="accordion" />
      </:loading>

      <.accordion id="patterns-async" class="accordion" items={accordion.items} value={accordion.value}>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.async_result>
    """
  end

  def patterns_async_heex_panel do
    ~S"""
    <.accordion id="patterns-async" class="accordion" items={accordion.items} value={accordion.value}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def patterns_async_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      socket =
        assign_async(socket, :accordion, fn ->
          Process.sleep(1000)

          items =
            Corex.Content.new([
              %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
              %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
              %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
            ])

          {:ok, %{accordion: %{items: items, value: ["duis"]}}}
        end)

      {:ok, socket}
    end
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.accordion
      id="patterns-controlled"
      class="accordion"
      items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
      multiple={false}
      controlled
      value={["lorem"]}
      on_value_change="patterns_controlled_changed"
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      items =
        Corex.Content.new([
          %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])

      socket =
        socket
        |> assign(:value, ["lorem"])
        |> assign(:items, items)

      {:ok, socket}
    end

    def handle_event("patterns_controlled_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :value, value)}
    end
    """
  end

  def patterns_open_single_heex do
    ~S"""
    <.accordion
      id="patterns-open-single"
      class="accordion"
      items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
      multiple={false}
      value="lorem"
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def patterns_open_multiple_heex do
    ~S"""
    <.accordion
      id="patterns-open-multiple"
      class="accordion"
      items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
      multiple
      value={["lorem", "donec"]}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def animation_items do
    items_with_meta()
  end

  def animation_playground_heex do
    ~S"""
    <.accordion
      id="accordion-animation-playground"
      class="accordion"
      animation="js"
      animation_options={
        %Corex.Animation.Height{
          duration: 0.3,
          easing: "ease",
          opacity_start: 0,
          opacity_end: 1
        }
      }
      items={
        Corex.Content.new([
          %{
            value: "lorem",
            trigger: "Lorem ipsum dolor sit amet",
            content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
          },
          %{
            value: "duis",
            trigger: "Duis dictum gravida odio ac pharetra?",
            content: "Nullam eget vestibulum ligula, at interdum tellus."
          },
          %{
            value: "donec",
            trigger: "Donec condimentum ex mi",
            content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
          }
        ])
      }
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def animation_instant_heex do
    ~S"""
    <.accordion
      class="accordion"
      animation="instant"
      items={Corex.Content.new([
        %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def animation_custom_heex do
    ~S"""
    <.accordion
      class="accordion"
      animation="custom"
      on_value_change_client="my-accordion-changed"
      items={Corex.Content.new([
        %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def animation_custom_js do
    ~S"""
    document.addEventListener("my-accordion-changed", (e) => {
      const accordionEl = document.getElementById(e.detail.id);
      if (!accordionEl) return;
      const openValues = e.detail.value;
      const contentEls = accordionEl.querySelectorAll(
        '[data-scope="accordion"][data-part="item-content"]'
      );
      contentEls.forEach(el => {
        const itemEl = el.closest('[data-scope="accordion"][data-part="item"]');
        const value = itemEl?.dataset.value;
        const isOpen = openValues.includes(value);
        const wasOpen = el.dataset.state === "open";
        if (isOpen === wasOpen) return;
        animate(
          el,
          {
            height: isOpen ? ["0px", "auto"] : ["auto", "0px"],
            opacity: isOpen ? [0, 1] : [1, 0],
          },
          { duration: 0.2, easing: "ease" }
        )
      });
    });
    """
  end

  def events_items do
    shared_items_full()
  end

  def events_server_heex do
    ~S"""
    <.accordion
      id="events-on-value-change-server"
      class="accordion"
      items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
      on_value_change="accordion_value_changed"
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def events_server_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, socket |> assign(:logs, [])}
    end

    def handle_event("accordion_value_changed", %{"id" => id, "value" => value}, socket) do
      socket =
        socket
        |> update(:logs, fn logs -> [new_log("server", id, value) | logs] |> Enum.take(25) end)

      {:noreply, socket}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.accordion
      id="events-on-value-change-client"
      class="accordion"
      items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
      on_value_change_client="accordion-value-changed"
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("events-on-value-change-client");
    el?.addEventListener("accordion-value-changed", (event) => {
      const detail = event.detail;
      console.log(detail.id, detail.value);
    });
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("events-on-value-change-client");
    type Detail = { id: string; value: string[] };
    el?.addEventListener("accordion-value-changed", (event: Event) => {
      const detail = (event as CustomEvent<Detail>).detail;
      console.log(detail.id, detail.value);
    });
    """
  end
end
