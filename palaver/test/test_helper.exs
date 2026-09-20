ExUnit.start()

case Palaver.Test.Cluster.ensure_distribution() do
  {:ok, node} ->
    IO.puts("distribution up as #{node}; hands-on-another-node claim will run")

  {:error, reason} ->
    ExUnit.configure(exclude: [:distributed])

    IO.puts(:stderr, """

    !! Distribution could not start: #{inspect(reason)}
    !! Excluding :distributed tests. The "kill the hands" claim is NOT proven in this run.
    """)
end
