defmodule E2e.AdminDemo.Seed do
  @moduledoc false

  import Ecto.Query

  alias E2e.AdminDemo.{Post, Ticket}
  alias E2e.Repo

  def ensure_seeded(demo_id) when is_binary(demo_id) do
    ensure_tickets(demo_id)
    ensure_posts(demo_id)
    :ok
  end

  defp ensure_tickets(demo_id) do
    count = Repo.aggregate(from(t in Ticket, where: t.demo_id == ^demo_id), :count)

    if count == 0 do
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      extras =
        for n <- 1..29 do
          at = DateTime.add(now, -n, :day)

          %{
            demo_id: demo_id,
            title: "Queue ticket #{String.pad_leading(Integer.to_string(n), 2, "0")}",
            email: "agent#{n}@demo.test",
            status: if(rem(n, 2) == 0, do: "done", else: "open"),
            priority: rem(n, 5) + 1,
            body: "Synthetic row #{n} for search, sort, and pagination.",
            inserted_at: at,
            updated_at: at
          }
        end

      Repo.insert_all(Ticket, [
        %{
          demo_id: demo_id,
          title: "Welcome ticket",
          email: "ops@example.test",
          status: "open",
          priority: 2,
          body: "This dataset is isolated to your demo session.",
          inserted_at: now,
          updated_at: now
        },
        %{
          demo_id: demo_id,
          title: "Search me",
          email: "search@example.test",
          status: "done",
          priority: 1,
          body: "Use search and filters on this row.",
          inserted_at: DateTime.add(now, -1, :day),
          updated_at: DateTime.add(now, -1, :day)
        },
        %{
          demo_id: demo_id,
          title: "High priority",
          email: "prio@example.test",
          status: "open",
          priority: 5,
          body: "Sort by priority to find this one.",
          inserted_at: DateTime.add(now, -10, :day),
          updated_at: DateTime.add(now, -10, :day)
        }
        | extras
      ])

      welcome =
        Repo.get_by!(Ticket, demo_id: demo_id, title: "Welcome ticket")

      welcome
      |> Ticket.changeset(%{
        "social_links" => [
          %{"label" => "Docs", "url" => "https://example.test/docs", "preferred" => true},
          %{"label" => "Status", "url" => "https://example.test/status", "preferred" => false}
        ]
      })
      |> Repo.update!()
    end

    :ok
  end

  defp ensure_posts(demo_id) do
    count = Repo.aggregate(from(p in Post, where: p.demo_id == ^demo_id), :count)

    if count == 0 do
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      posts =
        [
          %{
            title: "Welcome post",
            slug: "welcome-post",
            status: "published",
            author: "editor@demo.test",
            excerpt: "Session-scoped blog posts for the Admin demo.",
            body: "This dataset is isolated to your demo session."
          },
          %{
            title: "Draft notes",
            slug: "draft-notes",
            status: "draft",
            author: "writer@demo.test",
            excerpt: "An unpublished draft.",
            body: "Use status filters to hide drafts."
          },
          %{
            title: "Shipping Corex Admin",
            slug: "shipping-corex-admin",
            status: "published",
            author: "ops@demo.test",
            excerpt: "How the isolated admin demo is wired.",
            body: "Tickets and posts share the same session scope."
          }
        ] ++
          for n <- 1..7 do
            %{
              title: "Archive post #{String.pad_leading(Integer.to_string(n), 2, "0")}",
              slug: "archive-post-#{n}",
              status: if(rem(n, 2) == 0, do: "published", else: "draft"),
              author: "author#{n}@demo.test",
              excerpt: "Synthetic post #{n} for search and filters.",
              body: "Body for archive post #{n}."
            }
          end

      rows =
        posts
        |> Enum.with_index()
        |> Enum.map(fn {post, index} ->
          at = DateTime.add(now, -index, :day)

          post
          |> Map.merge(%{
            demo_id: demo_id,
            inserted_at: at,
            updated_at: at
          })
        end)

      Repo.insert_all(Post, rows)
    end

    :ok
  end
end
