defmodule E2e.AdminDemo do
  @moduledoc """
  Context behind the Corex Admin demo.

  Every function takes the demo `Scope` first and scopes its own query. The
  admin calls these and never touches `Repo`, which is the contract a real app
  would follow with `current_scope`.
  """

  import Ecto.Query

  alias CorexAdmin.{ListOpts, Page, Query}
  alias E2e.AdminDemo.{Author, Post, Scope, Ticket}
  alias E2e.Repo

  # -- tickets --------------------------------------------------------------

  def list_tickets(%Scope{} = scope, %ListOpts{} = opts) do
    Ticket
    |> where([t], t.demo_id == ^scope.demo_id)
    |> Query.apply(opts)
    |> page(opts, preload: [:assignee])
  end

  def get_ticket!(%Scope{} = scope, id) do
    Ticket
    |> Repo.get_by!(id: id, demo_id: scope.demo_id)
    |> Repo.preload([:assignee])
  end

  def create_ticket(%Scope{} = scope, attrs) do
    %Ticket{}
    |> Ticket.changeset(scoped_attrs(attrs, scope))
    |> Repo.insert()
  end

  def update_ticket(%Scope{} = scope, %Ticket{} = ticket, attrs) do
    if ticket.demo_id == scope.demo_id do
      ticket |> Ticket.changeset(attrs) |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  def delete_ticket(%Scope{} = scope, %Ticket{} = ticket) do
    if ticket.demo_id == scope.demo_id, do: Repo.delete(ticket), else: {:error, :unauthorized}
  end

  def change_ticket(%Scope{} = _scope, %Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end

  @doc "Sets the status of several tickets at once, for the bulk action."
  def set_ticket_status(%Scope{} = scope, ids, status) do
    {count, _} =
      Ticket
      |> where([t], t.demo_id == ^scope.demo_id and t.id in ^normalize_ids(ids))
      |> Repo.update_all(set: [status: status, updated_at: DateTime.utc_now(:second)])

    {:ok, count}
  end

  @doc """
  Priority range that actually exists in this demo's tickets.

  Drives the slider bounds, so an empty queue does not offer a 1–5 range that
  matches nothing.
  """
  def ticket_priority_bounds(%Scope{} = scope) do
    Ticket
    |> where([t], t.demo_id == ^scope.demo_id)
    |> select([t], {min(t.priority), max(t.priority)})
    |> Repo.one()
    |> case do
      {min, max} when is_integer(min) and is_integer(max) and min != max -> %{min: min, max: max}
      _ -> nil
    end
  end

  @doc "Counts per ticket status, for metric cards."
  def ticket_counts(%Scope{} = scope) do
    Ticket
    |> where([t], t.demo_id == ^scope.demo_id)
    |> group_by([t], t.status)
    |> select([t], {t.status, count(t.id)})
    |> Repo.all()
    |> Map.new()
  end

  @doc "Ticket statuses present in this demo, so the filter offers only real values."
  def ticket_statuses(%Scope{} = scope) do
    Ticket
    |> where([t], t.demo_id == ^scope.demo_id)
    |> distinct(true)
    |> select([t], t.status)
    |> Repo.all()
    |> Enum.sort()
  end

  # -- posts ----------------------------------------------------------------

  def list_posts(%Scope{} = scope, %ListOpts{} = opts) do
    Post
    |> where([p], p.demo_id == ^scope.demo_id)
    |> Query.apply(opts)
    |> page(opts, preload: [:author])
  end

  def get_post!(%Scope{} = scope, id) do
    Post
    |> Repo.get_by!(id: id, demo_id: scope.demo_id)
    |> Repo.preload([:author])
  end

  def create_post(%Scope{} = scope, attrs) do
    %Post{}
    |> Post.changeset(scoped_attrs(attrs, scope))
    |> Repo.insert()
  end

  def update_post(%Scope{} = scope, %Post{} = post, attrs) do
    if post.demo_id == scope.demo_id do
      post |> Post.changeset(attrs) |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  def delete_post(%Scope{} = scope, %Post{} = post) do
    if post.demo_id == scope.demo_id, do: Repo.delete(post), else: {:error, :unauthorized}
  end

  def change_post(%Scope{} = _scope, %Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc "Counts per post status, for metric cards."
  def post_counts(%Scope{} = scope) do
    Post
    |> where([p], p.demo_id == ^scope.demo_id)
    |> group_by([p], p.status)
    |> select([p], {p.status, count(p.id)})
    |> Repo.all()
    |> Map.new()
  end

  # -- authors --------------------------------------------------------------

  def list_authors(%Scope{} = scope, %ListOpts{} = opts) do
    Author
    |> where([a], a.demo_id == ^scope.demo_id)
    |> Query.apply(opts)
    |> page(opts, preload: [:posts])
  end

  @doc """
  Candidate authors for a relation picker.

  Called by the admin with `:query` and `:limit` when the field is searchable,
  so the option list stays bounded no matter how many authors exist.
  """
  def list_authors(%Scope{} = scope, opts) when is_list(opts) do
    query = opts |> Keyword.get(:query, "") |> to_string() |> String.trim()
    limit = Keyword.get(opts, :limit, 50)

    Author
    |> where([a], a.demo_id == ^scope.demo_id and a.active == true)
    |> then(fn q ->
      if query == "" do
        q
      else
        pattern = "%" <> query <> "%"
        where(q, [a], ilike(a.name, ^pattern) or ilike(a.email, ^pattern))
      end
    end)
    |> order_by([a], asc: a.name)
    |> limit(^limit)
    |> Repo.all()
  end

  def get_author!(%Scope{} = scope, id) do
    Author
    |> Repo.get_by!(id: id, demo_id: scope.demo_id)
    |> Repo.preload(posts: from(p in Post, order_by: [desc: p.inserted_at]))
  end

  def create_author(%Scope{} = scope, attrs) do
    %Author{}
    |> Author.changeset(scoped_attrs(attrs, scope))
    |> Repo.insert()
  end

  def update_author(%Scope{} = scope, %Author{} = author, attrs) do
    if author.demo_id == scope.demo_id do
      author |> Author.changeset(attrs) |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  def delete_author(%Scope{} = scope, %Author{} = author) do
    if author.demo_id == scope.demo_id, do: Repo.delete(author), else: {:error, :unauthorized}
  end

  def change_author(%Scope{} = _scope, %Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  # -- shared ---------------------------------------------------------------

  defp page(query, %ListOpts{} = opts, page_opts) do
    entries =
      query
      |> Query.paginate(opts)
      |> Repo.all()
      |> maybe_preload(page_opts[:preload])

    {:ok,
     %Page{
       entries: entries,
       total: Repo.aggregate(query, :count),
       page: opts.page,
       page_size: opts.page_size
     }}
  end

  defp maybe_preload(entries, nil), do: entries
  defp maybe_preload(entries, preload), do: Repo.preload(entries, preload)

  defp scoped_attrs(attrs, %Scope{} = scope) do
    attrs
    |> Map.new(fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {key, value}
    end)
    |> Map.put("demo_id", scope.demo_id)
  end

  defp normalize_ids(ids) do
    ids
    |> List.wrap()
    |> Enum.flat_map(fn id ->
      case Integer.parse(to_string(id)) do
        {int, ""} -> [int]
        _ -> []
      end
    end)
  end
end
