defmodule E2eWeb.TimerTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.TimerModel, as: Timer

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Timer has no A11y violations", %{session: session} do
      session
      |> Timer.goto(@mode)
      |> Timer.check_accessibility()
    end
  end
end
