defmodule E2eWeb.UserHTML do
  use E2eWeb, :html

  alias E2eWeb.SignaturePaths

  embed_templates "user_html/*"

  attr :form, Phoenix.HTML.Form, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil
  attr :return_context, :string, default: nil

  def user_form(assigns)

  def currency_items do
    [
      %{id: "eur", label: "Euro"},
      %{id: "usd", label: "US Dollar"},
      %{id: "gbp", label: "British Pound"},
      %{id: "jpy", label: "Japanese Yen"},
      %{id: "chf", label: "Swiss Franc"},
      %{id: "cad", label: "Canadian Dollar"},
      %{id: "aud", label: "Australian Dollar"},
      %{id: "sek", label: "Swedish Krona"},
      %{id: "nok", label: "Norwegian Krone"},
      %{id: "sgd", label: "Singapore Dollar"}
    ]
  end

  attr :signature, :string, default: nil

  def signature_preview(assigns) do
    path_d_values = SignaturePaths.path_d_list(assigns.signature)
    assigns = assign(assigns, :path_d_values, path_d_values)

    ~H"""
    <span :if={@path_d_values == []} class="text-muted">—</span>
    <svg
      :if={@path_d_values != []}
      viewBox="0 0 200 100"
      class="inline-block w-12 h-6 border border-muted rounded"
      aria-hidden="true"
    >
      <g
        fill="none"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <path :for={d <- @path_d_values} d={d} />
      </g>
    </svg>
    """
  end
end
