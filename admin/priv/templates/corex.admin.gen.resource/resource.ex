defmodule <%= inspect resource_module %> do
  @moduledoc false

  use CorexAdmin.Resource,
    context: <%= inspect context_module %>,
    schema: <%= inspect schema_module %>,
    slug: <%= inspect slug %>,
    group: <%= inspect group %>,
    label: <%= inspect label %>,
    page_size: 25,
    page_size_options: [10, 25, 50, 100]<%= if default_sort do %>,
    default_sort: <%= inspect default_sort %><% end %><%= if title_field do %>,
    title_field: <%= inspect title_field %><% end %>
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

    # Nested embeds (optional):
    # field :social_links, :embeds_many, schema: MyApp.SocialLink, index: false do
    #   field :label, :text
    #   field :url, :url
    # end
  end
<%= if filters != [] do %>
  filters do<%= for {name, type} <- filters do %>
    filter :<%= name %>, :<%= type %>
<% end %>  end
<% end %>end
