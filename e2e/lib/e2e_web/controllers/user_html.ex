defmodule E2eWeb.UserHTML do
  use E2eWeb, :html

  embed_templates "user_html/*"

  attr :form, Phoenix.HTML.Form, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil
  attr :return_context, :string, default: nil

  def user_form(assigns)

  def currency_items do
    [
      %{value: "eur", label: ~t"Euro"},
      %{value: "usd", label: ~t"US Dollar"},
      %{value: "gbp", label: ~t"British Pound"},
      %{value: "jpy", label: ~t"Japanese Yen"},
      %{value: "chf", label: ~t"Swiss Franc"},
      %{value: "cad", label: ~t"Canadian Dollar"},
      %{value: "aud", label: ~t"Australian Dollar"},
      %{value: "sek", label: ~t"Swedish Krona"},
      %{value: "nok", label: ~t"Norwegian Krone"},
      %{value: "sgd", label: ~t"Singapore Dollar"}
    ]
  end
end
