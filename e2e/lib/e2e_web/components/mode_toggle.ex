defmodule E2eWeb.ModeToggle do
  use E2eWeb, :html

  @doc """
  Provides dark vs light theme toggle using toggle_group.
  """

  attr :mode, :string,
    default: "light",
    values: ["light", "dark"],
    doc: "the mode (dark or light) from cookie/session"

  def mode_toggle(assigns) do
    ~H"""
    <.toggle_group
      id="mode-switcher"
      class="toggle-group toggle-group--sm toggle-group--duo toggle-group--circle"
      value={if @mode == "dark", do: ["dark"], else: []}
      on_value_change_client="phx:set-mode"
    >
      <:item value="dark">
        <.heroicon name="hero-sun" class="icon state-on" />
        <.heroicon name="hero-moon" class="icon state-off" />
      </:item>
    </.toggle_group>
    """
  end
end
