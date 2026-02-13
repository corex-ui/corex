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
    {:corex, "~> 0.1.0-alpha.19"}
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

In your `assets/js/app.js`, import and register the Corex hooks. Each component chunk loads when first mounted:

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

## Components

Now that Corex is installed, explore the component documentation:

- [Accordion](Corex.Accordion.html)
- [Checkbox](Corex.Checkbox.html)
- [Clipboard](Corex.Clipboard.html)
- [Collapsible](Corex.Collapsible.html)
- [Combobox](Corex.Combobox.html)
- [Date Picker](Corex.DatePicker.html)
- [Dialog](Corex.Dialog.html)
- [Select](Corex.Select.html)
- [Switch](Corex.Switch.html)
- [Tabs](Corex.Tabs.html)
- [Toast](Corex.Toast.html)
- [Toggle Group](Corex.ToggleGroup.html)

