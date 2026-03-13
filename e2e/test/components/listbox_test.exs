defmodule E2eWeb.ListboxTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ListboxModel, as: Listbox

  for mode <- [:static, :live, "/en/live/listbox/stream"] do
    @mode mode

    feature "#{@mode} - Listbox has no A11y violations", %{session: session} do
      session
      |> Listbox.goto(@mode)
      |> Listbox.wait(500)
      |> Listbox.check_accessibility()
    end
  end
end
