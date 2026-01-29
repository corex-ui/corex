# Installation

This guide will walk you through installing and configuring Corex in your Phoenix application.

## Prerequisites

- Phoenix 1.7+ with LiveView
- Gettext

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
    {:corex, "~> 0.1.0-alpha.1"}
  ]
end
```

Then fetch the dependencies:

```bash
mix deps.get
```

## Configuration

Configure Gettext backend in your `config/config.exs`:

```elixir
config :corex,
  gettext_backend: MyAppWeb.Gettext
```


### 2. Import Corex Hooks

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

## Import Components

Add `import Corex` into your `MyAppWeb` `html_helpers`

```elixir
  defp html_helpers do
    quote do
      # Translation
      use Gettext, backend: MyAppWeb.Gettext

      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components
      import MyAppWeb.CoreComponents
      import Corex
      # Common modules used in templates
      alias Phoenix.LiveView.JS
      alias MyAppWeb.Layouts

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end
```

## Styling

All components are unstyled by default, in this guide we will use the default styling provided by Corex

Apply the default theme by adding `data-theme="neo" data-mode="light"` to your `html` tag in `root.html.heex`

In your `app.css` add the following:

```css
@import "corex/design";
@import "corex/design/themes/neo/light.css";
@import "corex/design/components/typo.css";
@import "corex/design/components/accordion.css";
```

## Add your first component

```html
<.accordion class="accordion">
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Lorem ipsum dolor sit amet
    </.accordion_trigger>
    <.accordion_content item={item}>
      Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
    </.accordion_content>
  </:item>
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Duis dictum gravida odio ac pharetra?
    </.accordion_trigger>
    <.accordion_content item={item}>
      Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
    </.accordion_content>
  </:item>
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Donec condimentum ex mi
    </.accordion_trigger>
    <.accordion_content item={item}>
      Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis non, pellentesque elit. Pellentesque sagittis fermentum.
    </.accordion_content>
  </:item>
</.accordion>
```

## Next Steps

Now that Corex is installed, explore the component documentation:

- [Accordion](Corex.Accordion.html)
- [Switch](Corex.Switch.html)
