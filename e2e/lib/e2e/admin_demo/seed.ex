defmodule E2e.AdminDemo.Seed do
  @moduledoc false

  import Ecto.Query

  alias E2e.AdminDemo.Ticket
  alias E2e.Repo

  def ensure_seeded(demo_id) when is_binary(demo_id) do
    count = Repo.aggregate(from(t in Ticket, where: t.demo_id == ^demo_id), :count)

    if count == 0 do
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      extras =
        for n <- 1..29 do
          %{
            demo_id: demo_id,
            title: "Queue ticket #{String.pad_leading(Integer.to_string(n), 2, "0")}",
            email: "agent#{n}@demo.test",
            status: if(rem(n, 2) == 0, do: "done", else: "open"),
            priority: rem(n, 5) + 1,
            body: "Synthetic row #{n} for search, sort, and pagination.",
            inserted_at: now,
            updated_at: now
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
          inserted_at: now,
          updated_at: now
        },
        %{
          demo_id: demo_id,
          title: "High priority",
          email: "prio@example.test",
          status: "open",
          priority: 5,
          body: "Sort by priority to find this one.",
          inserted_at: now,
          updated_at: now
        }
        | extras
      ])
    end

    :ok
  end
end
