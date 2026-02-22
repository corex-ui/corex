defmodule E2eWeb.CodeTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.CodeModel, as: Code

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Code has no A11y violations", %{session: session} do
      session
      |> Code.goto(@mode)
      |> Code.check_accessibility()
    end
  end
end
