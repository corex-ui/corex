defmodule E2eWeb.AdminAuth do
  @moduledoc false

  alias E2e.AdminDemo.{Scope, Seed, Session}
  alias E2e.Repo

  def on_mount(:ensure_demo, _params, session, socket) do
    demo_id = session["admin_demo_id"] || Ecto.UUID.generate()
    touch_session(demo_id)
    Seed.ensure_seeded(demo_id)

    scope = %Scope{demo_id: demo_id, role: :admin}

    {:cont, Phoenix.Component.assign(socket, :current_scope, scope)}
  end

  defp touch_session(demo_id) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    %Session{demo_id: demo_id, last_seen_at: now}
    |> Repo.insert(
      on_conflict: [set: [last_seen_at: now]],
      conflict_target: [:demo_id]
    )
  end
end
