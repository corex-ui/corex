defmodule E2eWeb.LocaleTest do
  use ExUnit.Case, async: true

  test "label/1 uses CLDR native Arabic display name for ar" do
    assert E2eWeb.Locale.label("ar") == "العربية"
  end

  test "label/1 uses CLDR English display name for en" do
    assert E2eWeb.Locale.label("en") == "English"
  end
end
