ExUnit.start()

unless Code.ensure_loaded?(:json) do
  case Application.ensure_all_started(:json_polyfill) do
    {:ok, _} -> :ok
    {:error, reason} -> raise "failed to start :json_polyfill: #{inspect(reason)}"
  end
end
