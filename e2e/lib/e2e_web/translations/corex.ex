defmodule E2eWeb.Translations.Corex do
  use Gettext, backend: E2eWeb.Gettext

  def pin_input_digit_msgid do
    gettext("Digit %{digit}", digit: 1)
  end
end
