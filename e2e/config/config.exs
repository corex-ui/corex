# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :e2e,
  ecto_repos: [E2e.Repo],
  generators: [timestamp_type: :utc_datetime]

config :corex,
  json_library: Jason,
  gettext_backend: E2eWeb.Gettext,
  rtl_locales: ["ar"]

# Configure the endpoint
config :e2e, E2eWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: E2eWeb.ErrorHTML, json: E2eWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: E2e.PubSub,
  live_view: [signing_salt: "sS0JMLRI"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :e2e, E2e.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
#
# How Corex and shared parts are included:
# - JS: app.js does `import Hooks from "corex"`. NODE_PATH includes deps/ and build path,
#   so "corex" resolves to the corex dependency (path: "../"); esbuild bundles corex's
#   entry (priv/static/corex.mjs), which pulls in all component hooks. That yields a
#   large app.js (~1MB) and is expected.
# - CSS: app.css @imports from assets/corex/ (main.css, tokens, component CSS). Those
#   files live under e2e/assets/corex/ and are built with Tailwind.
#
# To exclude Corex from the bundle (smaller app.js, load Corex separately):
# - Add --external:corex to the args below.
# - Copy deps/corex/priv/static/corex.min.js to priv/static/assets/js/ (or serve it
#   from corex's priv/static) and add <script src="/assets/js/corex.min.js"> before
#   app.js in root.html.heex. Corex's build must expose Hooks globally (e.g. window.Corex)
#   and app.js would use that instead of `import Hooks from "corex"`.
config :esbuild,
  version: "0.25.4",
  e2e: [
    args:
      ~w(js/app.js --bundle --target=es2022 --format=esm --splitting --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  e2e: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
