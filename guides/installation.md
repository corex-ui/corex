# Installation

![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=corex-install)](https://coveralls.io/github/corex-ui/corex?branch=corex-install)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)

## Introduction

Corex is an accessible and unstyled UI components library written in Elixir and TypeScript that integrates [Zag.js](https://zagjs.com/) state machines into the Phoenix Framework.

Corex bridges the gap between Phoenix and modern JavaScript UI patterns by leveraging Zag.js: a collection of framework-agnostic UI component state machines. This approach gives you:

- **Accessible by default** - Built-in ARIA attributes and keyboard navigation
- **Unstyled components** - Complete control over styling and design
- **Type-safe state management** - Powered by Zag.js state machines
- **Works everywhere** - Phoenix Controllers and LiveView
- **No Node.js required** - Install directly from Hex and connect the Phoenix hooks

> #### Alpha stage {: .neutral}
> Corex is actively being developed and is currently in alpha stage.
> It's not recommended for production use at this time.
> You can monitor development progress and contribute to the [project on GitHub](https://github.com/corex-ui/corex).

## Live Demo

To preview the components, a [Live Demo](https://corex.gigalixirapp.com/en) is available to showcase some uses of components, language switching, RTL, and Dark Mode and Site Navigation.

You can also explore some components via [Live Captures](https://corex.gigalixirapp.com/captures/components/Elixir.CorexWeb.Accordion/accordion), a zero-boilerplate storybook for LiveView components. A big thanks to [@achempion](https://github.com/achempion) for assisting.

This is still in an early stage and will evolve with future stable releases.

Thanks to [Gigalixir](https://www.gigalixir.com/) for providing a reliable hosting solution for Elixir projects *(not sponsored, just a personal experience)*.

## New project with Corex

To create a new Phoenix application with Corex preconfigured, install the Corex project generator archive (first time only), then generate the app:

```bash
mix archive.install hex corex_new
mix corex.new my_app
```

To update the generator to the latest version before creating a project:

```bash
mix local.corex
mix corex.new my_app
```

Then in the generated project:

```bash
cd my_app
mix deps.get
```

The generated app includes the `corex` dependency, configuration, hooks, and layout setup.

## Existing Project

To add Corex to an existing Phoenix app instead of using the generator, see [Manual installation](manual_installation.html).


## Add your first component

Add the following Accordion examples to your application.

<!-- tabs-open -->

### Basic

You can use `Corex.Content.new/1` to create a list of content items.

The `id` for each item is optional and will be auto-generated if not provided.

You can specify `disabled` for each item.

```heex
<.accordion
  class="accordion"
  items={Corex.Content.new([
    [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

### With indicator

Use the optional `:indicator` slot to add an icon after each trigger.

This example assumes the import of `.heroicon` from Core Components.

```heex
<.accordion
  class="accordion"
  items={Corex.Content.new([
    [
      id: "lorem",
      trigger: "Lorem ipsum dolor sit amet",
      content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
    ],
    [
      trigger: "Duis dictum gravida odio ac pharetra?",
      content: "Nullam eget vestibulum ligula, at interdum tellus."
    ],
    [
      id: "donec",
      trigger: "Donec condimentum ex mi",
      content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
    ]
  ])}
>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

### Custom

Use `:trigger` and `:content` together to fully customize how each item is rendered. Add the `:indicator` slot to show an icon after each trigger. Use `:let={item}` on slots to access the item and its `data` (including `meta` for per-item customization).

```heex
<.accordion
  class="accordion"
  items={
    Corex.Content.new([
      [
        id: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      ],
      [
        trigger: "Duis dictum gravida ?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      ],
      [
        id: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      ]
    ])
  }
>
  <:trigger :let={item}>
    <.heroicon name={item.data.meta.icon} />{item.data.trigger}
  </:trigger>
  <:content :let={item}>{item.data.content}</:content>
  <:indicator :let={item}>
    <.heroicon name={item.data.meta.indicator} />
  </:indicator>
</.accordion>
```

### Controlled

Render an accordion controlled by the server.

You must use the `on_value_change` event to update the value on the server and pass the value as a list of strings.

The event will receive the value as a map with the key `value` and the id of the accordion.

```elixir
defmodule MyAppWeb.AccordionLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, ["lorem"])}
  end

  def handle_event("on_value_change", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def render(assigns) do
    ~H"""
    <.accordion
      controlled
      value={@value}
      on_value_change="on_value_change"
      class="accordion"
      items={Corex.Content.new([
        [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla."],
        [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex."]
      ])}
    />
    """
  end
end
```

### Async

When the initial props are not available on mount, you can use `Phoenix.LiveView.assign_async` to assign the props asynchronously.

You can use the optional `Corex.Accordion.accordion_skeleton/1` to render a loading or error state.

```elixir
defmodule MyAppWeb.AccordionAsyncLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_async(:accordion, fn ->
        Process.sleep(1000)

        items = Corex.Content.new([
          [
            id: "lorem",
            trigger: "Lorem ipsum dolor sit amet",
            content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
            disabled: true
          ],
          [
            id: "duis",
            trigger: "Duis dictum gravida odio ac pharetra?",
            content: "Nullam eget vestibulum ligula, at interdum tellus."
          ],
          [
            id: "donec",
            trigger: "Donec condimentum ex mi",
            content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
          ]
        ])

        {:ok,
         %{
           accordion: %{
             items: items,
             value: ["duis", "donec"]
           }
         }}
      end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.async_result :let={accordion} assign={@accordion}>
      <:loading>
        <.accordion_skeleton count={3} class="accordion" />
      </:loading>

      <:failed>
        there was an error loading the accordion
      </:failed>

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

<!-- tabs-close -->

## API Control

In order to use the API, you must use an id on the component.

**Client-side**

```heex
<button phx-click={Corex.Accordion.set_value("my-accordion", ["item-1"])}>
  Open Item 1
</button>
```

**Server-side**

```elixir
def handle_event("open_item", _, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["item-1"])}
end
```

For development performance tips (e.g. minifying assets), see [Troubleshooting](troubleshooting.html). For the final build in production, see the [Production guide](production.html).
