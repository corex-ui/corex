defmodule E2e.AdminDemo do
  @moduledoc false

  import Ecto.Query

  alias CorexAdmin.{ListOpts, Page, Query}
  alias E2e.AdminDemo.{Post, Scope, Ticket}
  alias E2e.Repo

  def list_tickets(%Scope{} = scope, %ListOpts{} = opts) do
    query =
      Ticket
      |> where([t], t.demo_id == ^scope.demo_id)
      |> Query.apply(opts)

    {:ok,
     %Page{
       entries: Repo.all(Query.paginate(query, opts)),
       total: Repo.aggregate(query, :count),
       page: opts.page,
       page_size: opts.page_size
     }}
  end

  def get_ticket!(%Scope{} = scope, id) do
    Repo.get_by!(Ticket, id: id, demo_id: scope.demo_id)
  end

  def create_ticket(%Scope{} = scope, attrs) do
    attrs =
      attrs
      |> Map.new(fn
        {key, value} when is_atom(key) -> {Atom.to_string(key), value}
        {key, value} -> {key, value}
      end)
      |> Map.put("demo_id", scope.demo_id)

    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end

  def update_ticket(%Scope{} = scope, %Ticket{} = ticket, attrs) do
    if ticket.demo_id == scope.demo_id do
      ticket
      |> Ticket.changeset(attrs)
      |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  def delete_ticket(%Scope{} = scope, %Ticket{} = ticket) do
    if ticket.demo_id == scope.demo_id do
      Repo.delete(ticket)
    else
      {:error, :unauthorized}
    end
  end

  def change_ticket(%Scope{} = _scope, %Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end

  def list_posts(%Scope{} = scope, %ListOpts{} = opts) do
    query =
      Post
      |> where([p], p.demo_id == ^scope.demo_id)
      |> Query.apply(opts)

    {:ok,
     %Page{
       entries: Repo.all(Query.paginate(query, opts)),
       total: Repo.aggregate(query, :count),
       page: opts.page,
       page_size: opts.page_size
     }}
  end

  def get_post!(%Scope{} = scope, id) do
    Repo.get_by!(Post, id: id, demo_id: scope.demo_id)
  end

  def create_post(%Scope{} = scope, attrs) do
    attrs =
      attrs
      |> Map.new(fn
        {key, value} when is_atom(key) -> {Atom.to_string(key), value}
        {key, value} -> {key, value}
      end)
      |> Map.put("demo_id", scope.demo_id)

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Scope{} = scope, %Post{} = post, attrs) do
    if post.demo_id == scope.demo_id do
      post
      |> Post.changeset(attrs)
      |> Repo.update()
    else
      {:error, :unauthorized}
    end
  end

  def delete_post(%Scope{} = scope, %Post{} = post) do
    if post.demo_id == scope.demo_id do
      Repo.delete(post)
    else
      {:error, :unauthorized}
    end
  end

  def change_post(%Scope{} = _scope, %Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
