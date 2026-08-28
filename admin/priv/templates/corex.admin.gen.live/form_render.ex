defmodule <%= inspect form_module %> do
  @moduledoc """
  Form page for <%= inspect resource_module %>.

  `render/1` composes public `CorexAdmin.UI.Form` blocks.
  """

  use CorexAdmin.Live, :form

  alias CorexAdmin.UI

  @impl true
  def render(assigns) do
    ~H"""
    <UI.shell :if={assigns[:form]}>
      <UI.Nav.breadcrumbs
        prefix={@corex_admin_prefix}
        spec={@spec}
        live_action={@live_action}
        record={@record}
        hub_title={CorexAdmin.Live.Helpers.hub_title(assigns)}
      />
      <UI.Form.heading {assigns} />
      <.form for={@form} id={@form.id} phx-change="validate" phx-submit="save" class="admin-form">
        <UI.Form.fields
          sections={@form_sections}
          fields={@form_fields}
          form={@form}
          spec={@spec}
          relation_options={@relation_options}
        />
        <UI.Form.actions live_action={@live_action} spec={@spec} />
      </.form>
    </UI.shell>
    """
  end
end
