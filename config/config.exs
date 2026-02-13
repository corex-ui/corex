import Config

config :logger, :console,
  colors: [enabled: false],
  format: "\n$time $metadata[$level] $message\n"

config :phoenix,
  json_library: Jason,
  stacktrace_depth: 20,
  trim_on_html_eex_engine: false,
  sort_verified_routes_query_params: true

if Mix.env() == :dev do
  corex_externals =
    ~w(accordion checkbox clipboard collapsible combobox date-picker dialog menu select signature-pad switch tabs toast toggle-group tree-view)
    |> Enum.map(fn name -> "--external:corex/#{name}" end)

  esbuild = fn args ->
    [
      args: ~w(./hooks/corex --bundle) ++ args,
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
    ]
  end

  hooks_entries =
    ~w(
      ./hooks/accordion.ts
      ./hooks/checkbox.ts
      ./hooks/clipboard.ts
      ./hooks/collapsible.ts
      ./hooks/combobox.ts
      ./hooks/date-picker.ts
      ./hooks/dialog.ts
      ./hooks/menu.ts
      ./hooks/select.ts
      ./hooks/signature-pad.ts
      ./hooks/switch.ts
      ./hooks/tabs.ts
      ./hooks/toast.ts
      ./hooks/toggle-group.ts
      ./hooks/tree-view.ts
    )

  hooks_args =
    hooks_entries ++
      ~w(--bundle --splitting --format=esm --outdir=../priv/static --out-extension:.js=.mjs)

  config :esbuild,
    version: "0.25.4",
    module:
      esbuild.(~w(--format=esm --sourcemap --outfile=../priv/static/corex.mjs) ++ corex_externals),
    main:
      esbuild.(
        ~w(--format=cjs --sourcemap --outfile=../priv/static/corex.cjs.js) ++ corex_externals
      ),
    cdn:
      esbuild.(
        ~w(--target=es2016 --format=iife --global-name=Corex --outfile=../priv/static/corex.js)
      ),
    cdn_min:
      esbuild.(
        ~w(--target=es2016 --format=iife --global-name=Corex --minify --outfile=../priv/static/corex.min.js)
      ),
    hooks: [
      args: hooks_args,
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
    ]
end
