defmodule E2eWeb.FeatureCase do
  @moduledoc """
  Wallaby feature tests. Ecto sandbox is owned by `use Wallaby.Feature`
  (`config :wallaby, otp_app: :corex_web`).

  Do not combine this with `E2eWeb.ConnCase` in the same module; ConnCase
  `start_owner!/1` conflicts with Wallaby checkout and metadata for HTTP requests.
  """

  use ExUnit.CaseTemplate

  using opts do
    async = Keyword.get(opts, :async, false)

    quote do
      use ExUnit.Case, async: unquote(async)
      use Wallaby.Feature
    end
  end

  setup do
    Localize.put_locale(:en)
    :ok
  end
end
