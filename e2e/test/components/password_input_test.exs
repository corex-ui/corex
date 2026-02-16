defmodule E2eWeb.PasswordInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.PasswordInputModel, as: PasswordInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Password input has no A11y violations", %{session: session} do
      session
      |> PasswordInput.goto(@mode)
      |> PasswordInput.check_accessibility()
    end
  end
end
