defmodule <%= inspect resource_module %> do
  @moduledoc false

  use CorexAdmin.Resource,
    context: <%= inspect context_module %>,
    schema: <%= inspect schema_module %>,
    slug: <%= inspect slug %>,
    group: <%= inspect group %>,
    label: <%= inspect label %>
<%= if with_scope? do %>
  scope :current_scope
<% end %>
  actions do
    list :list_<%= plural %>
    get :get_<%= singular %>!
    create :create_<%= singular %>
    update :update_<%= singular %>
    delete :delete_<%= singular %>
    change_create :change_<%= singular %>
    change_update :change_<%= singular %>
  end

  fields do<%= for {name, type, opts} <- fields do %>
    field :<%= name %>, :<%= type %><%= if opts != "" do %>, <%= opts %><% end %><% end %>
  end
end
