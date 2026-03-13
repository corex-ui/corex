[
  import_deps: [<%= if @ecto do %>:ecto, :ecto_sql, <% end %>:phoenix],<%= if @ecto do %>
  subdirectories: ["priv/*/migrations"],<% end %>
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"<%= if @ecto do %>, "priv/*/seeds.exs"<% end %>]
]
