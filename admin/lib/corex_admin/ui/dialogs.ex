defmodule CorexAdmin.UI.Dialogs do
  @moduledoc """
  Confirmation and form dialogs: delete, bulk delete, export, and custom actions.

  Destructive **triggers** are subtle (`ui-alert` without `ui-solid`) so a table
  full of rows is not a wall of red; the solid alert style is reserved for the
  confirm button inside the dialog, where it is the one thing to look at.
  """

  use CorexAdmin.UI

  alias CorexAdmin.Action

  attr :id, :string, required: true
  attr :spec, Spec, required: true
  attr :record, :any, required: true
  attr :trigger, :atom, default: :icon, values: [:icon, :labeled, :hidden]

  @doc "Single-record delete confirmation."
  def delete(assigns) do
    ~H"""
    <.dialog
      id={@id}
      class="dialog"
      role="alertdialog"
      modal
      close_on_interact_outside={false}
      initial_focus={"#{@id}-cancel"}
      final_focus={"dialog:#{@id}:trigger"}
    >
      <:trigger
        class={delete_trigger_class(@trigger)}
        aria_label={Gettext.t("Delete %{label}", label: @spec.singular)}
      >
        <.heroicon :if={@trigger != :labeled} name="hero-trash" class="icon" />
        <span :if={@trigger == :labeled}>{Gettext.t("Delete")}</span>
        <span :if={@trigger == :hidden} class="admin-visually-hidden">{Gettext.t("Delete")}</span>
      </:trigger>
      <:title>{Gettext.t("Delete %{label}?", label: @spec.singular)}</:title>
      <:description>{Gettext.t("This action cannot be undone.")}</:description>
      <:content>
        <div class="admin-dialog-actions">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            {Gettext.t("Cancel")}
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={
              Corex.Dialog.set_open(@id, false)
              |> JS.push("delete", value: %{id: Helpers.record_id(@spec, @record)})
            }
            class="button ui-size-sm ui-solid ui-alert"
          >
            {Gettext.t("Delete")}
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr :id, :string, required: true
  attr :spec, Spec, required: true
  attr :count, :integer, required: true

  @doc "Bulk delete confirmation for the current selection."
  def bulk_delete(assigns) do
    ~H"""
    <.dialog
      id={@id}
      class="dialog"
      role="alertdialog"
      modal
      close_on_interact_outside={false}
      initial_focus={"#{@id}-cancel"}
      final_focus={"dialog:#{@id}:trigger"}
    >
      <:trigger
        class="button ui-size-sm ui-alert ui-trigger--square"
        aria_label={Gettext.t("Delete selected %{label}", label: @spec.label)}
        title={Gettext.t("Delete selected")}
      >
        <.heroicon name="hero-trash" class="icon" />
        <span class="sr-only">{Gettext.t("Delete selected")}</span>
      </:trigger>
      <:title>{Gettext.t("Delete %{count} %{label}?", count: @count, label: @spec.label)}</:title>
      <:description>
        {Gettext.t("This action cannot be undone. Each record is authorized separately.")}
      </:description>
      <:content>
        <div class="admin-dialog-actions">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            {Gettext.t("Cancel")}
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={Corex.Dialog.set_open(@id, false) |> JS.push("bulk_delete")}
            class="button ui-size-sm ui-solid ui-alert"
          >
            {Gettext.t("Delete selected")}
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr :spec, Spec, required: true
  attr :token, :string, default: nil
  attr :fields, :list, required: true
  attr :action, :string, required: true

  @doc """
  Export picker.

  A plain `form` posting to the export controller, not a LiveView event: the
  response is a file download, which a websocket cannot deliver.
  """
  def export(assigns) do
    assigns =
      assigns
      |> assign(:csrf, Plug.CSRFProtection.get_csrf_token())
      |> assign(
        :format_items,
        list_items([{Gettext.t("CSV"), "csv"}, {Gettext.t("JSON"), "json"}])
      )

    ~H"""
    <.dialog id={"#{@spec.slug}-export"} class="dialog admin-dialog--scroll" modal>
      <:trigger class="admin-visually-hidden">{Gettext.t("Export")}</:trigger>
      <:title>{Gettext.t("Export %{label}", label: @spec.label)}</:title>
      <:description>{Gettext.t("Download the current list as CSV or JSON.")}</:description>
      <:content>
        <form id={"#{@spec.slug}-export-form"} action={@action} method="post" class="admin-form">
          <input type="hidden" name="_csrf_token" value={@csrf} />
          <input type="hidden" name="token" value={@token} />
          <.select
            id={"#{@spec.slug}-export-format"}
            class="select ui-size-sm"
            name="format"
            items={@format_items}
            value={["csv"]}
          >
            <:label>{Gettext.t("Format")}</:label>
            <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
          </.select>
          <fieldset class="admin-export-fields">
            <legend>{Gettext.t("Fields")}</legend>
            <.checkbox
              :for={field <- @fields}
              id={"#{@spec.slug}-export-field-#{field.name}"}
              class="checkbox ui-size-sm admin-export-field"
              name={"fields[#{field.name}]"}
              value="true"
              checked
            >
              <:label>{field.label}</:label>
              <:indicator><.heroicon name="hero-check" class="icon" /></:indicator>
              <:indeterminate><.heroicon name="hero-minus" class="icon" /></:indeterminate>
            </.checkbox>
          </fieldset>
          <div class="admin-dialog-actions">
            <.action
              type="button"
              phx-click={Corex.Dialog.set_open("#{@spec.slug}-export", false)}
              class="button ui-size-sm"
            >
              {Gettext.t("Cancel")}
            </.action>
            <.action
              type="submit"
              phx-click={Corex.Dialog.set_open("#{@spec.slug}-export", false)}
              class="button ui-size-sm ui-solid ui-brand"
            >
              {Gettext.t("Download")}
            </.action>
          </div>
        </form>
      </:content>
    </.dialog>
    """
  end

  attr :spec, Spec, required: true
  attr :action_mod, :atom, required: true
  attr :kind, :atom, required: true, values: [:bulk, :record]
  attr :record, :any, default: nil
  attr :count, :integer, default: 0

  @doc """
  Dialog for a custom action, with inputs when the action declares them.

  An action that implements `form_fields/1` gets a real form; one that only
  implements `confirm/1` gets a confirmation. Either way the submit pushes the
  generic `action` / `bulk_action` event, so the controller stays unaware of the
  action's shape.
  """
  def action_dialog(assigns) do
    mod = assigns.action_mod

    assigns =
      assigns
      |> assign(:id, action_dialog_id(assigns.spec, mod, assigns.record))
      |> assign(:label, mod.label(assigns.spec))
      |> assign(:icon, Action.icon(mod))
      |> assign(:fields, Action.form_fields(mod, assigns.spec))
      |> assign(:confirm, Action.confirm(mod, assigns.spec))
      |> assign(:event, if(assigns.kind == :bulk, do: "bulk_action", else: "action"))
      |> assign(:name, Atom.to_string(mod.name()))
      |> assign(:destructive?, Action.destructive?(mod))

    assigns =
      assign(
        assigns,
        :record_id,
        assigns.record && Helpers.record_id(assigns.spec, assigns.record)
      )

    ~H"""
    <.dialog
      id={@id}
      class="dialog admin-dialog--scroll"
      role={if(@destructive?, do: "alertdialog", else: "dialog")}
      modal
    >
      <:trigger
        class={action_trigger_class(@kind, @destructive?)}
        aria_label={@label}
        title={@label}
      >
        <.heroicon name={@icon} class="icon" />
        <span class={if(@kind == :record, do: "sr-only")}>{@label}</span>
      </:trigger>
      <:title>{@label}</:title>
      <:description :if={@confirm}>{@confirm}</:description>
      <:content>
        <form id={"#{@id}-form"} phx-submit={@event} class="admin-form">
          <input type="hidden" name="name" value={@name} />
          <input :if={@record_id} type="hidden" name="record_id" value={@record_id} />
          <div :if={@fields != []} class="admin-form-grid">
            <.action_input :for={field <- @fields} id={@id} field={field} />
          </div>
          <div class="admin-dialog-actions">
            <.action
              type="button"
              phx-click={Corex.Dialog.set_open(@id, false)}
              class="button ui-size-sm"
            >
              {Gettext.t("Cancel")}
            </.action>
            <.action
              type="submit"
              phx-click={Corex.Dialog.set_open(@id, false)}
              class={[
                "button ui-size-sm ui-solid",
                if(@destructive?, do: "ui-alert", else: "ui-brand")
              ]}
            >
              {@label}
            </.action>
          </div>
        </form>
      </:content>
    </.dialog>
    """
  end

  attr :id, :string, required: true
  attr :field, :map, required: true

  defp action_input(assigns) do
    field = assigns.field

    assigns =
      assigns
      |> assign(:type, Map.get(field, :type, :text))
      |> assign(:name, to_string(Map.get(field, :name)))
      |> assign(:label, Map.get(field, :label) || Phoenix.Naming.humanize(to_string(field.name)))
      |> assign(:options, list_items(Map.get(field, :options) || []))
      |> assign(:required, Map.get(field, :required, false))

    ~H"""
    <.select
      :if={@type == :select}
      id={"#{@id}-#{@name}"}
      class="select"
      name={"payload[#{@name}]"}
      items={@options}
    >
      <:label>{@label}</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
    </.select>
    <.switch
      :if={@type == :boolean}
      id={"#{@id}-#{@name}"}
      class="switch"
      name={"payload[#{@name}]"}
    >
      <:label>{@label}</:label>
    </.switch>
    <.native_input
      :if={@type not in [:select, :boolean]}
      id={"#{@id}-#{@name}"}
      type={to_string(@type)}
      name={"payload[#{@name}]"}
      class="native-input"
      required={@required}
    >
      <:label>{@label}</:label>
    </.native_input>
    """
  end

  @doc "Dialog id for a custom action, scoped to the record when there is one."
  @spec action_dialog_id(Spec.t(), module(), term()) :: String.t()
  def action_dialog_id(%Spec{} = spec, mod, nil), do: "#{spec.slug}-action-#{mod.name()}"

  def action_dialog_id(%Spec{} = spec, mod, record) do
    "#{spec.slug}-action-#{mod.name()}-#{Helpers.record_id(spec, record)}"
  end

  defp action_trigger_class(:record, destructive?) do
    ["button ui-size-sm ui-trigger--square", destructive? && "ui-alert"]
  end

  defp action_trigger_class(:bulk, destructive?) do
    ["button ui-size-sm", destructive? && "ui-alert"]
  end

  defp delete_trigger_class(:labeled), do: "button ui-alert"
  defp delete_trigger_class(:hidden), do: "admin-visually-hidden"
  defp delete_trigger_class(_), do: "button ui-size-sm ui-alert ui-trigger--square"
end
