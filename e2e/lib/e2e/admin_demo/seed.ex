defmodule E2e.AdminDemo.Seed do
  @moduledoc """
  Session-scoped demo data.

  The point is a queue that looks like a real one: a spread of statuses,
  assignees, due dates, and priorities, so filters, sorting, and metrics have
  something to say.
  """

  import Ecto.Query

  alias E2e.AdminDemo.{Author, Post, Ticket}
  alias E2e.Repo

  @authors [
    %{name: "Ada Okonkwo", email: "ada@demo.test", role: "editor", bio: "Runs the calendar."},
    %{name: "Grace Lindqvist", email: "grace@demo.test", role: "writer", bio: "Long-form."},
    %{name: "Rafael Duarte", email: "rafael@demo.test", role: "writer", bio: "Release notes."},
    %{name: "Mei Tanaka", email: "mei@demo.test", role: "reviewer", bio: "Copy review."},
    %{name: "Tomas Weber", email: "tomas@demo.test", role: "writer", active: false}
  ]

  @subjects [
    "Password reset email never arrives",
    "Invoice PDF is missing line items",
    "Cannot invite a teammate",
    "Export stops at 10k rows",
    "Timezone is wrong on the dashboard",
    "SSO login loops back to sign-in",
    "Webhook retries are duplicated",
    "Search misses accented names",
    "Mobile nav traps focus",
    "Bulk import rejects valid rows"
  ]

  def ensure_seeded(demo_id) when is_binary(demo_id) do
    authors = ensure_authors(demo_id)
    ensure_tickets(demo_id, authors)
    ensure_posts(demo_id, authors)
    :ok
  end

  defp ensure_authors(demo_id) do
    existing = Repo.all(from(a in Author, where: a.demo_id == ^demo_id))

    if existing == [] do
      now = DateTime.utc_now(:second)

      rows =
        Enum.map(@authors, fn author ->
          author
          |> Map.merge(%{demo_id: demo_id, inserted_at: now, updated_at: now})
          |> Map.put_new(:active, true)
        end)

      Repo.insert_all(Author, rows)
      Repo.all(from(a in Author, where: a.demo_id == ^demo_id, order_by: a.id))
    else
      existing
    end
  end

  defp ensure_tickets(demo_id, authors) do
    count = Repo.aggregate(from(t in Ticket, where: t.demo_id == ^demo_id), :count)

    if count == 0 do
      now = DateTime.utc_now(:second)
      today = Date.utc_today()
      assignable = Enum.filter(authors, & &1.active)

      rows =
        for {subject, index} <- Enum.with_index(@subjects), n <- 0..2 do
          seq = index * 3 + n
          at = DateTime.add(now, -seq, :day)
          assignee = assignee_for(assignable, seq)

          %{
            demo_id: demo_id,
            title: ticket_title(subject, n),
            email: "customer#{seq + 1}@example.test",
            status: Enum.at(~w(open pending done), rem(seq, 3)),
            priority: rem(seq, 5) + 1,
            due_on: Date.add(today, rem(seq, 9) - 3),
            assignee_id: assignee && assignee.id,
            body: "Reported by customer #{seq + 1}. #{subject}.",
            inserted_at: at,
            updated_at: at
          }
        end

      Repo.insert_all(Ticket, rows)
      add_preferred_links(demo_id)
    end

    :ok
  end

  defp ticket_title(subject, 0), do: subject
  defp ticket_title(subject, n), do: "#{subject} (report #{n + 1})"

  defp assignee_for([], _seq), do: nil
  defp assignee_for(authors, seq), do: Enum.at(authors, rem(seq, length(authors)))

  # One ticket carries social links so the nested list and its one-of flag are
  # visible without having to add a row by hand first.
  defp add_preferred_links(demo_id) do
    ticket =
      Repo.one(
        from(t in Ticket, where: t.demo_id == ^demo_id, order_by: [desc: t.inserted_at], limit: 1)
      )

    if ticket do
      ticket
      |> Ticket.changeset(%{
        "social_links" => [
          %{
            "label" => "Status page",
            "url" => "https://example.test/status",
            "preferred" => true
          },
          %{"label" => "Docs", "url" => "https://example.test/docs", "preferred" => false}
        ]
      })
      |> Repo.update!()
    end
  end

  defp ensure_posts(demo_id, authors) do
    count = Repo.aggregate(from(p in Post, where: p.demo_id == ^demo_id), :count)

    if count == 0 do
      now = DateTime.utc_now(:second)

      drafts = [
        {"Shipping Corex Admin", "shipping-corex-admin", ~w(release admin)},
        {"How we scope every query", "scoping-every-query", ~w(engineering ecto)},
        {"Designing the filter row", "designing-the-filter-row", ~w(design ux)},
        {"What we learned from Filament", "lessons-from-filament", ~w(research)},
        {"Accessibility in data tables", "accessible-data-tables", ~w(design a11y)},
        {"Export without blocking", "export-without-blocking", ~w(engineering)},
        {"Relations, finally", "relations-finally", ~w(release admin)},
        {"A tour of the DSL", "a-tour-of-the-dsl", ~w(docs)}
      ]

      rows =
        for {{title, slug, tags}, index} <- Enum.with_index(drafts) do
          status = Enum.at(~w(published published scheduled draft archived), rem(index, 5))
          author = Enum.at(authors, rem(index, max(length(authors), 1)))

          %{
            demo_id: demo_id,
            title: title,
            slug: slug,
            status: status,
            tags: tags,
            featured: rem(index, 4) == 0,
            author_id: author && author.id,
            published_at: published_at(status, now, index),
            excerpt: "#{title} — a short summary for the index.",
            body: "Body copy for #{title}.",
            inserted_at: DateTime.add(now, -index, :day),
            updated_at: DateTime.add(now, -index, :day)
          }
        end

      Repo.insert_all(Post, rows)
    end

    :ok
  end

  defp published_at("published", now, index), do: DateTime.add(now, -(index + 1), :day)
  defp published_at("scheduled", now, index), do: DateTime.add(now, index + 2, :day)
  defp published_at(_status, _now, _index), do: nil
end
