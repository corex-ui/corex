ExUnit.start()<%= if @ecto do %>
<%= @adapter_config[:test_setup_all] %><% end %><%= if @a11y do %>
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, <%= @endpoint_module %>.url())
{:ok, _} = <%= @endpoint_module %>.start_link()<% end %>
