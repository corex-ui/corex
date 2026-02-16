defmodule E2eWeb.NumberInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.NumberInputModel, as: NumberInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Number input has no A11y violations", %{session: session} do
      session
      |> NumberInput.goto(@mode)
      |> NumberInput.check_accessibility()
    end
  end
end
