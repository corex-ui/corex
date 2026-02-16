defmodule E2eWeb.FloatingPanelTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.FloatingPanelModel, as: FloatingPanel

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Floating panel has no A11y violations", %{session: session} do
      session
      |> FloatingPanel.goto(@mode)
      |> FloatingPanel.check_accessibility()
    end
  end
end
