defmodule E2eWeb.EmailInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.EmailInputModel, as: EmailInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Email input has no A11y violations", %{session: session} do
      session
      |> EmailInput.goto(@mode)
      |> EmailInput.check_accessibility()
    end
  end
end
