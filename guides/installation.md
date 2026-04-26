# Installation

![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=corex-install)](https://coveralls.io/github/corex-ui/corex?branch=corex-install)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)

## Introduction

Corex brings Zag.js state machines to Phoenix to build accessible and unstyled components with a full server and client API.
Control and listen from both sides of the wire and Fully Compatible with Phoenix Form, Stream and Ecto Changeset

- **Flexible anatomy:** declarative, custom slots and full compound mode.
- **Server and client API & Events:** push state in, pull it out and react to changes in Elixir and JavaScript.
- **LiveView-native:** update props at runtime without resetting component state.
- **Server App & Static Website** Build a full app with Phoenix or build a static site using Tableau.
- **Accessible and keyboard-first:** powered by Zag.js state machines.
- **Truly unstyled:** bring your own CSS or use Corex Design System.

> **Beta stage**
> Corex is actively being developed and is currently in beta stage.
> It is getting closer to a stable release and no critical changes in the API are excpected at this stage


## Live Demo

To preview the components, a [Live Demo](https://corex.gigalixirapp.com/en) is available to showcase some uses of components, language switching, RTL, Dark Mode and Site Navigation.

## New project with Corex

To create a new Phoenix application with Corex preconfigured, install the Corex project generator archive and Igniter (first time only), then generate the app:

```bash
mix archive.install hex igniter
mix archive.install hex corex_new
mix corex.new my_app
```

To update the generator to the latest version before creating a project:

```bash
mix local.corex
mix corex.new my_app
```

See full options at `Mix.Tasks.Corex.New`

## Existing project

```bash
mix igniter.install corex
```

See full options at `Mix.Tasks.Corex.Install`

### How Igniter shows (or hides) the diff

Corex’s installer is a normal [Igniter](https://hexdocs.pm/igniter) task. The behavior matches Igniter, not a custom TUI.

- **Interactive diff + confirm:** run `mix igniter.install corex` **without** `--yes`. When there are proposed file changes, Igniter prints a diff and asks for confirmation.
- **Non-interactive (CI, scripts, docs):** flags such as `--yes` and `--yes-to-deps` apply changes **without** printing the usual diff step first, then run deferred tasks (e.g. `mix deps.get`) and show **notices** at the end.
- **Preview only:** use `--dry-run` to see the proposed diff without writing files.
- **Maintainer / documentation bundle:** to generate a Markdown file that embeds per-section diffs (the “manual with fenced diff blocks” workflow), use Igniter’s **scribe** mode, for example:
  - `mix igniter.install corex --scribe path/to/corex_install_manual.md`  
  Exact option names can vary slightly with your Igniter version; see `mix help igniter.install` and the [writing generators](https://hexdocs.pm/igniter/writing-generators.html) guide. That path is for **publishing a portable install guide**, separate from the normal interactive `mix igniter.install` flow.

### `assets/js/app.js` and `assets/css/app.css` patching

- **[igniter_js](https://github.com/ash-project/igniter_js)** is an **optional** dependency of Corex. When it is available (it is in Corex’s own `mix.lock`), the installer patches `assets/js/app.js` using its JavaScript codemods (LiveSocket hooks and imports). If the module is not on the code path, the same behavior falls back to regular-expression patching. Set `COREX_PATCH_ASSETS_JS_REGEX=1` to force the regex path (for example when comparing output or debugging).
- **[igniter_css](https://github.com/ash-project/igniter_css)** is **not** integrated. It depends on [Pythonx](https://hexdocs.pm/pythonx) for part of its pipeline, which would add a heavy runtime to every install. Corex continues to strip daisyUI regions and append design imports in [`Mix.Corex.Install.Design`](https://github.com/corex-ui/corex) using the existing string and regex approach. Revisit if IgniterCss exposes a small, Python-free API for the same transforms.

## Add your first component

Add the following Accordion examples to your application.

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

## Events

Listen to component events on the **server** (LiveView events) or on the **client** (DOM CustomEvents).

### Server

```heex
<.accordion
  id="my-accordion"
  class="accordion"
  items={@items}
  on_value_change="accordion_value_changed"
/>
```

```elixir
def handle_event("accordion_value_changed", %{"id" => "my-accordion", "value" => value}, socket) do
  {:noreply, assign(socket, open_values: value)}
end
```

### Client

```heex
<.accordion
  id="my-accordion"
  class="accordion"
  items={@items}
  on_value_change_client="accordion-value-changed"
/>
```

```javascript
const el = document.getElementById("my-accordion");

el.addEventListener("accordion-value-changed", (event) => {
  const { id, value } = event.detail;
  console.log("accordion value changed", { id, value });
});
```

For the final build in production, see the [Production guide](production.html).
