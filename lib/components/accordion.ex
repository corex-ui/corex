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
      %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
      %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
      %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
    ])
  }
  />
  ```

  ### With slots

  With `items` and `<:indicator>` slot so every item shares the same indicator markup.

  ```heex
  <.accordion
  class="accordion"
  items={
    Corex.Content.new([
      %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
      %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
      %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
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
          {entry.label}
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

  ## API

  Requires a stable `id` on `<.accordion>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set open items (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set open items (server) | `socket` |
  | [`value/2`](#value/2) | Read open items (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read open items (server) | `socket` |
  | [`focused/2`](#focused/2) | Read focused item (client) | `%Phoenix.LiveView.JS{}` |
  | [`focused/3`](#focused/3) | Read focused item (server) | `socket` |
  | [`item_state/3`](#item_state/3) | Read one item state (client) | `%Phoenix.LiveView.JS{}` |
  | [`item_state/4`](#item_state/4) | Read one item state (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.accordion>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="items_changed"` | Open items change | `%{"id" => id, "value" => values}` — list of open item `value` strings |
  | `on_focus_change="focus_changed"` | Focused item changes | `%{"id" => id, "value" => value}` — item `value` or `nil` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.accordion
    id="faq"
    class="accordion"
    on_value_change="items_changed"
    items={
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
      ])
    }
  >
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.accordion>
  ```

  ```elixir
  def handle_event("items_changed", %{"id" => _id, "value" => values}, socket) do
    {:noreply, assign(socket, :open_items, values)}
  end
  ```

  ### on_focus_change

  ```heex
  <.accordion
    id="faq"
    class="accordion"
    on_focus_change="focus_changed"
    items={
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
      ])
    }
  >
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.accordion>
  ```

  ```elixir
  def handle_event("focus_changed", %{"id" => _id, "value" => item}, socket) do
    {:noreply, assign(socket, :focused_item, item)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="items-changed"` | Open items change | `id`, `value`, `previousValue`, `added`, `removed` |
  | `on_focus_change_client="focus-changed"` | Focused item changes | `id`, `value` |

  <!-- tabs-open -->

  ### on_value_change_client

  ```heex
  <.accordion
    id="faq"
    class="accordion"
    on_value_change_client="items-changed"
    items={
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
      ])
    }
  >
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.accordion>
  ```

  ```javascript
  document.getElementById("faq")?.addEventListener("items-changed", (e) => {
    console.log(e.detail.value, e.detail.added, e.detail.removed);
  });
  ```

  ### on_focus_change_client

  ```heex
  <.accordion
    id="faq"
    class="accordion"
    on_focus_change_client="focus-changed"
    items={
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
      ])
    }
  >
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.accordion>
  ```

  ```javascript
  document.getElementById("faq")?.addEventListener("focus-changed", (e) => {
    console.log(e.detail.value);
  });
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Async

  If `items` are not ready in `mount/3`—for example they load from the database or an external service—use `assign_async/3`, render inside `<.async_result>`, and put `<.accordion_skeleton>` in the `:loading` slot while the async assign is still pending.

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
                label: "Lorem ipsum dolor sit amet",
                content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
                disabled: true
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

  For server-owned open state—validation, forms, or rules that must run before items open—set `controlled`, bind `value`, and handle `on_value_change` in LiveView so assigns stay the source of truth.

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
              label: "Lorem ipsum dolor sit amet",
              content: "Consectetur adipiscing elit."
            },
            %{
              value: "duis",
              label: "Duis dictum gravida odio ac pharetra?",
              content: "Nullam eget vestibulum ligula."
            }
          ])
        }
      />
      """
    end
  end
  ```

  ### Stream

  Use `Phoenix.LiveView.stream/3` to add or remove accordion items at runtime. Keep a list assign in sync with the stream and pass it as `items`. Configure `dom_id` to match each item element id (`accordion:my-accordion:item:#{value}`).

  ```elixir
  defmodule MyAppWeb.AccordionStreamLive do
    use MyAppWeb, :live_view

    @initial_items [
      %{value: "1", label: "Lorem ipsum", content: "Consectetur adipiscing elit."},
      %{value: "2", label: "Duis dictum", content: "Nullam eget vestibulum ligula."},
      %{value: "3", label: "Donec condimentum", content: "Congue molestie ipsum gravida a."}
    ]

    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> stream_configure(:items, dom_id: &"accordion:my-accordion:item:#{&1.value}")
       |> stream(:items, @initial_items)
       |> assign(:items_list, @initial_items)
       |> assign(:next_id, 4)}
    end

    def handle_event("add_item", _params, socket) do
      id = to_string(socket.assigns.next_id)
      item = %{value: id, label: "Item #{id}", content: "Content for item #{id}."}

      {:noreply,
       socket
       |> stream_insert(:items, item)
       |> assign(:items_list, socket.assigns.items_list ++ [item])
       |> assign(:next_id, socket.assigns.next_id + 1)}
    end

    def render(assigns) do
      ~H"""
      <.accordion id="my-accordion" class="accordion" items={Corex.Content.new(@items_list)} />
      """
    end
  end
  ```

  <!-- tabs-close -->

  ## Animation

  <!-- tabs-open -->

  ### JS

  Built-in height and opacity (Web Animations API). Set `animation_options` with `Corex.Animation.Height` for duration, easing, and opacity.

  ```heex
  <.accordion
    class="accordion"
    animation="js"
    animation_options={%Corex.Animation.Height{duration: 0.3, easing: "ease-out", opacity_start: 0, opacity_end: 1}}
    items={
      Corex.Content.new([
        %{
          label: "Lorem ipsum dolor sit amet",
          content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
        },
        %{
          label: "Duis dictum gravida odio ac pharetra?",
          content: "Nullam eget vestibulum ligula, at interdum tellus."
        },
        %{
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
  ```

  ### Instant

  Items open and close immediately. Content visibility uses the native `hidden` attribute; there is no height animation.

  ```heex
  <.accordion
    class="accordion"
    animation="instant"
    items={
      Corex.Content.new([
        %{
          label: "Lorem ipsum dolor sit amet",
          content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
        },
        %{
          label: "Duis dictum gravida odio ac pharetra?",
          content: "Nullam eget vestibulum ligula, at interdum tellus."
        },
        %{
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
  ```

  ### Custom (Motion)

  Set `animation="custom"` and `on_value_change_client` to run Motion (or any JS) on open and close. Content stays in the DOM (`hidden` is not toggled). Each change fires a `CustomEvent` on the accordion with:

      // event.detail — AccordionChangedDetail
      { id, value, previousValue, added, removed }

  `added` and `removed` list which item values opened or closed so you can animate only those items. Register the listener after mount (and again after LiveView navigation if the DOM is replaced).

  ```heex
  <.accordion
    class="accordion"
    animation="custom"
    on_value_change_client="my-accordion-changed"
    items={
      Corex.Content.new([
        %{
          label: "Lorem ipsum dolor sit amet",
          content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
        },
        %{
          label: "Duis dictum gravida odio ac pharetra?",
          content: "Nullam eget vestibulum ligula, at interdum tellus."
        },
        %{
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

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `accordion.css`, then set `class="accordion"` on `<.accordion>`.

  ```css
  [data-scope="accordion"][data-part="root"] {}
  [data-scope="accordion"][data-part="item"] {}
  [data-scope="accordion"][data-part="item-trigger"] {}
  [data-scope="accordion"][data-part="item-text"] {}
  [data-scope="accordion"][data-part="item-content"] {}
  [data-scope="accordion"][data-part="item-indicator"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.accordion>`). Combine axes, for example `accordion ui-accent ui-size-lg` or `accordion ui-info`.

  Axes: **Semantic** (`--accent`, `--brand`, `--alert`, `--info`, `--success`), **Variant** (`--variant-solid`, `--variant-subtle`, `--variant-ghost`, `--variant-outline`), **Size** (`--sm`, `--md`, `--lg`, `--xl`, also scales text), **Radius** (`--rounded-none`, `--rounded-sm`, `--rounded-md`, `--rounded-lg`, `--rounded-xl`, `--rounded-full`), **Max width** (`max-w-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on triggers. Variant modifiers control surface treatment. Default open triggers use a neutral selected surface with semantic text ink; add `ui-solid` for a filled open trigger.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for trigger ink and fill. Does not change open trigger treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `accordion` |
  | Accent | `accordion ui-accent` |
  | Brand | `accordion ui-brand` |
  | Alert | `accordion ui-alert` |
  | Info | `accordion ui-info` |
  | Success | `accordion ui-success` |

  ### Variant

  Visual treatment of item triggers. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `accordion` or `accordion ui-accent` |
  | Solid | `accordion ui-accent ui-solid` |
  | Ghost | `accordion ui-info` |
  | Outline | `accordion ui-accent` |

  ### Size

  Trigger padding, gap, min-height, and content spacing.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `accordion` |
  | SM | `accordion ui-size-sm` |
  | MD | `accordion ui-size-md` |
  | LG | `accordion ui-size-lg` |
  | XL | `accordion ui-size-xl` |

  ### Rounded

  Corner radius on trigger and content.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `accordion` |
  | None | `accordion ui-rounded-none` |
  | SM | `accordion ui-rounded-sm` |
  | MD | `accordion ui-rounded-md` |
  | LG | `accordion ui-rounded-lg` |
  | XL | `accordion ui-rounded-xl` |
  | Full | `accordion ui-rounded-full` |

  ### Max width

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `accordion` |
  | None | `accordion max-w-none` |
  | 5XS | `accordion max-w-5xs` |
  | 2XS | `accordion max-w-2xs` |
  | XS | `accordion max-w-xs` |
  | SM | `accordion max-w-sm` |
  | MD | `accordion max-w-md` |
  | LG | `accordion max-w-lg` |
  | XL | `accordion max-w-xl` |
  | 2XL | `accordion max-w-2xl` |
  | 5XL | `accordion max-w-5xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Accordion.Anatomy.{Item, Props, Root}
  alias Corex.Accordion.Connect
  alias Corex.Api.RespondTo
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Api.Doc

  import Corex.Helpers,
    only: [
      validate_content_items_required!: 2,
      respond_to_fields: 1,
      normalize_string_list_value!: 1
    ]

  @doc """
  Renders an accordion. See the module documentation for list-driven `items`, With slots, Custom slots, Manual and Compound modes, patterns, API, and events.
  """

  attr(:id, :string,
    required: false,
    doc:
      "DOM id on the accordion root. Used by `set_value`, `value`, `focused`, and `item_state`; auto-generated when omitted."
  )

  attr(:items, :list,
    default: [],
    doc: "List of `%Corex.Content.Item{}` from `Corex.Content.new/1`."
  )

  attr(:value, :any,
    default: [],
    doc:
      "Initial or controlled open state: one string or a list of strings (`value` of each item)."
  )

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode. Use with :let={ctx} and sub-components to fully control structure."
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "When true, LiveView owns open items via `value` and `on_value_change`."
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
    How items animate when opening or closing.
    - `instant` — toggle `hidden` immediately
    - `js` — built-in height and opacity (`animation_options` / `Corex.Animation.Height`)
    - `custom` — no built-in animation; use `on_value_change_client` with Motion or other JS
    """
  )

  attr(:animation_options, Corex.Animation.Height,
    default: %Corex.Animation.Height{},
    doc:
      "Used when `animation` is `js`. Ignored for `instant` and `custom`. See `Corex.Animation.Height`."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "The orientation of the accordion"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the accordion. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: ~S"""
    LiveView event when open items change. Pick any event name.

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_value_change="items_changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```elixir
    def handle_event("items_changed", %{"id" => _id, "value" => values}, socket) do
      {:noreply, assign(socket, :open_items, values)}
    end
    ```
    """
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: ~S"""
    Browser event on the accordion element when open items change (same moment as `on_value_change`).

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_value_change_client="items-changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```javascript
    document.getElementById("faq")?.addEventListener("items-changed", (e) => {
      console.log(e.detail.value, e.detail.added, e.detail.removed);
    });
    ```
    """
  )

  attr(:on_focus_change, :string,
    default: nil,
    doc: ~S"""
    LiveView event when keyboard focus moves to another item.

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_focus_change="focus_changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```elixir
    def handle_event("focus_changed", %{"id" => _id, "value" => item}, socket) do
      {:noreply, assign(socket, :focused_item, item)}
    end
    ```
    """
  )

  attr(:on_focus_change_client, :string,
    default: nil,
    doc: ~S"""
    Browser event on the accordion element when focus moves.

    ```heex
    <.accordion
      id="faq"
      class="accordion"
      on_focus_change_client="focus-changed"
      items={
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
        ])
      }
    >
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    </.accordion>
    ```

    ```javascript
    document.getElementById("faq")?.addEventListener("focus-changed", (e) => {
      console.log(e.detail.value);
    });
    ```
    """
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
      "Optional slot after each trigger. With `:items`, use `:let={item}`. Without `:items` (manual mode), use one slot per item and a matching `value` on `:trigger` and `:content`." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
  end

  slot :trigger,
    required: false,
    doc:
      "With `:items`, optional custom trigger; use `:let={item}`. Without `:items` (manual mode), one slot per item with `value` (or default `item-0`, …)." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
    attr(:disabled, :boolean, required: false)
  end

  slot :content,
    required: false,
    doc:
      "With `:items`, optional custom content; use `:let={item}`. Without `:items` (manual mode), one slot per item with `value` (or default `item-0`, …)." do
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
          label={panel_source_label(panel)}
          :let={item}
        >
          <.accordion_trigger item={item}>
            {cond do
              panel.source == :slots -> render_slot(panel.trigger_slot)
              @trigger != [] -> render_slot(@trigger, panel.item_entry)
              true -> panel.item_entry.label
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

  @doc type: :compound
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

  @doc type: :compound
  attr(:ctx, :map,
    required: true,
    doc: "The context map yielded by the parent accordion via :let={ctx}"
  )

  attr(:value, :string, required: true, doc: "The unique value identifying this item")
  attr(:disabled, :boolean, default: false, doc: "Whether the item is disabled")
  attr(:label, :string, default: nil, doc: "Visible item label for unique region names")
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
      animation: Map.get(assigns.ctx, :animation, "instant"),
      label: assigns[:label]
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
  Renders the content area for an accordion item.

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

  api_doc(~S"""
  Open or close items from `phx-click`. Pass a list (`["lorem"]`), a comma string (`"lorem,donec"`), or `[]` to close all.

  ```heex
  <.action phx-click={Corex.Accordion.set_value("my-accordion", "lorem")}>Open Lorem</.action>
  <.action phx-click={Corex.Accordion.set_value("my-accordion", [])}>Close all</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}>
    <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
  </.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:set-value", {
      bubbles: false,
      detail: { value: ["lorem"] }
    })
  );
  ```
  """)

  def set_value(accordion_id, value) when is_binary(accordion_id) do
    JS.dispatch("corex:accordion:set-value",
      to: "##{accordion_id}",
      detail: %{value: normalize_string_list_value!(value)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Open or close items from `handle_event`. Pushes `accordion_set_value` (no reply event).

  ```heex
  <.action phx-click="open_lorem" phx-value-value="lorem">Open Lorem</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("open_lorem", %{"value" => value}, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", value)}
  end
  ```
  """)

  def set_value(socket, accordion_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) do
    RespondTo.push_set_value(
      socket,
      "accordion_set_value",
      accordion_id,
      normalize_string_list_value!(value)
    )
  end

  api_doc(~S"""
  Read open items from `phx-click`. Dispatches `corex:accordion:value`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `accordion_value_response` | `%{"id" => id, "value" => values}` |
  | Client | `accordion-value` on the accordion | `detail`: `id`, `value` |

  ```heex
  <.action phx-click={Corex.Accordion.value("my-accordion", respond_to: :both)}>Which items are open?</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:value", {
      bubbles: false,
      detail: { respond_to: "both" }
    })
  );
  ```

  ```elixir
  def handle_event("accordion_value_response", %{"id" => _id, "value" => values}, socket) do
    {:noreply, assign(socket, :open_items, values)}
  end
  ```

  `values` is a list of open item `value` strings, or `nil`.
  """)

  def value(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:value",
      to: "##{accordion_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def value(socket, accordion_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id),
      do: value(socket, accordion_id, [])

  def value(accordion_id) when is_binary(accordion_id), do: value(accordion_id, [])

  api_doc(~S"""
  Read open items from `handle_event` (`accordion_value`). Same replies as [`value/2`](#value/2).

  | Reply | Payload |
  | ----- | ------- |
  | `accordion_value_response` | `%{"id" => id, "value" => values}` |

  ```heex
  <.action phx-click="read_items">Which items are open?</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("read_items", _params, socket) do
    {:noreply, Corex.Accordion.value(socket, "my-accordion", respond_to: :server)}
  end

  def handle_event("accordion_value_response", %{"id" => _id, "value" => values}, socket) do
    {:noreply, assign(socket, :open_items, values)}
  end
  ```
  """)

  def value(socket, accordion_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_value",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  api_doc(~S"""
  Read the focused item from `phx-click`. Dispatches `corex:accordion:focused`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `accordion_focused_response` | `%{"id" => id, "value" => value}` |
  | Client | `accordion-focused` on the accordion | `detail`: `id`, `value` |

  ```heex
  <.action phx-click={Corex.Accordion.focused("my-accordion", respond_to: :both)}>Focused item</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:focused", {
      bubbles: false,
      detail: { respond_to: "both" }
    })
  );
  ```

  ```elixir
  def handle_event("accordion_focused_response", %{"id" => _id, "value" => item}, socket) do
    {:noreply, assign(socket, :focused_item, item)}
  end
  ```
  """)

  def focused(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:focused",
      to: "##{accordion_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def focused(socket, accordion_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id),
      do: focused(socket, accordion_id, [])

  def focused(accordion_id) when is_binary(accordion_id), do: focused(accordion_id, [])

  api_doc(~S"""
  Read the focused item from `handle_event` (`accordion_focused`). Same replies as [`focused/2`](#focused/2).

  | Reply | Payload |
  | ----- | ------- |
  | `accordion_focused_response` | `%{"id" => id, "value" => value}` |

  ```heex
  <.action phx-click="read_focus">Focused item</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("read_focus", _params, socket) do
    {:noreply, Corex.Accordion.focused(socket, "my-accordion", respond_to: :server)}
  end

  def handle_event("accordion_focused_response", %{"id" => _id, "value" => item}, socket) do
    {:noreply, assign(socket, :focused_item, item)}
  end
  ```
  """)

  def focused(socket, accordion_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_focused",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  api_doc(~S"""
  Read expanded, focused, and disabled state for one item from `phx-click`. Dispatches `corex:accordion:item-state`. Optional `disabled:` and `respond_to:` `:server` (default), `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `accordion_item_state_response` | `%{"id" => id, "value" => value, "state" => %{"expanded" => bool, "focused" => bool, "disabled" => bool}}` |
  | Client | `accordion-item-state` on the accordion | `detail`: `id`, `value`, `state` |

  ```heex
  <.action phx-click={Corex.Accordion.item_state("my-accordion", "lorem", respond_to: :both)}>State for Lorem</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```javascript
  document.getElementById("my-accordion")?.dispatchEvent(
    new CustomEvent("corex:accordion:item-state", {
      bubbles: false,
      detail: { value: "lorem", respond_to: "both" }
    })
  );
  ```

  ```elixir
  def handle_event("accordion_item_state_response", %{"id" => _id, "value" => item, "state" => state}, socket) do
    {:noreply, assign(socket, :item_state, {item, state})}
  end
  ```
  """)

  def item_state(accordion_id, item_value, opts)
      when is_binary(accordion_id) and is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    JS.dispatch("corex:accordion:item-state",
      to: "##{accordion_id}",
      detail:
        Map.merge(
          %{value: accordion_validate_item_value!(item_value), disabled: disabled},
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

  def item_state(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    item_state(accordion_id, item_value, [])
  end

  api_doc(~S"""
  Read item state from `handle_event` (`accordion_item_state`). Same replies as [`item_state/3`](#item_state/3).

  | Reply | Payload |
  | ----- | ------- |
  | `accordion_item_state_response` | `%{"id" => id, "value" => value, "state" => %{"expanded" => bool, "focused" => bool, "disabled" => bool}}` |

  ```heex
  <.action phx-click="read_lorem">State for Lorem</.action>
  <.accordion id="my-accordion" class="accordion" items={Corex.Content.new([
    %{value: "lorem", label: "Lorem", content: "Lorem body."},
    %{value: "duis", label: "Duis", content: "Duis body."},
    %{value: "donec", label: "Donec", content: "Donec body."}
  ])}><:indicator><.heroicon name="hero-chevron-right" /></:indicator></.accordion>
  ```

  ```elixir
  def handle_event("read_lorem", _params, socket) do
    {:noreply, Corex.Accordion.item_state(socket, "my-accordion", "lorem", respond_to: :server)}
  end

  def handle_event("accordion_item_state_response", %{"id" => _id, "value" => item, "state" => state}, socket) do
    {:noreply, assign(socket, :item_state, {item, state})}
  end
  ```
  """)

  def item_state(socket, accordion_id, item_value, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    LiveView.push_event(
      socket,
      "accordion_item_state",
      Map.merge(
        %{
          id: accordion_id,
          value: accordion_validate_item_value!(item_value),
          disabled: disabled
        },
        respond_to_fields(opts)
      )
    )
  end

  defp accordion_validate_item_value!(v) when is_binary(v) and byte_size(v) > 0, do: v

  defp accordion_validate_item_value!(_),
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
              value: entry.value || "item-#{index}",
              disabled: entry.disabled,
              item_entry: entry
            }
          end)
      end

    assign(assigns, :panels, panels)
  end

  defp accordion_panel_has_indicator?(%{source: :slots, indicator_slot: slot}, _top), do: !!slot
  defp accordion_panel_has_indicator?(%{source: :items}, top_indicator), do: top_indicator != []

  defp panel_source_label(%{source: :items, item_entry: %{label: label}}) when is_binary(label),
    do: label

  defp panel_source_label(_), do: nil

  defp normalize_value(nil), do: []
  defp normalize_value(v) when is_binary(v), do: [v]
  defp normalize_value(v) when is_list(v), do: v
  defp normalize_value(_), do: []
end
