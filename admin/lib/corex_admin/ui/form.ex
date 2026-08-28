defmodule CorexAdmin.UI.Form do
  @moduledoc """
  Form page blocks.

  ## Save semantics

  Creating and editing want different defaults, so the footer differs:

  | Page | Primary | Secondary |
  | ---- | ------- | --------- |
  | New | **Create** goes to the record | **Create and add another** returns to a blank form |
  | Edit | **Save** stays on the form | **Save and close** goes to the record |

  Staying put after Save is what makes a long edit session bearable; leaving is
  the explicit choice.
  """

  use CorexAdmin.UI

  alias CorexAdmin.UI.Nav

  slot :heading_actions
  slot :before_fields
  slot :after_fields

  @doc "The whole form page."
  def page(assigns) do
    ~H"""
    <.shell :if={assigns[:form]}>
      <Nav.breadcrumbs
        prefix={@corex_admin_prefix}
        spec={@spec}
        live_action={@live_action}
        record={@record}
        hub_title={Helpers.hub_title(assigns)}
      />
      <.heading {assigns}>
        <:actions>{render_slot(@heading_actions)}</:actions>
      </.heading>
      <.form for={@form} id={@form.id} phx-change="validate" phx-submit="save" class="admin-form">
        {render_slot(@before_fields)}
        <.fields
          sections={@form_sections}
          fields={@form_fields}
          form={@form}
          spec={@spec}
          relation_options={assigns[:relation_options] || %{}}
        />
        {render_slot(@after_fields)}
        <.actions live_action={@live_action} spec={@spec} />
      </.form>
    </.shell>
    """
  end

  slot :actions

  @doc "Page title and the back link."
  def heading(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>{@page_title}</:title>
      <:actions>
        {render_slot(@actions)}
        <.navigate
          to={Helpers.resource_path(assigns, @spec)}
          type="navigate"
          class="button ui-trigger--square"
          aria_label={Gettext.t("Cancel")}
          title={Gettext.t("Cancel")}
        >
          <.heroicon name="hero-arrow-left" class="icon" />
          <span class="sr-only">{Gettext.t("Back to %{label}", label: @spec.label)}</span>
        </.navigate>
      </:actions>
    </.layout_heading>
    """
  end

  attr :live_action, :atom, required: true
  attr :spec, Spec, required: true

  @doc "Save / create footer actions."
  def actions(assigns) do
    ~H"""
    <div class="admin-actions">
      <.action :if={@live_action == :new} type="submit" class="button ui-solid ui-brand">
        {Gettext.t("Create %{name}", name: @spec.singular)}
      </.action>
      <.action :if={@live_action == :new} type="submit" name="continue" value="true" class="button">
        {Gettext.t("Create and add another")}
      </.action>
      <.action :if={@live_action == :edit} type="submit" name="continue" value="true" class="button ui-solid ui-brand">
        {Gettext.t("Save")}
      </.action>
      <.action :if={@live_action == :edit} type="submit" class="button">
        {Gettext.t("Save and close")}
      </.action>
    </div>
    """
  end

  attr :sections, :list, required: true
  attr :fields, :list, required: true
  attr :form, :any, required: true
  attr :spec, Spec, required: true
  attr :relation_options, :map, default: %{}

  @doc "Field grid, or tabs when the resource declares more than one section."
  def fields(assigns) do
    tabs? = length(assigns.sections) > 1 and hd(assigns.sections).label != nil
    assigns = assign(assigns, :tabs?, tabs?)

    ~H"""
    <div :if={!@tabs?} class="admin-form-grid">
      <.field_cell
        :for={field <- @fields}
        field={field}
        form={@form}
        relation_options={@relation_options}
      />
    </div>
    <.tabs
      :if={@tabs?}
      id={"#{@spec.slug}-form-tabs"}
      class="tabs"
      value={"section-#{hd(@sections).name}"}
      items={section_items(@sections)}
    >
      <:content :let={item}>
        <div class="admin-form-grid">
          <.field_cell
            :for={field <- fields_for_tab(@sections, item.meta[:tab])}
            field={field}
            form={@form}
            relation_options={@relation_options}
          />
        </div>
      </:content>
    </.tabs>
    """
  end

  attr :field, Field, required: true
  attr :form, :any, required: true
  attr :relation_options, :map, default: %{}

  defp field_cell(assigns) do
    ~H"""
    <div class={if(wide?(@field), do: "admin-form-span")}>
      <CorexAdmin.UI.Fields.input
        field={@field}
        form={@form}
        options={Map.get(@relation_options, @field.name, [])}
      />
    </div>
    """
  end

  defp wide?(%Field{type: type}), do: type in [:textarea, :embeds_many, :embeds_one, :has_many]

  defp section_items(sections) do
    Corex.Content.new(
      Enum.map(sections, fn section ->
        %{
          value: "section-#{section.name}",
          label: section.label,
          content: "",
          meta: %{tab: "section-#{section.name}"}
        }
      end)
    )
  end

  defp fields_for_tab(sections, "section-" <> name) do
    case Enum.find(sections, &(to_string(&1.name) == name)) do
      %{fields: fields} -> fields
      _ -> []
    end
  end

  defp fields_for_tab(_sections, _), do: []
end
