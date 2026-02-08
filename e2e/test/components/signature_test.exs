defmodule E2eWeb.SignatureTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.SignatureModel, as: Signature

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Signature has no A11y violations", %{session: session} do
      session
      |> Signature.goto(@mode)
      |> Signature.check_accessibility()
    end
  end
end
