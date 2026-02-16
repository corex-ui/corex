defmodule E2eWeb.PinInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.PinInputModel, as: PinInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Pin input has no A11y violations", %{session: session} do
      session
      |> PinInput.goto(@mode)
      |> PinInput.check_accessibility()
    end
  end
end
