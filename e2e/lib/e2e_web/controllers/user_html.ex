defmodule E2eWeb.UserHTML do
  use E2eWeb, :html

  embed_templates "user_html/*"

  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil
  attr :form_id, :string, default: nil

  def user_form(assigns)

  attr :signature, :string, default: nil

  def signature_preview(assigns) do
    path_d_values = parse_signature_paths(assigns.signature)
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

  defp parse_signature_paths(nil), do: []
  defp parse_signature_paths(""), do: []

  defp parse_signature_paths(signature) when is_binary(signature) do
    case Jason.decode(signature) do
      {:ok, paths} when is_list(paths) ->
        Enum.flat_map(paths, fn
          d when is_binary(d) and d != "" -> [d]
          %{"d" => d} when is_binary(d) and d != "" -> [d]
          _ -> []
        end)

      _ ->
        []
    end
  end
end
