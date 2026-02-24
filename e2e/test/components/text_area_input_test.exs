defmodule E2eWeb.TextAreaInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.TextAreaInputModel, as: TextAreaInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Text area input has no A11y violations", %{session: session} do
      session
      |> TextAreaInput.goto(@mode)
      |> TextAreaInput.check_accessibility()
    end
  end
end
