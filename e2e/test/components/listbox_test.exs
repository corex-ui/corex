defmodule E2eWeb.ListboxTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ListboxModel, as: Listbox

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Listbox has no A11y violations", %{session: session} do
      session
      |> Listbox.goto(@mode)
      |> Listbox.check_accessibility()
    end
  end
end
