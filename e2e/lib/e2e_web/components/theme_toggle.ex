defmodule E2eWeb.ThemeToggle do
  use E2eWeb, :html

  @doc """
  Provides theme selection using the select component.
  """

  attr :theme, :string,
    default: "neo",
    values: ["neo", "uno", "duo", "leo"],
    doc: "the theme from cookie/session"

  def theme_toggle(assigns) do
    ~H"""
    <.select
      id="theme-select"
      class="select select--sm w-4xs"
      items={[
        %{id: "neo", label: "Neo"},
        %{id: "uno", label: "Uno"},
        %{id: "duo", label: "Duo"},
        %{id: "leo", label: "Leo"}
      ]}
      value={[@theme]}
      on_value_change_client="phx:set-theme"
    >
      <:label class="sr-only">
        Theme
      </:label>
      <:item :let={item}>
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-swatch" class="icon" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" class="icon" />
      </:item_indicator>
    </.select>
    """
  end
end
