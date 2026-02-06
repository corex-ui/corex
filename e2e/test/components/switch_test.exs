defmodule E2eWeb.SwitchTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.SwitchModel, as: Switch

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Switch has no A11y violations", %{session: session} do
      session
      |> Switch.goto(@mode)
      |> Switch.check_accessibility()
    end
  end
end
