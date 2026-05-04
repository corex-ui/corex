defmodule E2eWeb.LocaleSwitcher do
  use E2eWeb, :html

  attr :path, :string, required: true

  def locale_switcher(assigns) do
    items =
      for loc <- E2eWeb.Locale.locales(), into: [] do
        %{id: E2eWeb.Path.join_locale_path(loc, assigns.path), label: E2eWeb.Locale.label(loc)}
      end

    value = [E2eWeb.Path.with_current_locale(assigns.path)]

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:value, value)

    ~H"""
    <.select
      id="locale-select"
      class="select select--sm w-4xs"
      items={@items}
      value={@value}
      redirect
    >
      <:label class="sr-only">
        Language
      </:label>
      <:item :let={item}>
        {item.label}
      </:item>
      <:trigger>
        <.heroicon name="hero-language" class="icon" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" class="icon" />
      </:item_indicator>
    </.select>
    """
  end
end
