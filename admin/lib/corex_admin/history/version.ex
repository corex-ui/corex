defmodule CorexAdmin.History.Version do
  @moduledoc false

  defstruct [:id, :at, :actor, :action, changes: []]

  @type change :: %{field: String.t(), from: term(), to: term()}

  @type t :: %__MODULE__{
          id: term(),
          at: DateTime.t() | NaiveDateTime.t() | String.t() | nil,
          actor: term(),
          action: String.t() | atom() | nil,
          changes: [change()]
        }
end
