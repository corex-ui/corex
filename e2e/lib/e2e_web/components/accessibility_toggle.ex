defmodule E2eWeb.AccessibilityToggle do
  use E2eWeb, :html

  import E2eWeb.Helpers, only: [hexdocs_url: 0]

  alias Corex.Design.Accessibility

  @dialog_id "a11y-dialog"

  def accessibility_dialog_id, do: @dialog_id

  @trigger_class "button ui-ghost ui-size-sm ui-trigger--circle p-0 [--ctl-text:calc(var(--spacing-size-sm)*0.65)]"

  attr(:trigger_class, :string, default: @trigger_class)

  def accessibility_panel(assigns) do
    assigns = assign(assigns, :axes, Accessibility.axes())

    ~H"""
    <.dialog
      :if={@axes != []}
      id={accessibility_dialog_id()}
      class="dialog ui-rounded-xl"
      modal
      prevent_scroll
      animation="instant"
      final_focus={"dialog:#{accessibility_dialog_id()}:trigger"}
    >
      <:trigger class={@trigger_class} aria_label={~t"Accessibility"}>
        <.accessibility_icon />
      </:trigger>
      <:title>{~t"Accessibility"}</:title>
      <:description>
        {~t"To enable Corex Accessibility, see the"}{" "}<.navigate
          class="link ui-size-sm"
          to={"#{hexdocs_url()}/accessibility.html"}
          external
        >
          {~t"documentation"}
          <.heroicon name="hero-arrow-top-right-on-square" />
        </.navigate>{"."}
      </:description>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
      <:content>
        <div class="flex w-full flex-col gap-space-lg">
          <div class="grid w-full grid-cols-1 gap-space sm:grid-cols-2">
            <div
              :for={axis <- @axes}
              class="flex min-w-0 flex-col gap-space-sm"
            >
              <.toggle_group
                id={"a11y-#{axis}"}
                class="toggle-group ui-size-sm ui-width-full"
                multiple={false}
                deselectable={false}
                value={[]}
                on_value_change_client={"phx:set-a11y-#{axis}"}
              >
                <:label>{axis_label(axis)}</:label>
                <:item :for={value <- Accessibility.values(axis)} value={value}>
                  {value_label(axis, value)}
                </:item>
              </.toggle_group>
            </div>
          </div>

          <div class="flex justify-end">
            <.action
              type="button"
              class="button ui-ghost ui-alert ui-size-sm ui-width-fit"
              onclick="window.dispatchEvent(new CustomEvent('phx:set-a11y-reset'))"
            >
              {~t"Reset"}
            </.action>
          </div>
        </div>
      </:content>
    </.dialog>
    """
  end

  @doc """
  Opens the shared accessibility dialog (e.g. from the mobile nav drawer).
  """
  def accessibility_open_button(assigns) do
    assigns = assign_new(assigns, :class, fn -> @trigger_class end)

    ~H"""
    <.action
      type="button"
      class={@class}
      aria-label={~t"Accessibility"}
      phx-click={Corex.Dialog.set_open(accessibility_dialog_id(), true)}
    >
      <.accessibility_icon />
    </.action>
    """
  end

  def accessibility_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 512 512"
      aria-hidden="true"
    >
      <path
        fill="currentColor"
        d="M256 48c114.953 0 208 93.029 208 208 0 114.953-93.029 208-208 208-114.953 0-208-93.029-208-208 0-114.953 93.029-208 208-208m0-40C119.033 8 8 119.033 8 256s111.033 248 248 248 248-111.033 248-248S392.967 8 256 8zm0 56C149.961 64 64 149.961 64 256s85.961 192 192 192 192-85.961 192-192S362.039 64 256 64zm0 44c19.882 0 36 16.118 36 36s-16.118 36-36 36-36-16.118-36-36 16.118-36 36-36zm117.741 98.023c-28.712 6.779-55.511 12.748-82.14 15.807.851 101.023 12.306 123.052 25.037 155.621 3.617 9.26-.957 19.698-10.217 23.315-9.261 3.617-19.699-.957-23.316-10.217-8.705-22.308-17.086-40.636-22.261-78.549h-9.686c-5.167 37.851-13.534 56.208-22.262 78.549-3.615 9.255-14.05 13.836-23.315 10.217-9.26-3.617-13.834-14.056-10.217-23.315 12.713-32.541 24.185-54.541 25.037-155.621-26.629-3.058-53.428-9.027-82.141-15.807-8.6-2.031-13.926-10.648-11.895-19.249s10.647-13.926 19.249-11.895c96.686 22.829 124.283 22.783 220.775 0 8.599-2.03 17.218 3.294 19.249 11.895 2.029 8.601-3.297 17.219-11.897 19.249z"
      />
    </svg>
    """
  end

  defp axis_label(:text), do: "Zoom"
  defp axis_label(:contrast), do: "Contrast"
  defp axis_label(:motion), do: "Motion"
  defp axis_label(:cursor), do: "Cursor"
  defp axis_label(:focus), do: "Focus"
  defp axis_label(:links), do: "Links"
  defp axis_label(axis), do: axis |> Atom.to_string() |> String.capitalize()

  defp value_label(:text, "md"), do: "Default"
  defp value_label(:text, "lg"), do: "Larger"
  defp value_label(:contrast, "normal"), do: "Standard"
  defp value_label(:contrast, "more"), do: "High"
  defp value_label(:motion, "system"), do: "Full"
  defp value_label(:motion, "reduce"), do: "Reduced"
  defp value_label(:cursor, "normal"), do: "Default"
  defp value_label(:cursor, "large"), do: "Large"
  defp value_label(:focus, "normal"), do: "Default"
  defp value_label(:focus, "strong"), do: "Strong"
  defp value_label(:links, "normal"), do: "Default"
  defp value_label(:links, "underline"), do: "Underline"
  defp value_label(_axis, value), do: value |> String.capitalize()
end
