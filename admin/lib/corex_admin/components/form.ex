defmodule CorexAdmin.Components.Form do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Gettext
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers

  def page(assigns) do
    ~H"""
    <Components.shell :if={assigns[:form]}>
      <Components.breadcrumbs
        prefix={@corex_admin_prefix}
        spec={@spec}
        live_action={@live_action}
        record={@record}
        hub_title={Helpers.hub_title(assigns)}
      />
      <.layout_heading class="layout-heading">
        <:title>{@page_title}</:title>
        <:actions>
          <.navigate
            to={Helpers.resource_path(assigns, @spec)}
            type="navigate"
            class="button ui-trigger--square"
            aria_label={Gettext.t("Cancel")}
            title={Gettext.t("Cancel")}
          >
            <.heroicon name="hero-arrow-left" />
            <span class="sr-only">{Gettext.t("Back to %{label}", label: @spec.label)}</span>
          </.navigate>
        </:actions>
      </.layout_heading>

      <.form
        for={@form}
        id={@form.id}
        phx-change="validate"
        phx-submit="save"
        class="admin-form"
      >
        <.form_fields_body sections={@form_sections} fields={@form_fields} form={@form} spec={@spec} />
        <div class="admin-actions">
          <.action type="submit" class="button ui-solid ui-brand">{Gettext.t("Save")}</.action>
          <.action type="submit" name="continue" value="true" class="button">
            {Gettext.t("Save and continue")}
          </.action>
        </div>
      </.form>
    </Components.shell>
    """
  end

  attr(:sections, :list, required: true)
  attr(:fields, :list, required: true)
  attr(:form, :any, required: true)
  attr(:spec, :any, required: true)

  defp form_fields_body(assigns) do
    tabs? = length(assigns.sections) > 1 and hd(assigns.sections).label != nil
    assigns = assign(assigns, :tabs?, tabs?)

    ~H"""
    <div :if={!@tabs?} class="admin-form-grid">
      <div
        :for={field <- @fields}
        class={if field.type in [:textarea, :embeds_many], do: "admin-form-span"}
      >
        <Components.field_input field={field} form={@form} />
      </div>
    </div>
    <.tabs
      :if={@tabs?}
      id={"#{@spec.slug}-form-tabs"}
      class="tabs"
      value={"section-#{hd(@sections).name}"}
      items={
        Corex.Content.new(
          Enum.map(@sections, fn section ->
            %{
              value: "section-#{section.name}",
              label: section.label,
              content: "",
              meta: %{tab: "section-#{section.name}"}
            }
          end)
        )
      }
    >
      <:content :let={item}>
        <div class="admin-form-grid">
          <div
            :for={field <- fields_for_tab(@sections, item.meta[:tab])}
            class={if field.type in [:textarea, :embeds_many], do: "admin-form-span"}
          >
            <Components.field_input field={field} form={@form} />
          </div>
        </div>
      </:content>
    </.tabs>
    """
  end

  defp fields_for_tab(sections, "section-" <> name) do
    case Enum.find(sections, &(to_string(&1.name) == name)) do
      %{fields: fields} -> fields
      _ -> []
    end
  end

  defp fields_for_tab(_sections, _), do: []
end
