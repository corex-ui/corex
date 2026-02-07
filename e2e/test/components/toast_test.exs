defmodule E2eWeb.ToastTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ToastModel, as: Toast

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Toast has no A11y violations", %{session: session} do
      session
      |> Toast.goto(@mode)
      |> Toast.check_accessibility()
    end
  end
end
