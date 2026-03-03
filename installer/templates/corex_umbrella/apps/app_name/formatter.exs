[<%= if @ecto do %>
  import_deps: [:ecto, :ecto_sql],
  subdirectories: ["priv/*/migrations"],<% end %>
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"<%= if @ecto do %>, "priv/*/seeds.exs"<% end %>]
]
