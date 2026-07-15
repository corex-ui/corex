defmodule E2eWeb.SelectFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.SelectModel, as: Select

  feature "static form - submit without selection includes empty country", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.submit_form(:live, :ecto)
    |> Select.wait_for_select_field_error(:live)
  end

  feature "static form - select country then submit includes country", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.click_form_select_trigger(:live, :phoenix)
    |> Select.select_item("bel")
    |> Select.submit_form(:live, :phoenix)
    |> Select.see_flash("country=bel")
  end

  feature "live form - select country then submit shows success", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.click_form_select_trigger(:live, :phoenix)
    |> Select.select_item("bel")
    |> Select.submit_form(:live, :phoenix)
    |> Select.see_flash("country=bel")
  end

  feature "live form - submit without selection does not show success", %{
    session: session
  } do
    session
    |> Select.goto_form(:live)
    |> Select.submit_form(:live, :phoenix)
    |> Select.refute_success_toast("country=bel")
    |> Select.wait_for_live_phoenix_form()
  end

  feature "static form - select form has no A11y violations", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.check_accessibility()
  end

  feature "live form - select form has no A11y violations", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.check_accessibility()
  end
end
