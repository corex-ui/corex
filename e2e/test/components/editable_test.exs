defmodule E2eWeb.EditableTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.EditableModel, as: Editable

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Editable has no A11y violations", %{session: session} do
      session
      |> Editable.goto(@mode)
      |> Editable.check_accessibility()
    end
  end
end
