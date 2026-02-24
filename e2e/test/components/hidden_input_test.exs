defmodule E2eWeb.HiddenInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.HiddenInputModel, as: HiddenInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Hidden input has no A11y violations", %{session: session} do
      session
      |> HiddenInput.goto(@mode)
      |> HiddenInput.check_accessibility()
    end
  end
end
