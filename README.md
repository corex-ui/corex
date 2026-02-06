
# Corex

Corex is an accessible and unstyled UI components library written in Elixir and TypeScript that integrates [Zag.js](https://zagjs.com/) state machines into the Phoenix Framework.

Corex bridges the gap between Phoenix and modern JavaScript UI patterns by leveraging Zag.js: a collection of framework-agnostic UI component state machines. This approach gives you:

- **Accessible by default** - Built-in ARIA attributes and keyboard navigation
- **Unstyled components** - Complete control over styling and design
- **Type-safe state management** - Powered by Zag.js state machines
- **Works everywhere** - Phoenix Controllers and LiveView
- **No Node.js required** - Install directly from Hex and connect the Phoenix hooks


> ***Alpha stage ***
> Corex is actively being developed and is currently in alpha stage. 
> It's not recommended for production use at this time. 
> You can monitor development progress and contribute to the [project on GitHub](https://github.com/corex-ui/corex).


## Documentation

Hex Doc is available at [http://hexdocs.pm/corex](http://hexdocs.pm/corex)


## Installation

This guide will walk you through installing and configuring Corex in your Phoenix application.

If you don't already have a [Phoenix app up and running](https://hexdocs.pm/phoenix/up_and_running.html) you can run

```bash
mix phx.new my_app
```

## Dependencies

Add `corex` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-alpha.13"}
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

In your `assets/js/app.js`, import and register the Corex hooks:

```javascript
import Hooks from "corex"
```

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...Hooks}
})
```

You can add individual components with:

```javascript
import {Accordion, Checkbox} from "corex"

hooks: {...colocatedHooks, Accordion, Checkbox }
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

By default, this imports and aliases all Corex UI components (such as `accordion/1`, `combobox/1`, etc.), allowing them to be used directly in templates.
You can optionally limit which components are imported with `only:` or `except:`, or add a `prefix:` to avoid name collisions

```elixir
use Corex, only: [:accordion], prefix: "ui"
```
This will only import Accordion component and you can use as
```heex
<.ui_accordion>
...
</.ui_accordion>
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
  
In your `app.css` add the following:

```css
@import "../corex/main.css";
@import "../corex/tokens/themes/neo/light.css";
@import "../corex/components/typo.css";
@import "../corex/components/accordion.css";
```

- Delete Daisy UI related css and plugin `app.css`
  
For more details see [Corex Design](https://hexdocs.pm/corex/Mix.Tasks.Corex.Design.html) mix task use

## Add your first component

Add the following Accordion examples to your application

<!-- tabs-open -->

### List

  You must use `Corex.Accordion.Item` struct for items.

  The value for each item is optional, useful for controlled mode and API to identify the item.

  You can specify disabled for each item.

  ```heex
  <.accordion
    class="accordion"
    items={[
      %Corex.Accordion.Item{
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %Corex.Accordion.Item{
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %Corex.Accordion.Item{
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ]}
  />
  ```

### List Custom

  Similar to List but render a custom item slot that will be used for all items.

  Use `{item.meta.trigger}` and `{item.meta.content}` to render the trigger and content for each item.

  This example assumes the import of `.icon` from `Core Components`

  ```heex
    <.accordion
    class="accordion"
    items={[
      %Corex.Accordion.Item{
        value: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{
          indicator: "hero-chevron-right",
        }
      },
      %Corex.Accordion.Item{
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{
          indicator: "hero-chevron-right",
        }
      },
      %Corex.Accordion.Item{
        value: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{
          indicator: "hero-chevron-right",
        }
      }
    ]}
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

### Custom

  Render a custom item slot per accordion item manually.

  Use let={item} to get the item data and pass it to the `accordion_trigger/1` and `accordion_content/1` components.

  The trigger component takes an optional `:indicator` slot to render the indicator ico

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.accordion id="my-accordion" value={["duis"]} class="accordion">
  <:item :let={item} value="lorem" disabled>
    <.accordion_trigger item={item}>
      Lorem ipsum dolor sit amet
      <:indicator>
       <.icon name="hero-chevron-right" />
      </:indicator>
    </.accordion_trigger>
    <.accordion_content item={item}>
      Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
    </.accordion_content>
  </:item>
  <:item :let={item} value="duis">
    <.accordion_trigger item={item}>
      Duis dictum gravida odio ac pharetra?
      <:indicator>
       <.icon name="hero-chevron-right" />
      </:indicator>
    </.accordion_trigger>
    <.accordion_content item={item}>
      Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
    </.accordion_content>
  </:item>
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
    <.accordion value={@value} on_value_change="on_value_change" class="accordion">
      <:item :let={item} value="lorem">
        <.accordion_trigger item={item}>
          Lorem ipsum dolor sit amet
        </.accordion_trigger>
        <.accordion_content item={item}>
          Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
        </.accordion_content>
      </:item>
      <:item :let={item} value="duis">
        <.accordion_trigger item={item}>
          Duis dictum gravida odio ac pharetra?
        </.accordion_trigger>
        <.accordion_content item={item}>
          Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
        </.accordion_content>
      </:item>
    </.accordion>
  """
  end
  end

  ```

### Async

  When the initial props are not available on mount, you can use the `Phoenix.LiveView.assign_async` function to assign the props asynchronously

  You can use the optional `Corex.Accordion.accordion_skeleton/1` to render a loading or error state

  ```elixir
  defmodule MyAppWeb.AccordionAsyncLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_async(:accordion, fn ->
        Process.sleep(1000)

        items = [
          %Corex.Accordion.Item{
            value: "lorem",
            trigger: "Lorem ipsum dolor sit amet",
            content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
            disabled: true
          },
          %Corex.Accordion.Item{
            value: "duis",
            trigger: "Duis dictum gravida odio ac pharetra?",
            content: "Nullam eget vestibulum ligula, at interdum tellus."
          },
          %Corex.Accordion.Item{
            value: "donec",
            trigger: "Donec condimentum ex mi",
            content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
          }
        ]

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
    <Layouts.app flash={@flash}>
      <div class="layout__row">
        <h1>Accordion</h1>
        <h2>Async</h2>
      </div>

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
    </Layouts.app>
    """
  end
  end

  ```
  <!-- tabs-close -->
 

Full Hex Documentation is available at [http://hexdocs.pm/corex](http://hexdocs.pm/corex)

## License

[MIT](./LICENSE) © [Netoum.com](https://netoum.com)
