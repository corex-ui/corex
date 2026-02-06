defmodule E2eWeb.CheckboxTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.CheckboxModel, as: Checkbox

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Checkbox has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto(@mode)
      |> Checkbox.check_accessibility()
    end
  end
end
