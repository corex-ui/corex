defmodule E2eWeb.TextInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.TextInputModel, as: TextInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Text input has no A11y violations", %{session: session} do
      session
      |> TextInput.goto(@mode)
      |> TextInput.check_accessibility()
    end
  end
end
