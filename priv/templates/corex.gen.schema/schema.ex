defmodule <%= inspect schema.module %> do
  use Ecto.Schema
  import Ecto.Changeset
<%= if schema.prefix do %>
  @schema_prefix :<%= schema.prefix %><% end %><%= if schema.opts[:primary_key] do %>
  @derive {Phoenix.Param, key: :<%= schema.opts[:primary_key] %>}<% end %><%= if schema.binary_id do %>
  @primary_key {:<%= primary_key %>, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id<% else %><%= if schema.opts[:primary_key] do %>
  @primary_key {:<%= schema.opts[:primary_key] %>, :id, autogenerate: true}<% end %><% end %>
  schema <%= inspect schema.table %> do
<%= Mix.Phoenix.Schema.format_fields_for_schema(schema) %>
<%= for {_, k, _, _} <- schema.assocs do %>    field <%= inspect k %>, <%= if schema.binary_id do %>:binary_id<% else %>:id<% end %>
<% end %><%= if scope do %>    field :<%= scope.schema_key %>, <%= inspect scope.schema_type %>
<% end %>
    timestamps(<%= if schema.timestamp_type != :naive_datetime, do: "type: #{inspect schema.timestamp_type}" %>)
  end

  @doc false
  def changeset(<%= schema.singular %>, attrs<%= if scope do %>, <%= scope.name %>_scope<% end %>) do
    <%= schema.singular %>
    |> cast(attrs, [
<% attrs_list = schema.attrs %><%= for {{attr, _}, idx} <- Enum.with_index(attrs_list) do %>      <%= inspect attr %><%= if idx < length(attrs_list) - 1 do %>,<% end %>
<% end %>    ])
    |> validate_required([
<% required_list = Mix.Phoenix.Schema.required_fields(schema) %><%= for {{attr, _}, idx} <- Enum.with_index(required_list) do %>      <%= inspect attr %><%= if idx < length(required_list) - 1 do %>,<% end %>
<% end %>    ])
<%= for k <- schema.uniques do %>    |> unique_constraint(<%= inspect k %>)
<% end %><%= if scope do %>    |> put_change(:<%= scope.schema_key %>, <%= scope.name %>_scope.<%= Enum.join(scope.access_path, ".") %>)
<% end %>  end
end
