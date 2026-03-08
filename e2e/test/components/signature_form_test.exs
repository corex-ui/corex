defmodule E2eWeb.SignatureFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.SignatureModel, as: Signature

  feature "static form - submit empty/default includes signature", %{session: session} do
    session
    |> Signature.goto_form(:static)
    |> Signature.wait(500)
    |> Signature.submit_form()
    |> Signature.wait(500)
    |> Signature.see_flash("Submitted: signature=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> Signature.goto_form(:static)
    |> Signature.wait(500)
    |> Signature.check_accessibility()
  end

  feature "live form - submit default signature", %{session: session} do
    session
    |> Signature.goto_form(:live)
    |> Signature.wait(500)
    |> Signature.submit_form(:live)
    |> Signature.wait(2000)
    |> Signature.see_flash("signature=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> Signature.goto_form(:live)
    |> Signature.wait(500)
    |> Signature.check_accessibility()
  end
end
