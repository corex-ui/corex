defmodule E2eWeb.Admin.PostResource do
  @moduledoc """
  Editorial calendar.

  The publishing state and its timestamp are validated together in the schema,
  so the admin surfaces a real domain rule rather than a free-form date.
  """

  use CorexAdmin.Resource,
    context: E2e.AdminDemo,
    schema: E2e.AdminDemo.Post,
    slug: "posts",
    group: "Content",
    label: "Posts",
    singular: "Post",
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

    field(:status, :select,
      options: ~w(draft scheduled published archived),
      render: {E2eWeb.Admin.Cells, :status}
    )

    field(:author, :belongs_to,
      relation: [
        context: E2e.AdminDemo,
        list: :list_authors,
        label: :name,
        owner_key: :author_id,
        search: true
      ]
    )

    field(:featured, :boolean)
    field(:tags, :tags)
    field(:published_at, :datetime, label: "Published", sortable: true)
    field(:excerpt, :textarea)
    field(:body, :textarea)
    field(:inserted_at, :datetime, label: "Created", sortable: true)
  end

  form do
    section("Post", [:title, :slug, :status, :author, :published_at, :featured, :tags])
    section("Content", [:excerpt, :body])
  end

  filters do
    filter(:status, :multi_select, options: ~w(draft scheduled published archived), pin: true)
    filter(:published_at, :datetime_range, label: "Published", pin: true)
    filter(:featured, :boolean, pin: true)
    filter(:author_name, :text, label: "Author", path: [:author, :name], pin: false)
    filter(:tags, :tags, pin: false)
    filter(:excerpt, :presence, pin: false)
    filter(:id, :id, pin: false)
  end

  def canned_filters do
    [
      {"Live", %{"filters" => %{"status" => ["published"]}}},
      {"In progress", %{"filters" => %{"status" => ["draft", "scheduled"]}}},
      {"Featured", %{"filters" => %{"featured" => "true"}}}
    ]
  end

  def metrics(scope, _list_opts) do
    counts = E2e.AdminDemo.post_counts(scope)

    [
      %{label: "Published", value: Map.get(counts, "published", 0)},
      %{label: "Scheduled", value: Map.get(counts, "scheduled", 0), hint: "queued to go live"},
      %{label: "Drafts", value: Map.get(counts, "draft", 0)}
    ]
  end
end
