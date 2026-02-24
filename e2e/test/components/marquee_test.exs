defmodule E2eWeb.MarqueeTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.MarqueeModel, as: Marquee

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Marquee has no A11y violations", %{session: session} do
      session
      |> Marquee.goto(@mode)
      |> Marquee.check_accessibility()
    end
  end
end
