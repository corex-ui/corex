defmodule <%= inspect index_module %> do
  @moduledoc """
  Index page for <%= inspect resource_module %>.

  `render/1` composes public `CorexAdmin.UI.Index` blocks. Reorder them, drop
  one, wrap one, or fill a slot — the blocks themselves stay in the package, so
  upstream fixes still reach this page.

  Behaviour (auth, URL state, events) stays in
  `CorexAdmin.Live.Index.Controller`. Override `handle_event/3` and call `super`
  when this page needs to diverge.
  """

  use CorexAdmin.Live, :index

  alias CorexAdmin.UI

  @impl true
  def render(assigns) do
    ~H"""
    <UI.shell :if={assigns[:spec]}>
      <UI.Index.heading {assigns} />
      <UI.Index.metrics :if={@metrics != []} metrics={@metrics} />
      <UI.Index.command {assigns} />
      <UI.Index.table {assigns} />
      <UI.Index.footer {assigns} />
      <UI.Dialogs.export
        :if={@can_export}
        spec={@spec}
        token={@export_token}
        fields={@export_fields}
        action={CorexAdmin.Live.Helpers.export_path(assigns, @spec)}
      />
      <UI.Filters.range_dialogs
        spec={@spec}
        list_opts={@list_opts}
        options={@filter_options}
        bounds={@filter_bounds}
      />
    </UI.shell>
    """
  end
end
