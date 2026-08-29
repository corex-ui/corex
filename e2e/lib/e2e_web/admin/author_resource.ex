defmodule E2eWeb.Admin.AuthorResource do
  @moduledoc """
  People who write posts and pick up tickets.

  The `has_many` fields give the show page related lists, filled from the
  preloads `get_author!/2` already does — the admin never loads an association
  itself.
  """

  use CorexAdmin.Resource,
    context: E2e.AdminDemo,
    schema: E2e.AdminDemo.Author,
    slug: "authors",
    group: "Content",
    label: "Authors",
    singular: "Author",
    page_size: 25,
    default_sort: {:name, :asc},
    title_field: :name,
    selectable: true

  scope(:current_scope)

  actions do
    list(:list_authors)
    get(:get_author!)
    create(:create_author)
    update(:update_author)
    delete(:delete_author)
    change_create(:change_author)
    change_update(:change_author)
  end

  fields do
    field(:id, :id)
    field(:name, :text, searchable: true, sortable: true)
    field(:email, :email, searchable: true, sortable: true)
    field(:role, :radio, options: ~W(editor writer reviewer))
    field(:active, :boolean)
    field(:bio, :textarea)

    column(:post_count, E2eWeb.Admin.Cells.PostCount, label: "Posts")

    field(:posts, :has_many,
      label: "Recent posts",
      index: false,
      relation: [
        context: E2e.AdminDemo,
        schema: E2e.AdminDemo.Post,
        label: :title,
        columns: [:title, :status, :published_at]
      ]
    )

    field(:inserted_at, :datetime, label: "Joined", sortable: true)
  end

  filters do
    filter(:role, :multi_select, options: ~W(editor writer reviewer), pin: true)
    filter(:active, :boolean, label: "Active", pin: true)
    filter(:name, :text, pin: false)
    filter(:bio, :presence, pin: false)
  end

  def canned_filters do
    [{"Editors", %{"filters" => %{"role" => ["editor"]}}}]
  end

  def metrics(scope, _list_opts) do
    case E2e.AdminDemo.list_authors(scope, %CorexAdmin.ListOpts{page: 1, page_size: 1}) do
      {:ok, page} -> [%{label: "Authors", value: page.total}]
      {:error, _} -> []
    end
  end
end
