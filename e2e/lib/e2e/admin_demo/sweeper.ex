defmodule E2e.AdminDemo.Sweeper do
  @moduledoc false
  use GenServer

  import Ecto.Query

  alias E2e.AdminDemo.{Author, Post, Session, Ticket}
  alias E2e.Repo

  @ttl_ms :timer.minutes(30)
  @interval_ms :timer.minutes(5)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    sweep()
    schedule()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:sweep, state) do
    sweep()
    schedule()
    {:noreply, state}
  end

  def sweep do
    cutoff =
      DateTime.utc_now()
      |> DateTime.add(-div(@ttl_ms, 1000), :second)
      |> DateTime.truncate(:second)

    expired_ids =
      Repo.all(from(s in Session, where: s.last_seen_at < ^cutoff, select: s.demo_id))

    # Tickets and posts reference authors, so they go first.
    if expired_ids != [] do
      Repo.delete_all(from(t in Ticket, where: t.demo_id in ^expired_ids))
      Repo.delete_all(from(p in Post, where: p.demo_id in ^expired_ids))
      Repo.delete_all(from(a in Author, where: a.demo_id in ^expired_ids))
      Repo.delete_all(from(s in Session, where: s.demo_id in ^expired_ids))
    end

    :ok
  end

  defp schedule, do: Process.send_after(self(), :sweep, @interval_ms)
end
