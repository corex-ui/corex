defmodule E2eWeb.RadioGroupTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.RadioGroupModel, as: RadioGroup

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Radio group has no A11y violations", %{session: session} do
      session
      |> RadioGroup.goto(@mode)
      |> RadioGroup.check_accessibility()
    end
  end
end
