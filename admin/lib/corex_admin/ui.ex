defmodule CorexAdmin.UI do
  @moduledoc """
  Public chrome for Corex Admin pages.

  Every admin page is a composition of function components from this namespace:

    * `CorexAdmin.UI.Index` — heading, command bar, filter bar, table, footer
    * `CorexAdmin.UI.Form` — form grid, sections, actions
    * `CorexAdmin.UI.Show` — detail list, embeds, related lists, history
    * `CorexAdmin.UI.Home` — hub landing
    * `CorexAdmin.UI.Nav` — sidebar tree, mobile nav, breadcrumbs
    * `CorexAdmin.UI.Filters` — filter controls and dialogs
    * `CorexAdmin.UI.Dialogs` — delete, bulk delete, export, action forms

  These are **public API**. A host LiveView that overrides `render/1` composes
  them, which is how customization works without forking package internals:

      defmodule MyAppWeb.Admin.TicketLive.Index do
        use CorexAdmin.Live, :index

        def render(assigns) do
          ~H\"""
          <CorexAdmin.UI.Index.page {assigns}>
            <:command_bar_actions>
              <.link navigate={~p"/admin/tickets/triage"} class="button ui-size-sm">Triage</.link>
            </:command_bar_actions>
          </CorexAdmin.UI.Index.page>
          \"""
        end
      end

  Blocks only render Corex components and `admin.css` classes. They never query,
  and they never decide authorization — they receive assigns the controller
  already resolved.

  `use CorexAdmin.UI` sets up the imports a block module needs.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Phoenix.Component
      use Corex

      import CorexAdmin.UI, only: [list_items: 1, shell: 1, icon_tooltip: 1]

      alias CorexAdmin.Gettext
      alias CorexAdmin.ListOpts
      alias CorexAdmin.Live.Helpers
      alias CorexAdmin.Resource.Field
      alias CorexAdmin.Resource.Filter
      alias CorexAdmin.Resource.Spec
      alias CorexAdmin.UI.Labels
      alias Phoenix.LiveView.JS
    end
  end

  use Phoenix.Component
  use Corex

  slot :inner_block, required: true

  @doc "Vertical page stack every admin page sits in."
  def shell(assigns) do
    ~H"""
    <div class="admin-stack admin-stack--lg">
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, required: true
  slot :inner_block, required: true

  @doc """
  Tooltip around an icon-only control.

  Uses a `span` trigger so it can wrap a button without nesting interactive
  elements.
  """
  def icon_tooltip(assigns) do
    ~H"""
    <.tooltip id={@id} class="tooltip" show_arrow={false} trigger_tag={:span}>
      <:trigger>
        {render_slot(@inner_block)}
      </:trigger>
      <:content>{@label}</:content>
    </.tooltip>
    """
  end

  @doc """
  Corex list collection from `{label, value}` pairs or bare values.

  Every select, combobox, and menu in the admin builds its items through this,
  so option shapes stay consistent between filters and form fields.
  """
  @spec list_items(term()) :: Corex.List.t()
  def list_items(options) when is_list(options) do
    Corex.List.new(
      Enum.map(options, fn
        {label, value} -> %{label: to_string(label), value: to_string(value)}
        %{label: label, value: value} -> %{label: to_string(label), value: to_string(value)}
        value -> %{label: to_string(value), value: to_string(value)}
      end)
    )
  end

  def list_items(_), do: Corex.List.new([])
end
