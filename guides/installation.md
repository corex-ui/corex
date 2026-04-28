# Installation

![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=corex-install)](https://coveralls.io/github/corex-ui/corex?branch=corex-install)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)

## Introduction

Corex is an accessible UI components library for Phoenix and LiveView. It ships HEEx components, matching JavaScript hooks, and server-side APIs that stay in sync with the client. You bring your own styles, or opt in to the Corex Design system.

This guide covers adding Corex with the official generators. For the same setup without Igniter, see [Manual installation](manual_installation.html).

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
mix archive.install hex igniter_new
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

From your app directory:

```bash
mix igniter.install corex
```

Re-running `mix igniter.install corex` with the same flags makes no diffs to the project — the installer is idempotent. Re-running with new UI flags (e.g. add `--lang` later) only adds the new bits; previously enabled features are preserved.

## Corex options (`corex.new` and `mix igniter.install corex`)

Corex flags are unique and **do not conflict** with `phx.new` or Igniter switches, so you can pass them bare to either generator (no `--corex.` prefix needed).

| Flag                          | Effect                                                                                                                                                                                                                                                                                                                       |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--mode`                      | Light/dark mode: plugs, assigns, root layout script, optional layout UI (see [Dark mode](dark_mode.html)). **Implies `--design`** (with a notice).                                                                                                                                                                           |
| `--theme`                     | Theme picker (neo, uno, duo, leo): plugs, assigns, optional UI (see [Theming](theming.html)). **Implies `--design`** (with a notice).                                                                                                                                                                                        |
| `--lang`                      | Localization with `localize_web`, Path plug, router helpers (see [Localize](localize.html)). Does **not** imply `--design`.                                                                                                                                                                                                  |
| `--design` / `--no-design`    | Add the Corex Design system: copy assets into `assets/corex/`, strip stock daisy/Tailwind, and replace `assets/css/app.css` with the Corex design entry. Pass **`--no-design`** to leave the stock Phoenix Tailwind/daisy setup in place. **Default: on**.                                                                  |
| `--designex`                  | Also copy the design token sources into `assets/corex/design/`. **Implies `--design`**.                                                                                                                                                                                                                                      |
| `--mcp` / `--no-mcp`          | Add the Corex MCP plug on the web endpoint in development. Pass **`--no-mcp`** to skip. **Default: on**.                                                                                                                                                                                                                     |

The installer always patches `Layouts.app` and `home.html.heex`. Stock Phoenix templates are fully replaced with the Corex layout; already-touched files get only the missing flag-driven pieces (switchers, attrs, declarations) without losing existing customizations.

To refresh the Corex design assets to a newer version, remove `assets/corex/` and re-run `mix igniter.install corex --design [--designex]`.

Examples:

```bash
mix corex.new my_app --mode --theme --lang
mix corex.new my_app --no-design
mix igniter.install corex --mode --theme --lang --yes
```

Installing Corex from a **local checkout or path dependency** is **not** covered here — use **`mix help corex.new`** and the moduledoc for `Mix.Tasks.Corex.New`.

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
- [Manual installation](manual_installation.html) — install Corex without Igniter.
