# Manual installation

This guide describes how to add Corex to an existing Phoenix application without using the `mix corex.new` generator.

If you are creating a new project instead, see the [Installation guide](installation.html).

## Add the dependency

Add `corex` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-alpha.33"}
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

To load all hooks (in dev only):

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

To register only the hooks you use (recommended for production):

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

### Esbuild

Add `--format=esm` and `--splitting` to your esbuild config. ESM is required for dynamic `import()`. Splitting produces separate chunks for each component and shared code, so only the components used on a page are loaded.

```elixir
config :esbuild,
  version: "0.25.4",
  my_app: [
    args:
      ~w(js/app.js --bundle --format=esm --splitting --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]
```

Load your app script with `type="module"` in your root layout in `root.html.heex`:

```heex
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
```

## Import Components

Add `use Corex` into your `MyAppWeb` `html_helpers`:

```elixir
defp html_helpers do
  quote do
    use Gettext, backend: MyAppWeb.Gettext
    import Phoenix.HTML
    import MyAppWeb.CoreComponents
    use Corex
    alias Phoenix.LiveView.JS
    alias MyAppWeb.Layouts
    unquote(verified_routes())
  end
end
```

By default, this imports and aliases all Corex UI components (such as `accordion/1`, `combobox/1`, etc.), allowing them to be used directly in templates. You can optionally limit which components are imported with `only:` or `except:`, or add a `prefix:` to avoid name collisions:

```elixir
use Corex, only: [:accordion], prefix: "ui"
```

```heex
<.ui_accordion>
...
</.ui_accordion>
```

## Styling

All components are unstyled by default. To use the default styling provided by Corex:

1. Copy the default Corex Design files to your `assets` folder:

```bash
mix corex.design
```

2. Add `data-theme="neo" data-mode="light"` to your `html` tag in `root.html.heex`.

3. In your `app.css` add:

```css
@import "../corex/main.css";
@import "../corex/tokens/themes/neo/light.css";
@import "../corex/components/typo.css";
@import "../corex/components/accordion.css";
```

4. Remove any Daisy UI related CSS and plugin from `app.css`.

If you don't see the styling, run `mix assets.build`.

For more details see [Mix.Tasks.Corex.Design](Mix.Tasks.Corex.Design.html).

## Phoenix flash with Toast

To show Phoenix flash messages (and LiveView flash) as toasts, wire the Toast component to the layout and ensure the router fetches flash.

In your browser pipeline in `router.ex`, include both plugs:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_flash
  plug :fetch_live_flash
  # ... other plugs
end
```

In your app layout (the component that wraps page content and receives `@flash`), render the toast group and pass the flash assign. For example in `layouts.ex`:

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading>
    <.heroicon name="hero-arrow-path" />
  </:loading>
</.toast_group>
```

Ensure every LiveView and controller view that uses this layout passes `flash={@flash}` into the layout (e.g. `Layouts.app flash={@flash} ...`).

Optionally, add connection state toasts so users see feedback when the connection drops or recovers:

```heex
<.toast_client_error
  toast_group_id="layout-toast"
  title={gettext("We can't find the internet")}
  description={gettext("Attempting to reconnect")}
  type={:error}
  duration={:infinity}
/>
<.toast_server_error
  toast_group_id="layout-toast"
  title={gettext("Something went wrong!")}
  description={gettext("Attempting to reconnect")}
  type={:error}
  duration={:infinity}
/>
```

See `Corex.Toast` for `create_toast/5`, `push_toast/6`, and customisation options.

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
