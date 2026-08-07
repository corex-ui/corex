defmodule Corex.Component.Errors do
  @moduledoc false

  use Phoenix.Component

  attr(:scope, :string, required: true)
  attr(:errors, :list, default: [])

  attr(:error, :list,
    default: [],
    doc: "The caller's `:error` slot, forwarded as a value so the markup lives in one place"
  )

  @spec field_errors(map()) :: Phoenix.LiveView.Rendered.t()
  def field_errors(assigns) do
    ~H"""
    <div
      :if={@error != [] and @errors != []}
      :for={msg <- @errors}
      class={error_class(@error)}
      data-scope={@scope}
      data-part="error"
    >
      {render_slot(@error, msg)}
    </div>
    """
  end

  defp error_class([entry | _rest]) when is_map(entry), do: Map.get(entry, :class)
  defp error_class(_error), do: nil
end
