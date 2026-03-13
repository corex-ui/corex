# Troubleshooting

## Performance during development

During development only, you may experience a slowdown in performance and reactivity, especially on low specification local machines. This is due to Esbuild and Tailwind compiler serving unminified assets during development. To improve performance during development, you can minify assets.

In your `mix.exs` add `--minify` option to Tailwind and/or Esbuild:

```elixir
"assets.build": [
  "compile",
  "tailwind my_app --minify",
  "esbuild my_app --minify"
]
```

In your `config/dev.exs` add `--minify` option to Tailwind and/or Esbuild watchers:

```elixir
watchers: [
  esbuild: {Esbuild, :install_and_run, [:my_app, ~w(--sourcemap=inline --watch --minify)]},
  tailwind: {Tailwind, :install_and_run, [:my_app, ~w(--watch --minify)]}
]
```

See the [Production guide](production.html) for the final build in production.
