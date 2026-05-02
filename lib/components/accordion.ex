defmodule Corex.Accordion do
  @moduledoc ~S'''
  Phoenix implementation of the [Zag.js Accordion](https://zagjs.com/components/react/accordion).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.accordion
  class="accordion"
  items={
    Corex.Content.new([
      %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
      %{trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
      %{trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
    ])
  }
  />
  ```

  ### With slots

  With `items` and `<:indicator>` slot so every panel shares the same indicator markup.

  ```heex
  <.accordion
  class="accordion"
  items={
    Corex.Content.new([
      %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
      %{trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
      %{trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
    ])
  }
  >
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
  </.accordion>
  ```

  ### Custom slots

  With `items`, customize each item using slots with `:let={item}` to access the item and its `meta` data

  ```heex
  <.accordion
    class="accordion"
    value="lorem"
    items={
      Corex.Content.new([
        %{
          value: "lorem",
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
          value: "donec",
          trigger: "Donec condimentum ex mi",
          content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
          disabled: true,
          meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
        }
      ])
    }
  >
    <:trigger :let={item}>
      <.heroicon name={item.meta.icon} />{item.trigger}
    </:trigger>
    <:content :let={item}><p>{item.content}</p></:content>
    <:indicator :let={item}>
      <.heroicon name={item.meta.indicator} />
    </:indicator>
  </.accordion>
  ```

  ### Manual slots

  With an empty `items` list, use multiple `:trigger`, `:content`, and optional `:indicator` slots. 

  Each slot takes a `value` string that ties the three together. 

  ```heex
  <.accordion class="accordion" value="lorem">
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
  ```

  ### Compound

  Take full structural control with the `accordion_root`, `accordion_item`, `accordion_trigger`, `accordion_content`, and `accordion_indicator` sub-components.

  #### Manual items

  ```heex
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
  ```

  #### From a list

  ```heex
  <.accordion :let={ctx} compound id="faq" class="accordion">
    <.accordion_root ctx={ctx}>
      <.accordion_item :for={entry <- @items} :let={item} ctx={ctx} value={entry.value}>
        <.accordion_trigger item={item}>
          {entry.trigger}
          <:indicator>
            <.accordion_indicator item={item}>
              <.heroicon name="hero-chevron-right" />
            </.accordion_indicator>
          </:indicator>
        </.accordion_trigger>
        <.accordion_content item={item}>
          <p>{entry.content}</p>
        </.accordion_content>
      </.accordion_item>
    </.accordion_root>
  </.accordion>
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Async

  ```elixir
  defmodule MyAppWeb.AccordionAsyncLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      socket =
        socket
        |> assign_async(:accordion, fn ->
          items =
            Corex.Content.new([
              %{
                value: "lorem",
                trigger: "Lorem ipsum dolor sit amet",
                content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
                disabled: true
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

          {:ok, %{accordion: %{items: items, value: ["duis", "donec"]}}}
        end)

      {:ok, socket}
    end

    def render(assigns) do
      ~H"""
      <.async_result :let={accordion} assign={@accordion}>
        <:loading>
          <.accordion_skeleton count={3} class="accordion" />
        </:loading>
        <:failed>Could not load accordion.</:failed>
        <.accordion
          id="async-accordion"
          class="accordion"
          items={accordion.items}
          value={accordion.value}
        />
      </.async_result>
      """
    end
  end
  ```

  ### Controlled

  ```elixir
  defmodule MyAppWeb.AccordionLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :accordion_value, ["lorem"])}
    end

    def handle_event("accordion_value_changed", %{"id" => _id, "value" => value}, socket) do
      {:noreply, assign(socket, :accordion_value, value)}
    end

    def render(assigns) do
      ~H"""
      <.accordion
        id="my-accordion"
        controlled
        value={@accordion_value}
        on_value_change="accordion_value_changed"
        class="accordion"
        items={
          Corex.Content.new([
            %{
              value: "lorem",
              trigger: "Lorem ipsum dolor sit amet",
              content: "Consectetur adipiscing elit."
            },
            %{
              value: "duis",
              trigger: "Duis dictum gravida odio ac pharetra?",
              content: "Nullam eget vestibulum ligula."
            }
          ])
        }
      />
      """
    end
  end
  ```

  <!-- tabs-close -->

  ## Animation

  <!-- tabs-open -->

  ### `js`

  Built-in height and opacity via the Web Animations API. Tune timing with `animation_options` using `Corex.Animation.Height`.

  ```heex
  <.accordion
    class="accordion"
    animation="js"
    animation_options={%Corex.Animation.Height{duration: 0.3, easing: "ease-out", opacity_start: 0, opacity_end: 1}}
    items={
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
    }
  >
    <:indicator>
      <.heroicon name="hero-chevron-right" />
    </:indicator>
  </.accordion>
  ```

  ### `instant`

  Zag toggles the native `hidden` attribute; no height animation.

  ```heex
  <.accordion
    class="accordion"
    animation="instant"
    items={
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
    }
  >
    <:indicator>
      <.heroicon name="hero-chevron-right" />
    </:indicator>
  </.accordion>
  ```

  ### `custom`

  The hook removes `hidden` and dispatches a browser `CustomEvent` when the value changes. Use `on_value_change_client` for the event name. The event `detail` is enriched with deltas so user code rarely needs DOM lookups beyond the affected items:

      // event.detail (AccordionChangedDetail)
      { id, value, previousValue, added, removed }

  Animate panels in your own JS. The example below also seeds initial closed-state styling on mount and after LiveView navigations.

  ```heex
  <.accordion
    id="accordion-custom-animate"
    class="accordion"
    animation="custom"
    on_value_change_client="my-accordion-changed"
    items={
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
    }
  >
    <:indicator>
      <.heroicon name="hero-chevron-right" />
    </:indicator>
  </.accordion>
  ```

  ```javascript
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
  ```

  <!-- tabs-close -->

  ## API

  These helpers target one accordion via its DOM `id`. Use them from LiveView (server), from HEEx bindings (client binding), or from plain JavaScript/TypeScript (client JS).

  For `value`, `focused`, and `item_state`, you can pass `respond_to: :server | :client | :both` to control whether the response is pushed to LiveView, dispatched as a DOM event, or both.

  ### Set value

  Open/close panels programmatically.

  <!-- tabs-open -->

  #### Server

  ```heex
  <.action phx-click="open_lorem" class="button button--sm">Open Lorem</.action>
  <.action phx-click="open_lorem_and_donec" class="button button--sm">Lorem and Donec</.action>
  <.action phx-click="close_all" class="button button--sm">Close all</.action>

  <.accordion
    id="my-accordion"
    class="accordion"
    items={
      Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])
    }
  />
  ```

  ```elixir
  def handle_event("open_lorem", _params, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["lorem"])}
  end

  def handle_event("open_lorem_and_donec", _params, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["lorem", "donec"])}
  end

  def handle_event("close_all", _params, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", [])}
  end
  ```

  #### Client Binding

  ```heex
  <.action phx-click={Corex.Accordion.set_value("my-accordion", ["lorem"])} class="button button--sm">
    Open Lorem
  </.action>
  <.action
    phx-click={Corex.Accordion.set_value("my-accordion", ["lorem", "donec"])}
    class="button button--sm"
  >
    Lorem and Donec
  </.action>
  <.action phx-click={Corex.Accordion.set_value("my-accordion", [])} class="button button--sm">
    Close all
  </.action>

  <.accordion
    id="my-accordion"
    class="accordion"
    items={
      Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])
    }
  />
  ```

  #### Client JS

  ```javascript
  const el = document.getElementById("my-accordion");
  const set = (value) =>
    el?.dispatchEvent(
      new CustomEvent("corex:accordion:set-value", {
        bubbles: false,
        detail: { value },
      })
    );

  set(["lorem"]);
  set(["lorem", "donec"]);
  set([]);
  ```

  ```typescript
  const el = document.getElementById("my-accordion");
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
  ```

  <!-- tabs-close -->

  ### Read value

  Ask the browser what is currently open.

  <!-- tabs-open -->

  #### Server

  ```elixir
  def handle_event("read_value", _params, socket) do
    {:noreply, Corex.Accordion.value(socket, "my-accordion")}
  end

  def handle_event("accordion_value_response", %{"id" => "my-accordion", "value" => value}, socket) do
    {:noreply, assign(socket, :accordion_value, value)}
  end
  ```

  #### Client Binding

  ```heex
  <.action phx-click={Corex.Accordion.value("my-accordion")} class="button button--sm">
    Value
  </.action>
  ```

  #### Client JS

  ```javascript
  const el = document.getElementById("my-accordion");
  el?.dispatchEvent(new CustomEvent("corex:accordion:value", { bubbles: false, detail: {} }));

  el?.addEventListener("accordion-value", (e) => {
    console.log(e.detail.id, e.detail.value);
  });
  ```

  ```typescript
  const el = document.getElementById("my-accordion");
  type Detail = { id: string; value: string[] | null };

  el?.dispatchEvent(new CustomEvent("corex:accordion:value", { bubbles: false, detail: {} }));
  el?.addEventListener("accordion-value", (event: Event) => {
    const detail = (event as CustomEvent<Detail>).detail;
    console.log(detail.id, detail.value);
  });
  ```

  <!-- tabs-close -->

  ### Read focused

  Ask the browser which item is currently focused.

  <!-- tabs-open -->

  #### Server

  ```elixir
  def handle_event("read_focused", _params, socket) do
    {:noreply, Corex.Accordion.focused(socket, "my-accordion")}
  end

  def handle_event("accordion_focused_response", %{"id" => "my-accordion", "value" => value}, socket) do
    {:noreply, assign(socket, :accordion_focused, value)}
  end
  ```

  #### Client Binding

  ```heex
  <.action phx-click={Corex.Accordion.focused("my-accordion")} class="button button--sm">
    Focused
  </.action>
  ```

  #### Client JS

  ```javascript
  const el = document.getElementById("my-accordion");
  el?.dispatchEvent(new CustomEvent("corex:accordion:focused", { bubbles: false, detail: {} }));

  el?.addEventListener("accordion-focused", (e) => {
    console.log(e.detail.id, e.detail.value);
  });
  ```

  ```typescript
  const el = document.getElementById("my-accordion");
  type Detail = { id: string; value: string | null };

  el?.dispatchEvent(new CustomEvent("corex:accordion:focused", { bubbles: false, detail: {} }));
  el?.addEventListener("accordion-focused", (event: Event) => {
    const detail = (event as CustomEvent<Detail>).detail;
    console.log(detail.id, detail.value);
  });
  ```

  <!-- tabs-close -->

  ### Read item state

  Ask the browser for one item's state.

  <!-- tabs-open -->

  #### Server

  ```elixir
  def handle_event("read_item_state", _params, socket) do
    {:noreply, Corex.Accordion.item_state(socket, "my-accordion", "lorem", disabled: false)}
  end

  def handle_event(
        "accordion_item_state_response",
        %{"id" => "my-accordion", "value" => value, "state" => state},
        socket
      ) do
    {:noreply, assign(socket, :accordion_item_state, {value, state})}
  end
  ```

  #### Client Binding

  ```heex
  <.action
    phx-click={Corex.Accordion.item_state("my-accordion", "lorem", disabled: false)}
    class="button button--sm"
  >
    item_state("lorem")
  </.action>
  <.action
    phx-click={Corex.Accordion.item_state("my-accordion", "donec", disabled: true)}
    class="button button--sm"
  >
    item_state("donec", disabled)
  </.action>
  ```

  #### Client JS

  ```javascript
  const el = document.getElementById("my-accordion");
  el?.addEventListener("accordion-item-state", (e) => console.log(e.detail));

  el?.dispatchEvent(
    new CustomEvent("corex:accordion:item-state", {
      bubbles: false,
      detail: { value: "lorem", disabled: false, respond_to: "client" },
    })
  );
  ```

  ```typescript
  const el = document.getElementById("my-accordion");
  type State = { expanded: boolean; focused: boolean; disabled: boolean };
  type Detail = { id: string; value: string; state: State };

  el?.addEventListener("accordion-item-state", (event: Event) => {
    const detail = (event as CustomEvent<Detail>).detail;
    console.log(detail.id, detail.value, detail.state);
  });
  ```

  <!-- tabs-close -->

  ## Events

  Use `on_*` to receive value/focus changes either in LiveView (`pushEvent`) or in the browser (`CustomEvent`).

  <!-- tabs-open -->

  ### Server (LiveView)

  ```heex
  <.accordion
    id="my-accordion"
    class="accordion"
    items={
      Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])
    }
    on_value_change="accordion_value_changed"
    on_focus_change="accordion_focus_changed"
  />
  ```

  ```elixir
  def handle_event("accordion_value_changed", %{"id" => id, "value" => value}, socket) do
    {:noreply, assign(socket, :accordion_open, {id, value})}
  end

  def handle_event("accordion_focus_changed", %{"id" => id, "value" => value}, socket) do
    {:noreply, assign(socket, :accordion_focused, {id, value})}
  end
  ```

  ### Client (CustomEvent / DOM)

  ```heex
  <.accordion
    id="my-accordion"
    class="accordion"
    items={
      Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])
    }
    on_value_change_client="accordion-value-changed"
    on_focus_change_client="accordion-focus-changed"
  />
  ```

  ```javascript
  const el = document.getElementById("my-accordion");

  el?.addEventListener("accordion-value-changed", (event) => {
    const d = event.detail;
    console.log(d.id, d.value, "added:", d.added, "removed:", d.removed);
  });

  el?.addEventListener("accordion-focus-changed", (event) => {
    const d = event.detail;
    console.log(d.id, d.value);
  });
  ```

  ```typescript
  import type { AccordionChangedDetail } from "corex";

  const el = document.getElementById("my-accordion");
  type FocusDetail = { id: string; value: string | null };

  el?.addEventListener("accordion-value-changed", (event: Event) => {
    const d = (event as CustomEvent<AccordionChangedDetail>).detail;
    console.log(d.id, d.value, "added:", d.added, "removed:", d.removed);
  });

  el?.addEventListener("accordion-focus-changed", (event: Event) => {
    const d = (event as CustomEvent<FocusDetail>).detail;
    console.log(d.id, d.value);
  });
  ```

  <!-- tabs-close -->

  ## Style

  Zag exposes `data-scope` and `data-part` on each element:

  ```css
  [data-scope="accordion"][data-part="root"] {}
  [data-scope="accordion"][data-part="item"] {}
  [data-scope="accordion"][data-part="item-trigger"] {}
  [data-scope="accordion"][data-part="item-content"] {}
  [data-scope="accordion"][data-part="item-indicator"] {}
  ```

  With Corex Design, import tokens and the accordion stylesheet, then add the `accordion` class and modifiers:

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/accordion.css";
  ```

  ```heex
  <.accordion
    class="accordion accordion--accent accordion--lg"
    items={
      Corex.Content.new([
        %{trigger: "First", content: "First body."},
        %{trigger: "Second", content: "Second body."}
      ])
    }
  />
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Accordion.Anatomy.{Item, Props, Root}
  alias Corex.Accordion.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Helpers,
    only: [validate_value!: 1, validate_content_items_required!: 2, respond_to_fields: 1]

  @doc """
  Renders an accordion. See the module documentation for list-driven `items`, With slots, Custom slots, Manual and Compound modes, patterns, API, and events.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the accordion, useful for API to identify the accordion"
  )

  attr(:items, :list,
    default: [],
    doc: "The items of the accordion, must be a list of %Corex.Content.Item{} structs"
  )

  attr(:value, :any,
    default: [],
    doc: "The initial value or controlled value. Accepts a string or list of strings."
  )

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode. Use with :let={ctx} and sub-components to fully control structure."
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the accordion is controlled. Only in LiveView, the on_value_change event is required"
  )

  attr(:collapsible, :boolean, default: true, doc: "Whether the accordion is collapsible")

  attr(:multiple, :boolean,
    default: true,
    doc: "Whether the accordion allows multiple items to be selected"
  )

  attr(:animation, :string,
    default: "js",
    values: ["instant", "js", "custom"],
    doc: """
    Animation mode for content open/close.
    - `instant` — no animation, content opens/closes instantly via native `hidden` attribute
    - `js` — built-in animation via Web Animations API (opacity + height); tune with `animation_options` (`Corex.Animation.Height`)
    - `custom` — removes `hidden`, full JS control via `on_value_change_client`
    """
  )

  attr(:animation_options, Corex.Animation.Height,
    default: %Corex.Animation.Height{},
    doc:
      "Wired to the host when `animation` is `js` only. Custom transitions ignore this assign. See `Corex.Animation.Height` (opacity, height, `block_interaction`)."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "The orientation of the accordion"
  )

  attr(:dir, :string,
    default: "ltr",
    values: ["ltr", "rtl"],
    doc:
      "The direction of the accordion. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc:
      "LiveView event name for `pushEvent` when the open value(s) change. Params: `%{\"id\" => dom_id, \"value\" => list}`. See **Events** in the module doc."
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc:
      "Browser `CustomEvent` type when the open value(s) change. `event.detail`: `%{id: dom_id, value: list, previousValue: list, added: list, removed: list}` (TS: `AccordionChangedDetail`). See **Events** in the module doc."
  )

  attr(:on_focus_change, :string,
    default: nil,
    doc:
      "LiveView event name for `pushEvent` when the focused item changes. Params: `%{\"id\" => dom_id, \"value\" => focused_item_value}`. See **Events** in the module doc."
  )

  attr(:on_focus_change_client, :string,
    default: nil,
    doc:
      "Browser `CustomEvent` type for focus changes. `event.detail`: `%{id: dom_id, value: focused_value}`. See **Events** in the module doc."
  )

  attr(:rest, :global)

  slot(:inner_block,
    required: false,
    doc: """
    Compound mode inner content. Use with the `compound` attribute and `:let={ctx}`.
    `ctx` is a map with keys: `id`, `values`, `orientation`, `dir`.
    """
  )

  slot :indicator,
    required: false,
    doc:
      "Optional slot after each trigger. With `:items`, use `:let={item}`. Without `:items` (manual mode), use one slot per panel and a matching `value` on `:trigger` and `:content`." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
  end

  slot :trigger,
    required: false,
    doc:
      "With `:items`, optional custom trigger; use `:let={item}`. Without `:items` (manual mode), one slot per panel with `value` (or default `item-0`, …)." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  slot :content,
    required: false,
    doc:
      "With `:items`, optional custom content; use `:let={item}`. Without `:items` (manual mode), one slot per panel with `value` (or default `item-0`, …)." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  def accordion(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "accordion-#{System.unique_integer([:positive])}" end)
      |> update(:value, &normalize_value/1)
      |> then(fn assigns ->
        if not assigns.compound and Enum.empty?(assigns.items) and
             assigns.trigger == [] and assigns.content == [] do
          validate_content_items_required!(assigns, "Accordion")
        else
          assigns
        end
      end)
      |> then(&accordion_assert_trigger_content_pair!/1)
      |> then(&accordion_assign_manual_mode!/1)
      |> then(&accordion_assign_panels/1)

    ctx = %{
      id: assigns.id,
      values: assigns.value,
      orientation: assigns.orientation,
      dir: assigns.dir,
      animation: assigns.animation
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div
      id={@id}
      phx-hook="Accordion"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        value: @value,
        collapsible: @collapsible,
        multiple: @multiple,
        orientation: @orientation,
        dir: @dir,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_focus_change: @on_focus_change,
        on_focus_change_client: @on_focus_change_client,
        animation: @animation,
        animation_options: @animation_options
      })}
      {@rest}
    >

    {if @compound do render_slot(@inner_block, @ctx) end}

    <div :if={not @compound}
        phx-mounted={Connect.ignore_root(%Root{id: @id, orientation: @orientation, dir: @dir})}
        {Connect.root(%Root{id: @id, orientation: @orientation, dir: @dir})}
        >
        <.accordion_item
          :for={panel <- @panels}
          ctx={@ctx}
          value={panel.value}
          disabled={panel.disabled}
          :let={item}
        >
          <.accordion_trigger item={item}>
            {cond do
              panel.source == :slots -> render_slot(panel.trigger_slot)
              @trigger != [] -> render_slot(@trigger, panel.item_entry)
              true -> panel.item_entry.trigger
            end}
            <:indicator :if={accordion_panel_has_indicator?(panel, @indicator)}>
              <.accordion_indicator item={item}>
                {if panel.source == :slots,
                  do: render_slot(panel.indicator_slot),
                  else: render_slot(@indicator, panel.item_entry)}
              </.accordion_indicator>
            </:indicator>
          </.accordion_trigger>

          <.accordion_content item={item} animation={@animation}>
            {cond do
              panel.source == :slots -> render_slot(panel.content_slot)
              @content != [] -> render_slot(@content, panel.item_entry)
              true -> nil
            end}
            <p :if={panel.source == :items and @content == []}>{panel.item_entry.content}</p>
          </.accordion_content>
        </.accordion_item>
      </div>
    </div>
    """
  end

  @doc type: :compound
  @doc """
  Renders the root container for an accordion in compound mode.

  Use inside `accordion` compound mode with `:let={ctx}`, wrapping all `accordion_item` components.
  """

  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent accordion via :let={ctx}"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_root(assigns) do
    root = %Root{
      id: assigns.ctx.id,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :root, root)

    ~H"""
    <div
      phx-mounted={Connect.ignore_root(@root)}
      {Connect.root(@root)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :compound
  @doc """
  Renders an accordion item. Use inside `accordion` compound mode with `:let={ctx}`.

  Yields the `%Item{}` struct via `:let` for use in child parts.
  """

  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent accordion via :let={ctx}"
  )

  attr(:value, :string, required: true, doc: "The unique value identifying this item")
  attr(:disabled, :boolean, default: false, doc: "Whether the item is disabled")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def accordion_item(assigns) do
    item = %Item{
      id: assigns.ctx.id,
      value: assigns.value,
      disabled: assigns.disabled,
      values: assigns.ctx.values,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir,
      animation: Map.get(assigns.ctx, :animation, "instant")
    }

    assigns = assign(assigns, :item, item)

    ~H"""
    <div phx-mounted={Connect.ignore_item(@item)} {Connect.item(@item)} {@rest}>
      {render_slot(@inner_block, @item)}
    </div>
    """
  end

  @doc type: :compound
  @doc """
  Renders the trigger button for an accordion item.

  Use inside `accordion_item` with `:let={item}`, passing the yielded `item` as the `item` attr.
  Place `accordion_indicator` inside this component's inner block if needed.
  """

  attr(:item, :map, required: true)

  attr(:rest, :global)
  slot(:inner_block, required: true)
  slot(:indicator, required: false)

  def accordion_trigger(assigns) do
    ~H"""
    <h3>
      <button phx-mounted={Connect.ignore_trigger(@item)} {Connect.trigger(@item)} {@rest}>
        <span data-scope="accordion" data-part="item-text">
          {render_slot(@inner_block)}
        </span>
        {render_slot(@indicator)}
      </button>
    </h3>
    """
  end

  @doc type: :compound
  @doc """
  Renders the indicator for an accordion item.

  Use inside `accordion_trigger` inner block, passing the same `item` from `accordion_item`.
  """

  attr(:item, :map,
    required: true,
    doc: "The item struct yielded by accordion_item via :let={item}"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_indicator(assigns) do
    ~H"""
    <span phx-mounted={Connect.ignore_indicator(@item)} {Connect.indicator(@item)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc type: :compound
  @doc """
  Renders the content panel for an accordion item.

  Use inside `accordion_item` with `:let={item}`, passing the yielded `item` as the `item` attr.
  """

  attr(:item, :map,
    required: true,
    doc: "The item struct yielded by accordion_item via :let={item}"
  )

  attr(:animation, :string,
    default: nil,
    doc:
      "Override animation mode; defaults to the parent accordion `animation` from compound ctx."
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def accordion_content(assigns) do
    animation = assigns.animation || assigns.item.animation

    assigns = assign(assigns, :resolved_animation, animation)

    ~H"""
    <div
      phx-mounted={Connect.ignore_content(@item)}
      {Connect.content(@item, @resolved_animation)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the accordion component.
  """

  attr(:count, :integer, default: 3)
  attr(:rest, :global)

  slot :trigger do
    attr(:class, :string, required: false)
  end

  slot :indicator do
    attr(:class, :string, required: false)
  end

  slot :content do
    attr(:class, :string, required: false)
  end

  def accordion_skeleton(assigns) do
    ~H"""
    <div {@rest}>
      <div data-scope="accordion" data-part="root" data-async>
        <div :for={_item <- 1..@count} data-scope="accordion" data-part="item">
          <div data-scope="accordion" data-part="item-trigger">
            <span data-scope="accordion" data-part="item-text">
              {render_slot(@trigger)}
            </span>
            <span data-scope="accordion" data-part="item-indicator">
              {render_slot(@indicator)}
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the accordion value from client-side. Returns a `Phoenix.LiveView.JS` command.

  Pass a list of open item ids, or a comma-separated binary (trimmed); an empty binary closes all panels.

  ## Examples

  #### From Client Binding

      <.action phx-click={Corex.Accordion.set_value("my-accordion", ["lorem"])} class="button button--sm">
        Open Lorem
      </.action>
      <.action phx-click={Corex.Accordion.set_value("my-accordion", ["lorem", "donec"])} class="button button--sm">
        Open Lorem and Donec
      </.action>
      <.action phx-click={Corex.Accordion.set_value("my-accordion", [])} class="button button--sm">
        Close all
      </.action>

      <.accordion
        id="my-accordion"
        class="accordion"
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
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
              disabled: true
            }
          ])
        }
      />

  #### From Client JS

      ```javascript
      const el = document.getElementById("my-accordion");
      const set = (value) =>
        el?.dispatchEvent(
          new CustomEvent("corex:accordion:set-value", {
            bubbles: false,
            detail: { value },
          })
        );

      set(["lorem"]);
      set(["lorem", "donec"]);
      set([]);
      ```
  """
  def set_value(accordion_id, value) when is_binary(accordion_id) do
    JS.dispatch("corex:accordion:set-value",
      to: "##{accordion_id}",
      detail: %{value: normalize_set_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the accordion value from server-side. Pushes a LiveView event.

  ## Examples

  <!-- tabs-open -->

  ### Heex

      <.action phx-click="open_lorem" class="button button--sm">
        Open Lorem
      </.action>
      <.action phx-click="open_lorem_and_donec" class="button button--sm">
        Open Lorem and Donec
      </.action>
      <.action phx-click="close_all" class="button button--sm">
        Close all
      </.action>

      <.accordion
        id="my-accordion"
        class="accordion"
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
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
              disabled: true
            }
          ])
        }
      />

  ### Elixir

      def handle_event("open_lorem", _params, socket) do
        {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["lorem"])}
      end

      def handle_event("open_lorem_and_donec", _params, socket) do
        {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["lorem", "donec"])}
      end

      def handle_event("close_all", _params, socket) do
        {:noreply, Corex.Accordion.set_value(socket, "my-accordion", [])}
      end

  <!-- tabs-close -->
  """
  def set_value(socket, accordion_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) do
    LiveView.push_event(socket, "accordion_set_value", %{
      id: accordion_id,
      value: normalize_set_value!(value)
    })
  end

  defp normalize_set_value!(value) when is_list(value), do: validate_value!(value)

  defp normalize_set_value!(value) when is_binary(value) do
    case String.trim(value) do
      "" ->
        []

      trimmed ->
        trimmed
        |> String.split(",", trim: true)
        |> validate_value!()
    end
  end

  defp normalize_set_value!(value), do: validate_value!(value)

  @doc type: :api
  @doc """
  Requests the accordion's current open values from the browser. Returns a `Phoenix.LiveView.JS` command.

  Options:

  - `:respond_to` — `:server` (default, LiveView `accordion_value_response` only), `:both` (also dispatches
    `accordion-value`), or `:client` (DOM `accordion-value` only). When `:server` and the LiveView is not connected, nothing is pushed.

  The hook pushes `accordion_value_response` when `:respond_to` is `:both` or `:server`, and dispatches
  `accordion-value` on the element when `:respond_to` is `:both` or `:client`.

  ## Examples

  #### From Client Binding

      <.action phx-click={Corex.Accordion.value("my-accordion")} class="button button--sm">
        Value
      </.action>
      <.action phx-click={Corex.Accordion.value("my-accordion", respond_to: :client)} class="button button--sm">
        Value (client only)
      </.action>

      <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])} />

      ```javascript
      const el = document.getElementById("my-accordion");
      el?.addEventListener("accordion-value", (e) => console.log(e.detail));
      ```

  #### JS.dispatch

      <.action
        phx-click={JS.dispatch("corex:accordion:value",
          to: "#my-accordion",
          detail: %{respond_to: "client"},
          bubbles: false
        )}
        class="button button--sm"
      >
        Value (JS.dispatch, client only)
      </.action>
  """

  def value(accordion_id) when is_binary(accordion_id), do: value(accordion_id, [])

  def value(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:value",
      to: "##{accordion_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the accordion's current open values from the client. Pushes a LiveView event handled by the hook.

  See `value/2` for `:respond_to`. The hook pushes `accordion_value_response` and/or dispatches `accordion-value`
  accordingly.

  ## Examples

      def handle_event("accordion_value_response", %{"id" => id, "value" => value}, socket) do
        {:noreply, assign(socket, :accordion_value, {id, value})}
      end
  """

  def value(socket, accordion_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_value",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  @doc type: :api
  @doc """
  Requests the accordion's focused item value from the browser. Returns a `Phoenix.LiveView.JS` command.

  Options: `:respond_to` — `:server` (default, `accordion_focused_response` only), `:both` (also dispatches
  `accordion-focused`), or `:client` (`accordion-focused` DOM event only).

  ## Examples

  #### From Client Binding

      <.action phx-click={Corex.Accordion.focused("my-accordion")} class="button button--sm">
        Focused
      </.action>
      <.action phx-click={Corex.Accordion.focused("my-accordion", respond_to: :client)} class="button button--sm">
        Focused (client only)
      </.action>

      <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."}
      ])} />

      ```javascript
      const el = document.getElementById("my-accordion");
      el?.addEventListener("accordion-focused", (e) => console.log(e.detail));
      ```

  #### JS.dispatch

      <.action
        phx-click={JS.dispatch("corex:accordion:focused",
          to: "#my-accordion",
          detail: %{respond_to: "client"},
          bubbles: false
        )}
        class="button button--sm"
      >
        Focused (JS.dispatch, client only)
      </.action>
  """

  def focused(accordion_id) when is_binary(accordion_id), do: focused(accordion_id, [])

  def focused(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:focused",
      to: "##{accordion_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the accordion's focused item value from the client. Pushes a LiveView event handled by the hook.

  See `focused/2` for `:respond_to`.

  ## Examples

      def handle_event("accordion_focused_response", %{"id" => id, "value" => value}, socket) do
        {:noreply, assign(socket, :accordion_focused, {id, value})}
      end
  """

  def focused(socket, accordion_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_focused",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  @doc type: :api
  @doc """
  Zag `getItemState` for one item. Pass `value` and keyword `opts` (`:disabled`, `:respond_to`).

  - `item_state/2` — `item_state(id, value)`; same as `item_state(id, value, [])`.
  - `item_state/3` — client: `item_state(id, value, opts)`. Server: `item_state(socket, id, value)` or `item_state(socket, id, value, opts)`.

  The hook receives `value` and `disabled`, calls `getItemState`, pushes `accordion_item_state_response`
  and/or dispatches `accordion-item-state` with `detail: %{id, value, state}` according to `:respond_to`.

  ## Examples

  <!-- tabs-open -->

  ### From Client Binding

      <.action phx-click={Corex.Accordion.item_state("my-accordion", "lorem", disabled: false)} class="button button--sm">
        item_state("lorem")
      </.action>
      <.action phx-click={Corex.Accordion.item_state("my-accordion", "donec", disabled: true)} class="button button--sm">
        item_state("donec", disabled)
      </.action>

      <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
        %{value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
        %{value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
      ])} />

  ### From Client JS

      ```javascript
      const el = document.getElementById("my-accordion");
      el?.addEventListener("accordion-item-state", (e) => console.log(e.detail));
      ```

      <.action
        phx-click={JS.dispatch("corex:accordion:item-state",
          to: "#my-accordion",
          detail: %{value: "lorem", disabled: false, respond_to: "client"},
          bubbles: false
        )}
        class="button button--sm"
      >
        item_state("lorem") (JS.dispatch, client only)
      </.action>

  ### From Server

      def handle_event(
            "accordion_item_state_response",
            %{"id" => id, "value" => v, "state" => state},
            socket
          ) do
        {:noreply, assign(socket, :accordion_item_state, {id, v, state})}
      end

  <!-- tabs-close -->
  """

  def item_state(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    item_state(accordion_id, item_value, [])
  end

  def item_state(accordion_id, item_value, opts)
      when is_binary(accordion_id) and is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    JS.dispatch("corex:accordion:item-state",
      to: "##{accordion_id}",
      detail:
        Map.merge(
          %{value: validate_item_value!(item_value), disabled: disabled},
          respond_to_fields(opts)
        ),
      bubbles: false
    )
  end

  def item_state(socket, accordion_id, item_value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) do
    item_state(socket, accordion_id, item_value, [])
  end

  def item_state(socket, accordion_id, item_value, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) and
             is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    LiveView.push_event(
      socket,
      "accordion_item_state",
      Map.merge(
        %{
          id: accordion_id,
          value: validate_item_value!(item_value),
          disabled: disabled
        },
        respond_to_fields(opts)
      )
    )
  end

  defp validate_item_value!(v) when is_binary(v) and byte_size(v) > 0, do: v

  defp validate_item_value!(_),
    do: raise(ArgumentError, "accordion item value must be a non-empty string")

  defp accordion_assert_trigger_content_pair!(assigns) do
    if not assigns.compound and Enum.empty?(assigns.items) do
      tri = assigns.trigger != []
      con = assigns.content != []

      if tri != con do
        raise ArgumentError,
              "Accordion with an empty :items list requires both :trigger and :content slots together, or use :items."
      end
    end

    assigns
  end

  defp accordion_assign_manual_mode!(assigns) do
    if manual_accordion_mode?(assigns) do
      panels =
        Corex.Slot.resolve_panels!(
          %{trigger: assigns.trigger, content: assigns.content, indicator: assigns.indicator},
          required: [:trigger, :content],
          optional: [:indicator],
          disabled: &accordion_panel_disabled?/1,
          component: "Accordion"
        )

      assigns
      |> assign(:accordion_manual_mode, true)
      |> assign(:accordion_manual_panels, panels)
    else
      assigns
      |> assign(:accordion_manual_mode, false)
      |> assign(:accordion_manual_panels, [])
    end
  end

  defp manual_accordion_mode?(assigns) do
    not assigns.compound and Enum.empty?(assigns.items) and assigns.trigger != [] and
      assigns.content != []
  end

  defp accordion_panel_disabled?(entries) do
    entries
    |> Map.take([:trigger, :content])
    |> Map.values()
    |> Enum.any?(&truthy_disabled?/1)
  end

  defp truthy_disabled?(nil), do: false
  defp truthy_disabled?(entry), do: Map.get(entry, :disabled, false) == true

  defp accordion_assign_panels(assigns) do
    panels =
      cond do
        assigns.compound ->
          []

        assigns.accordion_manual_mode ->
          Enum.map(assigns.accordion_manual_panels, fn p ->
            %{
              source: :slots,
              value: p.value,
              disabled: p.disabled,
              trigger_slot: p.trigger,
              content_slot: p.content,
              indicator_slot: p.indicator
            }
          end)

        true ->
          assigns.items
          |> Enum.with_index()
          |> Enum.map(fn {entry, index} ->
            %{
              source: :items,
              value: entry.value || entry.id || "item-#{index}",
              disabled: entry.disabled,
              item_entry: entry
            }
          end)
      end

    assign(assigns, :panels, panels)
  end

  defp accordion_panel_has_indicator?(%{source: :slots, indicator_slot: slot}, _top), do: !!slot
  defp accordion_panel_has_indicator?(%{source: :items}, top_indicator), do: top_indicator != []

  defp normalize_value(nil), do: []
  defp normalize_value(v) when is_binary(v), do: [v]
  defp normalize_value(v) when is_list(v), do: v
  defp normalize_value(_), do: []
end
