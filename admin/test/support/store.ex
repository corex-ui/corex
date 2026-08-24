defmodule CorexAdmin.Test.Store do
  @moduledoc false

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {Agent, :start_link, [fn -> %{seq: 1, tickets: []} end, [name: __MODULE__]]}
    }
  end

  def reset do
    case Process.whereis(__MODULE__) do
      nil ->
        case Agent.start_link(fn -> %{seq: 1, tickets: []} end, name: __MODULE__) do
          {:ok, _pid} -> :ok
          {:error, {:already_started, _pid}} -> reset()
        end

      _pid ->
        Agent.update(__MODULE__, fn _ -> %{seq: 1, tickets: []} end)
        :ok
    end
  end

  def all, do: Agent.get(__MODULE__, & &1.tickets)

  def insert(attrs) do
    attrs = stringify_keys(attrs)

    Agent.get_and_update(__MODULE__, fn state ->
      id = state.seq
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      ticket = %CorexAdmin.Test.Ticket{
        id: id,
        demo_id: attrs["demo_id"],
        title: attrs["title"],
        email: attrs["email"],
        status: attrs["status"] || "open",
        priority: parse_int(attrs["priority"], 1),
        body: attrs["body"],
        password: attrs["password"],
        secret: attrs["secret"],
        inserted_at: now,
        updated_at: now
      }

      {ticket, %{state | seq: id + 1, tickets: [ticket | state.tickets]}}
    end)
  end

  def replace(%CorexAdmin.Test.Ticket{id: id} = ticket) do
    Agent.update(__MODULE__, fn state ->
      tickets =
        Enum.map(state.tickets, fn
          %{id: ^id} -> ticket
          other -> other
        end)

      %{state | tickets: tickets}
    end)

    ticket
  end

  def delete(%CorexAdmin.Test.Ticket{id: id} = ticket) do
    Agent.update(__MODULE__, fn state ->
      %{state | tickets: Enum.reject(state.tickets, &(&1.id == id))}
    end)

    ticket
  end

  defp parse_int(value, _default) when is_integer(value), do: value

  defp parse_int(value, default) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> default
    end
  end

  defp parse_int(_, default), do: default

  defp stringify_keys(attrs) do
    Map.new(attrs, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} when is_binary(key) -> {key, value}
      {key, value} -> {to_string(key), value}
    end)
  end
end
