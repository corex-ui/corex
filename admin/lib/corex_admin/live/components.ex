defmodule CorexAdmin.Live.Components do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Resource.Spec
  alias Phoenix.LiveView.JS

  attr :socket, :any, required: true
  attr :current, :any, default: nil
  slot :inner_block, required: true

  def shell(assigns) do
    prefix = Helpers.home_path(assigns.socket)
    grouped = Helpers.grouped_resources(assigns.socket)
    mobile_resources = Enum.flat_map(grouped, fn {_group, resources} -> resources end)

    assigns =
      assigns
      |> assign(:prefix, prefix)
      |> assign(:mobile_resources, mobile_resources)

    ~H"""
    <div class="flex min-h-0 min-w-0 flex-1">
      <aside class="sticky top-0 hidden h-dvh w-full max-w-2xs shrink-0 flex-col gap-space-lg overflow-y-auto border-r border-border bg-surface px-space py-space-lg lg:flex">
        <.navigate to={@prefix} class="link font-semibold text-ink no-underline">
          Admin
        </.navigate>
        <.nav socket={@socket} current={@current} />
      </aside>
      <div class="flex min-w-0 flex-1 flex-col">
        <nav
          class="flex flex-wrap items-center gap-space border-b border-border px-space py-space-sm lg:hidden"
          aria-label="Admin resources"
        >
          <.navigate
            to={@prefix}
            class="link ui-nav ui-size-sm"
            aria-current={if(is_nil(@current), do: "page")}
          >
            Admin
          </.navigate>
          <.navigate
            :for={resource <- @mobile_resources}
            to={Helpers.resource_path(@socket, Helpers.spec(resource))}
            class="link ui-nav ui-size-sm"
            aria-current={nav_current(@current, Helpers.spec(resource))}
          >
            {Helpers.spec(resource).label}
          </.navigate>
        </nav>
        <div class="flex min-w-0 flex-1 flex-col gap-space-lg px-space py-space-lg lg:px-space-xl">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  attr :socket, :any, required: true
  attr :current, :any, default: nil

  def nav(assigns) do
    grouped = Helpers.grouped_resources(assigns.socket)
    assigns = assign(assigns, :grouped, grouped)

    ~H"""
    <nav class="flex flex-col gap-space-lg" aria-label="Admin">
      <div :for={{group, resources} <- @grouped} class="flex flex-col gap-space-sm">
        <p class="m-0 text-sm font-medium tracking-wide text-ink-muted uppercase">{group}</p>
        <.navigate
          :for={resource <- resources}
          to={Helpers.resource_path(@socket, Helpers.spec(resource))}
          class="link ui-nav"
          aria-current={nav_current(@current, Helpers.spec(resource))}
        >
          {Helpers.spec(resource).label}
        </.navigate>
      </div>
    </nav>
    """
  end

  attr :prefix, :string, required: true
  attr :spec, Spec, default: nil
  attr :live_action, :atom, default: :index
  attr :record, :any, default: nil

  def breadcrumbs(assigns) do
    ~H"""
    <nav aria-label="Breadcrumb" class="text-sm text-ink-muted">
      <ol class="m-0 flex list-none flex-wrap items-center gap-space p-0">
        <li>
          <.navigate to={@prefix} class="link">Admin</.navigate>
        </li>
        <li :if={@spec} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <.navigate to={Path.join(@prefix, @spec.slug)} class="link">{@spec.label}</.navigate>
        </li>
        <li :if={@live_action == :new} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <span>New</span>
        </li>
        <li :if={@live_action in [:show, :edit] and @record} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <span>{Helpers.record_id(@spec, @record)}</span>
        </li>
      </ol>
    </nav>
    """
  end

  attr :field, Field, required: true
  attr :record, :any, required: true

  def field_value(assigns) do
    ~H"""
    <span>{format_value(@field, @record)}</span>
    """
  end

  attr :field, Field, required: true
  attr :form, :any, required: true

  def field_input(assigns) do
    field = assigns.field
    type = native_type(field.type)

    assigns =
      assigns
      |> assign(:type, type)
      |> assign(:options, select_options(field))

    ~H"""
    <.native_input
      :if={@field.type != :password}
      type={@type}
      field={@form[@field.name]}
      class="native-input"
      options={@options}
      prompt={if(@field.type == :select, do: "Select…")}
      auto_invalid
    >
      <:label>{@field.label}</:label>
    </.native_input>
    <.native_input
      :if={@field.type == :password}
      type="password"
      field={@form[@field.name]}
      class="native-input"
      value=""
      auto_invalid
    >
      <:label>{@field.label}</:label>
    </.native_input>
    """
  end

  attr :id, :string, required: true
  attr :spec, Spec, required: true
  attr :record, :any, required: true

  def delete_dialog(assigns) do
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
        aria_label={"Delete #{@spec.label}"}
      >
        <.heroicon name="hero-trash" />
      </:trigger>
      <:title>Delete {@spec.label}?</:title>
      <:description>This action cannot be undone.</:description>
      <:content>
        <div class="mt-space-lg flex flex-wrap justify-end gap-space-sm">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            Cancel
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={
              Corex.Dialog.set_open(@id, false)
              |> JS.push("delete", value: %{id: Helpers.record_id(@spec, @record)})
            }
            class="button ui-size-sm ui-alert"
          >
            Delete
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  defp nav_current(%Spec{slug: slug}, %Spec{slug: slug}), do: "page"
  defp nav_current(_, _), do: nil

  defp native_type(:id), do: "text"
  defp native_type(:text), do: "text"
  defp native_type(:textarea), do: "textarea"
  defp native_type(:email), do: "email"
  defp native_type(:password), do: "password"
  defp native_type(:number), do: "number"
  defp native_type(:boolean), do: "checkbox"
  defp native_type(:select), do: "select"
  defp native_type(:date), do: "date"
  defp native_type(:datetime), do: "datetime-local"
  defp native_type(:url), do: "url"
  defp native_type(_), do: "text"

  defp select_options(%Field{type: :select, options: options}) when is_list(options) do
    Enum.map(options, fn
      {label, value} -> {to_string(label), to_string(value)}
      value -> {to_string(value), to_string(value)}
    end)
  end

  defp select_options(_), do: nil

  def format_value(%Field{redact: true}, _record), do: "••••"

  def format_value(%Field{name: name, type: type}, record) do
    case Map.get(record, name) do
      nil -> "—"
      true -> "Yes"
      false -> "No"
      %Date{} = date -> Date.to_iso8601(date)
      %DateTime{} = dt -> Calendar.strftime(dt, "%Y-%m-%d %H:%M")
      %NaiveDateTime{} = dt -> NaiveDateTime.to_iso8601(dt)
      _value when type == :password -> "••••"
      value when is_binary(value) -> value
      value when is_integer(value) or is_float(value) -> to_string(value)
      value when is_atom(value) -> Atom.to_string(value)
      value -> inspect(value)
    end
  end
end
