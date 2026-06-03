defmodule E2eWeb.Demos.AccordionDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def minimal_example(assigns) do
    ~H"""
    <.accordion items={items_basic()} />
    """
  end

  def minimal_unstyled_example(assigns) do
    ~H"""
    <.accordion unstyled items={items_basic()} />
    """
  end

  def minimal_snippets do
    E2eWeb.AuthoringSnippet.accordion_anatomy_snippets([],
      slots: ~s( items={#{code_items_basic()}})
    )
  end

  def with_indicator_example(assigns) do
    ~H"""
    <.accordion items={items_basic()}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def with_indicator_unstyled_example(assigns) do
    ~H"""
    <.accordion unstyled items={items_basic()}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def with_indicator_snippets do
    E2eWeb.AuthoringSnippet.accordion_anatomy_snippets(
      [],
      inner: ~s(
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    ),
      slots: ~s( items={#{code_items_basic()}})
    )
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.accordion items={items_with_meta()}>
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
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

  def custom_slots_unstyled_example(assigns) do
    ~H"""
    <.accordion unstyled items={items_with_meta()}>
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
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

  def custom_slots_snippets do
    E2eWeb.AuthoringSnippet.accordion_anatomy_snippets(
      [value: "lorem"],
      inner: ~s(
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
      </:trigger>
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator :let={item}>
        <.heroicon name={item.meta.indicator} />
      </:indicator>
    ),
      slots: ~s( items={#{code_items_with_meta()}})
    )
  end

  def manual_slots_example(assigns) do
    ~H"""
    <.accordion id="accordion-anatomy-manual" value="lorem">
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

  def manual_slots_unstyled_example(assigns) do
    ~H"""
    <.accordion unstyled id="accordion-anatomy-manual" value="lorem">
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

  def manual_slots_snippets do
    E2eWeb.AuthoringSnippet.heex_snippets(manual_slots_code())
  end

  def compound_snippets do
    E2eWeb.AuthoringSnippet.heex_snippets(compound_code())
  end

  def heex_snippets(code) when is_binary(code) do
    E2eWeb.AuthoringSnippet.heex_snippets(code)
  end

  def manual_slots_code do
    ~S"""
    <.accordion  value="lorem">
      <:trigger value="lorem">
        <.heroicon name="hero-chevron-right" /> Lorem ipsum dolor sit amet
      </:trigger>
      <:content value="lorem"><p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p></:content>
      <:indicator value="lorem">
        <.heroicon name="hero-chevron-down" />
      </:indicator>

      <:trigger value="duis">
        <.heroicon name="hero-chevron-right" /> Duis dictum gravida odio ac pharetra?
      </:trigger>
      <:content value="duis"><p>Nullam eget vestibulum ligula, at interdum tellus.</p></:content>
      <:indicator value="duis">
        <.heroicon name="hero-chevron-down" />
      </:indicator>
    </.accordion>
    """
  end

  def nested_items do
    E2eWeb.Demos.DocExamples.content_items_with_values()
  end

  def items_basic, do: E2eWeb.Demos.DocExamples.content_items()

  def items_with_meta, do: E2eWeb.Demos.DocExamples.content_items_with_meta()

  def shared_items_full, do: E2eWeb.Demos.DocExamples.content_items_with_values()

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Accordion.set_value("api-set-value-client", "lorem")}>Open Lorem</.action>
    <.action phx-click={Corex.Accordion.set_value("api-set-value-client", ["lorem", "donec"])}>Lorem and Donec</.action>
    <.action phx-click={Corex.Accordion.set_value("api-set-value-client", [])}>Close all</.action>
    <.accordion id="api-set-value-client" items={Corex.Content.new([
      %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])} />
    """
  end

  def code_items_basic, do: E2eWeb.Demos.DocExamples.code_content_items()

  def code_items_with_meta do
    ~S"""
    Corex.Content.new([
      %{
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      },
      %{
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      }
    ])
    """
  end

  def minimal_code do
    ~S"""
    <.accordion
      
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

  def with_indicator_code do
    ~S"""
    <.accordion
      
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])
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
      
      value="lorem"
      items={
        Corex.Content.new([
          %{
            value: "lorem",
            label: "Lorem ipsum dolor sit amet",
            content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
            meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
          },
          %{
            label: "Duis dictum gravida odio ac pharetra?",
            content: "Nullam eget vestibulum ligula, at interdum tellus.",
            meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
          },
          %{
            value: "donec",
            label: "Donec condimentum ex mi",
            content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
            disabled: true,
            meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
          }
        ])
      }
    >
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
      </:trigger>
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator :let={item}>
        <.heroicon name={item.meta.indicator} />
      </:indicator>
    </.accordion>
    """
  end

  def compound_code do
    ~S"""
    <.accordion :let={ctx} compound>
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
    <.accordion :let={ctx} compound>
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
      <.action phx-click={Corex.Accordion.set_value(@id, "lorem")} size="sm">
        Open Lorem
      </.action>
      <.action
        phx-click={Corex.Accordion.set_value(@id, ["lorem", "donec"])}
        size="sm"
      >
        Lorem and Donec
      </.action>
      <.action phx-click={Corex.Accordion.set_value(@id, [])} size="sm">
        Close all
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
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
        size="sm"
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
        size="sm"
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
        size="sm"
      >
        Close all
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} value="lorem" size="sm">Open Lorem</.action>
      <.action phx-click={@event} value="lorem,donec" size="sm">
        Lorem and Donec
      </.action>
      <.action phx-click={@event} value="" size="sm">Close all</.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Accordion.value(@id)} size="sm">Value</.action>
      <.action
        phx-click={Corex.Accordion.value(@id, respond_to: :client)}
        size="sm"
      >
        Value (client only)
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
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
        size="sm"
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
        size="sm"
      >
        Value (client only)
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_value} size="sm">Value</.action>
      <.action phx-click={@event_value_client_only} size="sm">
        Value (client only)
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_focused_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_focused} size="sm">Focused</.action>
      <.action phx-click={@event_focused_client_only} size="sm">
        Focused (client only)
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_focused_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_focused} size="sm">Focused</.action>
      <.action phx-click={@event_focused_client_only} size="sm">
        Focused (client only)
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_focused_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_focused} size="sm">Focused</.action>
      <.action phx-click={@event_focused_client_only} size="sm">
        Focused (client only)
      </.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_item_state_client_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_lorem} size="sm">lorem</.action>
      <.action phx-click={@event_duis} size="sm">duis</.action>
      <.action phx-click={@event_donec} size="sm">donec</.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_item_state_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_lorem} size="sm">lorem</.action>
      <.action phx-click={@event_duis} size="sm">duis</.action>
      <.action phx-click={@event_donec} size="sm">donec</.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  def api_item_state_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_lorem} size="sm">lorem</.action>
      <.action phx-click={@event_duis} size="sm">duis</.action>
      <.action phx-click={@event_donec} size="sm">donec</.action>
    </div>
    <.accordion
      id={@id}
      items={@items}
      unstyled={Map.get(assigns, :unstyled, false)}
      class={unless Map.get(assigns, :unstyled, false), do: "accordion"}
    >
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
        const el: HTMLElement | null = document.getElementById("api-set-value-client-js");
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :value_js_heex ->
        """
        <.action phx-click={JS.dispatch("corex:accordion:value", to: "#api-value-client-js", detail: %{}, bubbles: false)}>Value</.action>
        <.action phx-click={JS.dispatch("corex:accordion:value", to: "#api-value-client-js", detail: %{respond_to: "client"}, bubbles: false)}>Value (client only)</.action>
        <.accordion id="api-value-client-js" items={Corex.Content.new([
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
        const el: HTMLElement | null = document.getElementById("api-value-client-js");
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
           Corex.Toast.create(socket, "layout-toast", "accordion_value_response", desc, :info, duration: 5000)}
        end
        """

      :focused_client_heex ->
        """
        <.action phx-click="api_focused_client">Focused</.action>
        <.action phx-click="api_focused_client_client_only">Focused (client only)</.action>
        <.accordion id="api-focused-client" items={Corex.Content.new([
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :focused_js_heex ->
        """
        <.action phx-click="api_focused_js">Focused</.action>
        <.action phx-click="api_focused_js_client_only">Focused (client only)</.action>
        <.accordion id="api-focused-client-js" items={Corex.Content.new([
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
        const el: HTMLElement | null = document.getElementById(\"api-focused-client-js\");
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
        ])} />
        """

      :item_state_js_heex ->
        """
        <.action phx-click={JS.dispatch("corex:accordion:item-state", to: "#api-item-client-js", detail: %{value: "lorem"}, bubbles: false)}>lorem</.action>
        <.action phx-click={JS.dispatch("corex:accordion:item-state", to: "#api-item-client-js", detail: %{value: "duis"}, bubbles: false)}>duis</.action>
        <.action phx-click={JS.dispatch("corex:accordion:item-state", to: "#api-item-client-js", detail: %{value: "donec"}, bubbles: false)}>donec</.action>
        <.accordion id="api-item-client-js" items={Corex.Content.new([
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
        const el: HTMLElement | null = document.getElementById(\"api-item-client-js\");
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
        <.accordion class=\"accordion\" id=\"api-item-server\" items={Corex.Content.new([
          %{value: \"lorem\", label: \"Lorem ipsum dolor sit amet\", content: \"Consectetur adipiscing elit. Sed sodales ullamcorper tristique.\"},
          %{value: \"duis\", label: \"Duis dictum gravida odio ac pharetra?\", content: \"Nullam eget vestibulum ligula, at interdum tellus.\"},
          %{value: \"donec\", label: \"Donec condimentum ex mi\", content: \"Congue molestie ipsum gravida a. Sed ac eros luctus.\", disabled: true}
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

  @styling_matrix_variants ~w(solid ghost outline subtle)

  @styling_matrix_semantics [
    {"Default", nil},
    {"Accent", "accent"},
    {"Brand", "brand"},
    {"Alert", "alert"},
    {"Info", "info"},
    {"Success", "success"}
  ]

  def styling_variant_semantic_values do
    "Variants: #{styling_axis_values(:variant)} · Semantics: default, #{styling_axis_values(:semantic)}"
  end

  def styling_variant_semantic_code do
    """
    <.accordion variant="solid" items={items}>
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion variant="solid" semantic="accent" items={items}>
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_variant_semantic_example(assigns) do
    assigns =
      assign(assigns,
        variants: @styling_matrix_variants,
        semantics: @styling_matrix_semantics,
        items: styling_items()
      )

    ~H"""
    <.stack gap="lg" width="full">
      <.stack :for={variant <- @variants} gap="sm" width="full">
        <.small>{variant}</.small>
        <.stack gap="md" width="full">
          <.accordion
            :for={{label, semantic} <- @semantics}
            id={"accordion-style-#{variant}-#{semantic || "default"}"}
            variant={variant}
            semantic={semantic}
            value="lorem"
            items={@items}
            width="full"
          >
            <:content :let={item}>
              <p>{item.content}</p>
            </:content>
            <:indicator>
              <.heroicon name="hero-chevron-right" />
            </:indicator>
          </.accordion>
        </.stack>
      </.stack>
    </.stack>
    """
  end

  def styling_size_code do
    ~S"""
    <.accordion size="sm" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion size="md" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion size="lg" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion size="xl" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :items, styling_items())

    ~H"""
    <.stack gap="md" width="full">
      <.accordion
        :for={size <- ~w(sm md lg xl)}
        id={"accordion-style-size-#{size}"}
        size={size}
        value="lorem"
        items={@items}
        width="full"
      >
        <:content :let={item}>
          <p>{item.content}</p>
        </:content>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.stack>
    """
  end

  def styling_text_code do
    ~S"""
    <.accordion text="sm" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion text="xl" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion text="2xl" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_text_example(assigns) do
    assigns = assign(assigns, :items, styling_items())

    ~H"""
    <.stack gap="md" width="full">
      <.accordion
        :for={text <- ~w(sm base lg xl 2xl 4xl)}
        id={"accordion-style-text-#{text}"}
        text={text}
        value="lorem"
        items={@items}
        width="full"
      >
        <:content :let={item}>
          <p>{item.content}</p>
        </:content>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.stack>
    """
  end

  def styling_radius_code do
    ~S"""
    <.accordion radius="none" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion radius="lg" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion radius="full" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_radius_example(assigns) do
    assigns = assign(assigns, :items, styling_items())

    ~H"""
    <.stack gap="md" width="full">
      <.accordion
        :for={radius <- ~w(none sm md lg xl full)}
        id={"accordion-style-radius-#{radius}"}
        radius={radius}
        value="lorem"
        items={@items}
        width="full"
      >
        <:content :let={item}>
          <p>{item.content}</p>
        </:content>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.stack>
    """
  end

  def styling_max_width_code do
    ~S"""
    <.accordion max_width="2xs" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion max_width="md" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion max_width="xl" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion max_width="2xl" items={items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :items, styling_items())

    ~H"""
    <.stack gap="md" width="full">
      <.accordion
        :for={max_width <- ~w(2xs md xl 2xl)}
        id={"accordion-style-max-width-#{max_width}"}
        max_width={max_width}
        value="lorem"
        items={@items}
        width="full"
      >
        <:content :let={item}>
          <p>{item.content}</p>
        </:content>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.stack>
    """
  end

  def styling_height_code do
    ~S"""
    <.accordion max_height="sm" items={long_items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion max_height="md" items={long_items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    <.accordion max_height="lg" items={long_items} width="full">
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    """
  end

  def styling_height_example(assigns) do
    assigns = assign(assigns, :items, styling_height_items())

    ~H"""
    <.stack gap="md" width="full">
      <.accordion
        :for={max_height <- ~w(sm md lg)}
        id={"accordion-style-max-height-#{max_height}"}
        max_height={max_height}
        value="lorem"
        items={@items}
        width="full"
      >
        <:content :let={item}>
          <p>{item.content}</p>
        </:content>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.stack>
    """
  end

  def styling_items, do: E2eWeb.Demos.DocExamples.content_items_with_values()

  def styling_height_items, do: E2eWeb.Demos.DocExamples.content_items_with_values_long()

  def patterns_items do
    items_with_meta()
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={accordion} assign={@accordion}>
      <:loading>
        <.accordion_skeleton count={3}  />
      </:loading>

      <.accordion items={accordion.items} value={accordion.value}>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.async_result>
    """
  end

  def patterns_async_heex_panel do
    ~S"""
    <.accordion items={accordion.items} value={accordion.value}>
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
              %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
              %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
              %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
      
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
          %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
          %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
          %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
      <.accordion items={Corex.Content.new(@items_list)}>
        <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
      </.accordion>
    </div>
    """
  end

  def patterns_stream_elixir do
    ~S'''
    defmodule MyAppWeb.AccordionStreamDemoLive do
      use MyAppWeb, :live_view

      @initial_items [
        %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ]

      @impl true
      def mount(_params, _session, socket) do
        socket =
          socket
          |> stream_configure(:items, dom_id: &("accordion:stream-accordion:item:" <> to_string(&1.value)))
          |> stream(:items, @initial_items)
          |> assign(:items_list, @initial_items)
          |> assign(:next_id, 4)

        if connected?(socket) do
          Process.send_after(self(), :add_timestamp_item, 3_000)
        end

        {:ok, socket}
      end

      @impl true
      def handle_info(:add_timestamp_item, socket) do
        Process.send_after(self(), :add_timestamp_item, 10_000)
        id = to_string(socket.assigns.next_id)

        time =
          DateTime.utc_now()
          |> DateTime.truncate(:second)
          |> DateTime.to_time()
          |> Time.to_string()

        item = %{
          value: id,
          label: "Item " <> id <> " @ " <> time,
          content: "Content for item " <> id <> "."
        }

        {:noreply,
         socket
         |> stream_insert(:items, item)
         |> assign(:items_list, socket.assigns.items_list ++ [item])
         |> assign(:next_id, socket.assigns.next_id + 1)}
      end

      @impl true
      def handle_event("add_item", _params, socket) do
        id = to_string(socket.assigns.next_id)
        item = %{value: id, label: "Item " <> id, content: "Content for item " <> id <> "."}

        {:noreply,
         socket
         |> stream_insert(:items, item)
         |> assign(:items_list, socket.assigns.items_list ++ [item])
         |> assign(:next_id, socket.assigns.next_id + 1)}
      end

      @impl true
      def handle_event("reset", _params, socket) do
        {:noreply,
         socket
         |> stream(:items, @initial_items, reset: true)
         |> assign(:items_list, @initial_items)
         |> assign(:next_id, 4)}
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
            <.accordion id="stream-accordion"  items={Corex.Content.new(@items_list)}>
              <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
            </.accordion>
          </div>
        """
      end
    end
    '''
  end

  def animation_items do
    items_with_meta()
  end

  def animation_playground_heex do
    ~S"""
    <.accordion
      
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
      
      animation="instant"
      items={Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def animation_custom_heex do
    ~S"""
    <.accordion
      
      animation="custom"
      on_value_change_client="my-accordion-changed"
      items={Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])}
    />
    """
  end

  def animation_custom_js do
    ~S"""
    import { animate } from "motion"
    import {
      findAccordionContent,
      animateHeightOpen,
      animateHeightClose,
    } from "corex"

    const reducedMotion = () =>
      window.matchMedia("(prefers-reduced-motion: reduce)").matches

    document.addEventListener("my-accordion-changed", (e) => {
      const root = document.getElementById(e.detail.id)
      if (!root) return
      e.detail.added.forEach((v) => {
        const el = findAccordionContent(root, v)
        if (!el) return
        animateHeightOpen(el, { animator: animate, duration: 0.55, easing: [0.16, 1, 0.3, 1] })
        if (!reducedMotion()) {
          animate(
            el,
            { filter: ["blur(12px)", "blur(0px)"], scale: [0.96, 1] },
            { duration: 0.6, easing: [0.16, 1, 0.3, 1] },
          )
        }
      })
      e.detail.removed.forEach((v) => {
        const el = findAccordionContent(root, v)
        if (!el) return
        animateHeightClose(el, { animator: animate, duration: 0.32, easing: [0.7, 0, 0.84, 0] })
        if (!reducedMotion()) {
          animate(
            el,
            { filter: ["blur(0px)", "blur(10px)"], scale: [1, 0.97] },
            { duration: 0.3, easing: "ease-in" },
          )
        }
      })
    })
    """
  end

  def events_items do
    shared_items_full()
  end

  def events_server_heex do
    ~S"""
    <.accordion
      
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "accordion_value_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.accordion id="events-on-value-change-client"
      
      items={Corex.Content.new([
        %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
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
