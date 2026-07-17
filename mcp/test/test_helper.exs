unless Code.ensure_loaded?(:json) do
  {:ok, _} = Application.ensure_all_started(:json_polyfill)
end

ExUnit.start()
