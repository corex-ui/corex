defmodule E2eWeb.CollapsibleTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.CollapsibleModel, as: Collapsible

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Collapsible has no A11y violations", %{session: session} do
      session
      |> Collapsible.goto(@mode)
      |> Collapsible.check_accessibility()
    end
  end
end
