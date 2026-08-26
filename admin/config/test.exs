import Config

config :phoenix, :json_library, Jason
config :phoenix, :plug_init_mode, :runtime

config :corex_admin, CorexAdmin.Test.Endpoint,
  url: [host: "localhost"],
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: String.duplicate("abcdefgh", 8),
  live_view: [signing_salt: "corexadmin"],
  server: false,
  pubsub_server: CorexAdmin.Test.PubSub

config :corex_admin,
  default_page_size: 25,
  page_size_options: [10, 25, 50, 100],
  max_page_size: 100,
  debug: false
