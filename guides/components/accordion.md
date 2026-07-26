# Accordion

Expandable panels for Phoenix LiveView. Behavior follows [Zag.js Accordion](https://zagjs.com/components/react/accordion).

## Anatomy

<!-- tabs-open -->

### Minimal

```heex
<.accordion
class="accordion"
items={
  Corex.Content.new([    %{value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
    %{value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula."},
    %{value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
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

### Dynamic items

Grow or shrink panels at runtime by updating a list assign and passing it as `items`. Accordion panels are DOM parts (not a LiveView stream consumer); use `Phoenix.LiveView.stream/3` only with components that render `@streams.*` (for example `data_table`).

```elixir
defmodule MyAppWeb.AccordionDynamicLive do
  use MyAppWeb, :live_view

  @initial_items [
    %{value: "1", label: "Lorem ipsum", content: "Consectetur adipiscing elit."},
    %{value: "2", label: "Duis dictum", content: "Nullam eget vestibulum ligula."},
    %{value: "3", label: "Donec condimentum", content: "Congue molestie ipsum gravida a."}
  ]

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:items, @initial_items) |> assign(:next_id, 4)}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)
    item = %{value: id, label: "Item #{id}", content: "Content for item #{id}."}

    {:noreply,
     socket
     |> assign(:items, socket.assigns.items ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, socket |> assign(:items, @initial_items) |> assign(:next_id, 4)}
  end

  def render(assigns) do
    ~H"""
    <.accordion id="dynamic-accordion" class="accordion" items={Corex.Content.new(@items)} />
    """
  end
end
```

<!-- tabs-close -->

## Animation

<!-- tabs-open -->

### JS

Built-in height and opacity (Web Animations API). The hook drives open/close from previous and next open-value lists: client toggles use the last known open set; controlled LiveView morphs use the pre-morph `data-value` snapshot from `beforeUpdate`. This is not CSS alone. Set `animation_options` with `Corex.Animation.Height` for duration, easing, and opacity.

After mount, item `disabled` is applied by re-spreading from each item's `data-disabled` attribute. Trigger `disabled` is Zag-owned (ignored by LiveView), so a morph that only flips item disabled still refreshes the trigger on the next hook `updated` when root props are unchanged. Custom Motion should keep using `added` / `removed` on the client change event.

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
@import "../corex/corex.css";
```

Stack modifiers on the host (`class` on `<.accordion>`). Combine axes, for example `accordion ui-accent ui-size-lg` or `accordion ui-info`.

Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`), **Max height** (`ui-max-height-*` on the host; clamps content). See the [modifier guide](modifiers.html).

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

### Size

Trigger padding, gap, min-height, and content spacing.

| Modifier | Classes |
| -------- | ------- |
| Default | `accordion` |
| SM | `accordion ui-size-sm` |
| MD | `accordion ui-size-md` |
| LG | `accordion ui-size-lg` |
| XL | `accordion ui-size-xl` |

### Max height

Opt-in clamp on `item-content`. Example: `accordion ui-max-height-sm`.

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
