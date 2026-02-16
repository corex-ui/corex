# Installation

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
> 


This guide will walk you through installing and configuring Corex in your Phoenix application.


## Phoenix App

If you don't already have a [Phoenix app up and running](https://hexdocs.pm/phoenix/up_and_running.html) you can run

```bash
mix phx.new my_app
```

## Dependencies

Add `corex` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-alpha.22"}
  ]
end
```

Then fetch the dependencies:

```bash
mix deps.get
```

## Configuration

Configure Gettext backend and Jason Library in your `config/config.exs`:

```elixir
config :corex,
  gettext_backend: MyAppWeb.Gettext,
  json_library: Jason

```


### Import Corex Hooks

In your `assets/js/app.js`, import Corex and register its hooks on the LiveSocket.

Each hook uses dynamic `import()` so component JavaScript is loaded only when a DOM element with that hook is mounted. If a component never appears on a page, its chunk is never fetched. See the Performance section below for how this works and the required build configuration.

To load all hooks:

```javascript
import corex from "corex"
```

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...corex}
})
```

To register only the hooks you use:

```javascript
import { hooks } from "corex"
```

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...hooks(["Accordion", "Combobox", "Dialog"])}
})
```

## Import Components

Add `use Corex` into your `MyAppWeb` `html_helpers`

```elixir
  defp html_helpers do
    quote do
      # Translation
      use Gettext, backend: MyAppWeb.Gettext

      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components
      import MyAppWeb.CoreComponents
      use Corex
      # Common modules used in templates
      alias Phoenix.LiveView.JS
      alias MyAppWeb.Layouts

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

```

By default, this imports and aliases all Corex UI components (such as `accordion/1`, `combobox/1`, etc.), allowing them to be used directly in templates. You can optionally limit which components are imported with `only:` or `except:`, or add a `prefix:` to avoid name collisions

```elixir
use Corex, only: [:accordion], prefix: "ui"
```
This will only import Accordion component and you can use as
```heex
<.ui_accordion>
...
<.ui_accordion>

```


## Styling

All components are unstyled by default, in this guide we will use the default styling provided by Corex

- Copy once the default Corex Design files to your `assets` folder by running

```bash
mix corex.design
```

- Apply the default theme 
  
Add `data-theme="neo" data-mode="light"` to your `html` tag in `root.html.heex`

- Add CSS imports
  
In your `app.css` add the following

```css
@import "../corex/main.css";
@import "../corex/tokens/themes/neo/light.css";
@import "../corex/components/typo.css";
@import "../corex/components/accordion.css";
```

- Delete Daisy UI related css and plugin `app.css`

If you don't see the styling, please run `mix assets.build`

For more details see [Corex Design](Mix.Tasks.Corex.Design.html) mix task use

## Add your first component

Add the following Accordion example to your application.

<!-- tabs-open -->

### List

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

### List Custom

  Similar to List but render a custom item slot that will be used for all items.

  Use `{item.data.trigger}` and `{item.data.content}` to render the trigger and content for each item.

  This example assumes the import of `.icon` from Core Components.

  ```heex
  <.accordion
    class="accordion"
    items={Corex.Content.new([
      [
        id: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-chevron-right"}
      ],
      [
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right"}
      ],
      [
        id: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-right"}
      ]
    ])}
  >
    <:item :let={item}>
      <.accordion_trigger item={item}>
        {item.data.trigger}
        <:indicator>
          <.icon name={item.data.meta.indicator} />
        </:indicator>
      </.accordion_trigger>

      <.accordion_content item={item}>
        {item.data.content}
      </.accordion_content>
    </:item>
  </.accordion>
  ```

### Controlled

  Render an accordion controlled by the server.

  Use the `on_value_change` event to update the value on the server and pass the value as a list of strings. The event receives a map with the key `value` and the id of the accordion.

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

  When the initial props are not available on mount, use `Phoenix.LiveView.assign_async/3` to assign the props asynchronously. You can use `Corex.Accordion.accordion_skeleton/1` to render a loading or error state.

  ```elixir
  defmodule MyAppWeb.AccordionAsyncLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      socket =
        socket
        |> assign_async(:accordion, fn ->
          Process.sleep(1000)

          items =
            Corex.Content.new([
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

In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Accordion.set_value("my-accordion", ["item-1"])}>
    Open Item 1
  </button>

  ```

  ***Server-side***

  ```elixir
  def handle_event("open_item", _, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["item-1"])}
  end
  ```

## Performance

Corex hooks load component JavaScript only when a DOM element with that hook is mounted. This requires ESM format and code splitting.

### 1. Build configuration (ESM and splitting)

Add `--format=esm` and `--splitting` to your esbuild config. ESM is required for dynamic `import()`. Splitting produces separate chunks for each component and shared code, so only the components used on a page are loaded.

```elixir
config :esbuild,
  version: "0.25.4",
  e2e: [
    args:
      ~w(js/app.js --bundle --format=esm --splitting --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]
```

### 2. Script type="module"

Load your app script with `type="module"` in your root layout, for example in `root.html.heex`:

```heex
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}>
</script>
```

### 3. Enable gzip for Plug.Static

Set `gzip: true` on `Plug.Static` in your endpoint so that pre-compressed `.gz` files are served when the client supports them.

### 4. How dynamic hook loading works

1. **App start** – Corex registers small stubs (e.g. Accordion, Combobox) as LiveSocket hooks. Each stub stores a function like `() => import("corex/accordion")` but does not run it yet.
2. **Page load** – If the page has no Corex components, no component code is loaded.
3. **Component appears** – When LiveView renders an element with `phx-hook="Accordion"`, LiveSocket mounts that hook and calls the stub's `mounted()`.
4. **Dynamic load** – Inside `mounted()`, the stub runs `await import("corex/accordion")`. The browser fetches and executes the accordion chunk for the first time. The stub then delegates to the real hook.
5. **Result** – Each component's JavaScript is loaded only when a DOM element with its `phx-hook` is mounted. If a component never appears on a page, its chunk is never fetched.

### 5. Compression and dev performance

In development, watchers output unminified, uncompressed assets. `Plug.Static` with `gzip: true` only serves pre-existing `.gz` files; watchers do not create them. If the app feels slow in development (especially with many nested components):

1. Run `mix assets.deploy` instead of `mix assets.build` before `mix phx.server` for production-like asset output (minified and compressed).
2. Ensure `gzip: true` is set on `Plug.Static` in your endpoint.

See the [Production guide](production.html) for the final build in production.