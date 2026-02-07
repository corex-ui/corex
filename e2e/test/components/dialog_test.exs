defmodule E2eWeb.DialogTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.DialogModel, as: Dialog

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Dialog has no A11y violations", %{session: session} do
      session
      |> Dialog.goto(@mode)
      |> Dialog.check_accessibility()
    end
  end
end
