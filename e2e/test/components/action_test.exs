defmodule E2eWeb.ActionTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ActionModel, as: Action

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Action has no A11y violations", %{session: session} do
      session
      |> Action.goto(@mode)
      |> Action.check_accessibility()
    end
  end
end
