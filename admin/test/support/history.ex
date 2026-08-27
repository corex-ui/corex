defmodule CorexAdmin.Test.History do
  @moduledoc false
  @behaviour CorexAdmin.History

  alias CorexAdmin.History.Version

  @impl true
  def history(_schema, _id, _opts) do
    [
      %Version{
        id: "1",
        at: ~U[2026-01-15 12:00:00Z],
        actor: "ops@example.test",
        action: "update",
        changes: [%{field: "title", from: "Old", to: "Broken login"}]
      }
    ]
  end
end
