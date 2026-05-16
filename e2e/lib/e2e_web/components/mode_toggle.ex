defmodule E2eWeb.ModeToggle do
  use E2eWeb, :html

  @doc """
  Provides dark vs light mode toggle using toggle.
  """

  attr :mode, :string,
    default: "light",
    values: ["light", "dark"],
    doc: "the mode (dark or light) from cookie/session"

  attr :id, :string, default: "mode-switcher"

  def mode_toggle(assigns) do
    ~H"""
    <.toggle
      id={@id}
      class="toggle toggle--sm"
      data-toggle-dual-label
      pressed={@mode == "dark"}
      on_pressed_change_client="phx:set-mode"
    >
      <span>
        <.heroicon name="hero-moon" />
        <span class="sr-only">{gettext("Dark mode")}</span>
      </span>
      <span data-pressed>
        <.heroicon name="hero-sun" />
        <span class="sr-only">{gettext("Light mode")}</span>
      </span>
    </.toggle>
    """
  end
end
