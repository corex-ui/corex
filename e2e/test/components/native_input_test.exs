defmodule E2eWeb.NativeInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.NativeInputModel, as: NativeInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Native input has no A11y violations", %{session: session} do
      session
      |> NativeInput.goto(@mode)
      |> NativeInput.check_accessibility()
    end
  end
end
