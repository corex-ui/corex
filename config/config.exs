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
  esbuild = fn args ->
    [
      args: ~w(./hooks/corex --metafile=meta.json --bundle) ++ args,
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
    ]
  end

  config :esbuild,
    version: "0.25.4",
    module: esbuild.(~w(--format=esm --sourcemap --outfile=../priv/static/corex.mjs)),
    main: esbuild.(~w(--format=cjs --sourcemap --outfile=../priv/static/corex.cjs.js)),
    cdn:
      esbuild.(
        ~w(--target=es2016 --format=iife --global-name=Corex --outfile=../priv/static/corex.js)
      ),
    cdn_min:
      esbuild.(
        ~w(--target=es2016 --format=iife --global-name=Corex --minify --outfile=../priv/static/corex.min.js)
      )
end
