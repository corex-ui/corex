defmodule <%= inspect show_module %> do
  @moduledoc """
  Show page for <%= inspect resource_module %>.

  `render/1` composes public `CorexAdmin.UI.Show` blocks.
  """

  use CorexAdmin.Live, :show

  alias CorexAdmin.UI

  @impl true
  def render(assigns) do
    ~H"""
    <UI.shell :if={assigns[:record]}>
      <UI.Nav.breadcrumbs
        prefix={@corex_admin_prefix}
        spec={@spec}
        live_action={:show}
        record={@record}
        hub_title={CorexAdmin.Live.Helpers.hub_title(assigns)}
      />
      <UI.Show.heading {assigns} />
      <UI.Show.body
        spec={@spec}
        record={@record}
        show_fields={@show_fields}
        show_sections={@show_sections}
        history_enabled={@history_enabled}
        history_versions={@history_versions}
        related={@related}
      />
    </UI.shell>
    """
  end
end
