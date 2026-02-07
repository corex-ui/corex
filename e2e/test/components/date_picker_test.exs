defmodule E2eWeb.DatePickerTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.DatePickerModel, as: DatePicker

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - DatePicker has no A11y violations", %{session: session} do
      session
      |> DatePicker.goto(@mode)
      |> DatePicker.check_accessibility()
    end
  end
end
