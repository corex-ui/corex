defmodule E2eWeb.ThemeToggle do
  use E2eWeb, :html

  @doc """
  Provides theme selection using the select component.
  """

  attr :theme, :string,
    default: "neo",
    values: ["neo", "uno", "duo", "leo"],
    doc: "the theme from cookie/session"

  attr :id, :string, default: "theme-select"

  def theme_toggle(assigns) do
    ~H"""
    <.select
      id={@id}
      class="select ui-size-sm w-4xs"
      items={[
        %{value: "neo", label: "Neo"},
        %{value: "uno", label: "Uno"},
        %{value: "duo", label: "Duo"},
        %{value: "leo", label: "Leo"}
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
