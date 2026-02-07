defmodule E2eWeb.ClipboardTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ClipboardModel, as: Clipboard

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Clipboard has no A11y violations", %{session: session} do
      session
      |> Clipboard.goto(@mode)
      |> Clipboard.check_accessibility()
    end
  end
end
