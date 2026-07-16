ExUnit.start()

case Integer.parse(System.otp_release()) do
  {otp, _} when otp < 27 ->
    {:ok, _} = Application.ensure_all_started(:json_polyfill)

  _ ->
    :ok
end
