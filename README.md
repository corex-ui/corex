
![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=corex-install)](https://coveralls.io/github/corex-ui/corex?branch=corex-install)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)

# Corex

Corex is an accessible and unstyled UI components library written in Elixir and TypeScript that integrates [Zag.js](https://zagjs.com/) state machines into the Phoenix Framework.

Corex bridges the gap between Phoenix and modern JavaScript UI patterns by leveraging Zag.js: a collection of framework-agnostic UI component state machines. This approach gives you:

- **Accessible by default** - Built-in ARIA attributes and keyboard navigation
- **Unstyled components** - Complete control over styling and design
- **Type-safe state management** - Powered by Zag.js state machines
- **Works everywhere** - Phoenix Controllers and LiveView
- **No Node.js required** - Install directly from Hex and connect the Phoenix hooks

> **Alpha stage**
> Corex is actively being developed and is currently in alpha stage.
> It's not recommended for production use at this time.
> You can monitor development progress and contribute to the [project on GitHub](https://github.com/corex-ui/corex).

## Live Demo

To preview the components, a [Live Demo](https://corex.gigalixirapp.com/en) is available to showcase some uses of components, language switching, RTL, and Dark Mode and Site Navigation.

You can also explore all components via [Live Captures](https://corex.gigalixirapp.com/captures/components/Elixir.CorexWeb.Accordion/accordion), a zero-boilerplate storybook for LiveView components. A big thanks to [@achempion](https://github.com/achempion) for assisting.

This is still in an early stage and will evolve with future stable releases.

Thanks to [Gigalixir](https://www.gigalixir.com/) for providing a reliable hosting solution for Elixir projects *(not sponsored, just a personal experience)*.


## Documentation

Full documentation is available at [hexdocs.pm/corex](http://hexdocs.pm/corex).

## Installation

Install the Corex project generator, then create a new Phoenix application with Corex:

```bash
mix archive.install hex corex_new
mix corex.new my_app
cd my_app
mix deps.get
```

To update the generator to the latest version first, run `mix local.corex` before `mix corex.new my_app`.

The generated project includes Corex, configuration, and default styling.

## Existing Project

To add Corex to an existing Phoenix app instead of using the generator, see [Manual installation](manual_installation.html).


### Add your first component

Example Accordion using `Corex.Content.new/1`:

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

More Accordion examples (with indicator, custom slots, controlled, async) and API control are in the [Installation guide](https://hexdocs.pm/corex/installation.html#add-your-first-component).

## License

[MIT](./LICENSE) © [Netoum.com](https://netoum.com)
