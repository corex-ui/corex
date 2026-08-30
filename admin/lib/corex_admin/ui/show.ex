defmodule CorexAdmin.UI.Show do
  @moduledoc """
  Detail page blocks.

  Values render through `CorexAdmin.UI.Fields.value/1`, the same path the index
  uses, so a custom field module or `render:` override shows up here too.

  Related lists come from the resource's relation config: each `has_many` field
  gets its own panel filled by the host context, not by a query the admin runs.
  """

  use CorexAdmin.UI

  alias CorexAdmin.UI.Dialogs
  alias CorexAdmin.UI.Nav

  slot :heading_actions
  slot :before_details
  slot :after_details

  @doc "The whole show page."
  def page(assigns) do
    ~H"""
    <.shell :if={assigns[:record]}>
      <Nav.breadcrumbs
        prefix={@corex_admin_prefix}
        spec={@spec}
        live_action={:show}
        record={@record}
        hub_title={Helpers.hub_title(assigns)}
      />
      <.heading {assigns}>
        <:actions>{render_slot(@heading_actions)}</:actions>
      </.heading>
      {render_slot(@before_details)}
      <.body
        spec={@spec}
        record={@record}
        show_fields={@show_fields}
        show_sections={@show_sections}
        history_enabled={@history_enabled}
        history_versions={@history_versions}
        related={assigns[:related] || %{}}
      />
      {render_slot(@after_details)}
    </.shell>
    """
  end

  slot :actions

  @doc "Record title, back, edit, and delete."
  def heading(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>{Helpers.record_title(@spec, @record)}</:title>
      <:actions>
        {render_slot(@actions)}
        <.navigate
          to={Helpers.resource_path(assigns, @spec)}
          type="navigate"
          class="button ui-trigger--square"
          aria_label={Gettext.t("Back")}
          title={Gettext.t("Back")}
        >
          <.heroicon name="hero-arrow-left" class="icon" />
          <span class="sr-only">{Gettext.t("Back to %{label}", label: @spec.label)}</span>
        </.navigate>
        <.navigate
          :if={Helpers.authorize(assigns, :edit, @resource_mod, @record) == :ok}
          to={Helpers.edit_path(assigns, @spec, @record)}
          type="navigate"
          class="button ui-solid ui-brand"
          aria_label={Gettext.t("Edit")}
        >
          <.heroicon name="hero-pencil-square" class="icon" />
          {Gettext.t("Edit")}
        </.navigate>
        <Dialogs.delete
          :if={@can_delete and Helpers.authorize(assigns, :delete, @resource_mod, @record) == :ok}
          id={"delete-#{Helpers.record_id(@spec, @record)}"}
          spec={@spec}
          record={@record}
          trigger={:labeled}
        />
      </:actions>
    </.layout_heading>
    """
  end

  attr :spec, Spec, required: true
  attr :record, :any, required: true
  attr :show_fields, :list, required: true
  attr :show_sections, :list, required: true
  attr :history_enabled, :boolean, required: true
  attr :history_versions, :list, required: true
  attr :related, :map, default: %{}

  @doc "Details, embeds, related lists, and history."
  def body(assigns) do
    tabs? = assigns.history_enabled or length(assigns.show_sections) > 1
    assigns = assign(assigns, :tabs?, tabs?)

    ~H"""
    <div :if={!@tabs?}>
      <.details fields={@show_fields} record={@record} />
      <.related_lists spec={@spec} related={@related} />
    </div>
    <.tabs
      :if={@tabs?}
      id={"#{@spec.slug}-show-tabs"}
      class="tabs"
      value="details"
      multiple={false}
      collapsible={false}
      items={tab_items(@show_sections, @history_enabled)}
    >
      <:content :let={item}>
        <div :if={detail_tab?(item.meta[:tab])}>
          <.details
            fields={fields_for_tab(@show_sections, @show_fields, item.meta[:tab])}
            record={@record}
          />
          <.related_lists spec={@spec} related={@related} />
        </div>
        <div :if={item.meta[:tab] == "history"}>
          <.history versions={@history_versions} />
        </div>
      </:content>
    </.tabs>
    """
  end

  attr :fields, :list, required: true
  attr :record, :any, required: true

  @doc """
  Scalar values as a definition list, then a panel per embed.

  `has_many` relations are left out: they render as their own related list
  below, and a list of titles squeezed into a detail row says nothing useful.
  """
  def details(assigns) do
    assigns =
      assigns
      |> assign(:scalars, Enum.reject(assigns.fields, &detail_excluded?/1))
      |> assign(:embeds, Enum.filter(assigns.fields, &Field.nested?/1))

    ~H"""
    <dl class="admin-details">
      <div :for={field <- @scalars} class="admin-detail">
        <dt class="admin-detail-label">{field.label}</dt>
        <dd class="admin-detail-value">
          <CorexAdmin.UI.Fields.value field={field} record={@record} />
        </dd>
      </div>
    </dl>
    <CorexAdmin.UI.Fields.embed :for={field <- @embeds} field={field} record={@record} />
    """
  end

  attr :spec, Spec, required: true
  attr :related, :map, default: %{}

  @doc """
  One panel per `has_many` relation.

  Rows come from the show controller, which reads what the host context
  preloaded. An empty relation still renders its panel, so the section does not
  silently vanish when a record has no children yet.
  """
  def related_lists(assigns) do
    assigns = assign(assigns, :entries, Enum.sort_by(assigns.related, fn {f, _} -> f.name end))

    ~H"""
    <section :for={{field, rows} <- @entries} class="admin-embed">
      <h2 class="admin-embed-title">{field.label}</h2>
      <p :if={rows == []} class="admin-embed-empty">
        {Gettext.t("No %{label} yet.", label: field.label)}
      </p>
      <div :if={rows != []} class="admin-embed-rows">
        <div :for={row <- rows} class="admin-embed-row">
          <div :for={column <- related_columns(field)} class="admin-embed-field">
            <span class="admin-embed-label">{Phoenix.Naming.humanize(to_string(column))}</span>
            <span class="admin-embed-value">{related_value(row, column)}</span>
          </div>
        </div>
      </div>
    </section>
    """
  end

  attr :versions, :list, required: true

  @doc "Read-only change log from the history adapter."
  def history(assigns) do
    ~H"""
    <p :if={@versions == []} class="admin-muted">{Gettext.t("No history for this record.")}</p>
    <section :for={version <- @versions} class="admin-embed">
      <h2 class="admin-embed-title">{version_heading(version)}</h2>
      <dl class="admin-details">
        <div :for={change <- List.wrap(version.changes)} class="admin-detail">
          <dt class="admin-detail-label">{to_string(change.field)}</dt>
          <dd class="admin-detail-value">
            {change_text(change.from)} → {change_text(change.to)}
          </dd>
        </div>
      </dl>
    </section>
    """
  end

  defp detail_excluded?(%Field{type: :has_many}), do: true
  defp detail_excluded?(field), do: Field.nested?(field)

  defp detail_tab?("details"), do: true
  defp detail_tab?(tab), do: String.starts_with?(to_string(tab), "section-")

  defp related_columns(%Field{relation: %{columns: [_ | _] = columns}}), do: columns

  defp related_columns(%Field{relation: relation}) do
    [relation.label] |> Enum.reject(&is_nil/1)
  end

  defp related_value(row, column) do
    case Map.get(row, column) do
      nil -> "—"
      %DateTime{} = dt -> Calendar.strftime(dt, "%Y-%m-%d %H:%M")
      %Date{} = date -> Date.to_iso8601(date)
      value -> to_string(value)
    end
  end

  defp tab_items(sections, history?) do
    detail_tabs =
      case sections do
        [%{label: nil} | _] ->
          [%{value: "details", label: Gettext.t("Details"), content: "", meta: %{tab: "details"}}]

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
      if history? do
        [%{value: "history", label: Gettext.t("History"), content: "", meta: %{tab: "history"}}]
      else
        []
      end

    Corex.Content.new(detail_tabs ++ history_tab)
  end

  defp fields_for_tab([%{label: nil, fields: fields} | _], fallback, "details") do
    if fields == [], do: fallback, else: fields
  end

  defp fields_for_tab(_sections, fallback, "details"), do: fallback

  defp fields_for_tab(sections, fallback, "section-" <> name) do
    case Enum.find(sections, &(to_string(&1.name) == name)) do
      %{fields: fields} -> fields
      _ -> fallback
    end
  end

  defp fields_for_tab(_sections, fallback, _), do: fallback

  defp version_heading(version) do
    action = version.action || Gettext.t("update")
    actor = version.actor || Gettext.t("unknown")
    "#{action} · #{actor} · #{format_at(version.at)}"
  end

  defp change_text(nil), do: "—"
  defp change_text(value) when is_binary(value), do: value
  defp change_text(value) when is_number(value), do: to_string(value)
  defp change_text(value) when is_boolean(value), do: to_string(value)
  defp change_text(value), do: inspect(value)

  defp format_at(%DateTime{} = dt), do: Calendar.strftime(dt, "%Y-%m-%d %H:%M")
  defp format_at(%NaiveDateTime{} = dt), do: NaiveDateTime.to_iso8601(dt)
  defp format_at(other) when other in [nil, ""], do: "—"
  defp format_at(other), do: to_string(other)
end
