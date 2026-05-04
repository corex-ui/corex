defmodule E2eWeb.SignatureFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.SignatureModel, as: Signature

  feature "static form - submit empty/default includes signature", %{session: session} do
    session
    |> Signature.goto_form(:static)
    |> Signature.submit_form()
    |> Signature.wait_for_signature_field_error()
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> Signature.goto_form(:static)
    |> Signature.check_accessibility()
  end

  feature "live form - submit default signature", %{session: session} do
    session
    |> Signature.goto_form(:live)
    |> Signature.submit_form(:live)
    |> Signature.wait_for_signature_field_error()
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> Signature.goto_form(:live)
    |> Signature.check_accessibility()
  end
end
