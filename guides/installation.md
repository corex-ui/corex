# Installation

![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=corex-install)](https://coveralls.io/github/corex-ui/corex?branch=corex-install)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)

## Introduction

Corex is an accessible UI components library for Phoenix and LiveView. It ships HEEx components, matching JavaScript hooks, and server-side APIs that stay in sync with the client. You bring your own styles, or opt in to the Corex Design system.

This guide covers adding Corex with the official generators. 
For the same manual setup, see [Manual installation](manual_installation.html).

> #### Beta {: .neutral}
>
> Corex is under active development. The public API is stabilizing; report rough edges on [GitHub](https://github.com/corex-ui/corex).

## Prerequisites

- **Elixir** `~> 1.17`
- **Phoenix** and **LiveView**

## New Phoenix application

Install the archives once:

```bash
mix archive.install hex phx_new
mix archive.install hex corex_new
```

Generate an application:

```bash
mix corex.new my_app
```

To update the generator before creating a project:

```bash
mix local.corex
mix corex.new my_app
```

For the full list of switches:

```bash
mix help corex.new
```

## Existing Phoenix application

There is no automatic installer for existing apps. Follow the
[manual installation guide](manual_installation.html) — it's a complete,
copy-paste walkthrough covering the dep, esbuild config, `use Corex`,
the root-layout script tag, and the optional `--mode`, `--theme`,
`--lang`, `--design`, and toast wiring.

To copy the Corex design assets into an existing app:

```bash
mix corex.design
```

Pass `--designex` to also copy the token sources into `assets/corex/design/`.
Pass `--force` to overwrite.

## Corex options (`mix corex.new`)

Corex flags are unique and **do not conflict** with `phx.new` switches, so you can pass them bare alongside Phoenix flags.

| Flag                          | Effect                                                                                                                                                                                                                                                                                                                       |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--mode`                      | Light/dark mode: plugs, assigns, root-layout script, mode toggle (see [Dark mode](dark_mode.html)). **Implies `--design`**.                                                                                                                                                                                                  |
| `--theme`                     | Theme picker (neo, uno, duo, leo): plugs, assigns, theme toggle (see [Theming](theming.html)). **Implies `--design`**.                                                                                                                                                                                                       |
| `--lang`                      | Localization with `localize_web`, Path plug, router helpers (see [Localize](localize.html)). Does **not** imply `--design`.                                                                                                                                                                                                  |
| `--design` / `--no-design`    | Copy **consumer** design assets from the Corex repo’s `priv/design/corex` tree into `assets/corex/` (no `assets/corex/design/` folder). Writes the Corex `app.css`. Pass **`--no-design`** for stock Phoenix Tailwind/daisy. **Default: on**.                                                                                  |
| `--designex`                  | After that, copy **`priv/design/design`** into **`assets/corex/design/`** (token sources next to consumer CSS). Adds the `:designex` Hex dependency (dev runtime), `config :designex`, and runs **`designex corex`** in `assets.build` / `assets.deploy`. **Implies `--design`**.                                           |
| `--dev PATH`                  | Use a local Corex checkout as a path dep (useful when developing Corex). `PATH` is relative to the generated app; `assets/js/app.js` imports `priv/static/corex.mjs` from that checkout via a relative path.                                                                                                                                                                                 |

The generator always writes Corex-owned files from templates: `layouts.ex`,
`root.html.heex`, `home.html.heex`, plus feature-specific plug modules under
`lib/<app>_web/plugs/`. For Phoenix-owned files (`mix.exs`, `<app>_web.ex`,
`router.ex`, `config/config.exs`) it applies small, idempotent patches.

The bundled installer snapshot mirrors **`priv/design`** (sibling **`corex`** and **`design`** folders); default **`--design`** copies only the consumer **`corex`** tree into your app. To refresh design assets after
upgrading the `corex` dependency, run `mix corex.design --force` (or
`mix corex.design --designex --force` to also refresh token sources).

Examples:

```bash
mix corex.new my_app --mode --theme --lang
mix corex.new my_app --no-design
mix corex.new my_app --dev ../corex
```

## Try your first component

After `use Corex` is in your `MyAppWeb` module (the installer puts it there), every Corex function component is available in your templates. Drop these into any `.html.heex` template or `~H` block to verify the install.

### Basic

`Corex.Content.new/1` builds a list of items with optional `id`, `disabled`, and `meta` per item. The `id` is auto-generated when missing.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

### With indicator

The optional `:indicator` slot adds an icon after each trigger. The example below assumes the `<.heroicon>` helper from `core_components.ex`.

```heex
<.accordion
  id="indicator-accordion"
  class="accordion"
  items={Corex.Content.new([
    [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [id: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

### Custom

Use the `:trigger`, `:content`, and `:indicator` slots together to fully control how each item renders. `:let={item}` exposes the item's `data` (including `meta` for per-item customization).

```heex
<.accordion
  id="custom-accordion"
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
        trigger: "Duis dictum gravida?",
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

### Controlled (server-driven)

Pass `controlled` and `value`, and handle `on_value_change` on the server. The event payload is a map with the key `value` (a list of strings) and the accordion `id`.

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
      id="controlled-accordion"
      controlled
      value={@value}
      on_value_change="on_value_change"
      class="accordion"
      items={Corex.Content.new([
        [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
        [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."]
      ])}
    />
    """
  end
end
```

### Async (loading state)

When the data is not available on mount, drive the component from `Phoenix.LiveView.assign_async/3` and use `Corex.Accordion.accordion_skeleton/1` for the loading state.

```elixir
defmodule MyAppWeb.AccordionAsyncLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign_async(socket, :accordion, fn ->
        items =
          Corex.Content.new([
            [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", disabled: true],
            [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
            [id: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
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

      <:failed>There was an error loading the accordion.</:failed>

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

### Driving components from the API

Every Corex component exposes JS commands for client-side control and matching `socket` helpers for server-side control. You need an `id` on the component.

**Client-side**, push commands inline from any element:

```heex
<button type="button" phx-click={Corex.Accordion.set_value("welcome-accordion", ["1"])}>
  Open the first panel
</button>
```

**Server-side**, return the modified socket from a `handle_event/3` (or call it anywhere a `socket` is in scope):

```elixir
def handle_event("open_first", _params, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "welcome-accordion", ["1"])}
end
```

The same pattern applies to every component — see each component's module docs for the available commands.

## Next steps

- [MCP](mcp.html) — Corex MCP for AI tooling in development.
- [Dark mode](dark_mode.html) — light/dark wiring after `--mode`.
- [Theming](theming.html) — theme picker after `--theme`.
- [Localize](localize.html) — locales and routes after `--lang`.
- [Production](production.html) — prod build and run.
- [Manual installation](manual_installation.html) — add Corex to an existing Phoenix app.
