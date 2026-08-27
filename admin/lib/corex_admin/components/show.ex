defmodule CorexAdmin.Components.Show do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Field
  alias CorexAdmin.Gettext
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers

  def page(assigns) do
    ~H"""
    <Components.shell :if={assigns[:record]}>
      <Components.breadcrumbs
        prefix={@corex_admin_prefix}
        spec={@spec}
        live_action={:show}
        record={@record}
        hub_title={Helpers.hub_title(assigns)}
      />
      <.layout_heading class="layout-heading">
        <:title>{Helpers.record_title(@spec, @record)}</:title>
        <:actions>
          <.navigate
            to={Helpers.resource_path(assigns, @spec)}
            type="navigate"
            class="button ui-trigger--square"
            aria_label={Gettext.t("Back")}
            title={Gettext.t("Back")}
          >
            <.heroicon name="hero-arrow-left" />
            <span class="sr-only">{Gettext.t("Back to %{label}", label: @spec.label)}</span>
          </.navigate>
          <.navigate
            :if={Helpers.authorize(assigns, :edit, @resource_mod, @record) == :ok}
            to={Helpers.edit_path(assigns, @spec, @record)}
            type="navigate"
            class="button ui-solid ui-brand"
            aria_label={Gettext.t("Edit")}
          >
            <.heroicon name="hero-pencil-square" /> {Gettext.t("Edit")}
          </.navigate>
          <Components.delete_dialog
            :if={@can_delete and Helpers.authorize(assigns, :delete, @resource_mod, @record) == :ok}
            id={"delete-#{Helpers.record_id(@spec, @record)}"}
            spec={@spec}
            record={@record}
            trigger={:labeled}
          />
        </:actions>
      </.layout_heading>

      <.show_body
        spec={@spec}
        record={@record}
        show_fields={@show_fields}
        show_sections={@show_sections}
        history_enabled={@history_enabled}
        history_versions={@history_versions}
      />
    </Components.shell>
    """
  end

  attr(:spec, :any, required: true)
  attr(:record, :any, required: true)
  attr(:show_fields, :list, required: true)
  attr(:show_sections, :list, required: true)
  attr(:history_enabled, :boolean, required: true)
  attr(:history_versions, :list, required: true)

  defp show_body(assigns) do
    tabs? = assigns.history_enabled or length(assigns.show_sections) > 1
    assigns = assign(assigns, :tabs?, tabs?)

    ~H"""
    <div :if={!@tabs?}>
      <.details_panel fields={@show_fields} record={@record} />
    </div>
    <.tabs
      :if={@tabs?}
      id={"#{@spec.slug}-show-tabs"}
      class="tabs"
      value="details"
      multiple={false}
      collapsible={false}
      items={show_tab_items(@show_sections, @history_enabled)}
    >
      <:content :let={item}>
        <div :if={
          item.meta[:tab] == "details" or String.starts_with?(to_string(item.meta[:tab]), "section-")
        }>
          <.details_panel
            fields={section_fields_for(@show_sections, @show_fields, item.meta[:tab])}
            record={@record}
          />
        </div>
        <div :if={item.meta[:tab] == "history"}>
          <.history_panel versions={@history_versions} />
        </div>
      </:content>
    </.tabs>
    """
  end

  attr(:fields, :list, required: true)
  attr(:record, :any, required: true)

  defp details_panel(assigns) do
    ~H"""
    <.data_list
      class="data-list ui-size-sm"
      orientation="horizontal"
      items={
        Corex.Content.new(
          for field <- @fields, field.type != :embeds_many do
            %{
              value: Atom.to_string(field.name),
              label: field.label,
              content: Field.format(field, @record)
            }
          end
        )
      }
    />
    <Components.embed_show
      :for={field <- Enum.filter(@fields, &(&1.type == :embeds_many))}
      field={field}
      record={@record}
    />
    """
  end

  attr(:versions, :list, required: true)

  defp history_panel(assigns) do
    ~H"""
    <p :if={@versions == []} class="admin-muted">{Gettext.t("No history for this record.")}</p>
    <section :for={version <- @versions} class="admin-embed">
      <h2 class="admin-embed-title">
        {history_heading(version)}
      </h2>
      <.data_list
        class="data-list ui-size-sm"
        orientation="horizontal"
        items={
          Corex.Content.new(
            for change <- List.wrap(version.changes) do
              field = change.field || change[:field]
              from = change.from || change[:from]
              to = change.to || change[:to]

              %{
                value: to_string(field),
                label: to_string(field),
                content: "#{inspect(from)} → #{inspect(to)}"
              }
            end
          )
        }
      />
    </section>
    """
  end

  defp show_tab_items(sections, history?) do
    detail_tabs =
      case sections do
        [%{label: nil} | _] ->
          [
            %{
              value: "details",
              label: Gettext.t("Details"),
              content: "",
              meta: %{tab: "details"}
            }
          ]

        many ->
          Enum.map(many, fn section ->
            %{
              value: "section-#{section.name}",
              label: section.label || Gettext.t("Details"),
              content: "",
              meta: %{tab: "section-#{section.name}"}
            }
          end)
      end

    history_tab =
      if history?,
        do: [
          %{value: "history", label: Gettext.t("History"), content: "", meta: %{tab: "history"}}
        ],
        else: []

    Corex.Content.new(detail_tabs ++ history_tab)
  end

  defp section_fields_for([%{label: nil, fields: fields} | _], fallback, "details") do
    if fields == [], do: fallback, else: fields
  end

  defp section_fields_for(_sections, fallback, "details"), do: fallback

  defp section_fields_for(sections, fallback, "section-" <> name) do
    case Enum.find(sections, &(to_string(&1.name) == name)) do
      %{fields: fields} -> fields
      _ -> fallback
    end
  end

  defp section_fields_for(_sections, fallback, _), do: fallback

  defp history_heading(version) do
    action = version.action || Gettext.t("update")
    actor = version.actor || Gettext.t("unknown")
    at = format_at(version.at)
    "#{action} · #{actor} · #{at}"
  end

  defp format_at(%DateTime{} = dt), do: Calendar.strftime(dt, "%Y-%m-%d %H:%M")
  defp format_at(%NaiveDateTime{} = dt), do: NaiveDateTime.to_iso8601(dt)
  defp format_at(other) when other in [nil, ""], do: "—"
  defp format_at(other), do: to_string(other)
end
