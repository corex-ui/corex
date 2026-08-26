defmodule E2eWeb.Admin.PostResource do
  @moduledoc false

  use CorexAdmin.Resource,
    context: E2e.AdminDemo,
    schema: E2e.AdminDemo.Post,
    slug: "posts",
    group: "Content",
    label: "Posts",
    page_size: 25,
    page_size_options: [10, 25, 50, 100],
    default_sort: {:inserted_at, :desc},
    title_field: :title,
    selectable: true

  scope(:current_scope)

  actions do
    list(:list_posts)
    get(:get_post!)
    create(:create_post)
    update(:update_post)
    delete(:delete_post)
    change_create(:change_post)
    change_update(:change_post)
  end

  fields do
    field(:id, :id)
    field(:title, :text, searchable: true, sortable: true)
    field(:slug, :text, searchable: true, sortable: true)
    field(:status, :select, options: ~W(draft published))
    field(:author, :email, searchable: true, sortable: true)
    field(:excerpt, :textarea)
    field(:body, :textarea)
    field(:inserted_at, :datetime, sortable: true)
  end

  filters do
    filter(:status, :select, options: ~W(draft published))
    filter(:inserted_at, :date_range, label: "Published")
  end
end
