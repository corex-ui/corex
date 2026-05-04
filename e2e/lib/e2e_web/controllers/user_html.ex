defmodule E2eWeb.UserHTML do
  use E2eWeb, :html

  alias E2eWeb.SignaturePaths

  embed_templates "user_html/*"

  attr :form, Phoenix.HTML.Form, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil
  attr :return_context, :string, default: nil

  def user_form(assigns)

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
